import { getPlatform } from '../platform.js'
import { getInitialSettings } from '../settings/settings.js'

/**
 * Resolve the default shell for input-box `!` commands.
 *
 * Resolution order (docs/design/ps-shell-selection.md §4.2):
 *   settings.defaultShell → platform default
 *
 * Platform default: 'powershell' on native Windows, 'bash' everywhere else.
 */
export function resolveDefaultShell(): 'bash' | 'powershell' {
  if (getInitialSettings().defaultShell) {
    return getInitialSettings().defaultShell
  }
  return getPlatform() === 'windows' ? 'powershell' : 'bash'
}
