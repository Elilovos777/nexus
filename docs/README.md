# 📚 Documentación Técnica — NeXus v1.8.7

---

## Arquitectura general

NeXus es un script PowerShell monolítico (~7,800 líneas) que usa **WPF (Windows Presentation Foundation)** cargado dinámicamente mediante `[Windows.Markup.XamlReader]::Load()`. No requiere compilación ni instalación de dependencias.

```
bootstrap.ps1
    └── descarga NeXus_v1_8_7.ps1 desde GitHub
            ├── XAML (interfaz WPF embebido como string)
            ├── Base de datos de apps ($script:appDatabase)
            ├── Funciones del sistema
            └── Handlers de eventos
```

---

## Flujo de ejecución

```
1. bootstrap.ps1 descarga NeXus_v1_8_7.ps1 con Invoke-RestMethod
2. Invoke-Expression ejecuta el script en memoria (sin escribir a disco)
3. El script carga los assemblies WPF (PresentationFramework, etc.)
4. Se muestra el splash screen con animación glitch (8 fases, ~3 seg)
5. Se inicializa la ventana principal y se registran todos los handlers
6. El usuario interactúa con la GUI
```

---

## Estructura interna del script

### Variables globales (`$script:`)

| Variable | Tipo | Descripción |
|----------|------|-------------|
| `$script:appDatabase` | `@{}` | Base de datos completa de apps por plataforma y categoría |
| `$script:selectedApps` | `@()` | Apps seleccionadas para instalar |
| `$script:selectedAppsToRemove` | `@()` | Apps seleccionadas para desinstalar |
| `$script:currentPlatform` | `string` | Plataforma detectada: `Windows`, `Linux`, `macOS` |
| `$script:currentView` | `string` | Pestaña activa actualmente |
| `$script:_regCache` | `@{}` | Caché del registro de Windows (TTL 2 min) |
| `$script:_ejSearchJob` | `Job` | Background job de búsqueda en "Mis Apps" |
| `$script:_hwJob` | `Job` | Background job del escáner de hardware |

### Funciones principales

| Función | Descripción |
|---------|-------------|
| `Switch-View($viewName)` | Oculta todas las vistas y muestra la solicitada |
| `Load-AppsList` | Renderiza las tarjetas de apps en la vista Instalar |
| `Load-InstalledAppsList` | Carga apps instaladas para la vista Desinstalar |
| `Load-EjecutarAppsList` | Detecta y muestra apps instaladas con botón ▶ Abrir |
| `Start-HardwareScan` | Escanea hardware del equipo y muestra compatibilidad |
| `Start-SecurityClean` | Ejecuta limpieza de seguridad en 5 fases |
| `Find-AppInfo($key)` | Busca una app en `$script:appDatabase` por su Key |
| `Get-RegCache` | Retorna caché del registro (construye si expiró) |
| `Load-OSList` | Carga botones de descarga de sistemas operativos |
| `Update-SelectionCount` | Actualiza contador de apps seleccionadas |
| `Update-RemoveSelectionCount` | Actualiza contador de apps a desinstalar |

---

## Base de datos de apps

Cada app en `$script:appDatabase["Windows"]` sigue esta estructura:

```powershell
@{
    Key   = "NombreInterno"       # Identificador único interno
    Name  = "Nombre Visible"      # Nombre que se muestra en la UI
    Desc  = "Descripción corta"   # Subtítulo en la tarjeta
    Icon  = "🔧"                  # Emoji del ícono
    ID    = "Publisher.AppName"   # ID de winget (puede ser $null para apps de pago)
    Price = "Gratis"              # "Gratis", "De pago", "Open Source"
}
```

Si `ID` es `$null`, NeXus abre la URL del sitio oficial en lugar de instalar con winget.

---

## Sistema de instalación

La instalación usa `Start-Job` para ejecutarse en background y un `DispatcherTimer` para hacer polling cada 300ms y actualizar la UI:

