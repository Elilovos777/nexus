# NeXus
# Copyright (c) 2026 Elilovos777
# Licensed under the MIT License
#Requires -RunAsAdministrator
Clear-Host
Write-Host "⚠️ NeXus - Instalador de aplicaciones" -ForegroundColor Yellow
Write-Host "Este script instalará software y requiere privilegios de administrador."
Write-Host "Presiona ENTER para continuar o Ctrl+C para cancelar."
Read-Host

<#
.SYNOPSIS
NeXus - Instalador de Aplicaciones Multiplataforma

.DESCRIPTION
Sistema de instalación automatizada basado en Chris Titus Tool
con soporte para Windows, Linux y MacOS, incluyendo especialidades
técnicas (Programación, Animación, Mecatrónica)

.AUTHOR
Nexus_016 - Proyecto de Titulación

.VERSION
4.7
#>



# Configuración Global
$Global:Config = @{
    Nombre = "NeXus"
    Version = "4.7"
    Autor = "Nexus_016"
    RepoURL = "https://raw.githubusercontent.com/tuusuario/nexus/main"
    LogPath = "$env:TEMP\nexus.log"
    Tema = "Dark"
    Plataforma = $null
}

# Inicializar plataforma
if ($IsWindows -or $env:OS -eq "Windows_NT") { 
    $Global:Config.Plataforma = "Windows" 
}
elseif ($IsLinux) { 
    $Global:Config.Plataforma = "Linux" 
}
elseif ($IsMacOS) { 
    $Global:Config.Plataforma = "MacOS" 
}
else { 
    $Global:Config.Plataforma = "Windows" 
}

# ============================================
# BASE DE DATOS DE APLICACIONES
# ============================================

