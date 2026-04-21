# 📄 CHANGELOG — NeXus

Todos los cambios notables de cada versión se documentan aquí.  
Formato basado en [Keep a Changelog](https://keepachangelog.com/es/1.0.0/).

---

## [1.8.7] — 2026

### Añadido
- **Pestaña "Mis Apps"** — detecta apps del catálogo instaladas en el equipo escaneando el registro de Windows y el menú de inicio. Muestra botón `▶ Abrir` para lanzar cada app directamente desde NeXus
- **Pestaña "Hardware"** — escanea CPU, RAM, GPU (VRAM) y almacenamiento; genera tabla de compatibilidad por categoría de apps (✅ Compatible / ⚠️ Parcial / ❌ Puede tener problemas)
- **Limpieza de Seguridad Profunda** en el apartado Optimizaciones — 5 fases inspiradas en Tron Script: temporales → Windows Defender → registro (adware/PUPs) → SFC + DISM → red (DNS, Winsock, hosts)
- Animación de carga con barra deslizante en "Mis Apps" (búsqueda en background con `Start-Job`)
- Animación de progreso por pasos en el escáner de hardware
- Buscador en tiempo real en la vista "Mis Apps"
- Sistema de caché de registro para acelerar la detección de apps instaladas

### Corregido
- **Bug crítico de desinstalación**: el job recibía el `Key` interno de la app (ej. `"Chrome"`) en lugar del ID winget real (ej. `"Google.Chrome"`). Ahora se resuelve el ID desde `$script:appDatabase` antes de lanzar el job
- **Mensaje de Microsoft Store** al desinstalar: las entradas del registro con `UninstallString` que contenían `ms-windows-store://` ya no se intentan ejecutar
- Error `PropertyAssignmentException` por `$scanTitle.x_Name` — propiedad inválida en controles WPF creados por código
- Handler duplicado de `BtnDesinstalarSeleccionadas` que causaba dos ejecuciones simultáneas al presionar el botón
- El `UninstallString` ahora se busca por nombre normalizado (sin caracteres especiales) en lugar de por `$appKey`

### Mejorado
- La detección de apps instaladas prioriza: registro → accesos directos del menú de inicio → `LocalAppData\Programs` (sin escaneo completo de `Program Files`)
- La desinstalación usa 4 estrategias en cascada: desinstalador nativo → `winget --id` → `winget --name` → `msiexec /x {GUID}`

---

## [1.8.6] — 2026

### Añadido
- Botones `▶` en tarjetas de instalación para apps ya instaladas
- Soporte de detección de PC Manager para desinstalación como fallback

### Corregido
- Error `NullArray` en la vista de Sistemas Operativos: el closure del botón capturaba `$ver` por referencia en lugar de por valor; corregido con `$verCopy = $ver`
- Función de desinstalación no ejecutaba acciones en muchos casos

### Mejorado
- Interfaz de desinstalación con actualización del label en tiempo real
- Estrategias de desinstalación mejoradas (msiexec como estrategia adicional)

---

## [1.8.5] — 2026

### Añadido
- Interfaz WPF completa con tema oscuro y paleta morada/violeta
- Splash screen animado con efecto glitch (8 fases: scanlines, aberración cromática, blackout, estabilización)
- Barra de navegación con 6 pestañas: Instalar Apps, Desinstalar, Sistemas Operativos, Optimizaciones, Extensiones, Información
- Catálogo de apps organizado por categorías con búsqueda en tiempo real
- Instalación silenciosa vía `winget` con progress window y jobs en background
- Desinstalación con detección de apps instaladas desde el registro de Windows
- Tweaks del sistema: Rendimiento, Privacidad, Gaming, Laptop, Limpieza
- Restauración de configuración predeterminada de Windows
- Soporte para Windows, Linux y macOS en la detección de plataforma

---

## [1.0.0] — 2025

### Añadido
- Versión inicial de NeXus en línea de comandos
- Instalación automática de apps vía winget
- Estructura base del proyecto
