# Free-Code 启动脚本
# 用法：.\start.ps1

$ErrorActionPreference = "Stop"

# ========== 全局状态 ==========
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$originalCwd = Get-Location
$selectedBinary = ".\cli-dev"         # 默认二进制
$selectedBuildVariant = "dev-full"    # 默认构建变体
$script:readyChecked = $false         # 环境检测是否已执行

# ========== 工具函数 ==========

function Write-Banner {
  Write-Host ""
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host "  free-code 启动脚本" -ForegroundColor Cyan
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host ""
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

# ========== Bun 环境检测与安装 ==========
function Invoke-BunCheck {
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
}

# ========== 项目依赖安装 ==========
function Invoke-DepsCheck {
  Set-Location $scriptDir

  if (Test-Path "$scriptDir\node_modules") {
    Write-OK "node_modules 已存在，跳过安装"
  } else {
    Write-Warn "正在运行 bun install..."
    bun install
    if ($LASTEXITCODE -ne 0) {
      Write-Err "依赖安装失败！"
      exit 1
    }
    Write-OK "依赖安装完成"
  }
}

# ========== 环境就绪检查（懒加载） ==========
function Invoke-EnsureReady {
  if ($script:readyChecked) { return }
  Write-Host ""
  Invoke-BunCheck
  Write-Host ""
  Invoke-DepsCheck
  Write-Host ""
  $script:readyChecked = $true
}

# ========== 构建菜单 ==========
function Invoke-BuildMenu {
  Invoke-EnsureReady

  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host "  构建 free-code" -ForegroundColor Cyan
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host ""
  Write-Host "  请选择构建变体：" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "  [1] 标准构建 (./cli)        - 正式版"
  Write-Host "  [2] 开发构建 (./cli-dev)    - 带调试标记"
  Write-Host "  [3] 完整实验版 (./cli-dev)  - 全部实验功能 (推荐)"
  Write-Host "  [4] 编译构建 (./dist/cli)   - 单文件输出"
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
    }
    2 {
      Write-Warn "正在构建开发版..."
      Set-Location $scriptDir
      bun run build:dev
      if ($LASTEXITCODE -ne 0) { Write-Err "构建失败！"; return }
      Write-OK "构建完成 -> ./cli-dev"
      $script:selectedBinary = ".\cli-dev"
      $script:selectedBuildVariant = "dev"
    }
    3 {
      Write-Warn "正在构建完整实验版..."
      Set-Location $scriptDir
      bun run build:dev:full
      if ($LASTEXITCODE -ne 0) { Write-Err "构建失败！"; return }
      Write-OK "构建完成 -> ./cli-dev (全部实验功能)"
      $script:selectedBinary = ".\cli-dev"
      $script:selectedBuildVariant = "dev-full"
    }
    4 {
      Write-Warn "正在编译构建..."
      Set-Location $scriptDir
      bun run compile
      if ($LASTEXITCODE -ne 0) { Write-Err "构建失败！"; return }
      Write-OK "构建完成 -> ./dist/cli"
      $script:selectedBinary = ".\dist\cli"
      $script:selectedBuildVariant = "compile"
    }
    5 {
      Write-Host ""
      Write-Host "  可用的 Feature Flags (多个用逗号分隔):" -ForegroundColor Yellow
      Write-Host "  ULTRAPLAN, ULTRATHINK, BRIDGE_MODE, TOKEN_BUDGET,"
      Write-Host "  HISTORY_PICKER, MESSAGE_ACTIONS, QUICK_SEARCH,"
      Write-Host "  BUILTIN_EXPLORE_PLAN_AGENTS, VERIFICATION_AGENT,"
      Write-Host "  AGENT_TRIGGERS, EXTRACT_MEMORIES, COMPACTION_REMINDERS,"
      Write-Host "  TEAMMEM, VOICE_MODE, SHOT_STATS, 等..."
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
      }
    }
    6 { return }
  }
  Pause-Continue
}

# ========== 启动 free-code ==========
function Invoke-Launch {
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host "  提示：建议使用 Windows Terminal 以获得最佳体验" -ForegroundColor Cyan
  Write-Host "  下载：https://aka.ms/terminal" -ForegroundColor Cyan
  Write-Host "========================================" -ForegroundColor Cyan
  Write-Host ""
  Write-Host "  Provider / API Key / 代理请在启动后通过以下命令配置:" -ForegroundColor DarkGray
  Write-Host "    /provider  - 配置 API 提供商 (DeepSeek / Gemini / Anthropic)" -ForegroundColor DarkGray
  Write-Host "    /proxy     - 配置网络代理" -ForegroundColor DarkGray
  Write-Host "    /login     - Anthropic OAuth 登录" -ForegroundColor DarkGray
  Write-Host ""

  # 检查二进制是否存在，不存在则自动构建
  $binaryPath = Join-Path $scriptDir $script:selectedBinary
  if (-not (Test-Path $binaryPath) -and -not (Test-Path "$binaryPath.exe")) {
    Invoke-EnsureReady
    Write-Warn "$script:selectedBinary 不存在，正在自动构建..."
    Set-Location $scriptDir
    switch ($script:selectedBuildVariant) {
      "standard"  { bun run build }
      "dev"       { bun run build:dev }
      "compile"   { bun run compile }
      default     { bun run build:dev:full }
    }
    if ($LASTEXITCODE -ne 0) {
      Write-Err "自动构建失败！请手动选择菜单 [2] 构建。"
      Pause-Continue
      return
    }
    Write-OK "自动构建完成"
  }

  # 恢复原始工作目录
  Set-Location $originalCwd

  # 启动
  $fullPath = Join-Path $scriptDir $script:selectedBinary
  Write-OK "启动: $fullPath"
  Write-Host ""

  & $fullPath

  Write-Host ""
  Write-Host "free-code 已退出。" -ForegroundColor Cyan
}

# ========== 主菜单 ==========
function Invoke-MainMenu {
  while ($true) {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  free-code 启动菜单" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  当前设置:" -ForegroundColor DarkGray
    Write-Host "    二进制: $script:selectedBinary ($script:selectedBuildVariant)" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  请选择操作：" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  [1] 启动 free-code"
    Write-Host "  [2] 构建 free-code"
    Write-Host "  [3] 从源码运行 (bun run dev)"
    Write-Host "  [4] 退出"
    Write-Host ""

    $choice = Read-Option "请输入选项 (1-4)" 1 4

    switch ($choice) {
      1 {
        Invoke-Launch
        break
      }
      2 {
        Invoke-BuildMenu
        break
      }
      3 {
        Invoke-EnsureReady
        Write-Warn "从源码运行 (bun run dev)，启动较慢..."
        Set-Location $scriptDir
        Write-Host ""
        & bun run dev
        Write-Host ""
        Write-Host "free-code 已退出。" -ForegroundColor Cyan
        Pause-Continue
        break
      }
      4 {
        Write-Host "再见!" -ForegroundColor Cyan
        exit 0
      }
    }
  }
}

# ==================== 主入口 ====================

Write-Banner
Invoke-MainMenu
