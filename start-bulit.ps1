# Free-Code 启动脚本 (交互菜单版)
# 用法：.\start.ps1

$ErrorActionPreference = "Stop"

# ========== 全局状态 ==========
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$originalCwd = Get-Location
$selectedBinary = ".\cli-dev"      # 默认二进制
$selectedBuildVariant = "dev-full" # 默认构建变体
$selectedProvider = "deepseek"     # 默认 API 提供商

# ========== 工具函数 ==========

function Write-Banner {
  Write-Host ""
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host "  free-code 启动脚本" -ForegroundColor Cyan
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host ""
}

function Write-Step([string]$step, [string]$text) {
  Write-Host "[$step] $text" -ForegroundColor Yellow
}

function Write-OK([string]$text) {
  Write-Host "  $text" -ForegroundColor Green
}

function Write-Warn([string]$text) {
  Write-Host "  $text" -ForegroundColor Yellow
}

function Write-Err([string]$text) {
  Write-Host "  $text" -ForegroundColor Red
}

function Read-Option([string]$prompt, [int]$min, [int]$max) {
  while ($true) {
    $choice = Read-Host -Prompt $prompt
    if ([string]::IsNullOrWhiteSpace($choice)) { continue }
    if ($choice -match '^\d+$' -and [int]$choice -ge $min -and [int]$choice -le $max) {
      return [int]$choice
    }
    Write-Warn "请输入 $min-$max 之间的数字"
  }
}

function Pause-Continue {
  Write-Host ""
  Write-Host "按 Enter 键返回主菜单..." -ForegroundColor DarkGray
  Read-Host | Out-Null
}

# ========== 1. Bun 环境检测与安装 ==========
function Invoke-BunCheck {
  Write-Step "1/4" "检测 Bun 运行环境..."

  $bunInstalled = $false
  try {
    $bunVersion = bun --version 2>&1
    if ($LASTEXITCODE -eq 0) {
      Write-OK "Bun 已安装，版本: $bunVersion"
      $bunInstalled = $true
    }
  } catch { }

  if (-not $bunInstalled) {
    Write-Warn "Bun 未安装，正在自动下载并安装（来源：bun.sh 官方）..."
    $env:BUN_INSTALL = "$env:USERPROFILE\.bun"
    try {
      irm bun.sh/install.ps1 | iex
    } catch {
      Write-Err "Bun 自动安装失败！错误信息：$($_.Exception.Message)"
      Write-Err "请手动安装 Bun：https://bun.sh"
      exit 1
    }
    $env:Path = "$env:USERPROFILE\.bun\bin;$env:Path"
    $bunVersion = bun --version 2>&1
    if ($LASTEXITCODE -ne 0) {
      Write-Err "Bun 安装后仍无法运行，请重启终端或手动安装。"
      exit 1
    }
    Write-OK "Bun 安装成功，版本: $bunVersion"
  }
  Write-Host ""
  return $true
}

# ========== 2. 项目依赖安装 ==========
function Invoke-DepsCheck {
  Write-Step "2/4" "安装项目依赖..."
  Set-Location $scriptDir

  if (Test-Path "$scriptDir\node_modules") {
    Write-OK "node_modules 已存在，跳过安装（如需重新安装请先删除 node_modules）"
  } else {
    Write-Warn "正在运行 bun install..."
    bun install
    if ($LASTEXITCODE -ne 0) {
      Write-Err "依赖安装失败！"
      exit 1
    }
    Write-OK "依赖安装完成"
  }
  Write-Host ""
}

