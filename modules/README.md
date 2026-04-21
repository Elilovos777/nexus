# 🧩 Módulos — NeXus

Esta carpeta está reservada para módulos independientes que se integrarán en versiones futuras de NeXus.

## Propósito

Permitir que NeXus crezca de forma modular sin aumentar el tamaño del script principal. Cada módulo podrá ser descargado y ejecutado de forma independiente o integrado automáticamente por `bootstrap.ps1`.

## Módulos planeados

### `nexus-db.ps1` — Base de datos de apps
Separará `$script:appDatabase` del script principal para poder actualizar el catálogo sin modificar el núcleo de NeXus.

### `nexus-security.ps1` — Limpieza de seguridad ampliada
Versión extendida de la Limpieza de Seguridad Profunda con soporte para:
- Descarga y ejecución de Malwarebytes Free (modo escáner)
- Limpieza de extensiones de Chrome/Edge/Firefox maliciosas
- Revisión de tareas programadas sospechosas (`schtasks`)
- Análisis de servicios de Windows con nombres no estándar

### `nexus-drivers.ps1` — Actualización de drivers
Detección y actualización de drivers desactualizados vía winget y Windows Update.

### `nexus-backup.ps1` — Punto de restauración automático
Crea un punto de restauración del sistema antes de aplicar tweaks o limpiezas.

### `nexus-profiles.ps1` — Perfiles de configuración
Guarda y restaura configuraciones predefinidas para diferentes tipos de usuario (estudiante, gamer, desarrollador, laptop).

## Convención de nombres

Todos los módulos seguirán el formato `nexus-[nombre].ps1` y serán cargados por bootstrap si están disponibles en el repositorio:

```powershell
# Ejemplo de carga dinámica en bootstrap.ps1 (versión futura)
$moduleUrl = "https://raw.githubusercontent.com/Elilovos777/nexus/main/modules/nexus-security.ps1"
$module = Invoke-RestMethod -Uri $moduleUrl
Invoke-Expression $module
```

## Contribuir

Si quieres proponer un módulo nuevo, abre un [Issue en GitHub](https://github.com/Elilovos777/nexus/issues) con el tag `módulo` describiendo qué haría y por qué sería útil para la comunidad.
