/**
 * Gemini Fetch Adapter
 *
 * Intercepts fetch calls from the Anthropic SDK and routes them to
 * Google's Gemini Interactions API, translating between Anthropic
 * Messages API format and Gemini Interactions API format.
 *
 * Endpoint: https://generativelanguage.googleapis.com/v1beta/interactions
 */

// ── Types ───────────────────────────────────────────────────────────

interface AnthropicContentBlock {
  type: string
  text?: string
  id?: string
  name?: string
  input?: Record<string, unknown>
  tool_use_id?: string
  content?: string | AnthropicContentBlock[]
  source?: { type: string; media_type?: string; data?: string }
  [key: string]: unknown
}

interface AnthropicMessage {
  role: string
  content: string | AnthropicContentBlock[]
}

interface AnthropicTool {
  name: string
  description?: string
  input_schema?: Record<string, unknown>
}

// ── Tool translation: Anthropic → Gemini ────────────────────────────

function translateTools(anthropicTools: AnthropicTool[]): Array<Record<string, unknown>> {
  return anthropicTools.map(tool => ({
    type: 'function',
    name: tool.name,
    description: tool.description || '',
    parameters: tool.input_schema || { type: 'object', properties: {} },
  }))
}

// ── Message translation: Anthropic → Gemini input steps ──────────────

let toolNameMap = new Map<string, string>() // tool_use_id → name mapping

function translateMessages(
  anthropicMessages: AnthropicMessage[],
): Array<Record<string, unknown>> {
  toolNameMap = new Map<string, string>()
  const steps: Array<Record<string, unknown>> = []

  for (const msg of anthropicMessages) {
    if (msg.role === 'user') {
      const content = translateUserContent(msg.content)
      steps.push({ type: 'user_input', content })
    } else if (msg.role === 'assistant') {
      const content = translateAssistantContent(msg.content)
      // Track tool_use→name for subsequent tool_result mapping
      if (Array.isArray(msg.content)) {
        for (const block of msg.content) {
          if (block.type === 'tool_use' && block.id && block.name) {
            toolNameMap.set(block.id, block.name as string)
          }
        }
      }
      steps.push({ type: 'model_output', content })
    }
  }

  return steps
}

function translateUserContent(
  content: string | AnthropicContentBlock[],
): Array<Record<string, unknown>> {
  if (typeof content === 'string') {
    return [{ type: 'text', text: content }]
  }
  if (!Array.isArray(content)) return []

  const result: Array<Record<string, unknown>> = []
  for (const block of content) {
    if (block.type === 'text' && typeof block.text === 'string') {
      result.push({ type: 'text', text: block.text })
    } else if (block.type === 'tool_result') {
      const callId = block.tool_use_id || ''
      const toolName = toolNameMap.get(callId) || ''
      let outputText = ''
      if (typeof block.content === 'string') {
        outputText = block.content
      } else if (Array.isArray(block.content)) {
        outputText = block.content
          .map(c => (c.type === 'text' ? c.text : ''))
          .join('\n')
      }
      result.push({
        type: 'function_result',
        name: toolName,
        call_id: callId,
        result: [{ type: 'text', text: outputText }],
      })
    } else if (block.type === 'image' && block.source) {
      const src = block.source as { type: string; media_type?: string; data?: string }
      result.push({
        type: 'image',
        data: src.data || '',
        mime_type: src.media_type || 'image/png',
      })
    }
  }
  return result
}

function translateAssistantContent(
  content: string | AnthropicContentBlock[],
): Array<Record<string, unknown>> {
  if (typeof content === 'string') {
    return [{ type: 'text', text: content }]
  }
  if (!Array.isArray(content)) return []

  const result: Array<Record<string, unknown>> = []
  for (const block of content) {
    if (block.type === 'text' && typeof block.text === 'string') {
      result.push({ type: 'text', text: block.text })
    } else if (block.type === 'tool_use') {
      result.push({
        type: 'function_call',
        id: block.id || '',
        name: block.name || '',
        arguments: block.input || {},
      })
    }
  }
  return result
}

