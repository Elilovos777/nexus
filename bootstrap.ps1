$ErrorActionPreference = "Stop"

Write-Host "🔷 NeXus Bootstrap Loader" -ForegroundColor Cyan
Write-Host "Preparando descarga..." -ForegroundColor Yellow

$scriptUrl = "https://raw.githubusercontent.com/Elilovos777/nexus/main/nexus.ps1"
$tempFile = "$env:TEMP\nexus.ps1"

try {
    # Descargar archivo
    Invoke-WebRequest -Uri $scriptUrl -OutFile $tempFile

    Write-Host "✔ Descarga completada" -ForegroundColor Green

    # Confirmación del usuario (seguridad básica)
    $confirm = Read-Host "¿Deseas ejecutar NeXus? (S/N)"
    if ($confirm -ne "S") {
        Write-Host "Cancelado por el usuario"
        exit
    }

    # Ejecutar como administrador
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$tempFile`"" -Verb RunAs
}
catch {
    Write-Host "❌ Error al descargar o ejecutar NeXus" -ForegroundColor Red
    Write-Host $_
}