# ========== 构建菜单 ==========
function Invoke-BuildMenu {
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host "  构建 free-code" -ForegroundColor Cyan
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host ""
  Write-Host "  请选择构建变体：" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "  [1] 标准构建 (./cli)        - 仅 VOICE_MODE，类似正式版"
  Write-Host "  [2] 开发构建 (./cli-dev)    - 带调试标记的开发版"
  Write-Host "  [3] 完整实验版 (./cli-dev)  - 全部 54 个实验功能 (推荐)"
  Write-Host "  [4] 编译构建 (./dist/cli)   - 另类输出路径"
  Write-Host "  [5] 自定义功能标志          - 手动指定 feature flags"
  Write-Host "  [6] 返回主菜单"
  Write-Host ""

  $choice = Read-Option "请输入选项 (1-6)" 1 6

  switch ($choice) {
    1 {
      Write-Warn "正在构建标准版..."
      Set-Location $scriptDir
      bun run build
      if ($LASTEXITCODE -ne 0) { Write-Err "构建失败！"; return }
      Write-OK "构建完成 -> ./cli"
      $script:selectedBinary = ".\cli"
      $script:selectedBuildVariant = "standard"
      [Environment]::SetEnvironmentVariable("FREE_CODE_BUILD_VARIANT", "standard", "User")
    }
    2 {
      Write-Warn "正在构建开发版..."
      Set-Location $scriptDir
      bun run build:dev
      if ($LASTEXITCODE -ne 0) { Write-Err "构建失败！"; return }
      Write-OK "构建完成 -> ./cli-dev"
      $script:selectedBinary = ".\cli-dev"
      $script:selectedBuildVariant = "dev"
      [Environment]::SetEnvironmentVariable("FREE_CODE_BUILD_VARIANT", "dev", "User")
    }
    3 {
      Write-Warn "正在构建完整实验版..."
      Set-Location $scriptDir
      bun run build:dev:full
      if ($LASTEXITCODE -ne 0) { Write-Err "构建失败！"; return }
      Write-OK "构建完成 -> ./cli-dev (全部 54 个实验功能)"
      $script:selectedBinary = ".\cli-dev"
      $script:selectedBuildVariant = "dev-full"
      [Environment]::SetEnvironmentVariable("FREE_CODE_BUILD_VARIANT", "dev-full", "User")
    }
    4 {
      Write-Warn "正在编译构建..."
      Set-Location $scriptDir
      bun run compile
      if ($LASTEXITCODE -ne 0) { Write-Err "构建失败！"; return }
      Write-OK "构建完成 -> ./dist/cli"
      $script:selectedBinary = ".\dist\cli"
      $script:selectedBuildVariant = "compile"
      [Environment]::SetEnvironmentVariable("FREE_CODE_BUILD_VARIANT", "compile", "User")
    }
    5 {
      Write-Host ""
      Write-Host "  可用的 Feature Flags (多个用逗号分隔):" -ForegroundColor Yellow
      Write-Host "  ULTRAPLAN, ULTRATHINK, BRIDGE_MODE, TOKEN_BUDGET,"
      Write-Host "  HISTORY_PICKER, MESSAGE_ACTIONS, QUICK_SEARCH,"
      Write-Host "  BUILTIN_EXPLORE_PLAN_AGENTS, VERIFICATION_AGENT,"
      Write-Host "  AGENT_TRIGGERS, EXTRACT_MEMORIES, COMPACTION_REMINDERS,"
      Write-Host "  TEAMMEM, BASH_CLASSIFIER, VOICE_MODE, SHOT_STATS, 等..."
      Write-Host ""
      $flags = Read-Host -Prompt "请输入要启用的 flags (逗号分隔，如 ULTRAPLAN,ULTRATHINK)"
      if (-not [string]::IsNullOrWhiteSpace($flags)) {
        $flagArgs = $flags -split ',' | ForEach-Object { "--feature=$($_.Trim())" }
        Write-Warn "正在构建自定义版本..."
        Set-Location $scriptDir
        $buildCmd = "bun run ./scripts/build.ts $($flagArgs -join ' ')"
        Write-Host "  执行: $buildCmd" -ForegroundColor DarkGray
        Invoke-Expression $buildCmd
        if ($LASTEXITCODE -ne 0) { Write-Err "构建失败！"; return }
        Write-OK "构建完成 -> ./cli-dev"
        $script:selectedBinary = ".\cli-dev"
        $script:selectedBuildVariant = "custom"
        [Environment]::SetEnvironmentVariable("FREE_CODE_BUILD_VARIANT", "custom", "User")
      }
    }
    6 { return }
  }
  Pause-Continue
}