// ── Full request translation ────────────────────────────────────────

function translateToGeminiBody(anthropicBody: Record<string, unknown>): {
  geminiBody: Record<string, unknown>
  geminiModel: string
} {
  const anthropicMessages = (anthropicBody.messages || []) as AnthropicMessage[]
  const systemPrompt = anthropicBody.system as
    | string
    | Array<{ type: string; text?: string }>
    | undefined
  const claudeModel = (anthropicBody.model as string) || ''
  const anthropicTools = (anthropicBody.tools || []) as AnthropicTool[]
  const maxTokens = anthropicBody.max_tokens as number | undefined
  const temperature = anthropicBody.temperature as number | undefined
  const topP = anthropicBody.top_p as number | undefined

  const geminiModel = mapModelToGemini(claudeModel)

  // Build system instruction
  let systemInstruction = ''
  if (systemPrompt) {
    systemInstruction =
      typeof systemPrompt === 'string'
        ? systemPrompt
        : systemPrompt
            .filter(b => b.type === 'text' && typeof b.text === 'string')
            .map(b => b.text!)
            .join('\n')
  }

  // Convert messages to input steps
  const input = translateMessages(anthropicMessages)

  const geminiBody: Record<string, unknown> = {
    model: geminiModel,
    stream: true,
    input,
  }

  if (systemInstruction) {
    geminiBody.system_instruction = systemInstruction
  }

  if (anthropicTools.length > 0) {
    geminiBody.tools = translateTools(anthropicTools)
  }

  // Generation config
  const generationConfig: Record<string, unknown> = {}
  if (maxTokens) generationConfig.maxOutputTokens = maxTokens
  if (temperature !== undefined) generationConfig.temperature = temperature
  if (topP !== undefined) generationConfig.topP = topP
  if (Object.keys(generationConfig).length > 0) {
    geminiBody.generation_config = generationConfig
  }

  return { geminiBody, geminiModel }
}

// ── Model mapping ───────────────────────────────────────────────────

const DEFAULT_GEMINI_MODEL = 'gemini-3.5-flash'

function mapModelToGemini(claudeModel: string): string {
  if (!claudeModel) return DEFAULT_GEMINI_MODEL
  // If already a Gemini model name, pass through
  if (claudeModel.startsWith('gemini-')) return claudeModel
  const lower = claudeModel.toLowerCase()
  if (lower.includes('opus')) return 'gemini-3.1-pro-preview'
  if (lower.includes('haiku')) return 'gemini-3.1-flash-lite'
  if (lower.includes('sonnet')) return 'gemini-3.5-flash'
  if (lower.startsWith('gpt-')) return claudeModel // pass through GPT model names
  return DEFAULT_GEMINI_MODEL
}

// ── SSE helpers ─────────────────────────────────────────────────────

function formatSSE(event: string, data: string): string {
  return `event: ${event}\ndata: ${data}\n\n`
}

// ── Response translation: Gemini SSE → Anthropic SSE ────────────────

