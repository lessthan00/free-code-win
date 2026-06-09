# Free-Code 安装与配置指南

## 环境要求

- **Runtime**: Bun >= 1.3.11
- **OS**: macOS / Linux / Windows (WSL 或 PowerShell)
- **API Key**: DeepSeek 或其他兼容 Anthropic API 的提供商

## 1. 安装 Bun

```powershell
curl -fsSL https://bun.sh/install | bash
```

## 2. 克隆项目并安装依赖

```powershell
git clone git@github.com:lessthan00/free-code-win.git
cd free-code-win
bun install
```

## 3. 配置 DeepSeek API 环境变量 (PowerShell)

```powershell
$env:ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic"
$env:ANTHROPIC_AUTH_TOKEN="<你的 DeepSeek API Key>"
$env:ANTHROPIC_MODEL="deepseek-v4-pro"
$env:ANTHROPIC_DEFAULT_OPUS_MODEL="deepseek-v4-pro"
$env:ANTHROPIC_DEFAULT_SONNET_MODEL="deepseek-v4-pro"
$env:ANTHROPIC_DEFAULT_HAIKU_MODEL="deepseek-v4-flash"
$env:CLAUDE_CODE_SUBAGENT_MODEL="deepseek-v4-flash"
$env:CLAUDE_CODE_EFFORT_LEVEL="max"
```

> 注意：Windows 用户建议安装 [Windows Terminal](https://aka.ms/terminal) 以获得更好的终端渲染效果。

## 4. 运行项目

```powershell
# 在同一个 PowerShell 窗口中运行（环境变量仅在该会话有效）
bun run dev
```

### 一次性命令（设置环境变量 + 启动）

```powershell
$env:ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic"; $env:ANTHROPIC_AUTH_TOKEN="sk-xxx"; $env:ANTHROPIC_MODEL="deepseek-v4-pro"; $env:ANTHROPIC_DEFAULT_OPUS_MODEL="deepseek-v4-pro"; $env:ANTHROPIC_DEFAULT_SONNET_MODEL="deepseek-v4-pro"; $env:ANTHROPIC_DEFAULT_HAIKU_MODEL="deepseek-v4-flash"; $env:CLAUDE_CODE_SUBAGENT_MODEL="deepseek-v4-flash"; $env:CLAUDE_CODE_EFFORT_LEVEL="max"; bun run dev
```

## 5. 可用 DeepSeek 模型

| 模型 | 说明 |
|------|------|
| `deepseek-v4-pro` | 推理能力最强，适合复杂任务 |
| `deepseek-v4-flash` | 速度快，适合子代理(sub-agent)、简单任务 |
| `deepseek-chat` | 将于 2026/07/24 弃用 |
| `deepseek-reasoner` | 将于 2026/07/24 弃用 |

## 6. 其他运行方式

```powershell
# 构建为二进制，然后运行
bun run build
./cli

# 完整功能构建（启用所有 54 个实验性功能）
bun run build:dev:full
./cli-dev

# 一次性问答模式
./cli -p "what files are in this directory?"