# ========== API 提供商配置 ==========
function Invoke-ProviderConfig {
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host "  配置 API 提供商" -ForegroundColor Cyan
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host ""
  Write-Host "  当前提供商: $script:selectedProvider" -ForegroundColor Green
  Write-Host ""
  Write-Host "  请选择 API 提供商：" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "  [1] DeepSeek (默认)     - api.deepseek.com/anthropic"
  Write-Host "  [2] Anthropic (官方)    - api.anthropic.com"
  Write-Host "  [3] OpenAI Codex        - 需要 Codex 订阅"
  Write-Host "  [4] AWS Bedrock         - 通过 AWS 账户路由"
  Write-Host "  [5] Google Vertex AI    - 通过 GCP 项目路由"
  Write-Host "  [6] Anthropic Foundry   - 专用部署"
  Write-Host "  [7] 返回主菜单"
  Write-Host ""

  $choice = Read-Option "请输入选项 (1-7)" 1 7
  if ($choice -eq 7) { return }

  $providerNames = @("deepseek", "anthropic", "openai", "bedrock", "vertex", "foundry")
  $script:selectedProvider = $providerNames[$choice - 1]
  [Environment]::SetEnvironmentVariable("FREE_CODE_PROVIDER", $script:selectedProvider, "User")

  switch ($choice) {
    1 {
      Write-OK "已选择: DeepSeek"
      $key = Read-Host -Prompt "请输入 DeepSeek API Key (回车跳过)"
      if (-not [string]::IsNullOrWhiteSpace($key)) {
        [Environment]::SetEnvironmentVariable("DEEPSEEK_API_KEY", $key, "User")
        Write-OK "API Key 已保存"
      }
    }
    2 {
      Write-OK "已选择: Anthropic (官方)"
      $key = Read-Host -Prompt "请输入 Anthropic API Key (回车跳过)"
      if (-not [string]::IsNullOrWhiteSpace($key)) {
        [Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $key, "User")
        Write-OK "API Key 已保存"
      }
    }
    3 {
      Write-OK "已选择: OpenAI Codex"
      Write-Warn "请确保已设置 OpenAI OAuth 或 API Key"
    }
    4 {
      Write-OK "已选择: AWS Bedrock"
      $region = Read-Host -Prompt "请输入 AWS Region (默认 us-east-1，回车跳过)"
      if (-not [string]::IsNullOrWhiteSpace($region)) {
        [Environment]::SetEnvironmentVariable("AWS_REGION", $region, "User")
        Write-OK "AWS Region 已保存: $region"
      }
    }
    5 {
      Write-OK "已选择: Google Vertex AI"
      Write-Warn "请确保已运行: gcloud auth application-default login"
    }
    6 {
      Write-OK "已选择: Anthropic Foundry"
      $key = Read-Host -Prompt "请输入 Foundry API Key (回车跳过)"
      if (-not [string]::IsNullOrWhiteSpace($key)) {
        [Environment]::SetEnvironmentVariable("ANTHROPIC_FOUNDRY_API_KEY", $key, "User")
        Write-OK "Foundry API Key 已保存"
      }
    }
  }
  Pause-Continue
}