async function translateGeminiStreamToAnthropic(
  geminiResponse: Response,
  geminiModel: string,
): Promise<Response> {
  const messageId = `msg_gemini_${Date.now()}`

  const readable = new ReadableStream({
    async start(controller) {
      const encoder = new TextEncoder()
      let contentBlockIndex = 0
      let outputTokens = 0
      let inputTokens = 0

      let currentTextBlockStarted = false
      let currentThinkingBlockStarted = false
      let currentToolCallId = ''
      let currentToolCallName = ''
      let currentToolCallArgs = ''
      let inToolCall = false
      let hadToolCalls = false
      let streamStarted = false

      try {
        const reader = geminiResponse.body?.getReader()
        if (!reader) {
          emitTextBlock(controller, encoder, contentBlockIndex, 'Error: No response body')
          finishStream(controller, encoder, outputTokens, inputTokens, false)
          return
        }

        const decoder = new TextDecoder()
        let buffer = ''

        while (true) {
          const { done, value } = await reader.read()
          if (done) break

          buffer += decoder.decode(value, { stream: true })
          const lines = buffer.split('\n')
          buffer = lines.pop() || ''

          for (const line of lines) {
            const trimmed = line.trim()
            if (!trimmed) continue
            if (trimmed.startsWith('event: ')) continue
            if (!trimmed.startsWith('data: ')) continue

            const dataStr = trimmed.slice(6)
            if (dataStr === '[DONE]') continue

            let event: Record<string, unknown>
            try {
              event = JSON.parse(dataStr)
            } catch {
              continue
            }

            const eventType = event.event_type as string

            // ── Interaction created ────────────────────────────
            if (eventType === 'interaction.created') {
              const interaction = event.interaction as Record<string, unknown>
              if (!streamStarted) {
                // Emit Anthropic message_start
                controller.enqueue(
                  encoder.encode(
                    formatSSE('message_start', JSON.stringify({
                      type: 'message_start',
                      message: {
                        id: messageId,
                        type: 'message',
                        role: 'assistant',
                        content: [],
                        model: interaction?.model || geminiModel,
                        stop_reason: null,
                        stop_sequence: null,
                        usage: { input_tokens: 0, output_tokens: 0 },
                      },
                    })),
                  ),
                )
                controller.enqueue(
                  encoder.encode(formatSSE('ping', JSON.stringify({ type: 'ping' }))),
                )
                streamStarted = true
              }
            }

            // ── Step start ─────────────────────────────────────
            else if (eventType === 'step.start') {
              const step = event.step as Record<string, unknown>
              const stepType = step?.type as string

              // Close previous blocks if any
              if (currentTextBlockStarted) {
                controller.enqueue(
                  encoder.encode(formatSSE('content_block_stop', JSON.stringify({
                    type: 'content_block_stop', index: contentBlockIndex,
                  }))),
                )
                contentBlockIndex++
                currentTextBlockStarted = false
              }
              if (currentThinkingBlockStarted) {
                controller.enqueue(
                  encoder.encode(formatSSE('content_block_stop', JSON.stringify({
                    type: 'content_block_stop', index: contentBlockIndex,
                  }))),
                )
                contentBlockIndex++
                currentThinkingBlockStarted = false
              }
              if (inToolCall) {
                finishToolCallBlock(controller, encoder, contentBlockIndex, currentToolCallId, currentToolCallName, currentToolCallArgs)
                contentBlockIndex++
                inToolCall = false
              }

              if (stepType === 'thought') {
                controller.enqueue(
                  encoder.encode(formatSSE('content_block_start', JSON.stringify({
                    type: 'content_block_start',
                    index: contentBlockIndex,
                    content_block: { type: 'thinking', thinking: '' },
                  }))),
                )
                currentThinkingBlockStarted = true
              } else if (stepType === 'model_output') {
                // Don't start text block yet — wait for delta
              } else if (stepType === 'function_call') {
                currentToolCallId = (step?.id as string) || `toolu_gemini_${Date.now()}`
                currentToolCallName = (step?.name as string) || ''
                currentToolCallArgs = ''
                inToolCall = true
                hadToolCalls = true

                controller.enqueue(
                  encoder.encode(formatSSE('content_block_start', JSON.stringify({
                    type: 'content_block_start',
                    index: contentBlockIndex,
                    content_block: {
                      type: 'tool_use',
                      id: currentToolCallId,
                      name: currentToolCallName,
                      input: {},
                    },
                  }))),
                )
              }
            }

            // ── Step delta ─────────────────────────────────────
            else if (eventType === 'step.delta') {
              const delta = event.delta as Record<string, unknown>
              const deltaType = delta?.type as string

              if (deltaType === 'text') {
                const text = delta.text as string
                if (typeof text === 'string' && text.length > 0) {
                  if (!currentTextBlockStarted) {
                    controller.enqueue(
                      encoder.encode(formatSSE('content_block_start', JSON.stringify({
                        type: 'content_block_start',
                        index: contentBlockIndex,
                        content_block: { type: 'text', text: '' },
                      }))),
                    )
                    currentTextBlockStarted = true
                  }
                  controller.enqueue(
                    encoder.encode(formatSSE('content_block_delta', JSON.stringify({
                      type: 'content_block_delta',
                      index: contentBlockIndex,
                      delta: { type: 'text_delta', text },
                    }))),
                  )
                  outputTokens++
                }
              } else if (deltaType === 'thought_signature') {
                const signature = delta.signature as string
                if (typeof signature === 'string' && currentThinkingBlockStarted) {
                  controller.enqueue(
                    encoder.encode(formatSSE('content_block_delta', JSON.stringify({
                      type: 'content_block_delta',
                      index: contentBlockIndex,
                      delta: { type: 'thinking_delta', thinking: signature },
                    }))),
                  )
                }
              } else if (deltaType === 'function_call') {
                // Function call name/args delta
                const fcName = delta.name as string
                const fcArgs = delta.arguments as Record<string, unknown>
                if (inToolCall && fcName) {
                  currentToolCallName = fcName
                }
                if (inToolCall && fcArgs) {
                  const argsStr = JSON.stringify(fcArgs)
                  currentToolCallArgs = argsStr
                  controller.enqueue(
                    encoder.encode(formatSSE('content_block_delta', JSON.stringify({
                      type: 'content_block_delta',
                      index: contentBlockIndex,
                      delta: { type: 'input_json_delta', partial_json: argsStr },
                    }))),
                  )
                }
              }
            }

            // ── Step stop ──────────────────────────────────────
            else if (eventType === 'step.stop') {
              // Don't close here — next step.start will handle it,
              // or interaction.completed will close the last block
            }

            // ── Interaction completed ──────────────────────────
            else if (eventType === 'interaction.completed') {
              const interaction = event.interaction as Record<string, unknown>
              const usage = interaction?.usage as Record<string, number> | undefined
              if (usage) {
                outputTokens = usage.total_output_tokens || outputTokens
                inputTokens = usage.total_input_tokens || inputTokens
              }
            }
          }
        }
      } catch (err) {
        if (!currentTextBlockStarted) {
          controller.enqueue(
            encoder.encode(formatSSE('content_block_start', JSON.stringify({
              type: 'content_block_start',
              index: contentBlockIndex,
              content_block: { type: 'text', text: '' },
            }))),
          )
          currentTextBlockStarted = true
        }
        controller.enqueue(
          encoder.encode(formatSSE('content_block_delta', JSON.stringify({
            type: 'content_block_delta',
            index: contentBlockIndex,
            delta: { type: 'text_delta', text: `\n\n[Error: ${String(err)}]` },
          }))),
        )
      }

      // Close any remaining open blocks
      if (currentTextBlockStarted) {
        controller.enqueue(
          encoder.encode(formatSSE('content_block_stop', JSON.stringify({
            type: 'content_block_stop', index: contentBlockIndex,
          }))),
        )
      }
      if (currentThinkingBlockStarted) {
        controller.enqueue(
          encoder.encode(formatSSE('content_block_stop', JSON.stringify({
            type: 'content_block_stop', index: contentBlockIndex,
          }))),
        )
      }
      if (inToolCall) {
        finishToolCallBlock(controller, encoder, contentBlockIndex, currentToolCallId, currentToolCallName, currentToolCallArgs)
      }

      finishStream(controller, encoder, outputTokens, inputTokens, hadToolCalls)
    },
  })

  return new Response(readable, {
    status: 200,
    headers: {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      Connection: 'keep-alive',
      'x-request-id': messageId,
    },
  })
}

