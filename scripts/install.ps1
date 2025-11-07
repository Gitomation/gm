# Requires Administrator privileges
$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/Gitomation/gm.git"
$AppName = "gm"
$InstallDir = "$Env:ProgramFiles\Gitomation"
$TempDir = Join-Path $Env:TEMP "gm_install_$(Get-Random)"

Write-Host "==> Cloning repository..."
git clone --depth 1 $RepoUrl $TempDir

Set-Location $TempDir

Write-Host "==> Building release binary..."
cargo build --release

$BinPath = "target\release\${AppName}.exe"

if (-not (Test-Path $BinPath)) {
    Write-Error "Build failed. Binary not found at $BinPath"
    exit 1
}

Write-Host "==> Installing binary to $InstallDir..."
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
}

Copy-Item $BinPath -Destination "$InstallDir\${AppName}.exe" -Force

Write-Host "==> Adding to PATH (if needed)..."
$CurrentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($CurrentPath -notlike "*$InstallDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$CurrentPath;$InstallDir", "Machine")
    Write-Host "PATH updated. You may need to restart PowerShell or your terminal."
}

Write-Host "==> Cleaning up temporary files..."
Set-Location $Env:TEMP
Remove-Item -Recurse -Force $TempDir

Write-Host "Installation complete!"
Write-Host "You can now run '$AppName' from any PowerShell window."
