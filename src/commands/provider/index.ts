import type { Command } from '../../commands.js'

const provider = {
  type: 'local-jsx',
  name: 'provider',
  description: 'Select and configure API provider (DeepSeek / Gemini / Anthropic)',
  argumentHint: '[deepseek|gemini|anthropic|status]',
  load: () => import('./provider.js'),
} satisfies Command

export default provider