# ========== 设置 API 环境变量 ==========
function Set-ProviderEnv {

  switch ($script:selectedProvider) {
    "deepseek" {
      $apiKey = $env:DEEPSEEK_API_KEY
      if ([string]::IsNullOrEmpty($apiKey)) { $apiKey = [Environment]::GetEnvironmentVariable("DEEPSEEK_API_KEY", "User") }

      if (-not [string]::IsNullOrEmpty($apiKey)) {
        $masked = $apiKey.Substring(0, [Math]::Min(7, $apiKey.Length)) + "***"
        Write-OK "DeepSeek API Key: $masked"
      } else {
        Write-Warn "未设置 DeepSeek API Key，可通过菜单 [6] 配置，或启动后 /login"
      }

      $env:ANTHROPIC_BASE_URL              = "https://api.deepseek.com/anthropic"
      $env:ANTHROPIC_AUTH_TOKEN            = $apiKey
      $env:ANTHROPIC_MODEL                 = "deepseek-v4-pro"
      $env:ANTHROPIC_DEFAULT_OPUS_MODEL    = "deepseek-v4-pro"
      $env:ANTHROPIC_DEFAULT_SONNET_MODEL  = "deepseek-v4-pro"
      $env:ANTHROPIC_DEFAULT_HAIKU_MODEL   = "deepseek-v4-flash"
      $env:CLAUDE_CODE_SUBAGENT_MODEL      = "deepseek-v4-flash"
      $env:CLAUDE_CODE_EFFORT_LEVEL        = "max"
    }
    "anthropic" {
      $apiKey = $env:ANTHROPIC_API_KEY
      if ([string]::IsNullOrEmpty($apiKey)) { $apiKey = [Environment]::GetEnvironmentVariable("ANTHROPIC_API_KEY", "User") }

      if (-not [string]::IsNullOrEmpty($apiKey)) {
        $env:ANTHROPIC_API_KEY = $apiKey
        $masked = $apiKey.Substring(0, [Math]::Min(7, $apiKey.Length)) + "***"
        Write-OK "Anthropic API Key: $masked"
      }
      # 不设 ANTHROPIC_BASE_URL，使用默认
      $env:ANTHROPIC_DEFAULT_OPUS_MODEL    = "claude-opus-4-6"
      $env:ANTHROPIC_DEFAULT_SONNET_MODEL  = "claude-sonnet-4-6"
      $env:ANTHROPIC_DEFAULT_HAIKU_MODEL   = "claude-haiku-4-5"
    }
    "openai" {
      $env:CLAUDE_CODE_USE_OPENAI = "1"
      Write-OK "OpenAI Codex 模式已启用"
    }
    "bedrock" {
      $env:CLAUDE_CODE_USE_BEDROCK = "1"
      $region = [Environment]::GetEnvironmentVariable("AWS_REGION", "User")
      if (-not [string]::IsNullOrEmpty($region)) {
        $env:AWS_REGION = $region
      } else {
        $env:AWS_REGION = "us-east-1"
      }
      Write-OK "AWS Bedrock 模式已启用 (region: $env:AWS_REGION)"
    }
    "vertex" {
      $env:CLAUDE_CODE_USE_VERTEX = "1"
      Write-OK "Google Vertex AI 模式已启用"
    }
    "foundry" {
      $env:CLAUDE_CODE_USE_FOUNDRY = "1"
      $key = [Environment]::GetEnvironmentVariable("ANTHROPIC_FOUNDRY_API_KEY", "User")
      if (-not [string]::IsNullOrEmpty($key)) {
        $env:ANTHROPIC_FOUNDRY_API_KEY = $key
      }
      Write-OK "Anthropic Foundry 模式已启用"
    }
  }

  Write-Host ""
  Write-Host "  环境变量概要:" -ForegroundColor DarkGray
  if ($env:ANTHROPIC_BASE_URL)           { Write-Host "    ANTHROPIC_BASE_URL = $env:ANTHROPIC_BASE_URL" -ForegroundColor DarkGray }
  if ($env:ANTHROPIC_MODEL)              { Write-Host "    ANTHROPIC_MODEL    = $env:ANTHROPIC_MODEL" -ForegroundColor DarkGray }
  if ($env:CLAUDE_CODE_USE_OPENAI)       { Write-Host "    CLAUDE_CODE_USE_OPENAI = 1" -ForegroundColor DarkGray }
  if ($env:CLAUDE_CODE_USE_BEDROCK)      { Write-Host "    CLAUDE_CODE_USE_BEDROCK = 1" -ForegroundColor DarkGray }
  if ($env:CLAUDE_CODE_USE_VERTEX)       { Write-Host "    CLAUDE_CODE_USE_VERTEX = 1" -ForegroundColor DarkGray }
  if ($env:CLAUDE_CODE_USE_FOUNDRY)      { Write-Host "    CLAUDE_CODE_USE_FOUNDRY = 1" -ForegroundColor DarkGray }
  Write-Host ""
}