// ── Helper: finish a tool_use block ─────────────────────────────────

function finishToolCallBlock(
  controller: ReadableStreamDefaultController,
  encoder: TextEncoder,
  index: number,
  _toolCallId: string,
  _toolCallName: string,
  _toolCallArgs: string,
) {
  controller.enqueue(
    encoder.encode(formatSSE('content_block_stop', JSON.stringify({
      type: 'content_block_stop', index,
    }))),
  )
}

// ── Helper: emit a single text block ────────────────────────────────

function emitTextBlock(
  controller: ReadableStreamDefaultController,
  encoder: TextEncoder,
  index: number,
  text: string,
) {
  controller.enqueue(
    encoder.encode(formatSSE('content_block_start', JSON.stringify({
      type: 'content_block_start', index,
      content_block: { type: 'text', text: '' },
    }))),
  )
  controller.enqueue(
    encoder.encode(formatSSE('content_block_delta', JSON.stringify({
      type: 'content_block_delta', index,
      delta: { type: 'text_delta', text },
    }))),
  )
  controller.enqueue(
    encoder.encode(formatSSE('content_block_stop', JSON.stringify({
      type: 'content_block_stop', index,
    }))),
  )
}

// ── Helper: finish the stream ───────────────────────────────────────

function finishStream(
  controller: ReadableStreamDefaultController,
  encoder: TextEncoder,
  outputTokens: number,
  inputTokens: number,
  hadToolCalls: boolean,
) {
  const stopReason = hadToolCalls ? 'tool_use' : 'end_turn'

  controller.enqueue(
    encoder.encode(formatSSE('message_delta', JSON.stringify({
      type: 'message_delta',
      delta: { stop_reason: stopReason, stop_sequence: null },
      usage: { output_tokens: outputTokens },
    }))),
  )
  controller.enqueue(
    encoder.encode(formatSSE('message_stop', JSON.stringify({
      type: 'message_stop',
      usage: { input_tokens: inputTokens, output_tokens: outputTokens },
    }))),
  )
  controller.close()
}

