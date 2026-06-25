import type { Command } from '../../commands.js'

const proxy = {
  type: 'local-jsx',
  name: 'proxy',
  description: 'Set or view HTTP/HTTPS proxy for API requests',
  argumentHint: '[set <url>|clear|status]',
  load: () => import('./proxy.js'),
} satisfies Command

export default proxy