# ========== 启动 free-code ==========
function Invoke-Launch {
  param(
    [string]$mode = "repl",
    [string]$prompt = "",
    [string]$model = ""
  )

  Write-Step "4/4" "启动 free-code..."
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host "  提示：建议使用 Windows Terminal 以获得最佳体验" -ForegroundColor Cyan
  Write-Host "  下载：https://aka.ms/terminal" -ForegroundColor Cyan
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host ""

  # 检查二进制是否存在
  $binaryPath = Join-Path $scriptDir $script:selectedBinary
  if (-not (Test-Path $binaryPath) -and -not (Test-Path "$binaryPath.exe")) {
    Write-Warn "$script:selectedBinary 不存在，正在自动构建..."
    Set-Location $scriptDir
    switch ($script:selectedBuildVariant) {
      "standard"  { bun run build }
      "dev"       { bun run build:dev }
      "compile"   { bun run compile }
      default     { bun run build:dev:full }
    }
    if ($LASTEXITCODE -ne 0) {
      Write-Err "自动构建失败！请手动构建后重试。"
      Pause-Continue
      return
    }
  }

  # 恢复原始工作目录
  Set-Location $originalCwd

  # 构建启动参数
  $launchArgs = @()
  if ($mode -eq "oneshot" -and -not [string]::IsNullOrEmpty($prompt)) {
    $launchArgs += "-p"
    $launchArgs += $prompt
  }
  if (-not [string]::IsNullOrEmpty($model)) {
    $launchArgs += "--model"
    $launchArgs += $model
  }

  # 启动
  $fullPath = Join-Path $scriptDir $script:selectedBinary
  Write-OK "启动: $fullPath $($launchArgs -join ' ')"
  Write-Host ""

  & $fullPath @launchArgs

  Write-Host ""
  Write-Host "free-code 已退出。" -ForegroundColor Cyan
}

# ========== 安装全局命令 ==========
function Invoke-InstallGlobalCommand {
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host "  注册全局 freecode 命令" -ForegroundColor Cyan
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host ""

  $scriptAbsolutePath = if ($PSCommandPath) {
    (Resolve-Path $PSCommandPath).Path
  } else {
    (Resolve-Path $MyInvocation.MyCommand.Path).Path
  }

  $profilePath = $PROFILE.CurrentUserAllHosts
  $profileDir = Split-Path $profilePath -Parent

  $newFunctionDef = @"

# Free-Code global command
function freecode {
    & "$scriptAbsolutePath" @args
}
"@

  if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    Write-OK "已创建 profile 目录：$profileDir"
  }

  if (Test-Path $profilePath) {
    $existingContent = Get-Content $profilePath -Raw -Encoding UTF8
    $pattern = '(?m)^\s*#\s*Free-Code global command\s*\n\s*function freecode\s*\{[^}]*\}\s*'
    if ($existingContent -match $pattern) {
      Write-Warn "检测到旧的 freecode 函数，正在移除..."
      $existingContent = $existingContent -replace $pattern, ''
      Set-Content -Path $profilePath -Value $existingContent -Encoding UTF8
      Write-OK "旧函数已移除。"
    } else {
      Write-OK "未发现旧函数，直接添加。"
    }
  }

  Add-Content -Path $profilePath -Value $newFunctionDef -Encoding UTF8
  Write-OK "已成功将 freecode 命令写入：$profilePath"
  Write-Host ""
  Write-Host "  现在请执行：. `$PROFILE   （或重新打开终端）" -ForegroundColor Cyan
  Write-Host "  之后在任何目录输入 freecode 即可启动！" -ForegroundColor Cyan
  Write-Host ""
  Write-Warn "  注意：如果项目目录位置发生变动，请重新执行此安装以更新路径。"
  Write-Host ""
}

