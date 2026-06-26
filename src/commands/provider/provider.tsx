import chalk from 'chalk'
import * as React from 'react'
import type { LocalJSXCommandOnDone } from '../../types/command.js'
import { applyConfigEnvironmentVariables } from '../../utils/managedEnv.js'
import { getAPIProvider } from '../../utils/model/providers.js'
import { updateSettingsForSource } from '../../utils/settings/settings.js'

const COMMON_HELP_ARGS = ['help', '-h', '--help']

const HELP_TEXT = `Usage: /provider [deepseek|gemini|openai|anthropic|status]

Select and configure your API provider.

Providers:
  deepseek   - DeepSeek API (needs API key)
  gemini     - Google Gemini API (needs API key)
  openai     - OpenAI / Codex (needs OAuth via /login, or API key)
  anthropic  - Anthropic API (default, needs OAuth via /login)

Examples:
  /provider                  Show current provider
  /provider deepseek <key>   Switch to DeepSeek
  /provider gemini <key>     Switch to Gemini
  /provider openai           Switch to OpenAI (then run /login)
  /provider anthropic        Switch to Anthropic`

// All provider env vars managed by this command
const ALL_PROVIDER_ENV_VARS = [
  'CLAUDE_CODE_USE_GEMINI',
  'CLAUDE_CODE_USE_DEEPSEEK',
  'CLAUDE_CODE_USE_OPENAI',
  'GEMINI_API_KEY',
  'DEEPSEEK_API_KEY',
  'OPENAI_API_KEY',
]

function clearProviderEnv(): Record<string, undefined> {
  const cleared: Record<string, undefined> = {}
  for (const v of ALL_PROVIDER_ENV_VARS) {
    cleared[v] = undefined
  }
  return cleared
}

function showCurrentProvider(): string {
  const provider = getAPIProvider()
  const labels: Record<string, string> = {
    deepseek: 'DeepSeek',
    gemini: 'Google Gemini',
    firstParty: 'Anthropic',
    bedrock: 'AWS Bedrock',
    vertex: 'Google Vertex AI',
    foundry: 'Microsoft Foundry',
    openai: 'OpenAI / Codex',
  }
  return `Current provider: ${chalk.bold(labels[provider] || provider)}`
}

function switchToDeepSeek(apiKey?: string): string {
  const key = apiKey || ''
  if (!key) {
    return 'DeepSeek requires an API key.\nUsage: /provider deepseek <api-key>\n\nGet one at: https://platform.deepseek.com'
  }

  // Clear all other providers first, then set DeepSeek
  const envUpdate: Record<string, string | undefined> = {
    ...clearProviderEnv(),
    CLAUDE_CODE_USE_DEEPSEEK: '1',
    DEEPSEEK_API_KEY: key,
  }

  const result = updateSettingsForSource('userSettings', { env: envUpdate })
  if (result.error) {
    return `Failed to configure DeepSeek: ${result.error.message}`
  }

  applyConfigEnvironmentVariables()

  return `Provider set to ${chalk.bold('DeepSeek')}\nModels will use DeepSeek API at api.deepseek.com/anthropic\n\nTip: /login still works for Anthropic OAuth.`
}

function switchToGemini(apiKey?: string): string {
  const key = apiKey || ''
  if (!key) {
    return 'Gemini requires an API key.\nUsage: /provider gemini <api-key>\n\nGet one at: https://aistudio.google.com'
  }

  const envUpdate: Record<string, string | undefined> = {
    ...clearProviderEnv(),
    CLAUDE_CODE_USE_GEMINI: '1',
    GEMINI_API_KEY: key,
  }

  const result = updateSettingsForSource('userSettings', { env: envUpdate })
  if (result.error) {
    return `Failed to configure Gemini: ${result.error.message}`
  }

  applyConfigEnvironmentVariables()

  return `Provider set to ${chalk.bold('Google Gemini')}\nModels will use Gemini Interactions API.\n\nTip: /login still works for Anthropic OAuth.`
}

function switchToOpenAI(apiKey?: string): string {
  const key = apiKey || ''
  if (key) {
    const envUpdate: Record<string, string | undefined> = {
      ...clearProviderEnv(),
      CLAUDE_CODE_USE_OPENAI: '1',
      OPENAI_API_KEY: key,
    }
    const result = updateSettingsForSource('userSettings', { env: envUpdate })
    if (result.error) {
      return `Failed to configure OpenAI: ${result.error.message}`
    }
    applyConfigEnvironmentVariables()
    return `Provider set to ${chalk.bold('OpenAI (API Key)')}\nAPI key saved.\n\nTip: Use ${chalk.bold('/model')} to select a model (e.g. gpt-4o).`
  }

  const envUpdate: Record<string, string | undefined> = {
    ...clearProviderEnv(),
    CLAUDE_CODE_USE_OPENAI: '1',
  }

  const result = updateSettingsForSource('userSettings', { env: envUpdate })
  if (result.error) {
    return `Failed to configure OpenAI: ${result.error.message}`
  }

  applyConfigEnvironmentVariables()

  return `Provider set to ${chalk.bold('OpenAI / Codex')}\nNow run ${chalk.bold('/login')} and select "OpenAI Codex account" to authenticate.\nRequires ChatGPT Plus/Pro subscription.`
}

function switchToAnthropic(): string {
  const envUpdate = clearProviderEnv()

  const result = updateSettingsForSource('userSettings', { env: envUpdate })
  if (result.error) {
    return `Failed to switch to Anthropic: ${result.error.message}`
  }

  applyConfigEnvironmentVariables()

  return `Provider set to ${chalk.bold('Anthropic')} (default)\nUse /login for OAuth authentication.`
}

function handleProviderCommand(args: string): string {
  const trimmed = args.trim()
  const parts = trimmed.split(/\s+/)
  const cmd = parts[0]?.toLowerCase() || ''
  const rest = parts.slice(1).join(' ')

  if (!cmd || cmd === 'status') {
    return showCurrentProvider()
  }

  switch (cmd) {
    case 'deepseek':
      return switchToDeepSeek(rest)
    case 'gemini':
      return switchToGemini(rest)
    case 'openai':
    case 'codex':
      return switchToOpenAI(rest)
    case 'anthropic':
    case 'firstparty':
    case 'first-party':
      return switchToAnthropic()
    default:
      return `Unknown provider: ${cmd}\n\n${HELP_TEXT}`
  }
}

export async function call(
  onDone: LocalJSXCommandOnDone,
  _context: unknown,
  args?: string,
): Promise<React.ReactNode> {
  args = args?.trim() || ''

  if (COMMON_HELP_ARGS.includes(args)) {
    onDone(HELP_TEXT)
    return null
  }

  const message = handleProviderCommand(args)
  onDone(message)
  return null
}
