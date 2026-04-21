<div align="center">

```
███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗
████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝
██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗
██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║
██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║
╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
```

**Sistema de Automatización Multiplataforma para Windows**

[![Version](https://img.shields.io/badge/versión-1.8.7-9D6FFF?style=flat-square)](https://github.com/Elilovos777/nexus/releases)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?style=flat-square&logo=powershell)](https://github.com/PowerShell/PowerShell)
[![License](https://img.shields.io/badge/licencia-MIT-green?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/plataforma-Windows%2010%2F11-0078D4?style=flat-square&logo=windows)](https://github.com/Elilovos777/nexus)

</div>

---

## ¿Qué es NeXus?

NeXus es una herramienta de automatización con **interfaz gráfica WPF** desarrollada completamente en PowerShell. Permite instalar, desinstalar, ejecutar y gestionar aplicaciones en Windows desde un solo panel visual, con soporte para detección de hardware, optimizaciones del sistema y limpieza de seguridad profunda.

Diseñado para estudiantes, técnicos y desarrolladores que configuran equipos con frecuencia — especialmente en entornos de **programación**, **animación digital** y **mecatrónica**.

---

## 🚀 Instalación — Una sola línea

Abre **PowerShell como Administrador** y ejecuta:

```powershell
irm https://raw.githubusercontent.com/Elilovos777/nexus/main/bootstrap.ps1 | iex
```

NeXus descargará la interfaz y se ejecutará automáticamente. No requiere instalación adicional.

> **Requisitos:** Windows 10/11 · PowerShell 5.1 o superior · Conexión a internet · Ejecutar como Administrador

---

## ✨ Funcionalidades

### 📦 Instalar Apps
Catálogo organizado por categorías con instalación silenciosa vía `winget`. Soporta búsqueda en tiempo real y selección múltiple.

| Categoría | Apps incluidas |
|-----------|---------------|
| 🌐 Navegadores | Chrome, Firefox, Brave, Opera, Edge |
| 💻 Programación | VS Code, Git, Python, Node.js, JDK, IntelliJ, PyCharm y más |
| 🎨 Animación 2D | Krita, GIMP, Inkscape, Aseprite |
| 🟠 Animación 3D | Blender, Wings3D |
| 🎬 Video/Audio | DaVinci Resolve, Kdenlive, Audacity, VLC |
| ⚙️ Mecatrónica | Arduino IDE, PlatformIO, KiCad, Fusion 360, FreeCAD |
| 💬 Comunicación | Discord, Telegram, Zoom, Teams, Slack |
| 🎁 Extras | Rufus, 7-Zip, WinRAR, VirtualBox, Notepad++, y más |

### 🗑️ Desinstalar Apps
Desinstalación inteligente con 4 estrategias en cascada: desinstalador nativo del registro → `winget uninstall` por ID → `winget uninstall` por nombre → `msiexec` con GUID. Filtra automáticamente entradas de Microsoft Store.

### ▶️ Mis Apps
Detecta qué aplicaciones del catálogo ya están instaladas en tu equipo escaneando el registro de Windows y el menú de inicio. Muestra un botón **▶ Abrir** para lanzar cada app directamente desde NeXus. Incluye búsqueda en tiempo real y animación de carga.

### 🖥️ Hardware
Escanea los componentes del equipo en segundo plano y muestra una tabla de compatibilidad por categoría de apps. Detecta CPU, RAM, GPU (con VRAM) y almacenamiento disponible. Útil para saber qué software puede correr tu laptop antes de instalarlo.

### 💿 Sistemas Operativos
Acceso directo a las páginas de descarga oficiales de Windows 10, Windows 11 y distribuciones Linux populares.

### ⚡ Optimizaciones
Tweaks seguros y reversibles para mejorar el sistema:
- **Rendimiento** — desactiva efectos visuales, optimiza servicios, activa plan de alto rendimiento
- **Privacidad** — desactiva telemetría, diagnósticos y Cortana
- **Gaming** — activa Game Mode, desactiva Xbox Game Bar
- **Laptop** — plan de energía equilibrado, optimiza batería
- **Limpieza** — temporales, papelera, caché
- **🛡️ Seguridad Profunda** — limpieza de 5 fases inspirada en Tron Script (ver abajo)
- **Restaurar** — revierte todos los cambios aplicados

### 🛡️ Limpieza de Seguridad Profunda
Elimina malware, adware y residuos del sistema en 5 fases con ventana de progreso animada:

```
Fase 1 — Temporales, caché y Prefetch del sistema
Fase 2 — Escaneo con Windows Defender (actualiza firmas + elimina amenazas)
Fase 3 — Registro: claves Run con adware conocido (Conduit, Babylon, Superfish, etc.)
Fase 4 — Reparación: SFC /scannow + DISM StartComponentCleanup
Fase 5 — Red: flush DNS, reset Winsock, limpieza del archivo hosts
```

> No elimina software legítimo. No modifica configuración de usuario. 100% reversible.

---

## 📁 Estructura del repositorio

```
nexus/
├── bootstrap.ps1          # Loader — descarga y ejecuta NeXus con una línea
├── NeXus_v1_8_7.ps1       # Aplicación principal (WPF + PowerShell)
├── README.md              # Este archivo
├── CHANGELOG.md           # Historial de cambios
├── LICENSE                # Licencia MIT
├── assets/
│   └── README.md          # Capturas y recursos gráficos
├── docs/
│   └── README.md          # Documentación técnica
└── modules/
    └── README.md          # Módulos futuros
```

---

## 🖼️ Interfaz

NeXus presenta una interfaz oscura con paleta morada/violeta, barra de navegación superior con 8 secciones, búsqueda en tiempo real, tarjetas de aplicaciones con checkboxes, animaciones de splash al inicio y progress bars en todas las operaciones largas.

---

## 🛠️ Desarrollo

NeXus está desarrollado completamente en **PowerShell puro** usando **WPF (Windows Presentation Foundation)** para la interfaz gráfica. No requiere dependencias externas más allá de `winget` (incluido en Windows 11 y disponible para Windows 10).

**Autor:** nexu_016 / Elilovos777  
**Versión actual:** 1.8.7  
**Año:** 2026

---

## 📄 Licencia

Distribuido bajo la [Licencia MIT](LICENSE). Libre para uso, modificación y distribución con atribución.
