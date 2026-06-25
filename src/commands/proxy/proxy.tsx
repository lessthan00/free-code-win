import chalk from 'chalk'
import * as React from 'react'
import type { LocalJSXCommandOnDone } from '../../types/command.js'
import { applyConfigEnvironmentVariables } from '../../utils/managedEnv.js'
import { updateSettingsForSource } from '../../utils/settings/settings.js'

const COMMON_HELP_ARGS = ['help', '-h', '--help']

const HELP_TEXT = `Usage: /proxy [set <url>|clear|status]

Manage HTTP/HTTPS proxy for API requests.
Proxy is persisted in settings.json and applied immediately.

Examples:
  /proxy                  Show current proxy
  /proxy set http://127.0.0.1:7890  Set proxy
  /proxy clear            Remove proxy`

function showCurrentProxy(): string {
  const httpProxy = process.env.HTTP_PROXY
  const httpsProxy = process.env.HTTPS_PROXY
  if (!httpProxy && !httpsProxy) {
    return 'No proxy configured.\n\nTip: /proxy set http://127.0.0.1:7890'
  }
  const lines = ['Current proxy:']
  if (httpProxy) lines.push(chalk.bold(`  HTTP_PROXY=${httpProxy}`))
  if (httpsProxy && httpsProxy !== httpProxy) lines.push(chalk.bold(`  HTTPS_PROXY=${httpsProxy}`))
  return lines.join('\n')
}

function setProxy(url: string): string {
  // Validate URL
  try {
    new URL(url)
  } catch {
    return `Invalid proxy URL: ${url}`
  }

  const envUpdate: Record<string, string | undefined> = {
    HTTP_PROXY: url,
    HTTPS_PROXY: url,
  }

  // Also persist to user env if running on Windows (for other apps)
  // But settings.json is the primary persistence mechanism
  const result = updateSettingsForSource('userSettings', { env: envUpdate })
  if (result.error) {
    return `Failed to save proxy: ${result.error.message}`
  }

  // Apply immediately
  applyConfigEnvironmentVariables()

  return `Proxy set to ${chalk.bold(url)}\nApplied immediately to all API requests.`
}

function clearProxy(): string {
  const envUpdate: Record<string, string | undefined> = {
    HTTP_PROXY: undefined,
    HTTPS_PROXY: undefined,
  }

  const result = updateSettingsForSource('userSettings', { env: envUpdate })
  if (result.error) {
    return `Failed to clear proxy: ${result.error.message}`
  }

  applyConfigEnvironmentVariables()

  return 'Proxy cleared.'
}

function handleProxyCommand(args: string): string {
  const trimmed = args.trim().toLowerCase()

  if (!trimmed || trimmed === 'status') {
    return showCurrentProxy()
  }

  if (trimmed === 'clear') {
    return clearProxy()
  }

  if (trimmed.startsWith('set ')) {
    const url = args.trim().slice(4).trim()
    if (!url) {
      return 'Usage: /proxy set <url>\nExample: /proxy set http://127.0.0.1:7890'
    }
    return setProxy(url)
  }

  return `Unknown argument: ${args}\n\n${HELP_TEXT}`
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

  const message = handleProxyCommand(args)
  onDone(message)
  return null
}