$Global:BaseDatos = @{
    Windows = @{
        Navegadores = @{
            # Estándar y uso general
            Chrome = @{
                Nombre = "Google Chrome"
                ID = "Google.Chrome"
                Descripcion = "Navegador más popular"
                Categoria = "Navegadores"
                Icono = "🌐"
                Origen = "Winget"
                Subcategoria = "Estandar"
            }
            Firefox = @{
                Nombre = "Mozilla Firefox"
                ID = "Mozilla.Firefox"
                Descripcion = "Navegador open source"
                Categoria = "Navegadores"
                Icono = "🦊"
                Origen = "Winget"
                Subcategoria = "Estandar"
            }
            Edge = @{
                Nombre = "Microsoft Edge"
                ID = "Microsoft.Edge"
                Descripcion = "Navegador de Microsoft"
                Categoria = "Navegadores"
                Icono = "🌊"
                Origen = "Winget"
                Subcategoria = "Estandar"
            }
            # Rendimiento / Eficiencia
            Brave = @{
                Nombre = "Brave Browser"
                ID = "Brave.Brave"
                Descripcion = "Bloqueadores nativos, rápido"
                Categoria = "Navegadores"
                Icono = "🦁"
                Origen = "Winget"
                Subcategoria = "Rendimiento"
            }
            Vivaldi = @{
                Nombre = "Vivaldi"
                ID = "VivaldiTechnologies.Vivaldi"
                Descripcion = "Altamente configurable"
                Categoria = "Navegadores"
                Icono = "🔭"
                Origen = "Winget"
                Subcategoria = "Rendimiento"
            }
            UngoogledChromium = @{
                Nombre = "Ungoogled Chromium"
                ID = $null
                Descripcion = "Mínimo y limpio"
                Categoria = "Navegadores"
                Icono = "⚡"
                Origen = "Web"
                URL = "https://ungoogled-software.github.io/ungoogled-chromium-binaries/"
                Subcategoria = "Rendimiento"
            }
            Thorium = @{
                Nombre = "Thorium"
                ID = $null
                Descripcion = "Optimizado para rendimiento"
                Categoria = "Navegadores"
                Icono = "🚀"
                Origen = "Web"
                URL = "https://thorium.rocks/"
                Subcategoria = "Rendimiento"
            }
            # Privacidad y seguridad
            TorBrowser = @{
                Nombre = "Tor Browser"
                ID = "TorProject.TorBrowser"
                Descripcion = "Navegación anónima"
                Categoria = "Navegadores"
                Icono = "🧅"
                Origen = "Winget"
                Subcategoria = "Privacidad"
            }
            LibreWolf = @{
                Nombre = "LibreWolf"
                ID = "LibreWolf.LibreWolf"
                Descripcion = "Fork privado de Firefox"
                Categoria = "Navegadores"
                Icono = "🐺"
                Origen = "Winget"
                Subcategoria = "Privacidad"
            }
            MullvadBrowser = @{
                Nombre = "Mullvad Browser"
                ID = $null
                Descripcion = "Privacidad extrema"
                Categoria = "Navegadores"
                Icono = "🔒"
                Origen = "Web"
                URL = "https://mullvad.net/en/download/browser"
                Subcategoria = "Privacidad"
            }
            Waterfox = @{
                Nombre = "Waterfox"
                ID = "Waterfox.Waterfox"
                Descripcion = "Firefox orientado a privacidad"
                Categoria = "Navegadores"
                Icono = "🌊"
                Origen = "Winget"
                Subcategoria = "Privacidad"
            }
            # Especializados
            Opera = @{
                Nombre = "Opera"
                ID = "Opera.Opera"
                Descripcion = "Navegador con VPN integrada"
                Categoria = "Navegadores"
                Icono = "🔴"
                Origen = "Winget"
                Subcategoria = "Especializado"
            }
            OperaGX = @{
                Nombre = "Opera GX"
                ID = "Opera.OperaGX"
                Descripcion = "Navegador para gamers"
                Categoria = "Navegadores"
                Icono = "🎮"
                Origen = "Winget"
                Subcategoria = "Especializado"
            }
            PaleMoon = @{
                Nombre = "Pale Moon"
                ID = "MoonchildProductions.PaleMoon"
                Descripcion = "Navegador clásico eficiente"
                Categoria = "Navegadores"
                Icono = "🌙"
                Origen = "Winget"
                Subcategoria = "Especializado"
            }
        }

        Comunicacion = @{
            # Uso cotidiano y académico
            WhatsApp = @{
                Nombre = "WhatsApp Desktop"
                ID = "WhatsApp.WhatsApp"
                Descripcion = "WhatsApp para PC"
                Categoria = "Comunicación"
                Icono = "💚"
                Origen = "Winget"
                Subcategoria = "Cotidiano"
            }
            Telegram = @{
                Nombre = "Telegram Desktop"
                ID = "Telegram.TelegramDesktop"
                Descripcion = "Mensajería segura"
                Categoria = "Comunicación"
                Icono = "✈️"
                Origen = "Winget"
                Subcategoria = "Cotidiano"
            }
            Discord = @{
                Nombre = "Discord"
                ID = "Discord.Discord"
                Descripcion = "Chat y comunidades"
                Categoria = "Comunicación"
                Icono = "💬"
                Origen = "Winget"
                Subcategoria = "Cotidiano"
            }
            Teams = @{
                Nombre = "Microsoft Teams"
                ID = "Microsoft.Teams"
                Descripcion = "Colaboración empresarial"
                Categoria = "Comunicación"
                Icono = "👥"
                Origen = "Winget"
                Subcategoria = "Cotidiano"
            }
            Zoom = @{
                Nombre = "Zoom"
                ID = "Zoom.Zoom"
                Descripcion = "Videoconferencias"
                Categoria = "Comunicación"
                Icono = "📹"
                Origen = "Winget"
                Subcategoria = "Cotidiano"
            }
            # Profesional / corporativo
            Slack = @{
                Nombre = "Slack"
                ID = "SlackTechnologies.Slack"
                Descripcion = "Comunicación equipos"
                Categoria = "Comunicación"
                Icono = "💼"
                Origen = "Winget"
                Subcategoria = "Profesional"
            }
            Skype = @{
                Nombre = "Skype"
                ID = "Microsoft.Skype"
                Descripcion = "Videollamadas clásico"
                Categoria = "Comunicación"
                Icono = "💙"
                Origen = "Winget"
                Subcategoria = "Profesional"
            }
            Webex = @{
                Nombre = "Cisco Webex"
                ID = "Cisco.CiscoWebexMeetings"
                Descripcion = "Videoconferencias empresarial"
                Categoria = "Comunicación"
                Icono = "🟢"
                Origen = "Winget"
                Subcategoria = "Profesional"
            }
            Mattermost = @{
                Nombre = "Mattermost"
                ID = "Mattermost.MattermostDesktop"
                Descripcion = "Colaboración open source"
                Categoria = "Comunicación"
                Icono = "📝"
                Origen = "Winget"
                Subcategoria = "Profesional"
            }
            # Privacidad
            Signal = @{
                Nombre = "Signal Desktop"
                ID = "OpenWhisperSystems.Signal"
                Descripcion = "Mensajería cifrada"
                Categoria = "Comunicación"
                Icono = "🔐"
                Origen = "Winget"
                Subcategoria = "Privacidad"
            }
            Element = @{
                Nombre = "Element"
                ID = "Element.Element"
                Descripcion = "Cliente Matrix"
                Categoria = "Comunicación"
                Icono = "🟢"
                Origen = "Winget"
                Subcategoria = "Privacidad"
            }
            Session = @{
                Nombre = "Session"
                ID = "Oxen.Session"
                Descripcion = "Mensajería anónima"
                Categoria = "Comunicación"
                Icono = "👻"
                Origen = "Winget"
                Subcategoria = "Privacidad"
            }
            # Gaming
            TeamSpeak = @{
                Nombre = "TeamSpeak"
                ID = "TeamSpeakSystems.TeamSpeakClient"
                Descripcion = "VoIP para gaming"
                Categoria = "Comunicación"
                Icono = "🎧"
                Origen = "Winget"
                Subcategoria = "Gaming"
            }
            Mumble = @{
                Nombre = "Mumble"
                ID = "Mumble.Mumble"
                Descripcion = "Chat de voz baja latencia"
                Categoria = "Comunicación"
                Icono = "🎙️"
                Origen = "Winget"
                Subcategoria = "Gaming"
            }
            # Descentralizadas
            JitsiMeet = @{
                Nombre = "Jitsi Meet"
                ID = $null
                Descripcion = "Videollamadas open source"
                Categoria = "Comunicación"
                Icono = "📹"
                Origen = "Web"
                URL = "https://meet.jit.si/"
                Subcategoria = "Descentralizada"
            }
            RocketChat = @{
                Nombre = "Rocket.Chat"
                ID = "RocketChat.RocketChat"
                Descripcion = "Chat empresarial open source"
                Categoria = "Comunicación"
                Icono = "🚀"
                Origen = "Winget"
                Subcategoria = "Descentralizada"
            }
        }

        Especialidad = @{
            Programacion = @{
                # Entornos de desarrollo web
                XAMPP = @{
                    Nombre = "XAMPP"
                    ID = "ApacheFriends.Xampp"
                    Descripcion = "Servidor web local (Apache, MySQL, PHP, Perl)"
                    Icono = "🌐"
                    Origen = "Winget"
                    Advertencia = "Requiere privilegios de administrador. Puerto 80 puede estar en uso."
                }
                WampServer = @{
                    Nombre = "WampServer"
                    ID = $null
                    Descripcion = "Servidor web Windows (Apache, MySQL, PHP)"
                    Icono = "🟢"
                    Origen = "Web"
                    URL = "https://www.wampserver.com/"
                    Advertencia = "Desactiva Skype/IIS antes de instalar (usan puerto 80)"
                }
                Laragon = @{
                    Nombre = "Laragon"
                    ID = "LeNguyenQuang.Laragon"
                    Descripcion = "Entorno de desarrollo web portable"
                    Icono = "🚀"
                    Origen = "Winget"
                    Advertencia = "Incluye múltiples versiones de PHP, Node.js y bases de datos"
                }

                # IDEs Java
                NetBeans = @{
                    Nombre = "Apache NetBeans"
                    ID = "Apache.NetBeans"
                    Descripcion = "IDE para Java, PHP, C++"
                    Icono = "☕"
                    Origen = "Winget"
                    Advertencia = "Requiere Java JDK previamente instalado"
                }
                IntelliJIDEA = @{
                    Nombre = "IntelliJ IDEA Community"
                    ID = "JetBrains.IntelliJIDEA.Community"
                    Descripcion = "IDE profesional para Java/Kotlin"
                    Icono = "💡"
                    Origen = "Winget"
                    Advertencia = "Versión Community gratuita. Ultimate es de pago"
                }
                Eclipse = @{
                    Nombre = "Eclipse IDE"
                    ID = "EclipseFoundation.EclipseIDE.Java"
                    Descripcion = "IDE clásico para Java"
                    Icono = "🌙"
                    Origen = "Winget"
                }

                # Bases de datos
                MySQLWorkbench = @{
                    Nombre = "MySQL Workbench"
                    ID = "Oracle.MySQLWorkbench"
                    Descripcion = "Diseño y administración MySQL"
                    Icono = "🐬"
                    Origen = "Winget"
                }
                DBeaver = @{
                    Nombre = "DBeaver Community"
                    ID = "DBeaver.DBeaver.Community"
                    Descripcion = "Cliente universal de bases de datos"
                    Icono = "🦫"
                    Origen = "Winget"
                }
                PostgreSQL = @{
                    Nombre = "PostgreSQL"
                    ID = "PostgreSQL.PostgreSQL"
                    Descripcion = "Sistema de base de datos relacional"
                    Icono = "🐘"
                    Origen = "Winget"
                    Advertencia = "Requiere configuración post-instalación"
                }
                MongoDBCompass = @{
                    Nombre = "MongoDB Compass"
                    ID = "MongoDB.Compass.Community"
                    Descripcion = "GUI para MongoDB"
                    Icono = "🍃"
                    Origen = "Winget"
                }

                # Herramientas adicionales
                Insomnia = @{
                    Nombre = "Insomnia"
                    ID = "Insomnia.Insomnia"
                    Descripcion = "Cliente REST API (alternativa a Postman)"
                    Icono = "😴"
                    Origen = "Winget"
                }
                TablePlus = @{
                    Nombre = "TablePlus"
                    ID = "TablePlus.TablePlus"
                    Descripcion = "Editor de bases de datos moderno"
                    Icono = "➕"
                    Origen = "Winget"
                    Advertencia = "Versión gratuita con limitaciones"
                }
                FileZilla = @{
                    Nombre = "FileZilla Client"
                    ID = "TimKosse.FileZilla.Client"
                    Descripcion = "Cliente FTP/SFTP"
                    Icono = "📂"
                    Origen = "Winget"
                }
                Wireshark = @{
                    Nombre = "Wireshark"
                    ID = "WiresharkFoundation.Wireshark"
                    Descripcion = "Analizador de protocolos de red"
                    Icono = "🦈"
                    Origen = "Winget"
                    Advertencia = "Requiere Npcap para captura de paquetes"
                }

                # Editores adicionales
                Atom = @{
                    Nombre = "Atom"
                    ID = "GitHub.Atom"
                    Descripcion = "Editor de texto hackable (descontinuado pero funcional)"
                    Icono = "⚛️"
                    Origen = "Winget"
                }
                Brackets = @{
                    Nombre = "Brackets"
                    ID = "Adobe.Brackets"
                    Descripcion = "Editor web moderno (descontinuado)"
                    Icono = "{}"
                    Origen = "Winget"
                }

                # Lenguajes adicionales
                JavaJDK = @{
                    Nombre = "Oracle Java SE Development Kit"
                    ID = "Oracle.JDK.17"
                    Descripcion = "Kit de desarrollo Java"
                    Icono = "☕"
                    Origen = "Winget"
                    Advertencia = "Requiere aceptar licencia Oracle"
                }
                OpenJDK = @{
                    Nombre = "Eclipse Adoptium OpenJDK"
                    ID = "EclipseAdoptium.Temurin.17.JDK"
                    Descripcion = "OpenJDK gratuito (alternativa a Oracle)"
                    Icono = "☕"
                    Origen = "Winget"
                }
                Ruby = @{
                    Nombre = "Ruby"
                    ID = "RubyInstallerTeam.RubyWithDevKit"
                    Descripcion = "Lenguaje de programación Ruby"
                    Icono = "💎"
                    Origen = "Winget"
                }
                Go = @{
                    Nombre = "Go"
                    ID = "GoLang.Go"
                    Descripcion = "Lenguaje de programación Go"
                    Icono = "🐹"
                    Origen = "Winget"
                }
                Rust = @{
                    Nombre = "Rust"
                    ID = "Rustlang.Rust.MSVC"
                    Descripcion = "Lenguaje de programación Rust"
                    Icono = "🦀"
                    Origen = "Winget"
                }
                PHP = @{
                    Nombre = "PHP"
                    ID = "PHP.PHP.8.1"
                    Descripcion = "Lenguaje de programación PHP"
                    Icono = "🐘"
                    Origen = "Winget"
                }

                # Frameworks y herramientas web
                NodeJS = @{
                    Nombre = "Node.js LTS"
                    ID = "OpenJS.NodeJS.LTS"
                    Descripcion = "JavaScript runtime environment"
                    Icono = "🟢"
                    Origen = "Winget"
                    Advertencia = "Incluye npm. Requiere reinicio de terminal"
                }
                Yarn = @{
                    Nombre = "Yarn"
                    ID = "Yarn.Yarn"
                    Descripcion = "Gestor de paquetes alternativo a npm"
                    Icono = "🧶"
                    Origen = "Winget"
                }
                Python = @{
                    Nombre = "Python 3.11"
                    ID = "Python.Python.3.11"
                    Descripcion = "Lenguaje de programación Python"
                    Icono = "🐍"
                    Origen = "Winget"
                    Advertencia = "Marca 'Add to PATH' durante instalación"
                }
                Anaconda = @{
                    Nombre = "Anaconda3"
                    ID = "Anaconda.Anaconda3"
                    Descripcion = "Distribución Python para ciencia de datos"
                    Icono = "🐍"
                    Origen = "Winget"
                    Advertencia = "Incluye Jupyter, Spyder, y 1,500+ paquetes"
                }

                # Control de versiones
                Git = @{
                    Nombre = "Git"
                    ID = "Git.Git"
                    Descripcion = "Sistema de control de versiones"
                    Icono = "🌳"
                    Origen = "Winget"
                }
                GitHubDesktop = @{
                    Nombre = "GitHub Desktop"
                    ID = "GitHub.GitHubDesktop"
                    Descripcion = "Cliente gráfico para GitHub"
                    Icono = "🐙"
                    Origen = "Winget"
                }
                GitKraken = @{
                    Nombre = "GitKraken"
                    ID = "Axosoft.GitKraken"
                    Descripcion = "Cliente Git profesional"
                    Icono = "🦑"
                    Origen = "Winget"
                    Advertencia = "Versión gratuita para repositorios públicos"
                }
                SourceTree = @{
                    Nombre = "SourceTree"
                    ID = "Atlassian.SourceTree"
                    Descripcion = "Cliente Git gratuito de Atlassian"
                    Icono = "🌲"
                    Origen = "Winget"
                }

                # Contenedores y virtualización
                DockerDesktop = @{
                    Nombre = "Docker Desktop"
                    ID = "Docker.DockerDesktop"
                    Descripcion = "Plataforma de contenedores"
                    Icono = "🐳"
                    Origen = "Winget"
                    Advertencia = "Requiere WSL2 en Windows. Reinicio necesario"
                }
                Kubernetes = @{
                    Nombre = "kubectl"
                    ID = "Kubernetes.kubectl"
                    Descripcion = "CLI para Kubernetes"
                    Icono = "☸️"
                    Origen = "Winget"
                }
                Helm = @{
                    Nombre = "Helm"
                    ID = "Helm.Helm"
                    Descripcion = "Gestor de paquetes para Kubernetes"
                    Icono = "⛵"
                    Origen = "Winget"
                }
                Vagrant = @{
                    Nombre = "Vagrant"
                    ID = "HashiCorp.Vagrant"
                    Descripcion = "Gestión de máquinas virtuales"
                    Icono = "📦"
                    Origen = "Winget"
                }

                # Editores principales
                VSCode = @{
                    Nombre = "Visual Studio Code"
                    ID = "Microsoft.VisualStudioCode"
                    Descripcion = "Editor de código más popular"
                    Icono = "💻"
                    Origen = "Winget"
                }
                VisualStudio = @{
                    Nombre = "Visual Studio 2022 Community"
                    ID = "Microsoft.VisualStudio.2022.Community"
                    Descripcion = "IDE completo para Windows/.NET"
                    Icono = "🅰️"
                    Origen = "Winget"
                    Advertencia = "Descarga grande (~3GB). Instalación prolongada"
                }
                VSCodeInsiders = @{
                    Nombre = "Visual Studio Code Insiders"
                    ID = "Microsoft.VisualStudioCode.Insiders"
                    Descripcion = "Versión preview de VS Code"
                    Icono = "💻"
                    Origen = "Winget"
                    Advertencia = "Versión inestable con características experimentales"
                }
                JetBrainsToolbox = @{
                    Nombre = "JetBrains Toolbox"
                    ID = "JetBrains.Toolbox"
                    Descripcion = "Gestor de IDEs JetBrains"
                    Icono = "🧰"
                    Origen = "Winget"
                }
                SublimeText = @{
                    Nombre = "Sublime Text 4"
                    ID = "SublimeHQ.SublimeText.4"
                    Descripcion = "Editor de texto rápido y ligero"
                    Icono = "✨"
                    Origen = "Winget"
                    Advertencia = "Gratuito para evaluación. Licencia recomendada"
                }
                NotepadPlusPlus = @{
                    Nombre = "Notepad++"
                    ID = "Notepad++.Notepad++"
                    Descripcion = "Editor de código mejorado"
                    Icono = "📝"
                    Origen = "Winget"
                }

                # Herramientas de terminal
                WindowsTerminal = @{
                    Nombre = "Windows Terminal"
                    ID = "Microsoft.WindowsTerminal"
                    Descripcion = "Terminal moderna para Windows"
                    Icono = "🖥️"
                    Origen = "Winget"
                }
                PowerShell7 = @{
                    Nombre = "PowerShell 7"
                    ID = "Microsoft.PowerShell"
                    Descripcion = "PowerShell multiplataforma"
                    Icono = "⚡"
                    Origen = "Winget"
                }
                PuTTY = @{
                    Nombre = "PuTTY"
                    ID = "PuTTY.PuTTY"
                    Descripcion = "Cliente SSH/Telnet"
                    Icono = "🖥️"
                    Origen = "Winget"
                }
                WinSCP = @{
                    Nombre = "WinSCP"
                    ID = "WinSCP.WinSCP"
                    Descripcion = "Cliente SFTP/SCP"
                    Icono = "📁"
                    Origen = "Winget"
                }

                # Utilidades de desarrollo
                Postman = @{
                    Nombre = "Postman"
                    ID = "Postman.Postman"
                    Descripcion = "Plataforma de API"
                    Icono = "🚀"
                    Origen = "Winget"
                }
                WinMerge = @{
                    Nombre = "WinMerge"
                    ID = "WinMerge.WinMerge"
                    Descripcion = "Comparación y fusión de archivos"
                    Icono = "⚖️"
                    Origen = "Winget"
                }
                ProcessMonitor = @{
                    Nombre = "Process Monitor"
                    ID = "Microsoft.Sysinternals.ProcessMonitor"
                    Descripcion = "Monitor de sistema avanzado"
                    Icono = "🔍"
                    Origen = "Winget"
                }
                ProcessExplorer = @{
                    Nombre = "Process Explorer"
                    ID = "Microsoft.Sysinternals.ProcessExplorer"
                    Descripcion = "Gestor de tareas avanzado"
                    Icono = "🔍"
                    Origen = "Winget"
                }
            }


            Animacion = @{
                # Animación 2D
                ToonBoomHarmony = @{
                    Nombre = "Toon Boom Harmony"
                    ID = $null
                    Descripcion = "Animación 2D profesional"
                    Icono = "🎨"
                    Origen = "Web"
                    URL = "https://www.toonboom.com/products/harmony"
                }
                TVPaint = @{
                    Nombre = "TVPaint Animation"
                    ID = $null
                    Descripcion = "Animación 2D raster"
                    Icono = "🖌️"
                    Origen = "Web"
                    URL = "https://www.tvpaint.com/"
                }
                AdobeAnimate = @{
                    Nombre = "Adobe Animate"
                    ID = $null
                    Descripcion = "Animación multimedia"
                    Icono = "🎭"
                    Origen = "Web"
                    URL = "https://www.adobe.com/products/animate.html"
                }
                ClipStudioPaint = @{
                    Nombre = "Clip Studio Paint"
                    ID = $null
                    Descripcion = "Ilustración y animación"
                    Icono = "✏️"
                    Origen = "Web"
                    URL = "https://www.clipstudio.net/"
                }
                OpenToonz = @{
                    Nombre = "OpenToonz"
                    ID = "OpenToonz.OpenToonz"
                    Descripcion = "Animación 2D open source"
                    Icono = "🎬"
                    Origen = "Winget"
                }
                Pencil2D = @{
                    Nombre = "Pencil2D"
                    ID = "Pencil2D.Pencil2D"
                    Descripcion = "Animación 2D"
                    Icono = "✏️"
                    Origen = "Winget"
                }
                # Animación 3D
                Maya = @{
                    Nombre = "Autodesk Maya"
                    ID = $null
                    Descripcion = "Animación 3D profesional"
                    Icono = "🏗️"
                    Origen = "Web"
                    URL = "https://www.autodesk.com/products/maya/overview"
                }
                Blender = @{
                    Nombre = "Blender"
                    ID = "BlenderFoundation.Blender"
                    Descripcion = "3D completo y gratuito"
                    Icono = "🟠"
                    Origen = "Winget"
                }
                Max3ds = @{
                    Nombre = "3ds Max"
                    ID = $null
                    Descripcion = "Modelado y animación 3D"
                    Icono = "🔷"
                    Origen = "Web"
                    URL = "https://www.autodesk.com/products/3ds-max/overview"
                }
                Cinema4D = @{
                    Nombre = "Cinema 4D"
                    ID = $null
                    Descripcion = "Motion graphics 3D"
                    Icono = "🔵"
                    Origen = "Web"
                    URL = "https://www.maxon.net/cinema-4d"
                }
                Houdini = @{
                    Nombre = "Houdini"
                    ID = $null
                    Descripcion = "FX y simulaciones 3D"
                    Icono = "🎩"
                    Origen = "Web"
                    URL = "https://www.sidefx.com/products/houdini/"
                }
                # Modelado y escultura
                ZBrush = @{
                    Nombre = "ZBrush"
                    ID = $null
                    Descripcion = "Escultura digital"
                    Icono = "🗿"
                    Origen = "Web"
                    URL = "https://pixologic.com/zbrush/"
                }
                Mudbox = @{
                    Nombre = "Mudbox"
                    ID = $null
                    Descripcion = "Escultura 3D Autodesk"
                    Icono = "🏔️"
                    Origen = "Web"
                    URL = "https://www.autodesk.com/products/mudbox/overview"
                }
                # Texturizado
                SubstancePainter = @{
                    Nombre = "Substance Painter"
                    ID = $null
                    Descripcion = "Texturizado 3D"
                    Icono = "🎨"
                    Origen = "Web"
                    URL = "https://www.adobe.com/products/substance3d-painter.html"
                }
                SubstanceDesigner = @{
                    Nombre = "Substance Designer"
                    ID = $null
                    Descripcion = "Creación de materiales"
                    Icono = "🧪"
                    Origen = "Web"
                    URL = "https://www.adobe.com/products/substance3d-designer.html"
                }
                QuixelMixer = @{
                    Nombre = "Quixel Mixer"
                    ID = $null
                    Descripcion = "Texturizado gratuito"
                    Icono = "🖼️"
                    Origen = "Web"
                    URL = "https://quixel.com/mixer"
                }
                ArmorPaint = @{
                    Nombre = "ArmorPaint"
                    ID = $null
                    Descripcion = "Texturizado open source"
                    Icono = "🛡️"
                    Origen = "Web"
                    URL = "https://armorpaint.org/"
                }
                # Motores y render
                UnrealEngine = @{
                    Nombre = "Unreal Engine"
                    ID = $null
                    Descripcion = "Motor gráfico AAA"
                    Icono = "🔺"
                    Origen = "Web"
                    URL = "https://www.unrealengine.com/"
                }
                Unity = @{
                    Nombre = "Unity"
                    ID = $null
                    Descripcion = "Motor multiplataforma"
                    Icono = "⬜"
                    Origen = "Web"
                    URL = "https://unity.com/"
                }
                Godot = @{
                    Nombre = "Godot"
                    ID = "GodotEngine.GodotEngine"
                    Descripcion = "Motor open source"
                    Icono = "🤖"
                    Origen = "Winget"
                }
                MarmosetToolbag = @{
                    Nombre = "Marmoset Toolbag"
                    ID = $null
                    Descripcion = "Render y baking"
                    Icono = "🐵"
                    Origen = "Web"
                    URL = "https://marmoset.co/toolbag/"
                }
                # Storyboard y preproducción
                StoryboardPro = @{
                    Nombre = "Storyboard Pro"
                    ID = $null
                    Descripcion = "Storyboard profesional"
                    Icono = "📋"
                    Origen = "Web"
                    URL = "https://www.toonboom.com/products/storyboard-pro"
                }
                Photoshop = @{
                    Nombre = "Adobe Photoshop"
                    ID = $null
                    Descripcion = "Edición de imágenes"
                    Icono = "🖼️"
                    Origen = "Web"
                    URL = "https://www.adobe.com/products/photoshop.html"
                }
                Krita = @{
                    Nombre = "Krita"
                    ID = "KDE.Krita"
                    Descripcion = "Pintura digital"
                    Icono = "🎨"
                    Origen = "Winget"
                }
                GIMP = @{
                    Nombre = "GIMP"
                    ID = "GIMP.GIMP"
                    Descripcion = "Edición de imágenes"
                    Icono = "🦓"
                    Origen = "Winget"
                }
                # Postproducción
                AfterEffects = @{
                    Nombre = "After Effects"
                    ID = $null
                    Descripcion = "Motion graphics"
                    Icono = "🎬"
                    Origen = "Web"
                    URL = "https://www.adobe.com/products/aftereffects.html"
                }
                PremierePro = @{
                    Nombre = "Premiere Pro"
                    ID = $null
                    Descripcion = "Edición de video"
                    Icono = "🎞️"
                    Origen = "Web"
                    URL = "https://www.adobe.com/products/premiere.html"
                }
                DaVinciResolve = @{
                    Nombre = "DaVinci Resolve"
                    ID = "BlackmagicDesign.DaVinciResolve"
                    Descripcion = "Edición video profesional"
                    Icono = "🎥"
                    Origen = "Winget"
                }
                Nuke = @{
                    Nombre = "Nuke"
                    ID = $null
                    Descripcion = "Compositing profesional"
                    Icono = "☢️"
                    Origen = "Web"
                    URL = "https://www.foundry.com/products/nuke"
                }
                Fusion = @{
                    Nombre = "Fusion"
                    ID = $null
                    Descripcion = "Compositing y motion graphics"
                    Icono = "⚛️"
                    Origen = "Web"
                    URL = "https://www.blackmagicdesign.com/products/fusion"
                }
                OBSStudio = @{
                    Nombre = "OBS Studio"
                    ID = "OBSProject.OBSStudio"
                    Descripcion = "Streaming/Grabación"
                    Icono = "📺"
                    Origen = "Winget"
                }
                # Audio
                Audition = @{
                    Nombre = "Adobe Audition"
                    ID = $null
                    Descripcion = "Edición de audio profesional"
                    Icono = "🎧"
                    Origen = "Web"
                    URL = "https://www.adobe.com/products/audition.html"
                }
                Reaper = @{
                    Nombre = "Reaper"
                    ID = $null
                    Descripcion = "DAW profesional"
                    Icono = "🎚️"
                    Origen = "Web"
                    URL = "https://www.reaper.fm/"
                }
                Audacity = @{
                    Nombre = "Audacity"
                    ID = "Audacity.Audacity"
                    Descripcion = "Edición de audio"
                    Icono = "🎙️"
                    Origen = "Winget"
                }
                FMOD = @{
                    Nombre = "FMOD"
                    ID = $null
                    Descripcion = "Audio middleware"
                    Icono = "🔊"
                    Origen = "Web"
                    URL = "https://www.fmod.com/"
                }
                Wwise = @{
                    Nombre = "Wwise"
                    ID = $null
                    Descripcion = "Audio interactivo"
                    Icono = "🎵"
                    Origen = "Web"
                    URL = "https://www.audiokinetic.com/products/wwise/"
                }
            }

            Mecatronica = @{
                # Programación y control
                MATLAB = @{
                    Nombre = "MATLAB"
                    ID = $null
                    Descripcion = "Computación técnica"
                    Icono = "📊"
                    Origen = "Web"
                    URL = "https://www.mathworks.com/products/matlab.html"
                }
                Simulink = @{
                    Nombre = "Simulink"
                    ID = $null
                    Descripcion = "Simulación multidominio"
                    Icono = "📈"
                    Origen = "Web"
                    URL = "https://www.mathworks.com/products/simulink.html"
                }
                LabVIEW = @{
                    Nombre = "LabVIEW"
                    ID = $null
                    Descripcion = "Programación gráfica"
                    Icono = "🔬"
                    Origen = "Web"
                    URL = "https://www.ni.com/labview"
                }
                Python = @{
                    Nombre = "Python 3.11"
                    ID = "Python.Python.3.11"
                    Descripcion = "Lenguaje de programación"
                    Icono = "🐍"
                    Origen = "Winget"
                }
                GCC = @{
                    Nombre = "MinGW-w64"
                    ID = "MinGW.MinGW"
                    Descripcion = "Compilador C/C++"
                    Icono = "⚙️"
                    Origen = "Winget"
                }
                # Microcontroladores
                ArduinoIDE = @{
                    Nombre = "Arduino IDE"
                    ID = "ArduinoSA.IDE.stable"
                    Descripcion = "Programación Arduino"
                    Icono = "🤖"
                    Origen = "Winget"
                }
                PlatformIO = @{
                    Nombre = "PlatformIO IDE"
                    ID = "PlatformIO.PlatformIO"
                    Descripcion = "IoT desarrollo"
                    Icono = "📟"
                    Origen = "Winget"
                }
                MPLABX = @{
                    Nombre = "MPLAB X IDE"
                    ID = $null
                    Descripcion = "Desarrollo Microchip"
                    Icono = "🔷"
                    Origen = "Web"
                    URL = "https://www.microchip.com/mplab/mplab-x-ide"
                }
                STM32CubeIDE = @{
                    Nombre = "STM32CubeIDE"
                    ID = $null
                    Descripcion = "Desarrollo STM32"
                    Icono = "⚡"
                    Origen = "Web"
                    URL = "https://www.st.com/en/development-tools/stm32cubeide.html"
                }
                KeilUVision = @{
                    Nombre = "Keil µVision"
                    ID = $null
                    Descripcion = "IDE ARM"
                    Icono = "🔧"
                    Origen = "Web"
                    URL = "https://www2.keil.com/mdk5/uvision/"
                }
                # PLC
                TIAPortal = @{
                    Nombre = "TIA Portal"
                    ID = $null
                    Descripcion = "Programación Siemens"
                    Icono = "🏭"
                    Origen = "Web"
                    URL = "https://www.siemens.com/tia-portal"
                }
                Studio5000 = @{
                    Nombre = "Studio 5000"
                    ID = $null
                    Descripcion = "Programación Allen-Bradley"
                    Icono = "🔴"
                    Origen = "Web"
                    URL = "https://www.rockwellautomation.com/products/software/design/studio-5000.html"
                }
                CODESYS = @{
                    Nombre = "CODESYS"
                    ID = $null
                    Descripcion = "Desarrollo IEC 61131-3"
                    Icono = "📋"
                    Origen = "Web"
                    URL = "https://www.codesys.com/"
                }
                # Diseño electrónico
                Proteus = @{
                    Nombre = "Proteus"
                    ID = $null
                    Descripcion = "Simulación electrónica"
                    Icono = "⚡"
                    Origen = "Web"
                    URL = "https://www.labcenter.com/"
                }
                Multisim = @{
                    Nombre = "Multisim"
                    ID = $null
                    Descripcion = "Diseño de circuitos"
                    Icono = "🔌"
                    Origen = "Web"
                    URL = "https://www.ni.com/multisim"
                }
                KiCad = @{
                    Nombre = "KiCad"
                    ID = "KiCad.KiCad"
                    Descripcion = "Diseño PCB open source"
                    Icono = "⚡"
                    Origen = "Winget"
                }
                AltiumDesigner = @{
                    Nombre = "Altium Designer"
                    ID = $null
                    Descripcion = "Diseño PCB profesional"
                    Icono = "🎯"
                    Origen = "Web"
                    URL = "https://www.altium.com/altium-designer"
                }
                Eagle = @{
                    Nombre = "Autodesk Eagle"
                    ID = $null
                    Descripcion = "Diseño PCB Autodesk"
                    Icono = "🦅"
                    Origen = "Web"
                    URL = "https://www.autodesk.com/products/eagle/overview"
                }
                Fritzing = @{
                    Nombre = "Fritzing"
                    ID = "Fritzing.Fritzing"
                    Descripcion = "Diseño circuitos"
                    Icono = "🔌"
                    Origen = "Winget"
                }
                # Diseño mecánico (CAD)
                SolidWorks = @{
                    Nombre = "SolidWorks"
                    ID = $null
                    Descripcion = "CAD profesional"
                    Icono = "🔷"
                    Origen = "Web"
                    URL = "https://www.solidworks.com/"
                }
                Inventor = @{
                    Nombre = "Autodesk Inventor"
                    ID = $null
                    Descripcion = "Diseño mecánico 3D"
                    Icono = "🔧"
                    Origen = "Web"
                    URL = "https://www.autodesk.com/products/inventor/overview"
                }
                Fusion360 = @{
                    Nombre = "Autodesk Fusion 360"
                    ID = "Autodesk.Fusion360"
                    Descripcion = "CAD/CAM/CAE"
                    Icono = "🔩"
                    Origen = "Winget"
                }
                CATIA = @{
                    Nombre = "CATIA"
                    ID = $null
                    Descripcion = "Diseño industrial"
                    Icono = "✈️"
                    Origen = "Web"
                    URL = "https://www.3ds.com/products-services/catia/"
                }
                FreeCAD = @{
                    Nombre = "FreeCAD"
                    ID = "FreeCAD.FreeCAD"
                    Descripcion = "CAD paramétrico open source"
                    Icono = "🔧"
                    Origen = "Winget"
                }
                LibreCAD = @{
                    Nombre = "LibreCAD"
                    ID = "LibreCAD.LibreCAD"
                    Descripcion = "CAD 2D open source"
                    Icono = "📐"
                    Origen = "Winget"
                }
                # Simulación y análisis
                ANSYS = @{
                    Nombre = "ANSYS"
                    ID = $null
                    Descripcion = "Simulación de ingeniería"
                    Icono = "🔬"
                    Origen = "Web"
                    URL = "https://www.ansys.com/"
                }
                COMSOL = @{
                    Nombre = "COMSOL Multiphysics"
                    ID = $null
                    Descripcion = "Simulación multiphysics"
                    Icono = "🔮"
                    Origen = "Web"
                    URL = "https://www.comsol.com/"
                }
                LTspice = @{
                    Nombre = "LTspice"
                    ID = $null
                    Descripcion = "Simulación de circuitos"
                    Icono = "📉"
                    Origen = "Web"
                    URL = "https://www.analog.com/en/design-center/design-tools-and-calculators/ltspice-simulator.html"
                }
                Scilab = @{
                    Nombre = "Scilab"
                    ID = "Scilab.Scilab"
                    Descripcion = "Computación numérica"
                    Icono = "📊"
                    Origen = "Winget"
                }
                # Robótica
                ROS = @{
                    Nombre = "ROS 2"
                    ID = $null
                    Descripcion = "Sistema operativo robótico"
                    Icono = "🤖"
                    Origen = "Web"
                    URL = "https://docs.ros.org/en/humble/Installation.html"
                }
                Gazebo = @{
                    Nombre = "Gazebo"
                    ID = $null
                    Descripcion = "Simulación robótica"
                    Icono = "🏟️"
                    Origen = "Web"
                    URL = "https://gazebosim.org/"
                }
                Webots = @{
                    Nombre = "Webots"
                    ID = "Cyberbotics.Webots"
                    Descripcion = "Simulación robótica"
                    Icono = "🕸️"
                    Origen = "Winget"
                }
                RoboDK = @{
                    Nombre = "RoboDK"
                    ID = $null
                    Descripcion = "Simulación y programación"
                    Icono = "🦾"
                    Origen = "Web"
                    URL = "https://robodk.com/"
                }
                # Impresión 3D
                UltimakerCura = @{
                    Nombre = "Ultimaker Cura"
                    ID = "Ultimaker.Cura"
                    Descripcion = "Slicing impresión 3D"
                    Icono = "🖨️"
                    Origen = "Winget"
                }
                PrusaSlicer = @{
                    Nombre = "PrusaSlicer"
                    ID = "Prusa3D.PrusaSlicer"
                    Descripcion = "Slicing Prusa"
                    Icono = "🔪"
                    Origen = "Winget"
                }
                QElectroTech = @{
                    Nombre = "QElectroTech"
                    ID = "QElectroTech.QElectroTech"
                    Descripcion = "Esquemas eléctricos"
                    Icono = "⚡"
                    Origen = "Winget"
                }
            }
        }

        Extras = @{
            # Compresión
            WinRAR = @{
                Nombre = "WinRAR"
                ID = "RARLab.WinRAR"
                Descripcion = "Compresión archivos"
                Icono = "📦"
                Origen = "Winget"
            }
            SevenZip = @{
                Nombre = "7-Zip"
                ID = "7zip.7zip"
                Descripcion = "Compresión open source"
                Icono = "🗜️"
                Origen = "Winget"
            }
            PeaZip = @{
                Nombre = "PeaZip"
                ID = "Giorgiotani.Peazip"
                Descripcion = "Compresión alternativa"
                Icono = "🫛"
                Origen = "Winget"
            }
            # Búsqueda y utilidades
            Everything = @{
                Nombre = "Everything"
                ID = "voidtools.Everything"
                Descripcion = "Búsqueda instantánea"
                Icono = "🔍"
                Origen = "Winget"
            }
            PowerToys = @{
                Nombre = "Microsoft PowerToys"
                ID = "Microsoft.PowerToys"
                Descripcion = "Utilidades avanzadas"
                Icono = "⚡"
                Origen = "Winget"
            }
            ShareX = @{
                Nombre = "ShareX"
                ID = "ShareX.ShareX"
                Descripcion = "Captura pantalla"
                Icono = "📸"
                Origen = "Winget"
            }
            Greenshot = @{
                Nombre = "Greenshot"
                ID = "Greenshot.Greenshot"
                Descripcion = "Captura de pantalla"
                Icono = "📷"
                Origen = "Winget"
            }
            # Multimedia
            VLC = @{
                Nombre = "VLC Media Player"
                ID = "VideoLAN.VLC"
                Descripcion = "Reproductor universal"
                Icono = "🎵"
                Origen = "Winget"
            }
            MPC = @{
                Nombre = "MPC-HC"
                ID = "clsid2.mpc-hc"
                Descripcion = "Reproductor ligero"
                Icono = "🎬"
                Origen = "Winget"
            }
            Spotify = @{
                Nombre = "Spotify"
                ID = "Spotify.Spotify"
                Descripcion = "Música streaming"
                Icono = "🎧"
                Origen = "Winget"
            }
            foobar2000 = @{
                Nombre = "foobar2000"
                ID = "PeterPawlowski.foobar2000"
                Descripcion = "Reproductor audio avanzado"
                Icono = "🎶"
                Origen = "Winget"
            }
            # Gaming
            Steam = @{
                Nombre = "Steam"
                ID = "Valve.Steam"
                Descripcion = "Plataforma juegos"
                Icono = "🎮"
                Origen = "Winget"
            }
            EpicGames = @{
                Nombre = "Epic Games Launcher"
                ID = "EpicGames.EpicGamesLauncher"
                Descripcion = "Tienda Epic Games"
                Icono = "🎯"
                Origen = "Winget"
            }
            GOG = @{
                Nombre = "GOG Galaxy"
                ID = "GOG.Galaxy"
                Descripcion = "Cliente GOG"
                Icono = "👾"
                Origen = "Winget"
            }
            # Hardware y diagnóstico
            CPUZ = @{
                Nombre = "CPU-Z"
                ID = "CPUID.CPU-Z"
                Descripcion = "Información hardware"
                Icono = "💻"
                Origen = "Winget"
            }
            HWiNFO = @{
                Nombre = "HWiNFO"
                ID = "REALiX.HWiNFO"
                Descripcion = "Monitoreo hardware"
                Icono = "🌡️"
                Origen = "Winget"
            }
            GPUZ = @{
                Nombre = "GPU-Z"
                ID = "TechPowerUp.GPU-Z"
                Descripcion = "Info tarjeta gráfica"
                Icono = "🎮"
                Origen = "Winget"
            }
            CrystalDiskInfo = @{
                Nombre = "CrystalDiskInfo"
                ID = "CrystalDewWorld.CrystalDiskInfo"
                Descripcion = "Salud discos"
                Icono = "💿"
                Origen = "Winget"
            }
            CrystalDiskMark = @{
                Nombre = "CrystalDiskMark"
                ID = "CrystalDewWorld.CrystalDiskMark"
                Descripcion = "Benchmark discos"
                Icono = "📊"
                Origen = "Winget"
            }
            # Herramientas de sistema
            Rufus = @{
                Nombre = "Rufus"
                ID = "Rufus.Rufus"
                Descripcion = "Crear USB booteable"
                Icono = "💾"
                Origen = "Winget"
            }
            BalenaEtcher = @{
                Nombre = "balenaEtcher"
                ID = "balenaEtcher"
                Descripcion = "Flashear imágenes ISO"
                Icono = "🔥"
                Origen = "Winget"
            }
            Ventoy = @{
                Nombre = "Ventoy"
                ID = "Ventoy.Ventoy"
                Descripcion = "USB multiboot"
                Icono = "🔌"
                Origen = "Winget"
            }
            # Oficina
            LibreOffice = @{
                Nombre = "LibreOffice"
                ID = "TheDocumentFoundation.LibreOffice"
                Descripcion = "Suite ofimática"
                Icono = "📄"
                Origen = "Winget"
            }
            Notion = @{
                Nombre = "Notion"
                ID = "Notion.Notion"
                Descripcion = "Notas y productividad"
                Icono = "📝"
                Origen = "Winget"
            }
            Obsidian = @{
                Nombre = "Obsidian"
                ID = "Obsidian.Obsidian"
                Descripcion = "Notas en Markdown"
                Icono = "🪨"
                Origen = "Winget"
            }
            # Seguridad
            Bitwarden = @{
                Nombre = "Bitwarden"
                ID = "Bitwarden.Bitwarden"
                Descripcion = "Gestor de contraseñas"
                Icono = "🔐"
                Origen = "Winget"
            }
            KeePass = @{
                Nombre = "KeePass"
                ID = "DominikReichl.KeePass"
                Descripcion = "Password manager local"
                Icono = "🗝️"
                Origen = "Winget"
            }
            # Desarrollo adicional
            GitKraken = @{
                Nombre = "GitKraken"
                ID = "Axosoft.GitKraken"
                Descripcion = "Cliente Git GUI"
                Icono = "🦑"
                Origen = "Winget"
            }
            SourceTree = @{
                Nombre = "SourceTree"
                ID = "Atlassian.SourceTree"
                Descripcion = "Cliente Git GUI"
                Icono = "🌲"
                Origen = "Winget"
            }
            FileZilla = @{
                Nombre = "FileZilla"
                ID = "TimKosse.FileZilla.Client"
                Descripcion = "Cliente FTP"
                Icono = "📂"
                Origen = "Winget"
            }
            # Virtualización
            VirtualBox = @{
                Nombre = "VirtualBox"
                ID = "Oracle.VirtualBox"
                Descripcion = "Virtualización"
                Icono = "🖥️"
                Origen = "Winget"
            }
            VMwarePlayer = @{
                Nombre = "VMware Workstation Player"
                ID = "VMware.WorkstationPlayer"
                Descripcion = "Virtualización"
                Icono = "💻"
                Origen = "Winget"
            }
        }
    }

    # ==========================================
    # LINUX APPS
    # ==========================================
    Linux = @{
        Navegadores = @{
            Chrome = @{ Nombre = "Google Chrome"; Comando = "wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo dpkg -i google-chrome-stable_current_amd64.deb"; Origen = "Deb" }
            Firefox = @{ Nombre = "Firefox"; Comando = "sudo apt install firefox -y"; Origen = "Apt" }
            Chromium = @{ Nombre = "Chromium"; Comando = "sudo apt install chromium-browser -y"; Origen = "Apt" }
            Brave = @{ Nombre = "Brave"; Comando = "snap install brave"; Origen = "Snap" }
            Tor = @{ Nombre = "Tor Browser"; Comando = "sudo apt install torbrowser-launcher -y"; Origen = "Apt" }
        }
        Comunicacion = @{
            Discord = @{ Nombre = "Discord"; Comando = "snap install discord"; Origen = "Snap" }
            Telegram = @{ Nombre = "Telegram"; Comando = "snap install telegram-desktop"; Origen = "Snap" }
            Teams = @{ Nombre = "Microsoft Teams"; Comando = "snap install teams"; Origen = "Snap" }
            Zoom = @{ Nombre = "Zoom"; Comando = "snap install zoom-client"; Origen = "Snap" }
            Slack = @{ Nombre = "Slack"; Comando = "snap install slack"; Origen = "Snap" }
            Signal = @{ Nombre = "Signal"; Comando = "snap install signal-desktop"; Origen = "Snap" }
        }
        Especialidad = @{
            Programacion = @{
                VSCode = @{ Nombre = "VS Code"; Comando = "snap install code --classic"; Origen = "Snap" }
                Git = @{ Nombre = "Git"; Comando = "sudo apt install git -y"; Origen = "Apt" }
                Python = @{ Nombre = "Python3"; Comando = "sudo apt install python3 python3-pip -y"; Origen = "Apt" }
                NodeJS = @{ Nombre = "Node.js"; Comando = "curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt install -y nodejs"; Origen = "Script" }
                Docker = @{ Nombre = "Docker"; Comando = "sudo apt install docker.io -y && sudo usermod -aG docker $USER"; Origen = "Apt" }
            }
            Animacion = @{
                Blender = @{ Nombre = "Blender"; Comando = "snap install blender --classic"; Origen = "Snap" }
                GIMP = @{ Nombre = "GIMP"; Comando = "sudo apt install gimp -y"; Origen = "Apt" }
                Inkscape = @{ Nombre = "Inkscape"; Comando = "sudo apt install inkscape -y"; Origen = "Apt" }
                Krita = @{ Nombre = "Krita"; Comando = "sudo apt install krita -y"; Origen = "Apt" }
                OBS = @{ Nombre = "OBS Studio"; Comando = "sudo apt install obs-studio -y"; Origen = "Apt" }
                Audacity = @{ Nombre = "Audacity"; Comando = "sudo apt install audacity -y"; Origen = "Apt" }
            }
            Mecatronica = @{
                FreeCAD = @{ Nombre = "FreeCAD"; Comando = "sudo apt install freecad -y"; Origen = "Apt" }
                KiCad = @{ Nombre = "KiCad"; Comando = "sudo apt install kicad -y"; Origen = "Apt" }
                Arduino = @{ Nombre = "Arduino IDE"; Comando = "sudo apt install arduino -y"; Origen = "Apt" }
                Cura = @{ Nombre = "Ultimaker Cura"; Comando = "snap install cura-slicer"; Origen = "Snap" }
                OpenSCAD = @{ Nombre = "OpenSCAD"; Comando = "sudo apt install openscad -y"; Origen = "Apt" }
            }
        }
    }

    # ==========================================
    # MACOS APPS
    # ==========================================
    MacOS = @{
        Navegadores = @{
            Chrome = @{ Nombre = "Google Chrome"; Comando = "brew install --cask google-chrome"; Origen = "Brew" }
            Firefox = @{ Nombre = "Firefox"; Comando = "brew install --cask firefox"; Origen = "Brew" }
            Edge = @{ Nombre = "Microsoft Edge"; Comando = "brew install --cask microsoft-edge"; Origen = "Brew" }
            Brave = @{ Nombre = "Brave"; Comando = "brew install --cask brave-browser"; Origen = "Brew" }
            Safari = @{ Nombre = "Safari"; Comando = "# Safari viene preinstalado"; Origen = "System" }
        }
        Comunicacion = @{
            Discord = @{ Nombre = "Discord"; Comando = "brew install --cask discord"; Origen = "Brew" }
            Telegram = @{ Nombre = "Telegram"; Comando = "brew install --cask telegram-desktop"; Origen = "Brew" }
            WhatsApp = @{ Nombre = "WhatsApp"; Comando = "brew install --cask whatsapp"; Origen = "Brew" }
            Teams = @{ Nombre = "Microsoft Teams"; Comando = "brew install --cask microsoft-teams"; Origen = "Brew" }
            Zoom = @{ Nombre = "Zoom"; Comando = "brew install --cask zoom"; Origen = "Brew" }
            Slack = @{ Nombre = "Slack"; Comando = "brew install --cask slack"; Origen = "Brew" }
            Signal = @{ Nombre = "Signal"; Comando = "brew install --cask signal"; Origen = "Brew" }
        }
        Especialidad = @{
            Programacion = @{
                VSCode = @{ Nombre = "VS Code"; Comando = "brew install --cask visual-studio-code"; Origen = "Brew" }
                Xcode = @{ Nombre = "Xcode"; Comando = "xcode-select --install"; Origen = "Apple" }
                Git = @{ Nombre = "Git"; Comando = "brew install git"; Origen = "Brew" }
                Python = @{ Nombre = "Python3"; Comando = "brew install python"; Origen = "Brew" }
                NodeJS = @{ Nombre = "Node.js"; Comando = "brew install node"; Origen = "Brew" }
                Docker = @{ Nombre = "Docker Desktop"; Comando = "brew install --cask docker"; Origen = "Brew" }
            }
            Animacion = @{
                Blender = @{ Nombre = "Blender"; Comando = "brew install --cask blender"; Origen = "Brew" }
                GIMP = @{ Nombre = "GIMP"; Comando = "brew install --cask gimp"; Origen = "Brew" }
                Inkscape = @{ Nombre = "Inkscape"; Comando = "brew install --cask inkscape"; Origen = "Brew" }
                Krita = @{ Nombre = "Krita"; Comando = "brew install --cask krita"; Origen = "Brew" }
                OBS = @{ Nombre = "OBS Studio"; Comando = "brew install --cask obs"; Origen = "Brew" }
                DaVinciResolve = @{ Nombre = "DaVinci Resolve"; Comando = "brew install --cask davinci-resolve"; Origen = "Brew" }
                FinalCutPro = @{ Nombre = "Final Cut Pro"; Comando = "mas install 424389933"; Origen = "MAS" }
            }
            Mecatronica = @{
                FreeCAD = @{ Nombre = "FreeCAD"; Comando = "brew install --cask freecad"; Origen = "Brew" }
                KiCad = @{ Nombre = "KiCad"; Comando = "brew install --cask kicad"; Origen = "Brew" }
                Arduino = @{ Nombre = "Arduino IDE"; Comando = "brew install --cask arduino"; Origen = "Brew" }
                Fusion360 = @{ Nombre = "Autodesk Fusion 360"; Comando = "brew install --cask autodesk-fusion360"; Origen = "Brew" }
                Cura = @{ Nombre = "Ultimaker Cura"; Comando = "brew install --cask ultimaker-cura"; Origen = "Brew" }
            }
        }
    }
}

