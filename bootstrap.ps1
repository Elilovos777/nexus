# NeXus Bootstrap Loader

$ErrorActionPreference = "Stop"

Write-Host "🔷 NeXus Bootstrap Loader" -ForegroundColor Cyan
Write-Host "Descargando NeXus..." -ForegroundColor Yellow

$scriptUrl = https://raw.githubusercontent.com/Elilovos777/nexus/refs/heads/main/nexus.ps1

try {
    $script = Invoke-RestMethod -Uri $scriptUrl
    Invoke-Expression $script
}
catch {
    Write-Host "❌ Error al ejecutar NeXus" -ForegroundColor Red
    Write-Host $_
}
