# PowerShell as first-class shell on Windows

Windows 原生运行时，PowerShell 替代 git-bash 成为默认 shell。`bashProvider` 和 `powershellProvider` 将在各自平台上获得平等对待。

**Why**: 项目最初设计以 bash 为中心——Windows 用户被要求安装 git-bash 才能运行。将 PowerShell 提升为一等 shell 消除了这个外部依赖，且符合 Windows 原生平台的惯例。git-bash 仍作为可选替代保留。

**Alternatives considered**: 强制要求 git-bash（当前状态）——但这意味着 Windows 版本永远不是"真原生"的。完全移除 git-bash——过度限制，部分用户可能在 hook 和其他脚本中依赖 bash。