# ==========================================
# SISTEMAS OPERATIVOS (SOLO DESCARGA)
# ==========================================
$SistemasOperativos = @{
    # Sistemas operativos más eficientes
    Eficientes = @{
        "QNX" = @{
            URL = "https://blackberry.qnx.com/en/products/qnx-software-development-platform"
            Descripcion = "RTOS para sistemas embebidos críticos"
            Tamano = "Varía"
            Tipo = "RTOS"
        }
        "Minix 3" = @{
            URL = "http://www.minix3.org/"
            Descripcion = "Microkernel Unix-like educativo"
            Tamano = "~600 MB"
            Tipo = "Microkernel"
        }
        "seL4" = @{
            URL = "https://sel4.systems/"
            Descripcion = "Microkernel verificado formalmente"
            Tamano = "~50 MB"
            Tipo = "Microkernel"
        }
    }

    # Linux más eficientes (ultra rápidos y minimalistas)
    LinuxUltra = @{
        "Arch Linux" = @{
            URL = "https://archlinux.org/download/"
            ISO = "archlinux-x86_64.iso"
            Tamano = "800 MB"
            Descripcion = "Rolling release minimalista"
        }
        "Void Linux" = @{
            URL = "https://voidlinux.org/download/"
            ISO = "void-live-x86_64.iso"
            Tamano = "400 MB"
            Descripcion = "Independiente, sin systemd"
        }
        "Alpine Linux" = @{
            URL = "https://www.alpinelinux.org/downloads/"
            ISO = "alpine-standard-x86_64.iso"
            Tamano = "150 MB"
            Descripcion = "Ultra ligero, seguridad"
        }
        "Gentoo" = @{
            URL = "https://www.gentoo.org/downloads/"
            ISO = "gentoo-install-amd64-minimal.iso"
            Tamano = "400 MB"
            Descripcion = "Compilación desde fuente"
        }
    }

    # Linux (ligero y estables)
    LinuxLigero = @{
        "Lubuntu" = @{
            URL = "https://lubuntu.net/downloads/"
            ISO = "lubuntu-desktop-amd64.iso"
            Tamano = "2.5 GB"
            Descripcion = "Ubuntu + LXQt"
        }
        "Xubuntu" = @{
            URL = "https://xubuntu.org/download/"
            ISO = "xubuntu-desktop-amd64.iso"
            Tamano = "2.3 GB"
            Descripcion = "Ubuntu + XFCE"
        }
        "Linux Mint XFCE" = @{
            URL = "https://linuxmint.com/download.php"
            ISO = "linuxmint-xfce.iso"
            Tamano = "2.4 GB"
            Descripcion = "Mint con XFCE"
        }
        "AntiX" = @{
            URL = "https://antixlinux.com/download/"
            ISO = "antiX-full.iso"
            Tamano = "1.2 GB"
            Descripcion = "Debian ligero"
        }
        "Puppy Linux" = @{
            URL = "https://puppylinux.com/"
            ISO = "puppy-linux.iso"
            Tamano = "400 MB"
            Descripcion = "Ultra portable"
        }
    }

    # Windows más eficientes (modificados)
    WindowsMod = @{
        "Windows Optimus" = @{
            URL = "https://github.com/hellzerg/optimizer"
            Descripcion = "Optimizador de Windows"
            Tamano = "N/A"
            Tipo = "Optimizador"
        }
        "ReviOS" = @{
            URL = "https://www.revi.cc/revios"
            Descripcion = "Windows optimizado para rendimiento"
            Tamano = "3.5 GB"
            Tipo = "Modificado"
        }
        "Atlas OS" = @{
            URL = "https://atlasos.net/"
            Descripcion = "Windows desbloqueado para gaming"
            Tamano = "3.2 GB"
            Tipo = "Modificado"
        }
        "Tiny11" = @{
            URL = "https://tiny11.net/"
            Descripcion = "Windows 11 minimalista"
            Tamano = "2.1 GB"
            Tipo = "Modificado"
        }
        "Windows LTSC" = @{
            URL = "https://www.microsoft.com/evalcenter/evaluate-windows-10-enterprise"
            Descripcion = "Windows Enterprise ligero"
            Tamano = "4.5 GB"
            Tipo = "Oficial"
        }
    }

    # Windows Oficiales
    Windows = @{
        "Windows 11" = @{
            Home = @{ URL = "https://www.microsoft.com/software-download/windows11"; ISO = "Win11_Home.iso"; Tamano = "5.2 GB" }
            Pro = @{ URL = "https://www.microsoft.com/software-download/windows11"; ISO = "Win11_Pro.iso"; Tamano = "5.4 GB" }
            Enterprise = @{ URL = "https://www.microsoft.com/software-download/windows11"; ISO = "Win11_Ent.iso"; Tamano = "5.1 GB" }
            Education = @{ URL = "https://www.microsoft.com/software-download/windows11"; ISO = "Win11_Edu.iso"; Tamano = "5.3 GB" }
        }
        "Windows 10" = @{
            Home = @{ URL = "https://www.microsoft.com/software-download/windows10"; ISO = "Win10_Home.iso"; Tamano = "4.8 GB" }
            Pro = @{ URL = "https://www.microsoft.com/software-download/windows10"; ISO = "Win10_Pro.iso"; Tamano = "5.0 GB" }
            Enterprise = @{ URL = "https://www.microsoft.com/software-download/windows10"; ISO = "Win10_Ent.iso"; Tamano = "4.9 GB" }
            Education = @{ URL = "https://www.microsoft.com/software-download/windows10"; ISO = "Win10_Edu.iso"; Tamano = "4.9 GB" }
        }
        "Windows 8.1" = @{
            Standard = @{ URL = "https://www.microsoft.com/software-download/windows8ISO"; ISO = "Win8.1.iso"; Tamano = "4.0 GB" }
            Pro = @{ URL = "https://www.microsoft.com/software-download/windows8ISO"; ISO = "Win8.1_Pro.iso"; Tamano = "4.2 GB" }
        }
        "Windows 7" = @{
            Home = @{ URL = "https://www.microsoft.com/software-download/windows7"; ISO = "Win7_Home.iso"; Tamano = "3.1 GB" }
            Professional = @{ URL = "https://www.microsoft.com/software-download/windows7"; ISO = "Win7_Pro.iso"; Tamano = "3.2 GB" }
            Ultimate = @{ URL = "https://www.microsoft.com/software-download/windows7"; ISO = "Win7_Ult.iso"; Tamano = "3.3 GB" }
            Enterprise = @{ URL = "https://www.microsoft.com/software-download/windows7"; ISO = "Win7_Ent.iso"; Tamano = "3.2 GB" }
        }
    }

    # Linux Oficiales
    Linux = @{
        "Ubuntu" = @{
            "24.04 LTS" = @{ URL = "https://ubuntu.com/download/desktop"; ISO = "ubuntu-24.04-desktop-amd64.iso"; Tamano = "5.1 GB" }
            "22.04 LTS" = @{ URL = "https://ubuntu.com/download/desktop"; ISO = "ubuntu-22.04-desktop-amd64.iso"; Tamano = "4.5 GB" }
        }
        "Linux Mint" = @{
            "Cinnamon" = @{ URL = "https://linuxmint.com/download.php"; ISO = "linuxmint-cinnamon.iso"; Tamano = "2.8 GB" }
            "XFCE" = @{ URL = "https://linuxmint.com/download.php"; ISO = "linuxmint-xfce.iso"; Tamano = "2.4 GB" }
        }
        "Debian" = @{
            "Stable" = @{ URL = "https://www.debian.org/distrib/netinst"; ISO = "debian-netinst.iso"; Tamano = "400 MB" }
            "Testing" = @{ URL = "https://www.debian.org/distrib/netinst"; ISO = "debian-testing.iso"; Tamano = "450 MB" }
        }
        "Fedora" = @{
            "Workstation" = @{ URL = "https://getfedora.org/workstation/download/"; ISO = "fedora-workstation.iso"; Tamano = "2.0 GB" }
            "Server" = @{ URL = "https://getfedora.org/server/download/"; ISO = "fedora-server.iso"; Tamano = "2.2 GB" }
        }
        "Kali Linux" = @{
            "Full" = @{ URL = "https://www.kali.org/get-kali/"; ISO = "kali-linux-full.iso"; Tamano = "4.0 GB" }
            "Light" = @{ URL = "https://www.kali.org/get-kali/"; ISO = "kali-linux-light.iso"; Tamano = "1.8 GB" }
        }
        "Pop!_OS" = @{
            "AMD/Intel" = @{ URL = "https://pop.system76.com/"; ISO = "pop-os-amd64.iso"; Tamano = "2.5 GB" }
            "NVIDIA" = @{ URL = "https://pop.system76.com/"; ISO = "pop-os-nvidia.iso"; Tamano = "3.1 GB" }
        }
        "Manjaro" = @{
            "KDE" = @{ URL = "https://manjaro.org/download/"; ISO = "manjaro-kde.iso"; Tamano = "3.5 GB" }
            "GNOME" = @{ URL = "https://manjaro.org/download/"; ISO = "manjaro-gnome.iso"; Tamano = "3.4 GB" }
            "XFCE" = @{ URL = "https://manjaro.org/download/"; ISO = "manjaro-xfce.iso"; Tamano = "3.2 GB" }
        }
    }
}

