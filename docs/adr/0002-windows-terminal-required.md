# Windows Terminal required on Windows

Windows 原生产物的最小终端要求是 Windows Terminal (wt.exe)。不再支持 conhost 和第三方终端（ConEmu 除外，可降级兼容）。

**Why**: CLI 重度依赖 ANSI 转义序列、DEC 2026 同步输出（用于零闪烁重绘）以及 Kitty 键盘协议。conhost 对这些特性的支持不完整，且存在已认证的光标视口回滚 bug（`hasCursorUpViewportYankBug`）。将支持限定在 Windows Terminal 可避免大量兼容代码和维护负担。

**Alternatives considered**: 支持全部终端——需要对每种终端差异实现降级路径，维护成本高。Windows Terminal 默认提供（Windows 10/11 已内置且可设为默认终端），对用户的阻力很小。
