# NeXus Bootstrap Loader v1.8.7
# Copyright (c) 2026 Elilovos777 (nexu_016)
# Licensed under the MIT License
#
# Uso:
#   irm https://raw.githubusercontent.com/Elilovos777/nexus/main/bootstrap.ps1 | iex

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

# ── Verificar que corre como Administrador ────────────────────────────────
$currentPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host ""
    Write-Host "  ❌  NeXus requiere privilegios de Administrador." -ForegroundColor Red
    Write-Host "     Abre PowerShell como Administrador y vuelve a intentarlo." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# ── Header ────────────────────────────────────────────────────────────────
Clear-Host
Write-Host ""
Write-Host "  ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗" -ForegroundColor Magenta
Write-Host "  ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝" -ForegroundColor Magenta
Write-Host "  ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗" -ForegroundColor Magenta
Write-Host "  ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║" -ForegroundColor Magenta
Write-Host "  ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║" -ForegroundColor Magenta
Write-Host "  ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝" -ForegroundColor Magenta
Write-Host ""
Write-Host "  Sistema de Automatización Multiplataforma  v1.8.7" -ForegroundColor Cyan
Write-Host "  by nexu_016 / Elilovos777" -ForegroundColor DarkGray
Write-Host "  ─────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

# ── URL del script principal ──────────────────────────────────────────────
$scriptUrl = "https://raw.githubusercontent.com/Elilovos777/nexus/main/nexus.ps1"

Write-Host "  🔷 Verificando conexión a internet..." -ForegroundColor Cyan

try {
    $null = Invoke-WebRequest -Uri "https://raw.githubusercontent.com" -UseBasicParsing -TimeoutSec 8 -ErrorAction Stop
    Write-Host "  ✅ Conexión establecida" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Sin conexión a internet o GitHub no disponible." -ForegroundColor Red
    Write-Host "     Verifica tu conexión e intenta de nuevo." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host "  🔷 Descargando NeXus v1.8.7..." -ForegroundColor Cyan

try {
    $scriptContent = Invoke-RestMethod -Uri $scriptUrl -ErrorAction Stop
    Write-Host "  ✅ Descarga completada ($([Math]::Round($scriptContent.Length / 1KB)) KB)" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "  ❌ Error al descargar NeXus:" -ForegroundColor Red
    Write-Host "     $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Puedes intentar la descarga manual:" -ForegroundColor Cyan
    Write-Host "  https://github.com/Elilovos777/nexus/releases" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host "  🔷 Iniciando NeXus..." -ForegroundColor Cyan
Write-Host ""
Start-Sleep -Milliseconds 400

try {
    Invoke-Expression $scriptContent
} catch {
    Write-Host ""
    Write-Host "  ❌ Error al ejecutar NeXus:" -ForegroundColor Red
    Write-Host "     $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Si el problema persiste, abre un issue en:" -ForegroundColor Cyan
    Write-Host "  https://github.com/Elilovos777/nexus/issues" -ForegroundColor White
    Write-Host ""
    exit 1
}
