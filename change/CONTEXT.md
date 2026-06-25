# Claude Code (free-code)

一个 AI 驱动的终端编码助手（CLI）。用户在交互式 REPL 中与 LLM 对话，LLM 通过工具（bash/powershell 命令、文件读写等）执行编码任务。

## Language

**REPL**:
主交互界面：一个全屏终端 UI，用户输入提示词，LLM 流式返回响应。构建在 Ink (React 终端渲染器) 之上。

**Tool**:
LLM 可以调用的能力。包括 BashTool (执行 shell 命令)、Edit (文件编辑)、Read (文件阅读) 等。每个工具都有 JSON schema 定义的输入参数。

**Shell provider**:
封装 shell 差异的适配层。`ShellProvider` 接口定义了如何构建命令、生成 spawn 参数、提供环境变量。当前有两个 provider：`bashProvider` (Linux/macOS 默认) 和 `powershellProvider`。

**Platform**:
运行时平台。分类为 `macos`、`windows`、`wsl`、`linux`。决定了 shell 选项、终端功能检测、路径格式等行为差异。注意 `wsl` 和 `windows` 是不同的：wsl 本质是 Linux 内核，windows 是原生 Win32。

**PowerShell edition**:
- **Core (pwsh.exe/pwsh)** — PowerShell 7+，支持 `&&`、`||` 等管道链操作符
- **Desktop (powershell.exe)** — Windows PowerShell 5.1，无管道链操作符，stderr 会导致 `$?` 为 false
_Avoid_: 混用 "PowerShell" 指代两个版本时不加限定

**Terminal emulator**:
- **Windows Terminal (wt.exe)** — Windows 上唯一完全支持 VT100/DEC 2026/Kitty 键盘协议的终端
- **conhost** — Windows 传统终端宿主，ANSI 支持有限，有光标视口回滚 bug
- **ConEmu** — 第三方终端，支持 OSC 9;4 进度条
_Avoid_: 用 "terminal" 泛指时不区分能力差异

**Feature flag**:
编译期特性开关，用 `feature()` 宏做 DCE (死代码消除)。生产构建只有默认特性；dev-full 构建包含所有实验特性。Windows 迁移用此机制排除不能跨平台的 native 模块。

## Relationships

- 一个 **Platform** 决定默认的 **Shell provider**：windows → powershellProvider，其他 → bashProvider
- **PowerShell edition** 影响提示词中的语法指导 — 模型不能在 Desktop 版上使用 `&&`
- Windows 上的 native 模块（语音、图片处理等）通过 **Feature flag** 编译期排除，运行时打印"当前平台不支持"

## Flagged ambiguities

- "Windows 支持" 之前意味着 WSL，现在意味着原生 Win32 — 迁移完成后 `SUPPORTED_PLATFORMS` 将包含 `windows`
- "git-bash" 曾经是 Windows 上强制要求的，现在降级为可选
