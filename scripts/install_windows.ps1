# 定義環境變數
$HTTP_PROXY = $env:HTTP_PROXY
$HTTPS_PROXY = $env:HTTPS_PROXY
$USE_UV = $env:USE_UV
$PYPI_SOURCE = $env:PYPI_SOURCE

$RYE_VERSION = $env:RYE_VERSION

# Install Rye
Invoke-RestMethod -Uri "https://github.com/astral-sh/rye/releases/download/${RYE_VERSION}/rye-x86-windows.exe" -OutFile "rye.exe"
if (-Not (Test-Path -Path "rye.exe")) {
    Write-Error "Rye 安裝失敗，未找到 'rye.exe' 檔案。"
    exit 1
}

# 確保 Rye 可執行
if (-Not (Get-Command ".\rye.exe" -ErrorAction SilentlyContinue)) {
    Write-Error "Rye 安裝失敗，'rye.exe' 無法執行。"
    exit 1
}

# Setup Rye path
$shimsPath = "$env:USERPROFILE\.rye\shims"
[System.Environment]::SetEnvironmentVariable("PATH", "$shimsPath;$env:PATH", [System.EnvironmentVariableTarget]::Process)
[System.Environment]::SetEnvironmentVariable("PATH", "$shimsPath;$env:PATH", [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("PATH", "$shimsPath;$env:PATH", [System.EnvironmentVariableTarget]::Machine)

# Check if the rye directory exists
if (-Not (Test-Path -Path "$env:USERPROFILE\.rye")) {
    New-Item -ItemType Directory -Path "$env:USERPROFILE\.rye"
}

# Copy base config
Copy-Item -Path "$env:GITHUB_ACTION_PATH\configs\config.toml" -Destination "$env:USERPROFILE\.rye\" -Force

# Reload powershell
$env:PATH = "$shimsPath;$env:PATH"

# 腳本所在目錄作為工作目錄
Set-Location $PSScriptRoot

# Setup Proxy if needed
if ($HTTP_PROXY) {
    .\rye.exe config --set "proxy.http=$HTTP_PROXY"
}
if ($HTTPS_PROXY) {
    .\rye.exe config --set "proxy.https=$HTTPS_PROXY"
}

# Setup UV
if ($USE_UV -eq "true") {
    .\rye.exe config --set-bool "behavior.use-uv=true"
}

# Setup PyPI source
if ($PYPI_SOURCE) {
    (Get-Content "$env:USERPROFILE\.rye\config.toml") -replace 'url = "https://pypi.org/simple"', ('url = "' + $PYPI_SOURCE + '"') | Set-Content "$env:USERPROFILE\.rye\config.toml"
}

# Check config
# Get-Content "$env:USERPROFILE\.rye\config.toml"