```
Usuario presiona "Instalar seleccionadas"
    → foreach $appKey in $script:selectedApps
        → Resolver ID y datos desde $script:appDatabase
        → Start-Job { winget install --id $id --silent --accept-* }
        → DispatcherTimer hace polling hasta que el job termina
        → Actualiza progress bar y label en la UI
        → Siguiente app
    → Muestra resumen final
```

---

## Sistema de desinstalación

4 estrategias en cascada, ejecutadas dentro del job:

```
1. UninstallString del registro (exe silencioso o msiexec)
2. winget uninstall --id $realWingetId --silent --force
3. winget uninstall --name $displayName --silent --force
4. msiexec /x {GUID} /qn /norestart
```

El `UninstallString` se filtra: se ignoran entradas que contienen `ms-windows-store` o `MicrosoftStore`.

---

## Vista "Mis Apps" — Detección de apps instaladas

El escaneo se ejecuta en un `Start-Job` para no bloquear la UI. Orden de búsqueda:

```
1. Registro de Windows (HKLM + HKCU Uninstall) — normaliza nombres con regex [^a-z0-9]
2. Accesos directos .lnk en el menú de inicio (sin escaneo de disco)
3. AppData\Local\Programs con Depth 3 (solo si los anteriores fallan)
```

La caché del registro expira cada 2 minutos (`$script:_regCacheTime`).

---

## Escáner de Hardware

Usa `Get-CimInstance` para obtener datos del sistema:

| CIM Class | Dato obtenido |
|-----------|--------------|
| `Win32_Processor` | Nombre, núcleos, threads, velocidad máxima |
| `Win32_PhysicalMemory` | Capacidad total de RAM |
| `Win32_VideoController` | Nombre GPU, memoria VRAM |
| `Win32_LogicalDisk` | Espacio libre y total en disco C: |
| `Win32_OperatingSystem` | Nombre y versión de Windows |

La compatibilidad se calcula comparando los valores obtenidos contra los requerimientos mínimos definidos en `$script:hwRequirements`.

---

## Limpieza de Seguridad (Tron-style)

Inspirada en [Tron Script](https://github.com/bmrf/tron). Las 5 fases se ejecutan secuencialmente con jobs en background y una ventana WPF separada con doble barra de progreso (por fase + total):

| Fase | Herramienta | Seguridad |
|------|-------------|-----------|
| 1 - Temporales | `Remove-Item`, `cleanmgr /sagerun` | ✅ Solo archivos temp |
| 2 - Defender | `Update-MpSignature`, `Start-MpScan`, `Remove-MpThreat` | ✅ Solo amenazas detectadas |
| 3 - Registro | `Remove-ItemProperty` en claves Run | ✅ Lista de 30+ PUPs conocidos |
| 4 - Reparación | `sfc /verifyonly` + `dism /Cleanup-Image` | ✅ No modifica archivos legítimos |
| 5 - Red | `ipconfig /flushdns`, `netsh winsock reset` | ✅ Restaurable con reinicio |

---

## Compatibilidad

| Componente | Versión mínima |
|------------|---------------|
| Windows | 10 (build 1903) / 11 |
| PowerShell | 5.1 |
| .NET Framework | 4.5 (incluido en Win 10+) |
| winget | 1.0+ (incluido en Win 11, disponible para Win 10) |

---

## Preguntas frecuentes

**¿NeXus escribe archivos en mi disco?**  
No. Cuando se ejecuta vía `irm | iex`, el script corre completamente en memoria.

**¿Puedo ejecutarlo sin internet después de descargarlo?**  
Sí. Descarga el archivo `.ps1` y ejecútalo directamente: `.\NeXus_v1_8_7.ps1`

**¿La limpieza de seguridad puede dañar mi sistema?**  
No. Solo elimina archivos temporales, amenazas detectadas por Defender, entradas de registro de adware conocido, y ejecuta herramientas propias de Windows (SFC, DISM). Nada de esto toca software legítimo.

**¿Qué pasa si winget no está instalado?**  
Para Windows 10, instala el [App Installer desde la Microsoft Store](https://apps.microsoft.com/store/detail/app-installer/9NBLGGH4NNS1). En Windows 11 ya viene incluido.
