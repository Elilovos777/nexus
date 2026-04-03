# NeXus
# Copyright (c) 2026 Elilovos777
# Licensed under the MIT License
# NeXus Bootstrap Loader

$ErrorActionPreference = "Stop"

Write-Host "🔷 NeXus Bootstrap Loader" -ForegroundColor Cyan
Write-Host "Descargando NeXus..." -ForegroundColor Yellow

$scriptUrl = "https://raw.githubusercontent.com/Elilovos777/nexus/main/nexus.ps1"

try {
    $scriptContent = Invoke-RestMethod -Uri $scriptUrl
    Invoke-Expression $scriptContent
}
catch {
    Write-Host "❌ Error al descargar o ejecutar NeXus" -ForegroundColor Red
    Write-Host $_
}