# ========== 主菜单 ==========
function Invoke-MainMenu {
  while ($true) {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  free-code 启动菜单" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  当前设置:" -ForegroundColor DarkGray
    Write-Host "    提供商: $script:selectedProvider" -ForegroundColor DarkGray
    Write-Host "    二进制:  $script:selectedBinary ($script:selectedBuildVariant)" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  请选择操作：" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  [1] 启动 free-code (交互式 REPL)"
    Write-Host "  [2] 单次提问模式 (one-shot)"
    Write-Host "  [3] 指定模型启动"
    Write-Host "  [4] 从源码运行 (bun run dev)"
    Write-Host "  [5] 构建/重新构建"
    Write-Host "  [6] 配置 API 提供商"
    Write-Host "  [7] 安装/更新全局命令 (freecode)"
    Write-Host "  [8] 退出"
    Write-Host ""

    $choice = Read-Option "请输入选项 (1-8)" 1 8

    switch ($choice) {
      1 {
        # 交互式 REPL
        Set-ProviderEnv
        Invoke-Launch -mode "repl"
        break
      }
      2 {
        # 单次提问
        Write-Host ""
        $userPrompt = Read-Host -Prompt "请输入要提问的内容"
        if (-not [string]::IsNullOrWhiteSpace($userPrompt)) {
          Set-ProviderEnv
          Invoke-Launch -mode "oneshot" -prompt $userPrompt
        } else {
          Write-Warn "输入为空，取消操作。"
          Pause-Continue
        }
        break
      }
      3 {
        # 指定模型
        Write-Host ""
        Write-Host "  常用模型:" -ForegroundColor DarkGray
        Write-Host "    deepseek-v4-pro, deepseek-v4-flash" -ForegroundColor DarkGray
        Write-Host "    claude-opus-4-6, claude-sonnet-4-6, claude-haiku-4-5" -ForegroundColor DarkGray
        Write-Host "    gpt-5.3-codex, gpt-5.4, gpt-5.4-mini" -ForegroundColor DarkGray
        Write-Host ""
        $customModel = Read-Host -Prompt "请输入模型 ID (回车使用默认)"
        Set-ProviderEnv
        if (-not [string]::IsNullOrWhiteSpace($customModel)) {
          Invoke-Launch -mode "repl" -model $customModel
        } else {
          Invoke-Launch -mode "repl"
        }
        break
      }
      4 {
        # 从源码运行
        Write-Warn "从源码运行 (bun run dev)，启动较慢..."
        Set-ProviderEnv
        Set-Location $scriptDir
        Write-Host ""
        & bun run dev
        Write-Host ""
        Write-Host "free-code 已退出。" -ForegroundColor Cyan
        Pause-Continue
        break
      }
      5 {
        # 构建
        Invoke-BuildMenu
        break
      }
      6 {
        # 配置提供商
        Invoke-ProviderConfig
        break
      }
      7 {
        # 安装全局命令
        Invoke-InstallGlobalCommand
        Pause-Continue
        break
      }
      8 {
        Write-Host "再见!" -ForegroundColor Cyan
        exit 0
      }
    }
  }
}

# ==================== 主入口 ====================

Write-Banner

# Bun 环境检测
Invoke-BunCheck

# 项目依赖安装
Invoke-DepsCheck

# 读取已保存的提供商配置
$savedProvider = [Environment]::GetEnvironmentVariable("FREE_CODE_PROVIDER", "User")
if (-not [string]::IsNullOrEmpty($savedProvider)) {
  $script:selectedProvider = $savedProvider
}

# 读取已保存的构建变体
$savedVariant = [Environment]::GetEnvironmentVariable("FREE_CODE_BUILD_VARIANT", "User")
if (-not [string]::IsNullOrEmpty($savedVariant)) {
  $script:selectedBuildVariant = $savedVariant
}

# 根据构建变体设置二进制路径
switch ($script:selectedBuildVariant) {
  "standard"  { $script:selectedBinary = ".\cli" }
  "dev"       { $script:selectedBinary = ".\cli-dev" }
  "dev-full"  { $script:selectedBinary = ".\cli-dev" }
  "compile"   { $script:selectedBinary = ".\dist\cli" }
  "custom"    { $script:selectedBinary = ".\cli-dev" }
}

# 进入交互菜单
Invoke-MainMenu
