# Free-Code 安装脚本（首次配置）
# 用法：.\install.ps1

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

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

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  free-code 安装脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  首次使用前运行此脚本，配置开发环境。" -ForegroundColor Yellow
Write-Host ""

# ========== 1. Bun 检测与安装 ==========
function Invoke-InstallBun {
  Write-Host ">>> 检测 Bun..." -ForegroundColor Yellow
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

# ========== 2. 项目依赖安装 ==========
function Invoke-InstallDeps {
  Write-Host ""
  Write-Host ">>> 安装项目依赖..." -ForegroundColor Yellow
  Set-Location $scriptDir

  if (Test-Path "$scriptDir\node_modules") {
    Write-Warn "node_modules 已存在，是否重新安装？"
    $redo = Read-Host -Prompt "重新安装? (y/n，回车跳过)"
    if ($redo -ne 'y') {
      Write-OK "跳过依赖安装"
      return
    }
  }

  Write-Warn "正在运行 bun install..."
  bun install
  if ($LASTEXITCODE -ne 0) {
    Write-Err "依赖安装失败！"
    exit 1
  }
  Write-OK "依赖安装完成"
}

# ========== 3. 注册全局命令 ==========
function Invoke-InstallGlobalCommand {
  Write-Host ""
  Write-Host ">>> 注册 freecode 全局命令..." -ForegroundColor Yellow

  $scriptAbsolutePath = (Resolve-Path "$scriptDir\start.ps1").Path
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
    }
  }

  Add-Content -Path $profilePath -Value $newFunctionDef -Encoding UTF8
  Write-OK "已成功将 freecode 命令写入：$profilePath"
  Write-Host ""
  Write-Host "  请执行：. `$PROFILE   （或重新打开终端）" -ForegroundColor Cyan
  Write-Host "  之后在任何目录输入 freecode 即可启动！" -ForegroundColor Cyan
}

# ========== 4. 清理旧版残留 ==========
function Invoke-CleanLegacyEnv {
  Write-Host ""
  Write-Host ">>> 检查旧版 start.ps1 残留..." -ForegroundColor Yellow

  $legacyVars = @(
    "FREE_CODE_PROVIDER",
    "FREE_CODE_PROXY",
    "FREE_CODE_BUILD_VARIANT",
    "DEEPSEEK_API_KEY",
    "GEMINI_API_KEY"
  )

  $found = @()
  foreach ($v in $legacyVars) {
    $val = [Environment]::GetEnvironmentVariable($v, "User")
    if (-not [string]::IsNullOrEmpty($val)) {
      $masked = if ($v -like "*KEY*") { $val.Substring(0, [Math]::Min(7, $val.Length)) + "***" } else { $val }
      Write-Warn "  发现残留: $v = $masked"
      $found += $v
    }
  }

  if ($found.Count -eq 0) {
    Write-OK "未发现旧版残留"
    return
  }

  Write-Host ""
  $confirm = Read-Host -Prompt "清除这些残留? (y/n)"
  if ($confirm -ne 'y') {
    Write-OK "跳过清理"
    return
  }

  foreach ($v in $found) {
    [Environment]::SetEnvironmentVariable($v, $null, "User")
    Write-OK "已清除: $v"
  }
  Write-OK "旧版残留清理完成"
}

# ========== 主菜单 ==========
while ($true) {
  Write-Host ""
  Write-Host "  请选择操作：" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "  [1] 检测并安装 Bun"
  Write-Host "  [2] 安装项目依赖"
  Write-Host "  [3] 注册 freecode 全局命令"
  Write-Host "  [4] 清理旧版 start.ps1 残留"
  Write-Host "  [5] 全部执行（推荐首次使用）"
  Write-Host "  [6] 退出"
  Write-Host ""

  $choice = Read-Option "请输入选项 (1-6)" 1 6

  switch ($choice) {
    1 { Invoke-InstallBun }
    2 { Invoke-InstallDeps }
    3 { Invoke-InstallGlobalCommand }
    4 { Invoke-CleanLegacyEnv }
    5 {
      Invoke-InstallBun
      Invoke-InstallDeps
      Invoke-InstallGlobalCommand
      Invoke-CleanLegacyEnv
      Write-Host ""
      Write-OK "安装完成！运行 .\start.ps1 启动 free-code。" -ForegroundColor Green
    }
    6 {
      Write-Host "再见!" -ForegroundColor Cyan
      exit 0
    }
  }
}