// ── Main fetch interceptor ──────────────────────────────────────────

const GEMINI_BASE_URL = 'https://generativelanguage.googleapis.com/v1beta/interactions'

/**
 * Creates a fetch function that intercepts Anthropic API calls and routes them to Gemini.
 */
export function createGeminiFetch(
  apiKey: string,
): (input: RequestInfo | URL, init?: RequestInit) => Promise<Response> {
  return async (input: RequestInfo | URL, init?: RequestInit): Promise<Response> => {
    const url = input instanceof Request ? input.url : String(input)

    // Only intercept Anthropic Messages API calls
    if (!url.includes('/v1/messages')) {
      return globalThis.fetch(input, init)
    }

    // Parse the Anthropic request body
    let anthropicBody: Record<string, unknown>
    try {
      const bodyText =
        init?.body instanceof ReadableStream
          ? await new Response(init.body).text()
          : typeof init?.body === 'string'
            ? init.body
            : '{}'
      anthropicBody = JSON.parse(bodyText)
    } catch {
      anthropicBody = {}
    }

    // Translate to Gemini format
    const { geminiBody, geminiModel } = translateToGeminiBody(anthropicBody)

    // Call Gemini Interactions API with SSE streaming
    const geminiUrl = `${GEMINI_BASE_URL}?alt=sse`
    const geminiResponse = await globalThis.fetch(geminiUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: JSON.stringify(geminiBody),
    })

    if (!geminiResponse.ok) {
      const errorText = await geminiResponse.text()
      const errorBody = {
        type: 'error',
        error: {
          type: 'api_error',
          message: `Gemini API error (${geminiResponse.status}): ${errorText}`,
        },
      }
      return new Response(JSON.stringify(errorBody), {
        status: geminiResponse.status,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Translate streaming response
    return translateGeminiStreamToAnthropic(geminiResponse, geminiModel)
  }
}