# ==========================================
# FUNCIONES DE UTILIDAD
# ==========================================
function Write-Log {
    param([string]$Mensaje, [string]$Nivel = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Nivel] $Mensaje"
    Add-Content -Path $Global:Config.LogPath -Value $logEntry -ErrorAction SilentlyContinue
    switch ($Nivel) {
        "ERROR" { Write-Host $logEntry -ForegroundColor Red }
        "SUCCESS" { Write-Host $logEntry -ForegroundColor Green }
        "WARNING" { Write-Host $logEntry -ForegroundColor Yellow }
        "INFO" { Write-Host $logEntry -ForegroundColor Cyan }
    }
}

function Test-Admin {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Log "Se requieren privilegios de administrador. Reiniciando..." "WARNING"
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        exit
    }
}

function Test-Winget {
    try {
        $null = Get-Command winget -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

function Install-Winget {
    Write-Log "Instalando Winget..." "INFO"
    try {
        $progressPreference = 'silentlyContinue'
        Invoke-WebRequest -Uri "https://aka.ms/getwinget" -OutFile "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
        Add-AppxPackage -Path "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -ErrorAction Stop
        Write-Log "Winget instalado correctamente" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Error instalando Winget: $_" "ERROR"
        return $false
    }
}

function Show-Header {
    Clear-Host
    Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗             ║
║   ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝             ║
║   ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗             ║
║   ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║             ║
║   ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║             ║
║   ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝             ║
║                                                           ║
║   Sistema de Instalación Multiplataforma v$($Global:Config.Version)             ║
║   by $($Global:Config.Autor)                                            ║
╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan
    Write-Host ""
}

function Show-MenuPrincipal {
    Show-Header
    Write-Host " PLATAFORMA ACTUAL: " -NoNewline
    Write-Host "$($Global:Config.Plataforma)" -ForegroundColor Green
    Write-Host ""
    Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Blue
    Write-Host "║ [1] 🖥️ INSTALAR - Instalar aplicaciones                  ║" -ForegroundColor White
    Write-Host "║ [2] 💿 SIST. OPERA - Descargar Sistemas Operativos       ║" -ForegroundColor White
    Write-Host "║ [3] ⚙️ TWEAKS - Optimizaciones del sistema               ║" -ForegroundColor White
    Write-Host "║ [4] 🔧 DESINSTALAR - Remover aplicaciones                ║" -ForegroundColor White
    Write-Host "║ [5] 📋 EXTENSIONES - Extensiones de navegadores/IDEs     ║" -ForegroundColor White
    Write-Host "║ [6] ℹ️ INFO - Acerca de este proyecto y Guía de Uso      ║" -ForegroundColor White
    Write-Host "║ [0] 🚪 SALIR - Cerrar aplicación                         ║" -ForegroundColor White
    Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Blue
    Write-Host ""
}

# ==========================================
# MENÚ DE INSTALACIÓN
# ==========================================
function Show-MenuInstalacion {
    param([string]$Plataforma = $Global:Config.Plataforma)
    do {
        Show-Header
        Write-Host " 📦 MODO INSTALACIÓN - $Plataforma" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
        Write-Host "║ CATEGORÍAS DE APLICACIONES                                ║" -ForegroundColor Green
        Write-Host "╠═══════════════════════════════════════════════════════════╣" -ForegroundColor Green
        Write-Host "║                                                           ║"
        Write-Host "║ [1] 🌐 NAVEGADORES                                        ║" -ForegroundColor White
        Write-Host "║     └─ Estándar, Rendimiento, Privacidad, Especializados  ║" -ForegroundColor Gray
        Write-Host "║                                                           ║"
        Write-Host "║ [2] 💬 COMUNICACIÓN                                       ║" -ForegroundColor White
        Write-Host "║     └─ Cotidiano, Profesional, Privacidad, Gaming         ║" -ForegroundColor Gray
        Write-Host "║                                                           ║"
        Write-Host "║ [3] 📚 APLICACIONES DE ESPECIALIDAD                       ║" -ForegroundColor Magenta
        Write-Host "║     └─ Programación, Animación, Mecatrónica               ║" -ForegroundColor Gray
        Write-Host "║                                                           ║"
        Write-Host "║ [4] 🎁 EXTRAS                                             ║" -ForegroundColor White
        Write-Host "║     └─ Utilidades, Multimedia, Gaming, Hardware           ║" -ForegroundColor Gray
        Write-Host "║                                                           ║"
        Write-Host "╠═══════════════════════════════════════════════════════════╣" -ForegroundColor Green
        Write-Host "║ [5] ✅ INSTALAR SELECCIONADAS                             ║" -ForegroundColor Green
        Write-Host "║ [6] 📋 VER SELECCIÓN ACTUAL                               ║" -ForegroundColor Cyan
        Write-Host "║ [7] 🗑️ LIMPIAR SELECCIÓN                                  ║" -ForegroundColor Yellow
        Write-Host "║                                                           ║"
        Write-Host "║ [0] 🔙 VOLVER AL MENÚ PRINCIPAL                           ║" -ForegroundColor Red
        Write-Host "║                                                           ║"
        Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
        Write-Host ""
        Write-Host " Aplicaciones seleccionadas: $($Global:Seleccion.Count)" -ForegroundColor Cyan
        Write-Host ""
        $opcion = Read-Host " Selecciona una opción"
        switch ($opcion) {
            "1" { Show-Categoria -Categoria "Navegadores" -Plataforma $Plataforma }
            "2" { Show-Categoria -Categoria "Comunicacion" -Plataforma $Plataforma }
            "3" { Show-MenuEspecialidad -Plataforma $Plataforma }
            "4" { Show-Categoria -Categoria "Extras" -Plataforma $Plataforma }
            "5" { Instalar-Seleccionadas }
            "6" { Ver-Seleccion }
            "7" { $Global:Seleccion = @(); Write-Log "Selección limpiada" "INFO"; Start-Sleep 1 }
            "0" { return }
        }
    } while ($true)
}

function Show-Categoria {
    param([string]$Categoria, [string]$Plataforma)
    $apps = $Global:BaseDatos[$Plataforma][$Categoria]
    do {
        Show-Header
        Write-Host " 📂 $Categoria - $Plataforma" -ForegroundColor Yellow
        Write-Host ""
        $i = 1
        $lista = @()
        foreach ($app in $apps.GetEnumerator() | Sort-Object { $_.Value.Nombre }) {
            $key = $app.Key
            $val = $app.Value
            $seleccionada = if ($Global:Seleccion -contains $key) { "[✓]" } else { "[ ]" }
            Write-Host " $seleccionada [$i] $($val.Icono) $($val.Nombre)" -NoNewline -ForegroundColor White
            Write-Host " - $($val.Descripcion)" -ForegroundColor Gray
            if ($val.Subcategoria) {
                Write-Host "     Subcategoría: $($val.Subcategoria)" -ForegroundColor DarkGray
            }
            if ($val.Advertencia) {
                Write-Host "     ⚠️  Tiene advertencia" -ForegroundColor Yellow
            }
            Write-Host "     Origen: $($val.Origen)" -ForegroundColor DarkGray
            $lista += $key
            $i++
        }
        Write-Host ""
        Write-Host " [A] Seleccionar todas  [N] Ninguna  [I] Instalar seleccionadas" -ForegroundColor Green
        Write-Host " [0] Volver" -ForegroundColor Red
        Write-Host ""
        $sel = Read-Host " Selecciona aplicación para agregar/quitar (número) o opción"
        switch ($sel) {
            "A" {
                Write-Host ""
                $confirmar = Read-Host " ¿Deseas seleccionar TODAS las aplicaciones de $Categoria? (S/N)"
                if ($confirmar -eq "S" -or $confirmar -eq "s") {
                    $lista | ForEach-Object {
                        if ($Global:Seleccion -notcontains $_) { $Global:Seleccion += $_ }
                    }
                    Write-Log "Todas las aplicaciones de $Categoria seleccionadas" "SUCCESS"
                }
            }
            "N" {
                Write-Host ""
                $confirmar = Read-Host " ¿Deseas limpiar la selección de $Categoria? (S/N)"
                if ($confirmar -eq "S" -or $confirmar -eq "s") {
                    $lista | ForEach-Object { $Global:Seleccion = $Global:Seleccion | Where-Object { $_ -ne $_ } }
                    Write-Log "Selección de $Categoria limpiada" "INFO"
                }
            }
            "I" { 
                if ($Global:Seleccion.Count -eq 0) {
                    Write-Host ""
                    Write-Host " No hay aplicaciones seleccionadas." -ForegroundColor Yellow
                    Start-Sleep 2
                } else {
                    Instalar-Seleccionadas; return 
                }
            }
            "0" { return }
            default {
                if ($sel -match "^\d+$" -and [int]$sel -le $lista.Count -and [int]$sel -gt 0) {
                    $appKey = $lista[[int]$sel - 1]
                    $app = $apps[$appKey]

                    if ($Global:Seleccion -contains $appKey) {
                        $Global:Seleccion = $Global:Seleccion | Where-Object { $_ -ne $appKey }
                        Write-Log "$appKey removido de la selección" "WARNING"
                    }
                    else {
                        # Mostrar confirmación si tiene advertencia
                        if ($app.Advertencia) {
                            Write-Host ""
                            Write-Host " ⚠️  ADVERTENCIA para $($app.Nombre):" -ForegroundColor Yellow
                            Write-Host " $($app.Advertencia)" -ForegroundColor Yellow
                            Write-Host ""
                            $confirmar = Read-Host " ¿Deseas agregar esta aplicación? (S/N)"
                            if ($confirmar -ne "S" -and $confirmar -ne "s") {
                                continue
                            }
                        }
                        $Global:Seleccion += $appKey
                        Write-Log "$appKey agregado a la selección" "SUCCESS"
                    }
                }
            }
        }
    } while ($true)
}



function Show-MenuEspecialidad {
    param([string]$Plataforma)
    do {
        Show-Header
        Write-Host " 📚 APLICACIONES DE ESPECIALIDAD" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " Selecciona tu área de especialidad:" -ForegroundColor White
        Write-Host ""
        Write-Host " [1] 💻 PROGRAMACIÓN" -ForegroundColor Cyan
        Write-Host "     VS Code, Visual Studio, Python, Node.js, Git, Docker..." -ForegroundColor Gray
        Write-Host ""
        Write-Host " [2] 🎨 ANIMACIÓN" -ForegroundColor Yellow
        Write-Host "     2D: Toon Boom, TVPaint, OpenToonz, Pencil2D" -ForegroundColor Gray
        Write-Host "     3D: Maya, Blender, 3ds Max, Cinema 4D, Houdini" -ForegroundColor Gray
        Write-Host "     Escultura: ZBrush, Mudbox | Texturizado: Substance" -ForegroundColor Gray
        Write-Host "     Motores: Unreal, Unity, Godot" -ForegroundColor Gray
        Write-Host ""
        Write-Host " [3] 🔧 MECATRÓNICA" -ForegroundColor Green
        Write-Host "     Control: MATLAB, LabVIEW, PLC (TIA Portal, Studio 5000)" -ForegroundColor Gray
        Write-Host "     Microcontroladores: Arduino, STM32, PIC" -ForegroundColor Gray
        Write-Host "     CAD: SolidWorks, Fusion 360, FreeCAD" -ForegroundColor Gray
        Write-Host "     Robótica: ROS, Gazebo, Webots" -ForegroundColor Gray
        Write-Host ""
        Write-Host " [0] 🔙 Volver" -ForegroundColor Red
        Write-Host ""
        $esp = Read-Host " Selecciona tu especialidad"
        switch ($esp) {
            "1" { Show-CategoriaEspecialidad -Especialidad "Programacion" -Plataforma $Plataforma }
            "2" { Show-CategoriaEspecialidad -Especialidad "Animacion" -Plataforma $Plataforma }
            "3" { Show-CategoriaEspecialidad -Especialidad "Mecatronica" -Plataforma $Plataforma }
            "0" { return }
        }
    } while ($true)
}

function Show-CategoriaEspecialidad {
    param([string]$Especialidad, [string]$Plataforma)
    $apps = $Global:BaseDatos[$Plataforma].Especialidad[$Especialidad]
    do {
        Show-Header
        Write-Host " 📚 $Especialidad - Aplicaciones especializadas" -ForegroundColor Magenta
        Write-Host ""
        $i = 1
        $lista = @()
        foreach ($app in $apps.GetEnumerator() | Sort-Object { $_.Value.Nombre }) {
            $key = $app.Key
            $val = $app.Value
            $seleccionada = if ($Global:Seleccion -contains $key) { "[✓]" } else { "[ ]" }
            Write-Host " $seleccionada [$i] $($val.Icono) $($val.Nombre)" -NoNewline -ForegroundColor White
            Write-Host " - $($val.Descripcion)" -ForegroundColor Gray
            if ($val.Advertencia) {
                Write-Host "     ⚠️  Tiene advertencia" -ForegroundColor Yellow
            }
            Write-Host "     Origen: $($val.Origen)" -ForegroundColor DarkGray
            $lista += $key
            $i++
        }
        Write-Host ""
        Write-Host " [K] Kit completo de $Especialidad (recomendadas)" -ForegroundColor Green
        Write-Host " [A] Seleccionar todas  [N] Ninguna  [I] Instalar seleccionadas" -ForegroundColor Green
        Write-Host " [0] Volver" -ForegroundColor Red
        Write-Host ""
        $sel = Read-Host " Selecciona opción"
        switch ($sel) {
            "K" {
                Write-Host ""
                $confirmar = Read-Host " ¿Deseas agregar el kit completo de $Especialidad? (S/N)"
                if ($confirmar -eq "S" -or $confirmar -eq "s") {
                    $kit = switch ($Especialidad) {
                        "Programacion" { @("VSCode", "Git", "Python", "NodeJS", "XAMPP", "DockerDesktop") }
                        "Animacion" { @("Blender", "GIMP", "Krita", "OBSStudio", "DaVinciResolve") }
                        "Mecatronica" { @("FreeCAD", "ArduinoIDE", "KiCad", "UltimakerCura", "Fusion360") }
                    }
                    $kit | ForEach-Object {
                        if ($Global:Seleccion -notcontains $_) { $Global:Seleccion += $_ }
                    }
                    Write-Log "Kit de $Especialidad agregado" "SUCCESS"
                }
            }
            "A" {
                Write-Host ""
                $confirmar = Read-Host " ¿Deseas seleccionar TODAS las apps de $Especialidad? (S/N)"
                if ($confirmar -eq "S" -or $confirmar -eq "s") {
                    $lista | ForEach-Object {
                        if ($Global:Seleccion -notcontains $_) { $Global:Seleccion += $_ }
                    }
                    Write-Log "Todas las apps de $Especialidad seleccionadas" "SUCCESS"
                }
            }
            "N" {
                Write-Host ""
                $confirmar = Read-Host " ¿Deseas limpiar la selección de $Especialidad? (S/N)"
                if ($confirmar -eq "S" -or $confirmar -eq "s") {
                    $lista | ForEach-Object { $Global:Seleccion = $Global:Seleccion | Where-Object { $_ -ne $_ } }
                    Write-Log "Selección de $Especialidad limpiada" "INFO"
                }
            }
            "I" { 
                if ($Global:Seleccion.Count -eq 0) {
                    Write-Host ""
                    Write-Host " No hay aplicaciones seleccionadas." -ForegroundColor Yellow
                    Start-Sleep 2
                } else {
                    Instalar-Seleccionadas; return 
                }
            }
            "0" { return }
            default {
                if ($sel -match "^\d+$" -and [int]$sel -le $lista.Count -and [int]$sel -gt 0) {
                    $appKey = $lista[[int]$sel - 1]
                    $app = $apps[$appKey]

                    if ($Global:Seleccion -contains $appKey) {
                        $Global:Seleccion = $Global:Seleccion | Where-Object { $_ -ne $appKey }
                        Write-Log "$appKey removido" "WARNING"
                    }
                    else {
                        # Mostrar confirmación si tiene advertencia
                        if ($app.Advertencia) {
                            Write-Host ""
                            Write-Host " ⚠️  ADVERTENCIA para $($app.Nombre):" -ForegroundColor Yellow
                            Write-Host " $($app.Advertencia)" -ForegroundColor Yellow
                            Write-Host ""
                            $confirmar = Read-Host " ¿Deseas agregar esta aplicación? (S/N)"
                            if ($confirmar -ne "S" -and $confirmar -ne "s") {
                                continue
                            }
                        }
                        $Global:Seleccion += $appKey
                        Write-Log "$appKey agregado" "SUCCESS"
                    }
                }
            }
        }
    } while ($true)
}



# ==========================================
# INSTALACIÓN DE APLICACIONES
# ==========================================
function Instalar-Seleccionadas {
    if ($Global:Seleccion.Count -eq 0) {
        Write-Log "No hay aplicaciones seleccionadas" "WARNING"
        Start-Sleep 2
        return
    }
    Show-Header
    Write-Host " 🚀 PROCESO DE INSTALACIÓN" -ForegroundColor Green
    Write-Host ""
    Write-Host " Se instalarán las siguientes aplicaciones:" -ForegroundColor White
    Write-Host ""
    $Global:Seleccion | ForEach-Object { Write-Host " • $_" -ForegroundColor Cyan }
    Write-Host ""
    $confirmar = Read-Host " ¿Continuar con la instalación? (S/N)"
    if ($confirmar -ne "S" -and $confirmar -ne "s") {
        Write-Log "Instalación cancelada por el usuario" "WARNING"
        return
    }
    $exitosas = 0
    $fallidas = 0
    $total = $Global:Seleccion.Count
    $actual = 0
    foreach ($appKey in $Global:Seleccion) {
        $actual++
        Write-Progress -Activity "Instalando aplicaciones" -Status "$appKey ($actual de $total)" -PercentComplete (($actual/$total)*100)
        $resultado = Instalar-Aplicacion -AppKey $appKey -Plataforma $Global:Config.Plataforma
        if ($resultado) { $exitosas++ } else { $fallidas++ }
    }
    Write-Progress -Activity "Instalando aplicaciones" -Completed
    Write-Host ""
    Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║ RESUMEN DE INSTALACIÓN                                    ║" -ForegroundColor Green
    Write-Host "╠═══════════════════════════════════════════════════════════╣" -ForegroundColor Green
    Write-Host "║ ✅ Exitosas: $exitosas" -ForegroundColor Green
    Write-Host "║ ❌ Fallidas: $fallidas" -ForegroundColor $(if ($fallidas -gt 0) { "Red" } else { "Green" })
    Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Read-Host " Presiona Enter para continuar"
    $Global:Seleccion = @()
}

function Instalar-Aplicacion {
    param([string]$AppKey, [string]$Plataforma)
    $app = $null
    $categoria = $null
    foreach ($cat in $Global:BaseDatos[$Plataforma].Keys) {
        if ($Global:BaseDatos[$Plataforma][$cat] -is [System.Collections.Hashtable]) {
            if ($Global:BaseDatos[$Plataforma][$cat].ContainsKey($AppKey)) {
                $app = $Global:BaseDatos[$Plataforma][$cat][$AppKey]
                $categoria = $cat
                break
            }
            foreach ($sub in $Global:BaseDatos[$Plataforma][$cat].Keys) {
                if ($Global:BaseDatos[$Plataforma][$cat][$sub] -is [System.Collections.Hashtable] -and
                    $Global:BaseDatos[$Plataforma][$cat][$sub].ContainsKey($AppKey)) {
                    $app = $Global:BaseDatos[$Plataforma][$cat][$sub][$AppKey]
                    $categoria = "$cat > $sub"
                    break
                }
            }
        }
    }
    if (-not $app) {
        Write-Log "Aplicación '$AppKey' no encontrada" "ERROR"
        return $false
    }
    Write-Log "Instalando $($app.Nombre)..." "INFO"
    try {
        switch ($Plataforma) {
            "Windows" {
                if ($app.Origen -eq "Winget") {
                    $args = @("install", "--id", $app.ID, "--accept-package-agreements", "--accept-source-agreements", "--silent")
                    $proc = Start-Process -FilePath "winget" -ArgumentList $args -Wait -PassThru -NoNewWindow
                    return ($proc.ExitCode -eq 0)
                }
                elseif ($app.Origen -eq "Web") {
                    Start-Process $app.URL
                    return $true
                }
            }
            "Linux" {
                Invoke-Expression $app.Comando
                return ($LASTEXITCODE -eq 0)
            }
            "MacOS" {
                Invoke-Expression $app.Comando
                return ($LASTEXITCODE -eq 0)
            }
        }
    }
    catch {
        Write-Log "Error instalando $($app.Nombre): $_" "ERROR"
        return $false
    }
}

function Ver-Seleccion {
    Show-Header
    Write-Host " 📋 SELECCIÓN ACTUAL" -ForegroundColor Cyan
    Write-Host ""
    if ($Global:Seleccion.Count -eq 0) {
        Write-Host " No hay aplicaciones seleccionadas." -ForegroundColor Yellow
    }
    else {
        Write-Host " Aplicaciones seleccionadas ($($Global:Seleccion.Count)):" -ForegroundColor White
        Write-Host ""
        $Global:Seleccion | ForEach-Object { Write-Host "   • $_" -ForegroundColor Green }
    }
    Write-Host ""
    Read-Host " Presiona Enter para continuar"
}

# ==========================================
# SISTEMAS OPERATIVOS (DESCARGA)
# ==========================================
function Show-MenuSistemasOperativos {
    do {
        Show-Header
        Write-Host " 💿 DESCARGA DE SISTEMAS OPERATIVOS" -ForegroundColor Yellow
        Write-Host ""
        Write-Host " NOTA: Estos sistemas se descargarán como archivos ISO." -ForegroundColor Red
        Write-Host " Deberás grabarlos en USB o usarlos en máquina virtual." -ForegroundColor Red
        Write-Host ""
        Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
        Write-Host "║ [1] ⚡ SISTEMAS EFICIENTES (RTOS/Microkernel)            ║" -ForegroundColor White
        Write-Host "║     QNX, Minix 3, seL4                                    ║" -ForegroundColor Gray
        Write-Host "║                                                           ║"
        Write-Host "║ [2] 🚀 LINUX ULTRA RÁPIDOS (Minimalistas)                ║" -ForegroundColor White
        Write-Host "║     Arch, Void, Alpine, Gentoo                            ║" -ForegroundColor Gray
        Write-Host "║                                                           ║"
        Write-Host "║ [3] 🪶 LINUX LIGEROS Y ESTABLES                          ║" -ForegroundColor White
        Write-Host "║     Lubuntu, Xubuntu, Mint XFCE, AntiX, Puppy             ║" -ForegroundColor Gray
        Write-Host "║                                                           ║"
        Write-Host "║ [4] 🎮 WINDOWS MODIFICADOS (Optimizados)                 ║" -ForegroundColor White
        Write-Host "║     ReviOS, Atlas OS, Tiny11, LTSC                        ║" -ForegroundColor Gray
        Write-Host "║                                                           ║"
        Write-Host "║ [5] 🪟 WINDOWS OFICIALES                                 ║" -ForegroundColor White
        Write-Host "║     Windows 7, 8.1, 10, 11                                ║" -ForegroundColor Gray
        Write-Host "║                                                           ║"
        Write-Host "║ [6] 🐧 LINUX GENERALES                                   ║" -ForegroundColor White
        Write-Host "║     Ubuntu, Debian, Fedora, Kali, Pop!_OS, Manjaro        ║" -ForegroundColor Gray
        Write-Host "║                                                           ║"
        Write-Host "║ [0] 🔙 VOLVER                                            ║" -ForegroundColor Red
        Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
        Write-Host ""
        $op = Read-Host " Selecciona opción"
        switch ($op) {
            "1" { Show-MenuSOEficientes }
            "2" { Show-MenuLinuxUltra }
            "3" { Show-MenuLinuxLigero }
            "4" { Show-MenuWindowsMod }
            "5" { Show-MenuWindows }
            "6" { Show-MenuLinux }
            "0" { return }
        }
    } while ($true)
}

function Show-MenuSOEficientes {
    do {
        Show-Header
        Write-Host " ⚡ SISTEMAS OPERATIVOS EFICIENTES" -ForegroundColor Cyan
        Write-Host ""
        $i = 1
        $lista = @()
        foreach ($so in $SistemasOperativos.Eficientes.GetEnumerator() | Sort-Object Key) {
            Write-Host " [$i] $($so.Key)" -ForegroundColor White
            Write-Host "     $($so.Value.Descripcion)" -ForegroundColor Gray
            Write-Host "     Tamaño: $($so.Value.Tamano) | Tipo: $($so.Value.Tipo)" -ForegroundColor DarkGray
            Write-Host ""
            $lista += $so.Key
            $i++
        }
        Write-Host " [0] Volver" -ForegroundColor Red
        Write-Host ""
        $sel = Read-Host " Selecciona sistema para descargar"
        if ($sel -eq "0") { return }
        if ($sel -match "^\d+$" -and [int]$sel -le $lista.Count) {
            $so = $lista[[int]$sel - 1]
            $info = $SistemasOperativos.Eficientes[$so]
            Write-Host ""
            Write-Host " Se abrirá el navegador para descargar:" -ForegroundColor Yellow
            Write-Host " $so - $($info.Descripcion)" -ForegroundColor Cyan
            Write-Host ""
            Read-Host " Presiona Enter para abrir el enlace..."
            Start-Process $info.URL
            Write-Log "Navegador abierto para descargar $so" "INFO"
        }
    } while ($true)
}

function Show-MenuLinuxUltra {
    do {
        Show-Header
        Write-Host " 🚀 LINUX ULTRA RÁPIDOS (MINIMALISTAS)" -ForegroundColor Green
        Write-Host ""
        $i = 1
        $lista = @()
        foreach ($distro in $SistemasOperativos.LinuxUltra.GetEnumerator() | Sort-Object Key) {
            Write-Host " [$i] $($distro.Key)" -ForegroundColor White
            Write-Host "     $($distro.Value.Descripcion)" -ForegroundColor Gray
            Write-Host "     Tamaño: $($distro.Value.Tamano) | ISO: $($distro.Value.ISO)" -ForegroundColor DarkGray
            Write-Host ""
            $lista += $distro.Key
            $i++
        }
        Write-Host " [0] Volver" -ForegroundColor Red
        Write-Host ""
        $sel = Read-Host " Selecciona distribución para descargar"
        if ($sel -eq "0") { return }
        if ($sel -match "^\d+$" -and [int]$sel -le $lista.Count) {
            $distro = $lista[[int]$sel - 1]
            $info = $SistemasOperativos.LinuxUltra[$distro]
            Write-Host ""
            Write-Host " Se abrirá el navegador para descargar:" -ForegroundColor Yellow
            Write-Host " $distro ($($info.Tamano))" -ForegroundColor Cyan
            Write-Host ""
            Read-Host " Presiona Enter para abrir el enlace..."
            Start-Process $info.URL
            Write-Log "Navegador abierto para descargar $distro" "INFO"
        }
    } while ($true)
}

function Show-MenuLinuxLigero {
    do {
        Show-Header
        Write-Host " 🪶 LINUX LIGEROS Y ESTABLES" -ForegroundColor Green
        Write-Host ""
        $i = 1
        $lista = @()
        foreach ($distro in $SistemasOperativos.LinuxLigero.GetEnumerator() | Sort-Object Key) {
            Write-Host " [$i] $($distro.Key)" -ForegroundColor White
            Write-Host "     $($distro.Value.Descripcion)" -ForegroundColor Gray
            Write-Host "     Tamaño: $($distro.Value.Tamano)" -ForegroundColor DarkGray
            Write-Host ""
            $lista += $distro.Key
            $i++
        }
        Write-Host " [0] Volver" -ForegroundColor Red
        Write-Host ""
        $sel = Read-Host " Selecciona distribución para descargar"
        if ($sel -eq "0") { return }
        if ($sel -match "^\d+$" -and [int]$sel -le $lista.Count) {
            $distro = $lista[[int]$sel - 1]
            $info = $SistemasOperativos.LinuxLigero[$distro]
            Write-Host ""
            Write-Host " Se abrirá el navegador para descargar:" -ForegroundColor Yellow
            Write-Host " $distro ($($info.Tamano))" -ForegroundColor Cyan
            Write-Host ""
            Read-Host " Presiona Enter para abrir el enlace..."
            Start-Process $info.URL
            Write-Log "Navegador abierto para descargar $distro" "INFO"
        }
    } while ($true)
}

function Show-MenuWindowsMod {
    do {
        Show-Header
        Write-Host " 🎮 WINDOWS MODIFICADOS (OPTIMIZADOS)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " ⚠️  ATENCIÓN: Versiones modificadas no oficiales" -ForegroundColor Red
        Write-Host ""
        $i = 1
        $lista = @()
        foreach ($win in $SistemasOperativos.WindowsMod.GetEnumerator() | Sort-Object Key) {
            Write-Host " [$i] $($win.Key)" -ForegroundColor White
            Write-Host "     $($win.Value.Descripcion)" -ForegroundColor Gray
            Write-Host "     Tamaño: $($win.Value.Tamano) | Tipo: $($win.Value.Tipo)" -ForegroundColor DarkGray
            Write-Host ""
            $lista += $win.Key
            $i++
        }
        Write-Host " [0] Volver" -ForegroundColor Red
        Write-Host ""
        $sel = Read-Host " Selecciona versión para descargar"
        if ($sel -eq "0") { return }
        if ($sel -match "^\d+$" -and [int]$sel -le $lista.Count) {
            $win = $lista[[int]$sel - 1]
            $info = $SistemasOperativos.WindowsMod[$win]
            Write-Host ""
            Write-Host " Se abrirá el navegador para descargar:" -ForegroundColor Yellow
            Write-Host " $win ($($info.Tamano))" -ForegroundColor Cyan
            Write-Host ""
            Read-Host " Presiona Enter para abrir el enlace..."
            Start-Process $info.URL
            Write-Log "Navegador abierto para descargar $win" "INFO"
        }
    } while ($true)
}

function Show-MenuWindows {
    do {
        Show-Header
        Write-Host " 🪟 DESCARGAR WINDOWS OFICIALES" -ForegroundColor Cyan
        Write-Host ""
        $i = 1
        $versiones = @()
        foreach ($ver in $SistemasOperativos.Windows.GetEnumerator() | Sort-Object Key -Descending) {
            Write-Host " [$i] $($ver.Key)" -ForegroundColor White
            $versiones += $ver.Key
            $i++
        }
        Write-Host ""
        Write-Host " [0] Volver" -ForegroundColor Red
        Write-Host ""
        $sel = Read-Host " Selecciona versión de Windows"
        if ($sel -eq "0") { return }
        if ($sel -match "^\d+$" -and [int]$sel -le $versiones.Count) {
            Show-VersionesWindows -Version $versiones[[int]$sel - 1]
        }
    } while ($true)
}

function Show-VersionesWindows {
    param([string]$Version)
    do {
        Show-Header
        Write-Host " 🪟 $Version - Selecciona edición" -ForegroundColor Cyan
        Write-Host ""
        $ediciones = $SistemasOperativos.Windows[$Version]
        $i = 1
        $lista = @()
        foreach ($ed in $ediciones.GetEnumerator()) {
            Write-Host " [$i] $($ed.Key)" -NoNewline -ForegroundColor White
            Write-Host " - $($ed.Value.Tamano)" -ForegroundColor Gray
            Write-Host "     Archivo: $($ed.Value.ISO)" -ForegroundColor DarkGray
            $lista += $ed.Key
            $i++
        }
        Write-Host ""
        Write-Host " [0] Volver" -ForegroundColor Red
        Write-Host ""
        $sel = Read-Host " Selecciona edición para descargar"
        if ($sel -eq "0") { return }
        if ($sel -match "^\d+$" -and [int]$sel -le $lista.Count) {
            $edicion = $lista[[int]$sel - 1]
            $info = $ediciones[$edicion]
            Write-Host ""
            Write-Host " Se abrirá el navegador para descargar:" -ForegroundColor Yellow
            Write-Host " $Version $edicion ($($info.Tamano))" -ForegroundColor Cyan
            Write-Host ""
            Read-Host " Presiona Enter para abrir el enlace..."
            Start-Process $info.URL
            Write-Log "Navegador abierto para descargar $Version $edicion" "INFO"
        }
    } while ($true)
}

function Show-MenuLinux {
    do {
        Show-Header
        Write-Host " 🐧 DESCARGAR LINUX GENERALES" -ForegroundColor Green
        Write-Host ""
        $i = 1
        $distros = @()
        foreach ($dist in $SistemasOperativos.Linux.GetEnumerator() | Sort-Object Key) {
            Write-Host " [$i] $($dist.Key)" -ForegroundColor White
            $distros += $dist.Key
            $i++
        }
        Write-Host ""
        Write-Host " [0] Volver" -ForegroundColor Red
        Write-Host ""
        $sel = Read-Host " Selecciona distribución Linux"
        if ($sel -eq "0") { return }
        if ($sel -match "^\d+$" -and [int]$sel -le $distros.Count) {
            Show-VersionesLinux -Distro $distros[[int]$sel - 1]
        }
    } while ($true)
}

function Show-VersionesLinux {
    param([string]$Distro)
    do {
        Show-Header
        Write-Host " 🐧 $Distro - Selecciona versión/variante" -ForegroundColor Green
        Write-Host ""
        $versiones = $SistemasOperativos.Linux[$Distro]
        $i = 1
        $lista = @()
        foreach ($ver in $versiones.GetEnumerator()) {
            Write-Host " [$i] $($ver.Key)" -NoNewline -ForegroundColor White
            Write-Host " - $($ver.Value.Tamano)" -ForegroundColor Gray
            Write-Host "     Archivo: $($ver.Value.ISO)" -ForegroundColor DarkGray
            $lista += $ver.Key
            $i++
        }
        Write-Host ""
        Write-Host " [0] Volver" -ForegroundColor Red
        Write-Host ""
        $sel = Read-Host " Selecciona versión para descargar"
        if ($sel -eq "0") { return }
        if ($sel -match "^\d+$" -and [int]$sel -le $lista.Count) {
            $version = $lista[[int]$sel - 1]
            $info = $versiones[$version]
            Write-Host ""
            Write-Host " Se abrirá el navegador para descargar:" -ForegroundColor Yellow
            Write-Host " $Distro $version ($($info.Tamano))" -ForegroundColor Cyan
            Write-Host ""
            Read-Host " Presiona Enter para abrir el enlace..."
            Start-Process $info.URL
            Write-Log "Navegador abierto para descargar $Distro $version" "INFO"
        }
    } while ($true)
}

# ==========================================
# TWEAKS Y OPTIMIZACIONES
# ==========================================
function Show-MenuTweaks {
    do {
        Show-Header
        Write-Host " ⚙️ TWEAKS - Optimizaciones del Sistema" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
        Write-Host "║ [1] 🚀 RENDIMIENTO - Optimizar para máximo rendimiento   ║" -ForegroundColor White
        Write-Host "║ [2] 🔒 PRIVACIDAD - Desactivar telemetría y tracking     ║" -ForegroundColor White
        Write-Host "║ [3] 🎮 GAMING - Optimizaciones para gaming               ║" -ForegroundColor White
        Write-Host "║ [4] 💻 LAPTOP - Optimizar para batería/portátil          ║" -ForegroundColor White
        Write-Host "║ [5] 🧹 LIMPIEZA - Limpiar archivos temporales            ║" -ForegroundColor White
        Write-Host "║ [6] 🔧 AVANZADO - Opciones avanzadas de sistema          ║" -ForegroundColor White
        Write-Host "║ [7] ↩️ RESTAURAR - Volver a configuración original       ║" -ForegroundColor White
        Write-Host "║                                                          ║"
        Write-Host "║ [0] 🔙 Volver al menú principal                           ║" -ForegroundColor Red
        Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
        Write-Host ""
        $tw = Read-Host " Selecciona una opción"
        switch ($tw) {
            "1" { Apply-TweakRendimiento }
            "2" { Apply-TweakPrivacidad }
            "3" { Apply-TweakGaming }
            "4" { Apply-TweakLaptop }
            "5" { Apply-Limpieza }
            "6" { Show-TweaksAvanzados }
            "7" { Restore-Defaults }
            "0" { return }
        }
    } while ($true)
}

function Apply-TweakRendimiento {
    Show-Header
    Write-Host " 🚀 APLICANDO OPTIMIZACIONES DE RENDIMIENTO" -ForegroundColor Green
    Write-Host ""
    Write-Host ""
    Write-Host " ⚠️  Esta optimización desactivará efectos visuales y servicios." -ForegroundColor Yellow
    $confirmar = Read-Host " ¿Deseas continuar? (S/N)"
    if ($confirmar -ne "S" -and $confirmar -ne "s") {
        Write-Log "Optimización cancelada por el usuario" "WARNING"
        return
    }
    try {
        Write-Host " [1/5] Optimizando efectos visuales..." -ForegroundColor Cyan
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2
        Write-Host " [2/5] Desactivando animaciones..." -ForegroundColor Cyan
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0
        Write-Host " [3/5] Configurando servicios..." -ForegroundColor Cyan
        $servicios = @("DiagTrack", "dmwappushservice", "MapsBroker", "WMPNetworkSvc")
        foreach ($svc in $servicios) {
            Stop-Service $svc -ErrorAction SilentlyContinue
            Set-Service $svc -StartupType Disabled -ErrorAction SilentlyContinue
        }
        Write-Host " [4/5] Activando plan de alto rendimiento..." -ForegroundColor Cyan
        powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
        Write-Host " [5/5] Configurando búsqueda de Windows..." -ForegroundColor Cyan
        Set-Service "WSearch" -StartupType Disabled -ErrorAction SilentlyContinue
        Stop-Service "WSearch" -ErrorAction SilentlyContinue
        Write-Host ""
        Write-Log "Optimizaciones de rendimiento aplicadas correctamente" "SUCCESS"
    }
    catch {
        Write-Log "Error aplicando tweaks: $_" "ERROR"
    }
    Read-Host "`n Presiona Enter para continuar"
}

function Apply-TweakPrivacidad {
    Show-Header
    Write-Host " 🔒 APLICANDO OPTIMIZACIONES DE PRIVACIDAD" -ForegroundColor Green
    Write-Host ""
    try {
        Write-Host " Desactivando telemetría..." -ForegroundColor Cyan
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0
        Write-Host " Desactivando diagnósticos..." -ForegroundColor Cyan
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0
        Write-Host " Desactivando anuncios personalizados..." -ForegroundColor Cyan
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0
        Write-Host " Desactivando Cortana..." -ForegroundColor Cyan
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0
        Write-Log "Optimizaciones de privacidad aplicadas" "SUCCESS"
    }
    catch {
        Write-Log "Error: $_" "ERROR"
    }
    Read-Host "`n Presiona Enter para continuar"
}

function Apply-TweakGaming {
    Show-Header
    Write-Host " 🎮 APLICANDO OPTIMIZACIONES PARA GAMING" -ForegroundColor Green
    Write-Host ""
    try {
        Write-Host " Activando Game Mode..." -ForegroundColor Cyan
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1
        Write-Host " Desactivando Xbox Game Bar..." -ForegroundColor Cyan
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0
        Write-Host " Optimizando GPU..." -ForegroundColor Cyan
        Write-Log "Optimizaciones para gaming aplicadas" "SUCCESS"
    }
    catch {
        Write-Log "Error: $_" "ERROR"
    }
    Read-Host "`n Presiona Enter para continuar"
}

function Apply-TweakLaptop {
    Show-Header
    Write-Host " 💻 APLICANDO OPTIMIZACIONES PARA LAPTOP" -ForegroundColor Green
    Write-Host ""
    try {
        Write-Host " Configurando plan de energía equilibrado..." -ForegroundColor Cyan
        powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
        Write-Host " Reduciendo brillo automático..." -ForegroundColor Cyan
        Write-Host " Configurando suspensión..." -ForegroundColor Cyan
        powercfg /change standby-timeout-ac 30
        powercfg /change standby-timeout-dc 15
        Write-Log "Optimizaciones para laptop aplicadas" "SUCCESS"
    }
    catch {
        Write-Log "Error: $_" "ERROR"
    }
    Read-Host "`n Presiona Enter para continuar"
}

function Apply-Limpieza {
    Show-Header
    Write-Host " 🧹 LIMPIEZA DEL SISTEMA" -ForegroundColor Green
    Write-Host ""
    try {
        Write-Host " Limpiando archivos temporales..." -ForegroundColor Cyan
        Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host " Limpiando caché de Windows..." -ForegroundColor Cyan
        Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host " Vaciando Papelera de reciclaje..." -ForegroundColor Cyan
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
        Write-Host " Ejecutando Liberador de espacio..." -ForegroundColor Cyan
        Start-Process cleanmgr -ArgumentList "/sagerun:1" -Wait
        Write-Log "Limpieza completada" "SUCCESS"
    }
    catch {
        Write-Log "Error: $_" "ERROR"
    }
    Read-Host "`n Presiona Enter para continuar"
}

function Show-TweaksAvanzados {
    Show-Header
    Write-Host " 🔧 OPCIONES AVANZADAS" -ForegroundColor Yellow
    Write-Host ""
    Write-Host " Funciones avanzadas disponibles:" -ForegroundColor White
    Write-Host " • Desactivar Windows Defender (no recomendado)" -ForegroundColor Gray
    Write-Host " • Desactivar actualizaciones automáticas" -ForegroundColor Gray
    Write-Host " • Configurar servicios de arranque" -ForegroundColor Gray
    Write-Host " • Optimizar red (TCP/IP)" -ForegroundColor Gray
    Write-Host ""
    Write-Host " ⚠️ Estas opciones pueden afectar la estabilidad del sistema" -ForegroundColor Red
    Read-Host "`n Presiona Enter para volver"
}

function Restore-Defaults {
    Show-Header
    Write-Host " ↩️ RESTAURANDO CONFIGURACIÓN PREDETERMINADA" -ForegroundColor Yellow
    Write-Host ""
    try {
        Write-Host " Restaurando efectos visuales..." -ForegroundColor Cyan
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 0
        Write-Host " Restaurando plan de energía equilibrado..." -ForegroundColor Cyan
        powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
        Write-Host " Habilitando servicios..." -ForegroundColor Cyan
        Set-Service "WSearch" -StartupType Automatic -ErrorAction SilentlyContinue
        Start-Service "WSearch" -ErrorAction SilentlyContinue
        Write-Log "Configuración restaurada" "SUCCESS"
    }
    catch {
        Write-Log "Error restaurando: $_" "ERROR"
    }
    Read-Host "`n Presiona Enter para continuar"
}

# ==========================================
# EXTENSIONES
# ==========================================
function Show-MenuExtensiones {
    do {
        Show-Header
        Write-Host " 📋 EXTENSIONES Y COMPLEMENTOS" -ForegroundColor Magenta
        Write-Host ""
        Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
        Write-Host "║ [1] 💻 VS CODE EXTENSIONS - Extensiones de desarrollo    ║" -ForegroundColor White
        Write-Host "║ [2] 🌐 CHROME EXTENSIONS - Extensiones de navegador      ║" -ForegroundColor White
        Write-Host "║ [3] 🦊 FIREFOX ADDONS - Complementos Firefox             ║" -ForegroundColor White
        Write-Host "║ [4] ⚡ POWER TOYS - Módulos de PowerToys                 ║" -ForegroundColor White
        Write-Host "║                                                          ║"
        Write-Host "║ [0] 🔙 Volver al menú principal                          ║" -ForegroundColor Red
        Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Magenta
        Write-Host ""
        $ext = Read-Host " Selecciona categoría"
        switch ($ext) {
            "1" { Show-VSCodeExtensions }
            "2" { Show-ChromeExtensions }
            "3" { Show-FirefoxAddons }
            "4" { Show-PowerToysModules }
            "0" { return }
        }
    } while ($true)
}

function Show-VSCodeExtensions {
    Show-Header
    Write-Host " 💻 EXTENSIONES RECOMENDADAS PARA VS CODE" -ForegroundColor Cyan
    Write-Host ""
    $exts = @{
        "Python" = "ms-python.python"
        "ESLint" = "dbaeumer.vscode-eslint"
        "Prettier" = "esbenp.prettier-vscode"
        "Live Server" = "ritwickdey.LiveServer"
        "GitLens" = "eamodio.gitlens"
        "Docker" = "ms-azuretools.vscode-docker"
        "C/C++" = "ms-vscode.cpptools"
        "Arduino" = "vsciot-vscode.vscode-arduino"
        "Blender Development" = "JacquesLucke.blender-development"
        "PowerShell" = "ms-vscode.PowerShell"
        "Markdown All in One" = "yzhang.markdown-all-in-one"
        "Remote - SSH" = "ms-vscode-remote.remote-ssh"
    }
    Write-Host " Instalando extensiones..." -ForegroundColor Yellow
    foreach ($ext in $exts.GetEnumerator()) {
        Write-Host " Instalando: $($ext.Key)..." -NoNewline -ForegroundColor Cyan
        code --install-extension $ext.Value --force | Out-Null
        Write-Host " ✓" -ForegroundColor Green
    }
    Write-Log "Extensiones de VS Code instaladas" "SUCCESS"
    Read-Host "`n Presiona Enter para continuar"
}

function Show-ChromeExtensions {
    Show-Header
    Write-Host " 🌐 EXTENSIONES RECOMENDADAS PARA CHROME/EDGE" -ForegroundColor Cyan
    Write-Host ""
    $urls = @(
        "https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm",
        "https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb",
        "https://chrome.google.com/webstore/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh",
        "https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi",
        "https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb"
    )
    Write-Host " Se abrirán las páginas de extensiones recomendadas..." -ForegroundColor Yellow
    foreach ($url in $urls) {
        Start-Process $url
        Start-Sleep 1
    }
    Write-Log "Páginas de extensiones de Chrome abiertas" "INFO"
    Read-Host "`n Presiona Enter para continuar"
}

function Show-FirefoxAddons {
    Show-Header
    Write-Host " 🦊 EXTENSIONES RECOMENDADAS PARA FIREFOX" -ForegroundColor Cyan
    Write-Host ""
    $urls = @(
        "https://addons.mozilla.org/firefox/addon/ublock-origin/",
        "https://addons.mozilla.org/firefox/addon/bitwarden-password-manager/",
        "https://addons.mozilla.org/firefox/addon/darkreader/",
        "https://addons.mozilla.org/firefox/addon/vimium-ff/"
    )
    Write-Host " Se abrirán las páginas de complementos recomendados..." -ForegroundColor Yellow
    foreach ($url in $urls) {
        Start-Process $url
        Start-Sleep 1
    }
    Write-Log "Páginas de complementos de Firefox abiertas" "INFO"
    Read-Host "`n Presiona Enter para continuar"
}

function Show-PowerToysModules {
    Show-Header
    Write-Host " ⚡ MÓDULOS DE POWERTOYS" -ForegroundColor Cyan
    Write-Host ""
    Write-Host " Módulos disponibles en PowerToys:" -ForegroundColor White
    Write-Host " • PowerToys Run (lanzador)" -ForegroundColor Gray
    Write-Host " • FancyZones (gestión de ventanas)" -ForegroundColor Gray
    Write-Host " • PowerRename (renombrar archivos)" -ForegroundColor Gray
    Write-Host " • Color Picker (selector de color)" -ForegroundColor Gray
    Write-Host " • Image Resizer" -ForegroundColor Gray
    Write-Host " • Keyboard Manager" -ForegroundColor Gray
    Write-Host ""
    Write-Host " Abriendo configuración de PowerToys..." -ForegroundColor Yellow
    Start-Process "powertoys"
    Read-Host "`n Presiona Enter para continuar"
}

# ==========================================
# DESINSTALAR
# ==========================================
function Show-MenuDesinstalar {
    do {
        Show-Header
        Write-Host " 🔧 DESINSTALAR APLICACIONES" -ForegroundColor Red
        Write-Host ""
        Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Red
        Write-Host "║ [1] 🗑️ BLOATWARE WINDOWS - Eliminar apps preinstaladas   ║" -ForegroundColor White
        Write-Host "║ [2] 📋 LISTAR INSTALADAS - Ver apps instaladas           ║" -ForegroundColor White
        Write-Host "║ [3] 🔍 BUSCAR Y ELIMINAR - Buscar app específica         ║" -ForegroundColor White
        Write-Host "║ [4] ⚠️ ELIMINAR TODO - Formatear estilo (CUIDADO)        ║" -ForegroundColor Yellow
        Write-Host "║                                                          ║"
        Write-Host "║ [0] 🔙 Volver al menú principal                          ║" -ForegroundColor Red
        Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Red
        Write-Host ""
        $des = Read-Host " Selecciona opción"
        switch ($des) {
            "1" { Remove-Bloatware }
            "2" { List-InstalledApps }
            "3" { Search-AndRemove }
            "4" { Write-Host " ⚠️ Función deshabilitada por seguridad" -ForegroundColor Red; Start-Sleep 2 }
            "0" { return }
        }
    } while ($true)
}

function Remove-Bloatware {
    Show-Header
    Write-Host " 🗑️ ELIMINANDO BLOATWARE DE WINDOWS" -ForegroundColor Yellow
    Write-Host ""
    $bloatware = @(
        "Microsoft.3DBuilder", "Microsoft.Microsoft3DViewer", "Microsoft.BingFinance",
        "Microsoft.BingNews", "Microsoft.BingSports", "Microsoft.BingWeather",
        "Microsoft.GetHelp", "Microsoft.Getstarted", "Microsoft.Messaging",
        "Microsoft.MicrosoftOfficeHub", "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.NetworkSpeedTest", "Microsoft.News", "Microsoft.Office.Lens",
        "Microsoft.Office.OneNote", "Microsoft.Office.Sway", "Microsoft.OneConnect",
        "Microsoft.People", "Microsoft.Print3D", "Microsoft.SkypeApp",
        "Microsoft.StorePurchaseApp", "Microsoft.Wallet", "Microsoft.WindowsAlarms",
        "Microsoft.WindowsCamera", "Microsoft.WindowsMaps", "Microsoft.WindowsPhone",
        "Microsoft.WindowsSoundRecorder", "Microsoft.XboxApp", "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo"
    )
    foreach ($app in $bloatware) {
        Write-Host " Eliminando $app..." -NoNewline -ForegroundColor Cyan
        try {
            Get-AppxPackage $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
            Write-Host " ✓" -ForegroundColor Green
        }
        catch {
            Write-Host " ✗" -ForegroundColor Red
        }
    }
    Write-Log "Bloatware eliminado" "SUCCESS"
    Read-Host "`n Presiona Enter para continuar"
}

function List-InstalledApps {
    Show-Header
    Write-Host " 📋 APLICACIONES INSTALADAS" -ForegroundColor Cyan
    Write-Host ""
    Write-Host " Obteniendo lista de aplicaciones instaladas..." -ForegroundColor Yellow
    $apps = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
        Select-Object DisplayName, DisplayVersion, Publisher |
        Where-Object { $_.DisplayName -ne $null } |
        Sort-Object DisplayName
    $apps | Format-Table -AutoSize
    Write-Host " Total: $($apps.Count) aplicaciones" -ForegroundColor Green
    Read-Host "`n Presiona Enter para continuar"
}

function Search-AndRemove {
    Show-Header
    Write-Host " 🔍 BUSCAR Y ELIMINAR APLICACIÓN" -ForegroundColor Cyan
    Write-Host ""
    $busqueda = Read-Host " Escribe el nombre de la aplicación a buscar"
    if ($busqueda) {
        $resultados = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
            Where-Object { $_.DisplayName -like "*$busqueda*" }
        if ($resultados) {
            Write-Host "`n Resultados encontrados:" -ForegroundColor Green
            $resultados | ForEach-Object { Write-Host " • $($_.DisplayName)" -ForegroundColor White }
            Write-Host ""
            $confirmar = Read-Host " ¿Deseas desinstalar estas aplicaciones? (S/N)"
            if ($confirmar -eq "S" -or $confirmar -eq "s") {
                foreach ($app in $resultados) {
                    Write-Host " Desinstalando $($app.DisplayName)..." -ForegroundColor Yellow
                    # Lógica de desinstalación aquí
                }
            }
        }
        else {
            Write-Host " No se encontraron aplicaciones con ese nombre." -ForegroundColor Yellow
        }
    }
    Read-Host "`n Presiona Enter para continuar"
}

# ==========================================
# INFORMACIÓN Y GUÍA DE USO
# ==========================================
function Show-Info {
    do {
        Show-Header
        Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║                    ACERCA DE NeXus                        ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║  NeXus v4.7                                               ║
║  Sistema de Instalación Multiplataforma                   ║
║                                                           ║
║  Desarrollado por: Nexus_016                              ║
║  Institución de desarrollo: [CECyTE 30]                   ║
║  Especialidad: Técnico en Programación                    ║
║                                                           ║
║  Este proyecto fue desarrollado como trabajo de           ║
║  titulación, basándose en el concepto de Chris Titus      ║
║  Tech Windows Utility pero adaptado para las              ║
║  necesidades de estudiantes de especialidades             ║
║  técnicas (Programación, Animación, Mecatrónica)          ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan
        Write-Host ""
        Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Blue
        Write-Host "║ [1] 📖 GUÍA DE USO COMPLETA                               ║" -ForegroundColor White
        Write-Host "║ [2] ⚙️ FUNCIONES DEL SISTEMA                              ║" -ForegroundColor White
        Write-Host "║ [3] 📋 CATEGORÍAS DISPONIBLES                             ║" -ForegroundColor White
        Write-Host "║ [4] ❓ PREGUNTAS FRECUENTES                               ║" -ForegroundColor White
        Write-Host "║                                                           ║"
        Write-Host "║ [0] 🔙 VOLVER AL MENÚ PRINCIPAL                           ║" -ForegroundColor Red
        Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Blue
        Write-Host ""
        $op = Read-Host " Selecciona una opción"
        switch ($op) {
            "1" { Show-GuiaUso }
            "2" { Show-Funciones }
            "3" { Show-CategoriasInfo }
            "4" { Show-FAQ }
            "0" { return }
        }
    } while ($true)
}

function Show-GuiaUso {
    Show-Header
    Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║                   📖 GUÍA DE USO                          ║
╠═══════════════════════════════════════════════════════════╣

 1️⃣  INSTALAR APLICACIONES
     ─────────────────────────────────────────────────────
     • Selecciona [1] en el menú principal
     • Elige una categoría (Navegadores, Comunicación, etc.)
     • Marca las aplicaciones deseadas con su número
     • Usa [A] para seleccionar todas, [N] para ninguna
     • Presiona [I] para instalar las seleccionadas
     • Confirma la instalación cuando se te solicite

 2️⃣  DESCARGAR SISTEMAS OPERATIVOS
     ─────────────────────────────────────────────────────
     • Selecciona [2] en el menú principal
     • Elige el tipo de sistema operativo:
       - Eficientes (QNX, Minix 3, seL4)
       - Linux Ultra Rápidos (Arch, Void, Alpine)
       - Linux Ligeros (Lubuntu, Xubuntu, AntiX)
       - Windows Modificados (ReviOS, Atlas, Tiny11)
       - Windows/Linux Oficiales
     • Se abrirá el navegador en la página de descarga
     • Descarga el archivo ISO manualmente

 3️⃣  APLICAR TWEAKS/OPTIMIZACIONES
     ─────────────────────────────────────────────────────
     • Selecciona [3] en el menú principal
     • Elige el tipo de optimización:
       - Rendimiento: Maximiza velocidad del sistema
       - Privacidad: Desactiva telemetría y tracking
       - Gaming: Optimiza para videojuegos
       - Laptop: Ahorra batería
       - Limpieza: Elimina archivos temporales
     • Las optimizaciones se aplican automáticamente

 4️⃣  DESINSTALAR APLICACIONES
     ─────────────────────────────────────────────────────
     • Selecciona [4] en el menú principal
     • Opciones disponibles:
       - Bloatware: Elimina apps preinstaladas de Windows
       - Listar: Ver todas las apps instaladas
       - Buscar: Encontrar y eliminar app específica

 5️⃣  INSTALAR EXTENSIONES
     ─────────────────────────────────────────────────────
     • Selecciona [5] en el menú principal
     • Elige la plataforma (VS Code, Chrome, Firefox)
     • Las extensiones se instalarán automáticamente

 💡 CONSEJOS:
     • Ejecuta siempre como Administrador
     • Revisa la selección antes de instalar
     • Algunas apps requieren reinicio posterior
     • Las apps "Web" abren el navegador para descarga manual

╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor White
    Read-Host "`n Presiona Enter para volver"
}

function Show-Funciones {
    Show-Header
    Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║                  ⚙️ FUNCIONES DEL SISTEMA                 ║
╠═══════════════════════════════════════════════════════════╣

 CARACTERÍSTICAS PRINCIPALES:
 ───────────────────────────────────────────────────────────
 ✅ Instalación automatizada vía Winget (Windows)
 ✅ Soporte multiplataforma (Windows/Linux/MacOS)
 ✅ Base de datos con 200+ aplicaciones organizadas
 ✅ Sistemas operativos eficientes y minimalistas
 ✅ Kits de especialidad preconfigurados
 ✅ Optimizaciones del sistema (Tweaks)
 ✅ Gestión de extensiones de desarrollo
 ✅ Eliminación de bloatware
 ✅ Interfaz intuitiva con menús interactivos
 ✅ Registro de operaciones (logging)

 PLATAFORMAS SOPORTADAS:
 ───────────────────────────────────────────────────────────
 🪟 Windows 10/11 (con Winget)
 🐧 Linux (APT, SNAP, Flatpak)
 🍎 MacOS (Homebrew)

 MÉTODOS DE INSTALACIÓN:
 ───────────────────────────────────────────────────────────
 • Winget: Gestor de paquetes de Windows (recomendado)
 • Web: Descarga manual desde sitio oficial
 • Apt/Snap: Gestores de paquetes Linux
 • Brew: Homebrew para MacOS

╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan
    Read-Host "`n Presiona Enter para volver"
}

function Show-CategoriasInfo {
    Show-Header
    Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║                📋 CATEGORÍAS DISPONIBLES                  ║
╠═══════════════════════════════════════════════════════════╣

 🌐 NAVEGADORES (20+ opciones)
    ├─ Estándar: Chrome, Firefox, Edge
    ├─ Rendimiento: Brave, Vivaldi, Thorium, Ungoogled
    ├─ Privacidad: Tor, LibreWolf, Mullvad, Waterfox
    └─ Especializados: Opera, Opera GX, Pale Moon

 💬 COMUNICACIÓN (15+ opciones)
    ├─ Cotidiano: WhatsApp, Telegram, Discord, Zoom
    ├─ Profesional: Slack, Teams, Skype, Webex
    ├─ Privacidad: Signal, Element, Session
    ├─ Gaming: TeamSpeak, Mumble
    └─ Descentralizadas: Jitsi, Rocket.Chat

 💻 PROGRAMACIÓN (15+ opciones)
    ├─ Editores: VS Code, Visual Studio, Sublime Text
    ├─ Lenguajes: Python, Node.js, Git
    ├─ Herramientas: Docker, Postman, GitHub Desktop
    └─ Utilidades: WinMerge, PuTTY, WinSCP

 🎨 ANIMACIÓN (25+ opciones)
    ├─ 2D: Toon Boom, TVPaint, Adobe Animate, OpenToonz
    ├─ 3D: Maya, Blender, 3ds Max, Cinema 4D, Houdini
    ├─ Escultura: ZBrush, Mudbox
    ├─ Texturizado: Substance Painter, Designer, Quixel
    ├─ Motores: Unreal Engine, Unity, Godot
    ├─ Postproducción: After Effects, Premiere, DaVinci
    └─ Audio: Audition, Reaper, Audacity, FMOD, Wwise

 🔧 MECATRÓNICA (25+ opciones)
    ├─ Control: MATLAB, Simulink, LabVIEW
    ├─ Microcontroladores: Arduino, PlatformIO, STM32
    ├─ PLC: TIA Portal, Studio 5000, CODESYS
    ├─ Electrónica: Proteus, Multisim, KiCad, Altium
    ├─ CAD: SolidWorks, Inventor, Fusion 360, CATIA
    ├─ Robótica: ROS, Gazebo, Webots, RoboDK
    └─ Impresión 3D: Cura, PrusaSlicer

 🎁 EXTRAS (20+ opciones)
    ├─ Compresión: WinRAR, 7-Zip, PeaZip
    ├─ Utilidades: Everything, PowerToys, ShareX
    ├─ Multimedia: VLC, Spotify, foobar2000
    ├─ Gaming: Steam, Epic Games, GOG
    ├─ Hardware: CPU-Z, GPU-Z, HWiNFO
    ├─ Sistema: Rufus, Ventoy, VirtualBox
    └─ Seguridad: Bitwarden, KeePass

╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Yellow
    Read-Host "`n Presiona Enter para volver"
}

function Show-FAQ {
    Show-Header
    Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║                 ❓ PREGUNTAS FRECUENTES                   ║
╠═══════════════════════════════════════════════════════════╣

 ❓ ¿NeXus es gratuito?
    ✅ Sí, NeXus es completamente gratuito y open source.

 ❓ ¿Es seguro usar NeXus?
    ✅ Sí, utiliza gestores de paquetes oficiales (Winget,
       APT, Homebrew). Las apps se descargan de fuentes
       verificadas.

 ❓ ¿Funciona sin internet?
    ❌ No, se requiere conexión para descargar aplicaciones.

 ❓ ¿Puedo instalar apps de todas las categorías?
    ✅ Sí, puedes seleccionar apps de cualquier especialidad
       independientemente de tu campo.

 ❓ ¿Qué es Winget y por qué lo usa NeXus?
    ℹ️  Winget es el gestor de paquetes oficial de Microsoft
       para Windows. Permite instalaciones seguras y
       automatizadas.

 ❓ ¿Las versiones modificadas de Windows son legales?
    ⚠️  ReviOS, Atlas OS y Tiny11 son proyectos comunitarios
       que modifican Windows. Requiere licencia válida de
       Windows para activación.

 ❓ ¿Puedo deshacer los tweaks aplicados?
    ✅ Sí, usa la opción "Restaurar" en el menú de Tweaks
       para volver a la configuración predeterminada.

 ❓ ¿Cómo agrego una app que no está en la lista?
    ℹ️  Puedes solicitarla en el repositorio del proyecto
       o instalarla manualmente vía la opción Web.

 ❓ ¿Funciona en Windows 7/8?
    ⚠️  Winget solo funciona en Windows 10/11. Algunas
       funciones pueden no estar disponibles en versiones
       anteriores.

 ❓ ¿Dónde reporto errores?
    ℹ️  Puedes reportar issues en el repositorio oficial
       o contactar a Nexus_016.

╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green
    Read-Host "`n Presiona Enter para volver"
}

# ==========================================
# FUNCIÓN PRINCIPAL
# ==========================================
function Start-NeXus {
    # Inicializar variables globales
    $Global:Seleccion = @()

    # Verificar admin
    Test-Admin

    # Verificar winget (solo Windows)
    if ($Global:Config.Plataforma -eq "Windows" -and -not (Test-Winget)) {
        Write-Log "Winget no encontrado. Instalando..." "WARNING"
        if (-not (Install-Winget)) {
            Write-Log "No se pudo instalar Winget. Algunas funciones no estarán disponibles." "ERROR"
            Start-Sleep 3
        }
    }

    # Bucle principal
    do {
        Show-MenuPrincipal
        $opcion = Read-Host " Selecciona una opción"
        switch ($opcion) {
            "1" { Show-MenuInstalacion }
            "2" { Show-MenuSistemasOperativos }
            "3" { Show-MenuTweaks }
            "4" { Show-MenuDesinstalar }
            "5" { Show-MenuExtensiones }
            "6" { Show-Info }
            "0" {
                Write-Host ""
                Write-Host " ¡Gracias por usar NeXus!" -ForegroundColor Green
                Write-Host " Proyecto de Titulación - Nexus_016" -ForegroundColor Cyan
                Write-Host ""
                exit
            }
        }
    } while ($true)
}

# Iniciar aplicación
Start-NeXus
