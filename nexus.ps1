#Requires -RunAsAdministrator

<#

.SYNOPSIS

NeXus WPF GUI v1.8.2 - Instalador Multiplataforma Completo

.DESCRIPTION

Interfaz gráfica moderna para NeXus usando WPF desde PowerShell.

Versión completa con todas las funcionalidades del programa original.

.VERSION

1.8.2

.AUTHOR

nexu_016

#>

Add-Type -AssemblyName PresentationFramework

Add-Type -AssemblyName PresentationCore

Add-Type -AssemblyName WindowsBase

Add-Type -AssemblyName System.Windows.Forms

# Verificar si se ejecuta como administrador

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    [System.Windows.MessageBox]::Show("Este script requiere privilegios de administrador.`n`nPor favor, ejecute PowerShell como administrador.", "NeXus - Permisos Requeridos", "OK", "Warning")

    exit

}

# Función helper para convertir colores hex a SolidColorBrush

function Get-ColorBrush($hexColor) {

    $color = [System.Windows.Media.ColorConverter]::ConvertFromString($hexColor)

    return New-Object System.Windows.Media.SolidColorBrush($color)

}

# XAML de la interfaz completa

[xml]$xaml = @"

<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"

        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"

        Title="NEXUS v1.8.2 - Sistema de Instalación Multiplataforma"

        Height="750" Width="1200"

        WindowStartupLocation="CenterScreen"

        Background="#FF0F1419"

        FontFamily="Segoe UI"

        MinWidth="900" MinHeight="600">

    <Window.Resources>

        <!-- Colores del tema -->

        <SolidColorBrush x:Key="BgDark" Color="#FF0F1419"/>

        <SolidColorBrush x:Key="BgSidebar" Color="#FF161B22"/>

        <SolidColorBrush x:Key="BgCard" Color="#FF1C2128"/>

        <SolidColorBrush x:Key="BgHover" Color="#FF21262D"/>

        <SolidColorBrush x:Key="AccentBlue" Color="#FF58A6FF"/>

        <SolidColorBrush x:Key="AccentGreen" Color="#FF238636"/>

        <SolidColorBrush x:Key="AccentYellow" Color="#FFD29922"/>

        <SolidColorBrush x:Key="AccentRed" Color="#FFDA3633"/>

        <SolidColorBrush x:Key="TextPrimary" Color="#FFE6EDF3"/>

        <SolidColorBrush x:Key="TextSecondary" Color="#FF8B949E"/>

        <SolidColorBrush x:Key="TextMuted" Color="#FF6E7681"/>

        <SolidColorBrush x:Key="BorderColor" Color="#FF30363D"/>

        <!-- Estilo para botones del sidebar -->

        <Style x:Key="SidebarButtonStyle" TargetType="Button">

            <Setter Property="Background" Value="Transparent"/>

            <Setter Property="Foreground" Value="{StaticResource TextSecondary}"/>

            <Setter Property="BorderThickness" Value="0"/>

            <Setter Property="Padding" Value="16,12"/>

            <Setter Property="FontSize" Value="13"/>

            <Setter Property="HorizontalContentAlignment" Value="Left"/>

            <Setter Property="Cursor" Value="Hand"/>

            <Setter Property="Template">

                <Setter.Value>

                    <ControlTemplate TargetType="Button">

                        <Border Background="{TemplateBinding Background}" CornerRadius="6" Padding="{TemplateBinding Padding}">

                            <ContentPresenter HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" VerticalAlignment="Center"/>

                        </Border>

                    </ControlTemplate>

                </Setter.Value>

            </Setter>

            <Style.Triggers>

                <Trigger Property="IsMouseOver" Value="True">

                    <Setter Property="Background" Value="{StaticResource BgHover}"/>

                    <Setter Property="Foreground" Value="{StaticResource TextPrimary}"/>

                </Trigger>

                <Trigger Property="Tag" Value="Selected">

                    <Setter Property="Background" Value="{StaticResource AccentBlue}"/>

                    <Setter Property="Foreground" Value="White"/>

                </Trigger>

            </Style.Triggers>

        </Style>

        <!-- Estilo para botones del header -->

        <Style x:Key="HeaderButtonStyle" TargetType="Button">

            <Setter Property="Background" Value="Transparent"/>

            <Setter Property="Foreground" Value="{StaticResource TextSecondary}"/>

            <Setter Property="BorderThickness" Value="0"/>

            <Setter Property="Padding" Value="16,8"/>

            <Setter Property="FontSize" Value="13"/>

            <Setter Property="Cursor" Value="Hand"/>

            <Setter Property="Template">

                <Setter.Value>

                    <ControlTemplate TargetType="Button">

                        <Border Background="{TemplateBinding Background}" CornerRadius="6" Padding="{TemplateBinding Padding}">

                            <StackPanel Orientation="Horizontal">

                                <TextBlock Text="{TemplateBinding Tag}" FontFamily="Segoe UI Symbol" Margin="0,0,6,0" VerticalAlignment="Center"/>

                                <ContentPresenter VerticalAlignment="Center"/>

                            </StackPanel>

                        </Border>

                    </ControlTemplate>

                </Setter.Value>

            </Setter>

            <Style.Triggers>

                <Trigger Property="IsMouseOver" Value="True">

                    <Setter Property="Foreground" Value="{StaticResource TextPrimary}"/>

                </Trigger>

            </Style.Triggers>

        </Style>

        <!-- Estilo para cards -->

        <Style x:Key="AppCardStyle" TargetType="Border">

            <Setter Property="Background" Value="{StaticResource BgCard}"/>

            <Setter Property="BorderBrush" Value="{StaticResource BorderColor}"/>

            <Setter Property="BorderThickness" Value="1"/>

            <Setter Property="CornerRadius" Value="8"/>

            <Setter Property="Padding" Value="16"/>

            <Setter Property="Margin" Value="0,0,0,8"/>

        </Style>

        <!-- Estilo para checkbox -->

        <Style x:Key="ModernCheckBox" TargetType="CheckBox">

            <Setter Property="Foreground" Value="{StaticResource TextPrimary}"/>

            <Setter Property="FontSize" Value="13"/>

            <Setter Property="Template">

                <Setter.Value>

                    <ControlTemplate TargetType="CheckBox">

                        <StackPanel Orientation="Horizontal">

                            <Border x:Name="CheckBorder" Width="18" Height="18" Background="{StaticResource BgHover}"

                                    BorderBrush="{StaticResource BorderColor}" BorderThickness="1" CornerRadius="4" Margin="0,0,12,0">

                                <Path x:Name="CheckMark" Data="M 3 9 L 7 13 L 13 5" Stroke="{StaticResource AccentBlue}"

                                      StrokeThickness="2" StrokeStartLineCap="Round" StrokeEndLineCap="Round" Visibility="Collapsed"/>

                            </Border>

                            <ContentPresenter VerticalAlignment="Center"/>

                        </StackPanel>

                        <ControlTemplate.Triggers>

                            <Trigger Property="IsChecked" Value="True">

                                <Setter TargetName="CheckMark" Property="Visibility" Value="Visible"/>

                                <Setter TargetName="CheckBorder" Property="BorderBrush" Value="{StaticResource AccentBlue}"/>

                            </Trigger>

                            <Trigger Property="IsMouseOver" Value="True">

                                <Setter TargetName="CheckBorder" Property="BorderBrush" Value="{StaticResource AccentBlue}"/>

                            </Trigger>

                        </ControlTemplate.Triggers>

                    </ControlTemplate>

                </Setter.Value>

            </Setter>

        </Style>

        <!-- Estilo para botones de acción -->

        <Style x:Key="ActionButtonStyle" TargetType="Button">

            <Setter Property="Background" Value="{StaticResource AccentBlue}"/>

            <Setter Property="Foreground" Value="White"/>

            <Setter Property="BorderThickness" Value="0"/>

            <Setter Property="Padding" Value="16,10"/>

            <Setter Property="FontSize" Value="13"/>

            <Setter Property="FontWeight" Value="SemiBold"/>

            <Setter Property="Cursor" Value="Hand"/>

            <Setter Property="Template">

                <Setter.Value>

                    <ControlTemplate TargetType="Button">

                        <Border Background="{TemplateBinding Background}" CornerRadius="6" Padding="{TemplateBinding Padding}">

                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>

                        </Border>

                    </ControlTemplate>

                </Setter.Value>

            </Setter>

            <Style.Triggers>

                <Trigger Property="IsMouseOver" Value="True">

                    <Setter Property="Background" Value="#FF79B8FF"/>

                </Trigger>

                <Trigger Property="IsEnabled" Value="False">

                    <Setter Property="Opacity" Value="0.5"/>

                </Trigger>

            </Style.Triggers>

        </Style>

        <!-- Estilo para botones de advertencia -->

        <Style x:Key="WarningButtonStyle" TargetType="Button">

            <Setter Property="Background" Value="{StaticResource AccentYellow}"/>

            <Setter Property="Foreground" Value="#FF0F1419"/>

            <Setter Property="BorderThickness" Value="0"/>

            <Setter Property="Padding" Value="16,10"/>

            <Setter Property="FontSize" Value="13"/>

            <Setter Property="FontWeight" Value="SemiBold"/>

            <Setter Property="Cursor" Value="Hand"/>

            <Setter Property="Template">

                <Setter.Value>

                    <ControlTemplate TargetType="Button">

                        <Border Background="{TemplateBinding Background}" CornerRadius="6" Padding="{TemplateBinding Padding}">

                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>

                        </Border>

                    </ControlTemplate>

                </Setter.Value>

            </Setter>

        </Style>

        <!-- Estilo para botón de eliminar (rojo) -->

        <Style x:Key="DeleteButtonStyle" TargetType="Button">

            <Setter Property="Background" Value="{StaticResource AccentRed}"/>

            <Setter Property="Foreground" Value="White"/>

            <Setter Property="BorderThickness" Value="0"/>

            <Setter Property="Padding" Value="16,10"/>

            <Setter Property="FontSize" Value="13"/>

            <Setter Property="FontWeight" Value="SemiBold"/>

            <Setter Property="Cursor" Value="Hand"/>

            <Setter Property="Template">

                <Setter.Value>

                    <ControlTemplate TargetType="Button">

                        <Border Background="{TemplateBinding Background}" CornerRadius="6" Padding="{TemplateBinding Padding}">

                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>

                        </Border>

                    </ControlTemplate>

                </Setter.Value>

            </Setter>

            <Style.Triggers>

                <Trigger Property="IsMouseOver" Value="True">

                    <Setter Property="Background" Value="#FFF85149"/>

                </Trigger>

                <Trigger Property="IsEnabled" Value="False">

                    <Setter Property="Opacity" Value="0.5"/>

                </Trigger>

            </Style.Triggers>

        </Style>

    </Window.Resources>

    <Grid>

        <Grid.RowDefinitions>

            <RowDefinition Height="Auto"/>

            <RowDefinition Height="*"/>

            <RowDefinition Height="Auto"/>

        </Grid.RowDefinitions>

        <!-- HEADER -->

        <Grid Grid.Row="0" Background="{StaticResource BgSidebar}" Height="70">

            <Grid.ColumnDefinitions>

                <ColumnDefinition Width="Auto"/>

                <ColumnDefinition Width="*"/>

                <ColumnDefinition Width="Auto"/>

            </Grid.ColumnDefinitions>

            <!-- LOGO: Imagen personalizada -->

            <StackPanel Grid.Column="0" Orientation="Horizontal" Margin="20,0">

                <Border Width="44" Height="44" Background="Transparent" CornerRadius="22" Margin="0,0,12,0">

                    <Image x:Name="LogoImage" Width="44" Height="44" Stretch="Uniform" RenderOptions.BitmapScalingMode="HighQuality"/>

                </Border>

                <StackPanel VerticalAlignment="Center">

                    <TextBlock Text="NEXUS" FontSize="20" FontWeight="Bold" Foreground="White"/>

                    <TextBlock Text="Sistema de Instalación Multiplataforma v1.8.2" FontSize="11" Foreground="{StaticResource TextMuted}"/>

                </StackPanel>

            </StackPanel>

            <!-- Navigation Tabs -->

            <StackPanel Grid.Column="1" Orientation="Horizontal" HorizontalAlignment="Center">

                <Button x:Name="BtnInstalar" Content="Instalar Apps" Tag="📦" Style="{StaticResource HeaderButtonStyle}" Foreground="{StaticResource AccentBlue}"/>

                <Button x:Name="BtnDesinstalar" Content="Desinstalar" Tag="🗑️" Style="{StaticResource HeaderButtonStyle}"/>

                <Button x:Name="BtnSO" Content="Sistemas Operativos" Tag="💿" Style="{StaticResource HeaderButtonStyle}"/>

                <Button x:Name="BtnTweaks" Content="Optimizaciones" Tag="⚡" Style="{StaticResource HeaderButtonStyle}"/>

                <Button x:Name="BtnExtensiones" Content="Extensiones" Tag="🧩" Style="{StaticResource HeaderButtonStyle}"/>

                <Button x:Name="BtnInfo" Content="Info/Guía" Tag="ℹ️" Style="{StaticResource HeaderButtonStyle}"/>

            </StackPanel>

            <!-- Platform Info -->

            <StackPanel Grid.Column="2" Orientation="Horizontal" Margin="20,0">

                <TextBlock x:Name="TxtPlatform" Text="Windows" FontSize="14" FontWeight="SemiBold" Foreground="{StaticResource AccentBlue}" VerticalAlignment="Center"/>

                <TextBlock x:Name="TxtSelectionCount" Text="0 seleccionadas" FontSize="11" Foreground="{StaticResource TextMuted}" Margin="12,0,0,0" VerticalAlignment="Center"/>

            </StackPanel>

        </Grid>

        <!-- MAIN CONTENT -->

        <Grid Grid.Row="1">

            <Grid.ColumnDefinitions>

                <ColumnDefinition Width="280"/>

                <ColumnDefinition Width="*"/>

            </Grid.ColumnDefinitions>

            <!-- SIDEBAR -->

            <Border Grid.Column="0" Background="{StaticResource BgSidebar}" BorderBrush="{StaticResource BorderColor}" BorderThickness="0,0,1,0">

                <ScrollViewer VerticalScrollBarVisibility="Auto" Margin="0,16">

                    <StackPanel x:Name="SidebarContent">

                        <!-- Plataforma Section -->

                        <TextBlock Text="PLATAFORMA" Foreground="{StaticResource AccentBlue}" FontSize="11" FontWeight="Bold" Margin="20,0,20,12"/>

                        <StackPanel Margin="8,0">

                            <Button x:Name="BtnPlatformWindows" Style="{StaticResource SidebarButtonStyle}" Tag="Selected">

                                <StackPanel Orientation="Horizontal">

                                    <TextBlock Text="🪟" FontSize="16" Margin="0,0,12,0"/>

                                    <TextBlock Text="Windows"/>

                                </StackPanel>

                            </Button>

                            <Button x:Name="BtnPlatformLinux" Style="{StaticResource SidebarButtonStyle}">

                                <StackPanel Orientation="Horizontal">

                                    <TextBlock Text="🐧" FontSize="16" Margin="0,0,12,0"/>

                                    <TextBlock Text="Linux"/>

                                </StackPanel>

                            </Button>

                            <Button x:Name="BtnPlatformMac" Style="{StaticResource SidebarButtonStyle}">

                                <StackPanel Orientation="Horizontal">

                                    <TextBlock Text="🍎" FontSize="16" Margin="0,0,12,0"/>

                                    <TextBlock Text="macOS"/>

                                </StackPanel>

                            </Button>

                        </StackPanel>

                        <Separator Background="{StaticResource BorderColor}" Margin="20,16"/>

                        <!-- Categorías Section -->

                        <TextBlock Text="CATEGORÍAS" Foreground="{StaticResource AccentBlue}" FontSize="11" FontWeight="Bold" Margin="20,0,20,12"/>

                        <StackPanel x:Name="CategoryButtons" Margin="8,0">

                            <Button x:Name="BtnCatNavegadores" Style="{StaticResource SidebarButtonStyle}" Tag="Selected">

                                <StackPanel Orientation="Horizontal">

                                    <TextBlock Text="🌐" FontSize="16" Margin="0,0,12,0"/>

                                    <TextBlock Text="Navegadores"/>

                                </StackPanel>

                            </Button>

                            <Button x:Name="BtnCatComunicacion" Style="{StaticResource SidebarButtonStyle}">

                                <StackPanel Orientation="Horizontal">

                                    <TextBlock Text="💬" FontSize="16" Margin="0,0,12,0"/>

                                    <TextBlock Text="Comunicación"/>

                                </StackPanel>

                            </Button>

                            <Button x:Name="BtnCatEspecialidad" Style="{StaticResource SidebarButtonStyle}">

                                <StackPanel Orientation="Horizontal">

                                    <TextBlock Text="🎓" FontSize="16" Margin="0,0,12,0"/>

                                    <TextBlock Text="Especialidad"/>

                                    <TextBlock Text="▶" FontSize="10" Margin="8,0,0,0" Foreground="{StaticResource TextMuted}"/>

                                </StackPanel>

                            </Button>

                            <Button x:Name="BtnCatExtras" Style="{StaticResource SidebarButtonStyle}">

                                <StackPanel Orientation="Horizontal">

                                    <TextBlock Text="🎁" FontSize="16" Margin="0,0,12,0"/>

                                    <TextBlock Text="Extras"/>

                                </StackPanel>

                            </Button>

                        </StackPanel>

                        <Separator Background="{StaticResource BorderColor}" Margin="20,16"/>

                        <!-- Subcategorías Especialidad (se muestran solo cuando se selecciona Especialidad) -->

                        <StackPanel x:Name="SubcategoryPanel" Visibility="Collapsed" Margin="8,0">

                            <TextBlock Text="ESPECIALIDAD" Foreground="{StaticResource AccentYellow}" FontSize="11" FontWeight="Bold" Margin="12,0,20,12"/>

                            <Button x:Name="BtnSubProgramacion" Style="{StaticResource SidebarButtonStyle}">

                                <StackPanel Orientation="Horizontal">

                                    <TextBlock Text="💻" FontSize="14" Margin="8,0,12,0"/>

                                    <TextBlock Text="Programación"/>

                                </StackPanel>

                            </Button>

                            <Button x:Name="BtnSubAnimacion" Style="{StaticResource SidebarButtonStyle}">

                                <StackPanel Orientation="Horizontal">

                                    <TextBlock Text="🎨" FontSize="14" Margin="8,0,12,0"/>

                                    <TextBlock Text="Animación"/>

                                </StackPanel>

                            </Button>

                            <Button x:Name="BtnSubMecatronica" Style="{StaticResource SidebarButtonStyle}">

                                <StackPanel Orientation="Horizontal">

                                    <TextBlock Text="🔧" FontSize="14" Margin="8,0,12,0"/>

                                    <TextBlock Text="Mecatrónica"/>

                                </StackPanel>

                            </Button>

                        </StackPanel>

                    </StackPanel>

                </ScrollViewer>

            </Border>

            <!-- CONTENT AREA -->

            <Grid Grid.Column="1" Background="{StaticResource BgDark}">

                <!-- Vista: Instalar Apps -->

                <Grid x:Name="ViewInstalar">

                    <Grid.RowDefinitions>

                        <RowDefinition Height="Auto"/>

                        <RowDefinition Height="*"/>

                    </Grid.RowDefinitions>

                    <!-- Search/Filter bar -->

                    <Border Grid.Row="0" Background="{StaticResource BgSidebar}" BorderBrush="{StaticResource BorderColor}" BorderThickness="0,0,0,1" Padding="20,16">

                        <Grid>

                            <Grid.ColumnDefinitions>

                                <ColumnDefinition Width="*"/>

                                <ColumnDefinition Width="Auto"/>

                            </Grid.ColumnDefinitions>

                            <Border Grid.Column="0" Background="{StaticResource BgCard}" CornerRadius="6" Padding="12,8" Margin="0,0,16,0">

                                <StackPanel Orientation="Horizontal">

                                    <TextBlock Text="🔍" Foreground="{StaticResource TextMuted}" Margin="0,0,8,0"/>

                                    <TextBox x:Name="SearchBox" Background="Transparent" BorderThickness="0" Foreground="{StaticResource TextPrimary}"

                                             CaretBrush="{StaticResource AccentBlue}" Width="300" FontSize="13"/>

                                </StackPanel>

                            </Border>

                            <StackPanel Grid.Column="1" Orientation="Horizontal">

                                <Button x:Name="BtnSelectAll" Content="☑️ Seleccionar todas" Background="Transparent" Foreground="{StaticResource TextSecondary}"

                                        BorderThickness="0" Padding="12,8" Cursor="Hand" Margin="0,0,8,0"/>

                                <Button x:Name="BtnSelectNone" Content="⬜ Ninguna" Background="Transparent" Foreground="{StaticResource TextSecondary}"

                                        BorderThickness="0" Padding="12,8" Cursor="Hand"/>

                            </StackPanel>

                        </Grid>

                    </Border>

                    <!-- Apps List -->

                    <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" Margin="20">

                        <StackPanel x:Name="AppsList"/>

                    </ScrollViewer>

                </Grid>

                <!-- Vista: Desinstalar Apps (NUEVA) -->

                <Grid x:Name="ViewDesinstalar" Visibility="Collapsed">

                    <Grid.RowDefinitions>

                        <RowDefinition Height="Auto"/>

                        <RowDefinition Height="*"/>

                        <RowDefinition Height="Auto"/>

                    </Grid.RowDefinitions>

                    <!-- Header -->

                    <Border Grid.Row="0" Background="{StaticResource BgSidebar}" BorderBrush="{StaticResource BorderColor}" BorderThickness="0,0,0,1" Padding="20,16">

                        <StackPanel>

                            <TextBlock Text="🗑️ Desinstalar Aplicaciones" FontSize="20" FontWeight="Bold" Foreground="White" Margin="0,0,0,8"/>

                            <TextBlock Text="Selecciona las aplicaciones instaladas que deseas eliminar del sistema." 

                                       Foreground="{StaticResource TextSecondary}" TextWrapping="Wrap"/>

                        </StackPanel>

                    </Border>

                    <!-- Installed Apps List -->

                    <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" Margin="20">

                        <StackPanel x:Name="InstalledAppsList"/>

                    </ScrollViewer>

                    <!-- Botón de desinstalar (ahora en XAML) -->

                    <Border Grid.Row="2" Background="{StaticResource BgSidebar}" BorderBrush="{StaticResource BorderColor}" BorderThickness="0,1,0,0" Padding="20,16">

                        <Grid>

                            <Grid.ColumnDefinitions>

                                <ColumnDefinition Width="*"/>

                                <ColumnDefinition Width="Auto"/>

                            </Grid.ColumnDefinitions>

                            <TextBlock Grid.Column="0" Text="⚠️ La desinstalación es permanente y no se puede deshacer" 

                                       Foreground="{StaticResource AccentRed}" VerticalAlignment="Center" FontSize="12"/>

                            <Button x:Name="BtnDesinstalarSeleccionadas" Grid.Column="1" Style="{StaticResource DeleteButtonStyle}" IsEnabled="False">

                                <StackPanel Orientation="Horizontal">

                                    <TextBlock Text="🗑️" Margin="0,0,6,0"/>

                                    <TextBlock Text="DESINSTALAR SELECCIONADAS"/>

                                </StackPanel>

                            </Button>

                        </Grid>

                    </Border>

                </Grid>

                <!-- Vista: Sistemas Operativos -->

                <Grid x:Name="ViewSO" Visibility="Collapsed">

                    <ScrollViewer VerticalScrollBarVisibility="Auto" Margin="20">

                        <StackPanel>

                            <TextBlock Text="💿 Sistemas Operativos" FontSize="28" FontWeight="Bold" Foreground="White" Margin="0,0,0,8"/>

                            <TextBlock Text="Descarga ISOs de sistemas operativos para instalación limpia o máquinas virtuales."

                                       Foreground="{StaticResource TextSecondary}" Margin="0,0,0,24"/>

                            <!-- Advertencia amigable -->

                            <Border Background="#FF341A00" BorderBrush="{StaticResource AccentYellow}" BorderThickness="1" CornerRadius="8" Padding="16" Margin="0,0,0,24">

                                <StackPanel Orientation="Horizontal">

                                    <TextBlock Text="⚠️" FontSize="20" Margin="0,0,12,0"/>

                                    <TextBlock Text="Nota: Algunas versiones modificadas de Windows son proyectos comunitarios. Asegúrate de tener una licencia válida de Windows para la activación."

                                               Foreground="{StaticResource AccentYellow}" TextWrapping="Wrap"/>

                                </StackPanel>

                            </Border>

                            <UniformGrid Columns="2">

                                <!-- Eficientes -->

                                <Border Style="{StaticResource AppCardStyle}" Margin="0,0,12,12">

                                    <StackPanel>

                                        <TextBlock Text="⚡ Sistemas Eficientes" FontSize="18" FontWeight="Bold" Foreground="White" Margin="0,0,0,16"/>

                                        <StackPanel x:Name="EficientesList"/>

                                    </StackPanel>

                                </Border>

                                <!-- Linux Ultra -->

                                <Border Style="{StaticResource AppCardStyle}" Margin="0,0,0,12">

                                    <StackPanel>

                                        <TextBlock Text="🚀 Linux Ultra Rápidos" FontSize="18" FontWeight="Bold" Foreground="White" Margin="0,0,0,16"/>

                                        <StackPanel x:Name="LinuxUltraList"/>

                                    </StackPanel>

                                </Border>

                                <!-- Windows Modificados -->

                                <Border Style="{StaticResource AppCardStyle}" Margin="0,0,12,0">

                                    <StackPanel>

                                        <TextBlock Text="🎮 Windows Modificados" FontSize="18" FontWeight="Bold" Foreground="White" Margin="0,0,0,16"/>

                                        <StackPanel x:Name="WindowsModList"/>

                                    </StackPanel>

                                </Border>

                                <!-- Windows Oficiales -->

                                <Border Style="{StaticResource AppCardStyle}">

                                    <StackPanel>

                                        <TextBlock Text="🪟 Windows Oficiales" FontSize="18" FontWeight="Bold" Foreground="White" Margin="0,0,0,16"/>

                                        <StackPanel x:Name="WindowsOfficialList"/>

                                    </StackPanel>

                                </Border>

                            </UniformGrid>

                            <Border Style="{StaticResource AppCardStyle}" Margin="0,12,0,0">

                                <StackPanel>

                                    <TextBlock Text="🐧 Linux Generales" FontSize="18" FontWeight="Bold" Foreground="White" Margin="0,0,0,16"/>

                                    <StackPanel x:Name="LinuxGeneralList"/>

                                </StackPanel>

                            </Border>

                        </StackPanel>

                    </ScrollViewer>

                </Grid>

                <!-- Vista: Tweaks -->

                <Grid x:Name="ViewTweaks" Visibility="Collapsed">

                    <ScrollViewer VerticalScrollBarVisibility="Auto" Margin="20">

                        <StackPanel>

                            <TextBlock Text="⚡ Optimizaciones del Sistema" FontSize="28" FontWeight="Bold" Foreground="White" Margin="0,0,0,8"/>

                            <TextBlock Text="Aplica tweaks para mejorar rendimiento, privacidad o gaming."

                                       Foreground="{StaticResource TextSecondary}" Margin="0,0,0,24"/>

                            <!-- Advertencia amigable -->

                            <Border Background="#FF341A00" BorderBrush="{StaticResource AccentYellow}" BorderThickness="1" CornerRadius="8" Padding="16" Margin="0,0,0,24">

                                <StackPanel Orientation="Horizontal">

                                    <TextBlock Text="💡" FontSize="20" Margin="0,0,12,0"/>

                                    <TextBlock Text="Consejo: Puedes restaurar la configuración original en cualquier momento usando el botón 'Restaurar valores predeterminados'."

                                               Foreground="{StaticResource AccentYellow}" TextWrapping="Wrap"/>

                                </StackPanel>

                            </Border>

                            <UniformGrid Columns="2">

                                <Border Style="{StaticResource AppCardStyle}" Margin="0,0,12,12">

                                    <StackPanel>

                                        <TextBlock Text="🚀 Rendimiento" FontSize="18" FontWeight="Bold" Foreground="White"/>

                                        <TextBlock Text="Desactiva efectos visuales, optimiza servicios y activa plan de alto rendimiento. Ideal para equipos con hardware limitado."

                                                   TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,8,0,16"/>

                                        <Button x:Name="BtnTweakPerformance" Content="Aplicar optimización" Style="{StaticResource ActionButtonStyle}"/>

                                    </StackPanel>

                                </Border>

                                <Border Style="{StaticResource AppCardStyle}" Margin="0,0,0,12">

                                    <StackPanel>

                                        <TextBlock Text="🔒 Privacidad" FontSize="18" FontWeight="Bold" Foreground="White"/>

                                        <TextBlock Text="Desactiva telemetría, diagnósticos, anuncios personalizados y Cortana. Mejora tu privacidad sin afectar el funcionamiento."

                                                   TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,8,0,16"/>

                                        <Button x:Name="BtnTweakPrivacy" Content="Aplicar privacidad" Style="{StaticResource ActionButtonStyle}"/>

                                    </StackPanel>

                                </Border>

                                <Border Style="{StaticResource AppCardStyle}" Margin="0,0,12,0">

                                    <StackPanel>

                                        <TextBlock Text="🎮 Gaming" FontSize="18" FontWeight="Bold" Foreground="White"/>

                                        <TextBlock Text="Activa Game Mode, desactiva Xbox Game Bar y optimiza para juegos. Mejora los FPS y reduce la latencia."

                                                   TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,8,0,16"/>

                                        <Button x:Name="BtnTweakGaming" Content="Aplicar gaming" Style="{StaticResource ActionButtonStyle}"/>

                                    </StackPanel>

                                </Border>

                                <Border Style="{StaticResource AppCardStyle}">

                                    <StackPanel>

                                        <TextBlock Text="💻 Laptop" FontSize="18" FontWeight="Bold" Foreground="White"/>

                                        <TextBlock Text="Configura plan de energía equilibrado, reduce brillo automático y optimiza suspensión. Extiende la duración de la batería."

                                                   TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,8,0,16"/>

                                        <Button x:Name="BtnTweakLaptop" Content="Aplicar laptop" Style="{StaticResource ActionButtonStyle}"/>

                                    </StackPanel>

                                </Border>

                            </UniformGrid>

                            <Border Style="{StaticResource AppCardStyle}" Margin="0,12,0,0">

                                <StackPanel>

                                    <TextBlock Text="🧹 Limpieza del Sistema" FontSize="18" FontWeight="Bold" Foreground="White"/>

                                    <TextBlock Text="Elimina archivos temporales, vacía la papelera y libera espacio en disco de forma segura."

                                               TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,8,0,16"/>

                                    <Button x:Name="BtnTweakClean" Content="Limpiar sistema" Style="{StaticResource WarningButtonStyle}"/>

                                </StackPanel>

                            </Border>

                            <Border Style="{StaticResource AppCardStyle}" Margin="0,12,0,0">

                                <StackPanel>

                                    <TextBlock Text="↩️ Restaurar Configuración" FontSize="18" FontWeight="Bold" Foreground="White"/>

                                    <TextBlock Text="Vuelve a la configuración predeterminada de Windows. Revierte todos los cambios aplicados."

                                               TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,8,0,16"/>

                                    <Button x:Name="BtnTweakRestore" Content="Restaurar valores predeterminados" Background="Transparent"

                                            Foreground="{StaticResource TextPrimary}" BorderBrush="{StaticResource BorderColor}" BorderThickness="1"

                                            Padding="16,10" HorizontalAlignment="Left"/>

                                </StackPanel>

                            </Border>

                        </StackPanel>

                    </ScrollViewer>

                </Grid>

                <!-- Vista: Extensiones -->

                <Grid x:Name="ViewExtensiones" Visibility="Collapsed">

                    <ScrollViewer VerticalScrollBarVisibility="Auto" Margin="20">

                        <StackPanel>

                            <TextBlock Text="🧩 Extensiones y Complementos" FontSize="28" FontWeight="Bold" Foreground="White" Margin="0,0,0,8"/>

                            <TextBlock Text="Instala extensiones recomendadas para tus aplicaciones."

                                       Foreground="{StaticResource TextSecondary}" Margin="0,0,0,24"/>

                            <UniformGrid Columns="2">

                                <Border Style="{StaticResource AppCardStyle}" Margin="0,0,12,12">

                                    <StackPanel>

                                        <TextBlock Text="💻 VS Code Extensions" FontSize="18" FontWeight="Bold" Foreground="White" Margin="0,0,0,8"/>

                                        <TextBlock Text="Python, ESLint, Prettier, GitLens, Docker, C/C++, Arduino, Live Server"

                                                   TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,16"/>

                                        <Button x:Name="BtnExtVSCode" Content="Instalar extensiones" Style="{StaticResource ActionButtonStyle}"/>

                                    </StackPanel>

                                </Border>

                                <Border Style="{StaticResource AppCardStyle}" Margin="0,0,0,12">

                                    <StackPanel>

                                        <TextBlock Text="🌐 Chrome Extensions" FontSize="18" FontWeight="Bold" Foreground="White" Margin="0,0,0,8"/>

                                        <TextBlock Text="uBlock Origin, Bitwarden, Dark Reader, React DevTools, Vimium"

                                                   TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,16"/>

                                        <Button x:Name="BtnExtChrome" Content="Abrir Chrome Web Store" Style="{StaticResource ActionButtonStyle}"/>

                                    </StackPanel>

                                </Border>

                                <Border Style="{StaticResource AppCardStyle}" Margin="0,0,12,0">

                                    <StackPanel>

                                        <TextBlock Text="🦊 Firefox Addons" FontSize="18" FontWeight="Bold" Foreground="White" Margin="0,0,0,8"/>

                                        <TextBlock Text="uBlock Origin, Bitwarden, Dark Reader, Vimium-FF"

                                                   TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,16"/>

                                        <Button x:Name="BtnExtFirefox" Content="Abrir Firefox Add-ons" Style="{StaticResource ActionButtonStyle}"/>

                                    </StackPanel>

                                </Border>

                                <Border Style="{StaticResource AppCardStyle}">

                                    <StackPanel>

                                        <TextBlock Text="⚡ PowerToys Módulos" FontSize="18" FontWeight="Bold" Foreground="White" Margin="0,0,0,8"/>

                                        <TextBlock Text="PowerToys Run, FancyZones, PowerRename, Color Picker, Image Resizer"

                                                   TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,16"/>

                                        <Button x:Name="BtnExtPowerToys" Content="Abrir PowerToys" Style="{StaticResource ActionButtonStyle}"/>

                                    </StackPanel>

                                </Border>

                            </UniformGrid>

                        </StackPanel>

                    </ScrollViewer>

                </Grid>

                <!-- Vista: Info/Guía -->

                <Grid x:Name="ViewInfo" Visibility="Collapsed">

                    <ScrollViewer VerticalScrollBarVisibility="Auto" Margin="20">

                        <StackPanel MaxWidth="800">

                            <TextBlock Text="ℹ️ Acerca de NeXus" FontSize="28" FontWeight="Bold" Foreground="White" Margin="0,0,0,8"/>

                            <TextBlock Text="Sistema de Instalación Multiplataforma v1.8.2"

                                       Foreground="{StaticResource AccentBlue}" FontSize="16" Margin="0,0,0,24"/>

                            <Border Style="{StaticResource AppCardStyle}" Margin="0,0,0,16">

                                <StackPanel>

                                    <TextBlock Text="📖 Guía de Uso Rápido" FontSize="20" FontWeight="Bold" Foreground="White" Margin="0,0,0,16"/>

                                    <TextBlock Text="1️⃣ Instalar Aplicaciones" FontSize="16" FontWeight="SemiBold" Foreground="{StaticResource AccentBlue}" Margin="0,0,0,8"/>

                                    <TextBlock Text="• Selecciona tu plataforma (Windows/Linux/macOS) en el sidebar&#x0a;• Elige una categoría: Navegadores, Comunicación, Especialidad o Extras&#x0a;• Marca las aplicaciones deseadas con el checkbox&#x0a;• Usa 'Seleccionar todas' o 'Ninguna' para selección rápida&#x0a;• Presiona 'INSTALAR SELECCIONADAS' y confirma&#x0a;• Algunas aplicaciones requieren reinicio posterior&#x0a;&#x0a;📦 TIPOS DE INSTALACIÓN:&#x0a;&#x0a;[Winget] — Instalación automática vía Windows Package Manager&#x0a;  → Se instalan directamente en segundo plano sin intervención manual&#x0a;  → Aparecen automáticamente en el Escritorio y Menú de Inicio al terminar&#x0a;  → Destino habitual: C:\Program Files\ o C:\Program Files (x86)\&#x0a;  → Peso aproximado varía por app (ver columna Tamaño en la lista)&#x0a;  → Ejemplos: Chrome (~120 MB), Discord (~180 MB), VS Code (~90 MB), Spotify (~150 MB)&#x0a;&#x0a;[Web] — Descarga manual desde el navegador&#x0a;  → NeXus abre automáticamente la página oficial de descarga en tu navegador&#x0a;  → Debes descargar el instalador (.exe / .msi) manualmente y ejecutarlo&#x0a;  → El instalador suele guardarse en C:\Users\TuUsuario\Downloads\&#x0a;  → Después de instalar, el acceso directo aparece en el Escritorio&#x0a;  → Ejemplos: Ungoogled Chromium (???), Thorium (???), Mullvad Browser (???)&#x0a;&#x0a;[Otros] — Instaladores especiales o de fuentes alternativas&#x0a;  → Pueden requerir pasos adicionales como aceptar licencias o elegir componentes&#x0a;  → Algunos se instalan en rutas personalizadas elegidas durante la instalación&#x0a;  → Revisa siempre el icono ⚠️ que indica advertencias especiales antes de instalar"

                                               TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,16"/>

                                    <TextBlock Text="2️⃣ Desinstalar Aplicaciones (NUEVO)" FontSize="16" FontWeight="SemiBold" Foreground="{StaticResource AccentBlue}" Margin="0,0,0,8"/>

                                    <TextBlock Text="• Ve a la pestaña 'Desinstalar'&#x0a;• Se muestran las aplicaciones instaladas detectadas&#x0a;• Marca las que deseas eliminar&#x0a;• Presiona 'DESINSTALAR SELECCIONADAS'&#x0a;• Confirma la acción&#x0a;&#x0a;🗑️ CÓMO FUNCIONA LA DESINSTALACIÓN:&#x0a;&#x0a;[Apps Winget] — Desinstalación automática y silenciosa&#x0a;  → NeXus ejecuta 'winget uninstall' en segundo plano&#x0a;  → Se elimina de C:\Program Files\ o C:\Program Files (x86)\ según corresponda&#x0a;  → El acceso directo del Escritorio y Menú Inicio se elimina automáticamente&#x0a;  → Algunos programas requieren reinicio para completar la limpieza de archivos&#x0a;&#x0a;[Apps Web / Manuales] — Desinstalación vía Panel de Control&#x0a;  → Se utiliza el desinstalador nativo del programa&#x0a;  → Puede abrir un asistente de desinstalación con pasos adicionales&#x0a;  → Archivos residuales en C:\Users\TuUsuario\AppData\ pueden quedar; elimínalos manualmente si es necesario&#x0a;&#x0a;⚠️ NOTA: Algunas aplicaciones del sistema no pueden desinstalarse desde NeXus. Si no aparecen en la lista, usa Panel de Control → Programas → Desinstalar un programa."

                                               TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,16"/>

                                    <TextBlock Text="3️⃣ Descargar Sistemas Operativos" FontSize="16" FontWeight="SemiBold" Foreground="{StaticResource AccentBlue}" Margin="0,0,0,8"/>

                                    <TextBlock Text="• Ve a la pestaña 'Sistemas Operativos'&#x0a;• Selecciona el tipo: Eficientes, Linux Ultra, Windows Modificados, etc.&#x0a;• Haz clic en el sistema deseado para abrir la página de descarga&#x0a;• Descarga el archivo ISO manualmente&#x0a;• Usa Rufus o Ventoy para crear USB booteable&#x0a;&#x0a;💿 TIPOS DE DESCARGA Y DESTINOS:&#x0a;&#x0a;[Web — Descarga directa desde web oficial]&#x0a;  → NeXus abre la página oficial del sistema operativo en tu navegador&#x0a;  → Descarga el archivo .ISO manualmente (tamaño varía por distro)&#x0a;  → El archivo ISO se guarda en C:\Users\TuUsuario\Downloads\ por defecto&#x0a;  → Peso aproximado: Windows (~5-8 GB), Ubuntu (~3 GB), Arch (~800 MB), Tails (~1.3 GB)&#x0a;&#x0a;[Torrent — Descarga P2P para ISOs grandes]&#x0a;  → Algunos sistemas usan torrent para distribución eficiente&#x0a;  → Requiere cliente torrent instalado (ej. qBittorrent)&#x0a;  → El archivo .torrent se descarga primero, luego inicia la descarga del ISO&#x0a;&#x0a;[USB Booteable]&#x0a;  → Una vez descargado el ISO, usa Rufus (Windows) o Ventoy (multiboot)&#x0a;  → Rufus: selecciona ISO → elige USB → clic en Iniciar (⚠️ borra el USB)&#x0a;  → Ventoy: copia el ISO directamente al USB formateado con Ventoy"

                                               TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,16"/>

                                    <TextBlock Text="4️⃣ Aplicar Optimizaciones (Tweaks)" FontSize="16" FontWeight="SemiBold" Foreground="{StaticResource AccentBlue}" Margin="0,0,0,8"/>

                                    <TextBlock Text="• Ve a la pestaña 'Optimizaciones'&#x0a;• Elige el tipo: Rendimiento, Privacidad, Gaming o Laptop&#x0a;• Lee la descripción de cada opción&#x0a;• Presiona 'Aplicar' y confirma&#x0a;• Usa 'Restaurar' para volver a la configuración original&#x0a;&#x0a;⚡ TIPOS DE OPTIMIZACIÓN Y QUÉ MODIFICAN:&#x0a;&#x0a;[Rendimiento] — Optimiza velocidad general del sistema&#x0a;  → Desactiva efectos visuales de Windows (animaciones, sombras, transparencias)&#x0a;  → Ajusta configuración de energía a 'Alto rendimiento'&#x0a;  → Modifica: Registro de Windows, Configuración de Energía, Servicios del sistema&#x0a;  → No requiere descarga; se aplican cambios de configuración local&#x0a;&#x0a;[Gaming] — Optimiza para juegos y fps&#x0a;  → Activa Windows Game Mode, desactiva Xbox Game Bar&#x0a;  → Prioriza procesos de juego, desactiva superposiciones innecesarias&#x0a;  → Modifica: Registro, configuración GPU, servicios de background&#x0a;&#x0a;[Privacidad] — Reduce telemetría y seguimiento&#x0a;  → Desactiva servicios de diagnóstico y telemetría de Microsoft&#x0a;  → Modifica: Registro de Windows, Políticas de grupo, Servicios&#x0a;  → ⚠️ Algunos cambios pueden afectar funciones de Windows Update&#x0a;&#x0a;[Laptop] — Extiende vida de batería&#x0a;  → Ajusta suspensión automática y brillo adaptativo&#x0a;  → Modifica: Plan de energía, configuración de pantalla y CPU throttling&#x0a;&#x0a;🔄 Usa 'Restaurar valores predeterminados' para revertir todos los cambios."

                                               TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,16"/>

                                    <TextBlock Text="5️⃣ Instalar Extensiones" FontSize="16" FontWeight="SemiBold" Foreground="{StaticResource AccentBlue}" Margin="0,0,0,8"/>

                                    <TextBlock Text="• Ve a la pestaña 'Extensiones'&#x0a;• Selecciona la plataforma: VS Code, Chrome, Firefox o PowerToys&#x0a;• Para VS Code: se instalan automáticamente&#x0a;• Para navegadores: se abre la tienda de extensiones&#x0a;&#x0a;🧩 TIPOS DE EXTENSIONES Y CÓMO SE INSTALAN:&#x0a;&#x0a;[VS Code Extensions — Instalación automática vía CLI]&#x0a;  → NeXus ejecuta 'code --install-extension' en segundo plano&#x0a;  → Se instalan directamente en VS Code sin abrir el editor&#x0a;  → Destino: C:\Users\TuUsuario\.vscode\extensions\&#x0a;  → Se activan la próxima vez que abras VS Code&#x0a;  → Peso por extensión: generalmente entre 1 MB y 30 MB según la extensión&#x0a;  → Ejemplos: Prettier (???), ESLint (???), GitLens (???)&#x0a;&#x0a;[Chrome Extensions — Instalación vía Chrome Web Store]&#x0a;  → NeXus abre la Chrome Web Store en tu navegador automáticamente&#x0a;  → Haz clic en 'Añadir a Chrome' → confirma los permisos&#x0a;  → Se instalan en el perfil de Chrome: C:\Users\TuUsuario\AppData\Local\Google\Chrome\User Data\Default\Extensions\&#x0a;  → Aparecen en la barra de herramientas de Chrome al instalarse&#x0a;  → Peso: muy ligeras, entre 100 KB y 5 MB&#x0a;&#x0a;[Firefox Extensions — Instalación vía Firefox Add-ons]&#x0a;  → NeXus abre addons.mozilla.org en Firefox&#x0a;  → Haz clic en '+ Agregar a Firefox' y acepta los permisos&#x0a;  → Se guardan en el perfil de Firefox: C:\Users\TuUsuario\AppData\Roaming\Mozilla\Firefox\Profiles\&#x0a;&#x0a;[PowerToys — Instalación y configuración de módulos]&#x0a;  → Requiere tener PowerToys instalado previamente&#x0a;  → NeXus activa o configura módulos dentro de PowerToys&#x0a;  → Peso del paquete completo de PowerToys: ~100 MB (Winget)"

                                               TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,16"/>

                                    <TextBlock Text="💡 Consejos Importantes" FontSize="16" FontWeight="SemiBold" Foreground="{StaticResource AccentYellow}" Margin="0,0,0,8"/>

                                    <TextBlock Text="• Ejecuta siempre como Administrador&#x0a;• Revisa la selección antes de instalar&#x0a;• Las apps marcadas con ⚠️ tienen advertencias especiales&#x0a;• Las apps 'Web' abren el navegador para descarga manual&#x0a;• Puedes cambiar de categoría sin perder tu selección"

                                               TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}"/>

                                </StackPanel>

                            </Border>

                            <Border Style="{StaticResource AppCardStyle}" Margin="0,0,0,16">

                                <StackPanel>

                                    <TextBlock Text="❓ Preguntas Frecuentes" FontSize="20" FontWeight="Bold" Foreground="White" Margin="0,0,0,16"/>

                                    <TextBlock Text="¿NeXus es gratuito?" FontWeight="SemiBold" Foreground="White" Margin="0,0,0,4"/>

                                    <TextBlock Text="Sí, NeXus es completamente gratuito y open source." Foreground="{StaticResource TextSecondary}" Margin="0,0,0,12"/>

                                    <TextBlock Text="¿Es seguro usar NeXus?" FontWeight="SemiBold" Foreground="White" Margin="0,0,0,4"/>

                                    <TextBlock Text="Sí, utiliza gestores de paquetes oficiales (Winget, APT, Homebrew). Las apps se descargan de fuentes verificadas." Foreground="{StaticResource TextSecondary}" Margin="0,0,0,12"/>

                                    <TextBlock Text="¿Funciona sin internet?" FontWeight="SemiBold" Foreground="White" Margin="0,0,0,4"/>

                                    <TextBlock Text="No, se requiere conexión para descargar aplicaciones." Foreground="{StaticResource TextSecondary}" Margin="0,0,0,12"/>

                                    <TextBlock Text="¿Puedo deshacer los tweaks?" FontWeight="SemiBold" Foreground="White" Margin="0,0,0,4"/>

                                    <TextBlock Text="Sí, usa la opción 'Restaurar valores predeterminados' en la pestaña de Optimizaciones." Foreground="{StaticResource TextSecondary}" Margin="0,0,0,12"/>

                                    <TextBlock Text="¿Qué es Winget?" FontWeight="SemiBold" Foreground="White" Margin="0,0,0,4"/>

                                    <TextBlock Text="Es el gestor de paquetes oficial de Microsoft para Windows. Permite instalaciones seguras y automatizadas.&#x0a;&#x0a;→ Las apps Winget se descargan e instalan directamente desde los servidores oficiales del fabricante&#x0a;→ No requieren que hagas nada: NeXus lanza el comando y la app aparece en tu Escritorio al terminar&#x0a;→ Se instalan típicamente en C:\Program Files\ o C:\Program Files (x86)\&#x0a;→ Puedes verificar apps instaladas con Winget ejecutando en PowerShell: winget list&#x0a;&#x0a;📐 SOBRE EL PESO (TAMAÑO) DE LAS APPS:&#x0a;→ Cada app en la lista muestra su tipo de instalación: [Winget], [Web] u [Otros]&#x0a;→ La columna 'Tamaño' indica el peso aproximado del instalador o descarga&#x0a;→ Los tamaños marcados como '???' significan que el peso varía según versión o no está disponible&#x0a;→ Verifica siempre el espacio libre en disco antes de instalar varios programas a la vez" Foreground="{StaticResource TextSecondary}"/>

                                </StackPanel>

                            </Border>

                            <TextBlock Text="Desarrollado por: nexu_016&#x0a;Proyecto de Titulación - Técnico en Programación&#x0a;Basado en el concepto de Chris Titus Tech Windows Utility"

                                       Foreground="{StaticResource TextMuted}" FontSize="11" TextAlignment="Center" Margin="0,16,0,0"/>

                        </StackPanel>

                    </ScrollViewer>

                </Grid>

            </Grid>

        </Grid>

        <!-- FOOTER -->

        <Grid Grid.Row="2" Background="{StaticResource BgSidebar}" Height="60">

            <Grid.ColumnDefinitions>

                <ColumnDefinition Width="*"/>

                <ColumnDefinition Width="Auto"/>

                <ColumnDefinition Width="Auto"/>

            </Grid.ColumnDefinitions>

            <TextBlock Grid.Column="0" Text="Proyecto de Titulación - Técnico en Programación | nexu_016"

                       Foreground="{StaticResource TextMuted}" FontSize="11" VerticalAlignment="Center" Margin="20,0"/>

            <Button x:Name="BtnVerSeleccion" Grid.Column="1" Background="{StaticResource BgCard}" Foreground="{StaticResource TextPrimary}"

                    BorderBrush="{StaticResource BorderColor}" BorderThickness="1" Padding="16,10" Margin="0,0,12,0" Cursor="Hand">

                <StackPanel Orientation="Horizontal">

                    <TextBlock Text="📋" Margin="0,0,6,0"/>

                    <TextBlock x:Name="TxtBtnSeleccion" Text="Ver Selección (0)"/>

                </StackPanel>

            </Button>

            <Button x:Name="BtnInstalarSeleccionadas" Grid.Column="2" Background="{StaticResource AccentGreen}" Foreground="White"

                    BorderThickness="0" Padding="24,10" Margin="0,0,20,0" Cursor="Hand" IsEnabled="False" Opacity="0.5">

                <StackPanel Orientation="Horizontal">

                    <TextBlock Text="🚀" Margin="0,0,6,0"/>

                    <TextBlock Text="INSTALAR SELECCIONADAS"/>

                </StackPanel>

            </Button>

        </Grid>

    </Grid>

</Window>

"@

# Crear el lector XAML

$reader = New-Object System.Xml.XmlNodeReader $xaml

$window = [Windows.Markup.XamlReader]::Load($reader)

# Variables globales

$script:selectedApps = @()

$script:selectedAppsToRemove = @()

$script:currentPlatform = "Windows"

$script:currentCategory = "Navegadores"

$script:currentSubcategory = $null

$script:currentView = "Instalar"

# Cargar la imagen del logo

$logoImage = $window.FindName("LogoImage")

# Logo embebido como base64 (no requiere archivo externo)
$logoB64 = "iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAIAAABuYg/PAAAFQ0lEQVR42u2Wy0+cVRTAz7n3e8zMNzMMMMNjKAxDC1JobbGtSWOltLWxVo2PLroy0Zho3bnwr9DWaOLGhQuTxmhcdVFNNDXRpgkqGISWUqSUAWaYYWBmYN7zffceF1+phUKcEtO46F3de5Nzfve87jmIiPCoFoNHuB7D1i1E2Fakle3ApCSAbWSW8pAmIWOK4jQYskoxJ4VJRNWL8+ofyBjTnYa/revD858MnDg59Od1aZaksKrnVRsz+0XCEksLc8PDw53htlIhb5bLjHH8zxMEEQFQSlFf6xsaHgqHWr/84nNUHUTAeLW8qtyIiIxxIeUTe58yvDVer6cu0HjmlZdUh/vKT1c4QwCoxplbwux7BEBEzhXLkn2H+3d192QzacPl5IrqcrmOPvtMMp0fGf5d4ZyAgMgW3Ern5jAiIiLOGCJDxh2Gtym0s2t379TEeCGXBeSqppmWxTlvDgZj8cXY/CxnjEgiopSSiDZVuxGGiEDkDzS17+pajMc4VzTd6fT4jp08NRuZyaSSBKg6nIGGBl3XfbU+znjJlNForFIuA5GwzPDOLsPtzq5kkLF/gTHGJLCB519+9czZTLZQtqipNdwW3tUcbJm8eUN3OHf39Dy5p6fW5wuFQsFgsKbGKyQyVeearunOxubWN956R3W4xsdGOOcbArnOv4wxt6emqbXj6PHnwuEOSwgpSVWVmUgkn8vGY/OaovT17Xe7dEtAvd+vKEqxWIhGo8uZrM9XZ5oVIWR7qG1ufu7KD98n5iMrK2lhWZvD7LOiqkJIVXfWBxp1h6uppa1n7/5IZObm2EhmOeE2jHw+H+7oOHjo6XxFTNz6a8/uLkA2OXFzYT6SW80AQDGfE8KUQmywbJMEEZZFUgqrnM2kcivpZCKuudwnjg/0DxwLhTtXi6bLMJaWM5rbd7R/4Fj/EcuyxsZGx0eG0sl4uZQvF/OWaZKkqrJxLXfx7g5hIRaNxxNuj6e7u9vfGLS4wx8MvXj6VGd4x8effvbt1xdzmZRVLlUqpXsKiGitdmBLN64rMrSrFQGAqbrqNHz+5tdeP4OMxxOLmqYO/TYYnb7FQBSyq8gQgaSwbJM03W1ZZZLWlpbh3c+CITLGGCACcsYV5CoyjkjFYqFkWgNHDhsux6VLl1bTS2alVC6VAEhKIuC6s97ra/HWtiiaq1LMAMnNLbNJgAwAiUhKUnUHIApARdWJcUQOXKmQ2t3bG/AHrv58TVVJ4VxVdd3h9XganZphFbPZ9PxK6k4xl0REACL5T5LcB0NEZHaoFK746uoSyWVU1Nr6QLZQ0Q2P4jDcPn93T+9kWqotO1/o6/xz/HYykYB81sylC0tzq/Fps7BslvIkBeccCACk/RltbJ42k3FuVkr79vedv3Dh4lffcFXf0dYamYseOnjg1vTs0ERE4eyj9896Ak3XfrnqtNLnTu/74N333j73ZnoZgw0HDJeTMf7d5ct/DP+qcEVKBCAEoA0xQ0RAJJKGr01z1Y6MjgwODrW0d1yfnIktrlSYazknyhXLEjA1fWfwx8tTt28npm7k0wmnQyWisdHRVCq1lEyurK4m4rHk4iIiA5CwRnogZowBUY0/rDlqhETN6UUj0NDelY7PVip5aRWYyFuVQmIhCuWiu8ZAgGw6xTVNFPOAAEQA0lbOuWr78P7es8kPIqVEBEXRCJAzVUgphUkkCewxh6maBohCCJKkcCalQEQiudZigIiklA+2ONy0qO02Y4cR16r7XoWuU2Lv8d4tAQFt3YS3MwEiAD281DYnYtqW1ONZ/zHs/wP7Gxu3gPT/EGGBAAAAAElFTkSuQmCC"
$logoBytes  = [Convert]::FromBase64String($logoB64)
$logoStream = New-Object System.IO.MemoryStream(,$logoBytes)
$logoBitmap = New-Object System.Windows.Media.Imaging.BitmapImage
$logoBitmap.BeginInit()
$logoBitmap.StreamSource = $logoStream
$logoBitmap.CacheOption  = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
$logoBitmap.EndInit()
$logoStream.Close()
$logoImage.Source = $logoBitmap

# BASE DE DATOS COMPLETA DE APLICACIONES (desde NeXus V4.7 F)

$script:appDatabase = @{

    Windows = @{

        Navegadores = @(

            # Estándar

            @{ Key = "Chrome"; Name = "Google Chrome"; ID = "Google.Chrome"; Desc = "Navegador más popular"; Icon = "🌐"; Sub = "Estándar"; Warning = $null }

            @{ Key = "Firefox"; Name = "Mozilla Firefox"; ID = "Mozilla.Firefox"; Desc = "Navegador open source"; Icon = "🦊"; Sub = "Estándar"; Warning = $null }

            @{ Key = "Edge"; Name = "Microsoft Edge"; ID = "Microsoft.Edge"; Desc = "Navegador de Microsoft"; Icon = "🌊"; Sub = "Estándar"; Warning = $null }

            # Rendimiento

            @{ Key = "Brave"; Name = "Brave Browser"; ID = "Brave.Brave"; Desc = "Bloqueadores nativos, rápido"; Icon = "🦁"; Sub = "Rendimiento"; Warning = $null }

            @{ Key = "Vivaldi"; Name = "Vivaldi"; ID = "VivaldiTechnologies.Vivaldi"; Desc = "Altamente configurable"; Icon = "🔭"; Sub = "Rendimiento"; Warning = $null }

            @{ Key = "UngoogledChromium"; Name = "Ungoogled Chromium"; ID = $null; Desc = "Mínimo y limpio"; Icon = "⚡"; Sub = "Rendimiento"; Warning = "Requiere descarga manual desde el sitio web"; URL = "https://ungoogled-software.github.io/ungoogled-chromium-binaries/" }

            @{ Key = "Thorium"; Name = "Thorium"; ID = $null; Desc = "Optimizado para rendimiento"; Icon = "🚀"; Sub = "Rendimiento"; Warning = "Requiere descarga manual desde el sitio web"; URL = "https://thorium.rocks/" }

            # Privacidad

            @{ Key = "Tor"; Name = "Tor Browser"; ID = "TorProject.TorBrowser"; Desc = "Navegación anónima"; Icon = "🧅"; Sub = "Privacidad"; Warning = $null }

            @{ Key = "LibreWolf"; Name = "LibreWolf"; ID = "LibreWolf.LibreWolf"; Desc = "Fork privado de Firefox"; Icon = "🐺"; Sub = "Privacidad"; Warning = $null }

            @{ Key = "MullvadBrowser"; Name = "Mullvad Browser"; ID = $null; Desc = "Privacidad extrema"; Icon = "🔒"; Sub = "Privacidad"; Warning = "Requiere descarga manual desde el sitio web"; URL = "https://mullvad.net/en/download/browser" }

            @{ Key = "Waterfox"; Name = "Waterfox"; ID = "Waterfox.Waterfox"; Desc = "Firefox orientado a privacidad"; Icon = "🌊"; Sub = "Privacidad"; Warning = $null }

            # Especializados

            @{ Key = "Opera"; Name = "Opera"; ID = "Opera.Opera"; Desc = "Navegador con VPN integrada"; Icon = "🔴"; Sub = "Especializado"; Warning = $null }

            @{ Key = "OperaGX"; Name = "Opera GX"; ID = "Opera.OperaGX"; Desc = "Navegador para gamers"; Icon = "🎮"; Sub = "Especializado"; Warning = $null }

            @{ Key = "PaleMoon"; Name = "Pale Moon"; ID = "MoonchildProductions.PaleMoon"; Desc = "Navegador clásico eficiente"; Icon = "🌙"; Sub = "Especializado"; Warning = $null }

        )

        Comunicacion = @(

            # Cotidiano

            @{ Key = "WhatsApp"; Name = "WhatsApp Desktop"; ID = "WhatsApp.WhatsApp"; Desc = "WhatsApp para PC"; Icon = "💚"; Sub = "Cotidiano"; Warning = $null }

            @{ Key = "Telegram"; Name = "Telegram Desktop"; ID = "Telegram.TelegramDesktop"; Desc = "Mensajería segura"; Icon = "✈️"; Sub = "Cotidiano"; Warning = $null }

            @{ Key = "Discord"; Name = "Discord"; ID = "Discord.Discord"; Desc = "Chat y comunidades"; Icon = "💬"; Sub = "Cotidiano"; Warning = $null }

            @{ Key = "Teams"; Name = "Microsoft Teams"; ID = "Microsoft.Teams"; Desc = "Colaboración empresarial"; Icon = "👥"; Sub = "Cotidiano"; Warning = $null }

            @{ Key = "Zoom"; Name = "Zoom"; ID = "Zoom.Zoom"; Desc = "Videoconferencias"; Icon = "📹"; Sub = "Cotidiano"; Warning = $null }

            # Profesional

            @{ Key = "Slack"; Name = "Slack"; ID = "SlackTechnologies.Slack"; Desc = "Comunicación equipos"; Icon = "💼"; Sub = "Profesional"; Warning = $null }

            @{ Key = "Skype"; Name = "Skype"; ID = "Microsoft.Skype"; Desc = "Videollamadas clásico"; Icon = "💙"; Sub = "Profesional"; Warning = $null }

            @{ Key = "Webex"; Name = "Cisco Webex"; ID = "Cisco.CiscoWebexMeetings"; Desc = "Videoconferencias empresarial"; Icon = "🟢"; Sub = "Profesional"; Warning = $null }

            @{ Key = "Mattermost"; Name = "Mattermost"; ID = "Mattermost.MattermostDesktop"; Desc = "Colaboración open source"; Icon = "📎"; Sub = "Profesional"; Warning = $null }

            # Privacidad

            @{ Key = "Signal"; Name = "Signal Desktop"; ID = "OpenWhisperSystems.Signal"; Desc = "Mensajería cifrada"; Icon = "🔐"; Sub = "Privacidad"; Warning = $null }

            @{ Key = "Element"; Name = "Element"; ID = "Element.Element"; Desc = "Cliente Matrix"; Icon = "🟢"; Sub = "Privacidad"; Warning = $null }

            @{ Key = "Session"; Name = "Session"; ID = "Oxen.Session"; Desc = "Mensajería anónima"; Icon = "👻"; Sub = "Privacidad"; Warning = $null }

            # Gaming

            @{ Key = "TeamSpeak"; Name = "TeamSpeak"; ID = "TeamSpeakSystems.TeamSpeakClient"; Desc = "VoIP para gaming"; Icon = "🎧"; Sub = "Gaming"; Warning = $null }

            @{ Key = "Mumble"; Name = "Mumble"; ID = "Mumble.Mumble"; Desc = "Chat de voz baja latencia"; Icon = "🎙️"; Sub = "Gaming"; Warning = $null }

        )

        Especialidad = @{

            Programacion = @(

                # Entornos web

                @{ Key = "XAMPP"; Name = "XAMPP"; ID = "ApacheFriends.Xampp"; Desc = "Servidor web local (Apache, MySQL, PHP, Perl)"; Icon = "🌱"; Warning = "Requiere privilegios de administrador. Puerto 80 puede estar en uso." }

                @{ Key = "WampServer"; Name = "WampServer"; ID = $null; Desc = "Servidor web Windows (Apache, MySQL, PHP)"; Icon = "🟢"; Warning = "Desactiva Skype/IIS antes de instalar (usan puerto 80)"; URL = "https://www.wampserver.com/" }

                @{ Key = "Laragon"; Name = "Laragon"; ID = "LeNguyenQuang.Laragon"; Desc = "Entorno de desarrollo web portable"; Icon = "🚀"; Warning = "Incluye múltiples versiones de PHP, Node.js y bases de datos" }

                # IDEs Java

                @{ Key = "NetBeans"; Name = "Apache NetBeans"; ID = "Apache.NetBeans"; Desc = "IDE para Java, PHP, C++"; Icon = "☕"; Warning = "Requiere Java JDK previamente instalado" }

                @{ Key = "IntelliJIDEA"; Name = "IntelliJ IDEA Community"; ID = "JetBrains.IntelliJIDEA.Community"; Desc = "IDE profesional para Java/Kotlin"; Icon = "💡"; Warning = "Versión Community gratuita. Ultimate es de pago" }

                @{ Key = "Eclipse"; Name = "Eclipse IDE"; ID = "EclipseFoundation.EclipseIDE.Java"; Desc = "IDE clásico para Java"; Icon = "🌙"; Warning = $null }

                # Bases de datos

                @{ Key = "MySQLWorkbench"; Name = "MySQL Workbench"; ID = "Oracle.MySQLWorkbench"; Desc = "Diseño y administración MySQL"; Icon = "🐬"; Warning = $null }

                @{ Key = "DBeaver"; Name = "DBeaver Community"; ID = "DBeaver.DBeaver.Community"; Desc = "Cliente universal de bases de datos"; Icon = "🦫"; Warning = $null }

                @{ Key = "PostgreSQL"; Name = "PostgreSQL"; ID = "PostgreSQL.PostgreSQL"; Desc = "Sistema de base de datos relacional"; Icon = "🐘"; Warning = "Requiere configuración post-instalación" }

                @{ Key = "MongoDBCompass"; Name = "MongoDB Compass"; ID = "MongoDB.Compass.Community"; Desc = "GUI para MongoDB"; Icon = "🍃"; Warning = $null }

                # Herramientas adicionales

                @{ Key = "Insomnia"; Name = "Insomnia"; ID = "Insomnia.Insomnia"; Desc = "Cliente REST API (alternativa a Postman)"; Icon = "😴"; Warning = $null }

                @{ Key = "TablePlus"; Name = "TablePlus"; ID = "TablePlus.TablePlus"; Desc = "Editor de bases de datos moderno"; Icon = "➕"; Warning = "Versión gratuita con limitaciones" }

                @{ Key = "FileZilla"; Name = "FileZilla Client"; ID = "TimKosse.FileZilla.Client"; Desc = "Cliente FTP/SFTP"; Icon = "📂"; Warning = $null }

                @{ Key = "Wireshark"; Name = "Wireshark"; ID = "WiresharkFoundation.Wireshark"; Desc = "Analizador de protocolos de red"; Icon = "🦈"; Warning = "Requiere Npcap para captura de paquetes" }

                # Editores adicionales

                @{ Key = "Atom"; Name = "Atom"; ID = "GitHub.Atom"; Desc = "Editor de texto hackable (descontinuado pero funcional)"; Icon = "⚛️"; Warning = "Proyecto archivado, pero aún funcional" }

                @{ Key = "Brackets"; Name = "Brackets"; ID = "Adobe.Brackets"; Desc = "Editor web moderno (descontinuado)"; Icon = "{}"; Warning = "Adobe dejó de mantenerlo, usar con precaución" }

                # Lenguajes adicionales

                @{ Key = "JavaJDK"; Name = "Oracle Java SE Development Kit"; ID = "Oracle.JDK.17"; Desc = "Kit de desarrollo Java"; Icon = "☕"; Warning = "Requiere aceptar licencia Oracle" }

                @{ Key = "OpenJDK"; Name = "Eclipse Adoptium OpenJDK"; ID = "EclipseAdoptium.Temurin.17.JDK"; Desc = "OpenJDK gratuito (alternativa a Oracle)"; Icon = "☕"; Warning = $null }

                @{ Key = "Ruby"; Name = "Ruby"; ID = "RubyInstallerTeam.RubyWithDevKit"; Desc = "Lenguaje de programación Ruby"; Icon = "💎"; Warning = $null }

                @{ Key = "Go"; Name = "Go"; ID = "GoLang.Go"; Desc = "Lenguaje de programación Go"; Icon = "🐹"; Warning = $null }

                @{ Key = "Rust"; Name = "Rust"; ID = "Rustlang.Rust.MSVC"; Desc = "Lenguaje de programación Rust"; Icon = "🦀"; Warning = $null }

                @{ Key = "PHP"; Name = "PHP"; ID = "PHP.PHP.8.1"; Desc = "Lenguaje de programación PHP"; Icon = "🐘"; Warning = $null }

                # Frameworks y herramientas web

                @{ Key = "NodeJS"; Name = "Node.js LTS"; ID = "OpenJS.NodeJS.LTS"; Desc = "JavaScript runtime environment"; Icon = "🟢"; Warning = "Incluye npm. Requiere reinicio de terminal" }

                @{ Key = "Yarn"; Name = "Yarn"; ID = "Yarn.Yarn"; Desc = "Gestor de paquetes alternativo a npm"; Icon = "🧶"; Warning = $null }

                @{ Key = "Python"; Name = "Python 3.11"; ID = "Python.Python.3.11"; Desc = "Lenguaje de programación Python"; Icon = "🐍"; Warning = "Marca 'Add to PATH' durante instalación" }

                @{ Key = "Anaconda"; Name = "Anaconda3"; ID = "Anaconda.Anaconda3"; Desc = "Distribución Python para ciencia de datos"; Icon = "🐍"; Warning = "Incluye Jupyter, Spyder, y 1,500+ paquetes" }

                # Control de versiones

                @{ Key = "Git"; Name = "Git"; ID = "Git.Git"; Desc = "Sistema de control de versiones"; Icon = "🌳"; Warning = $null }

                @{ Key = "GitHubDesktop"; Name = "GitHub Desktop"; ID = "GitHub.GitHubDesktop"; Desc = "Cliente gráfico para GitHub"; Icon = "🐙"; Warning = $null }

                @{ Key = "GitKraken"; Name = "GitKraken"; ID = "Axosoft.GitKraken"; Desc = "Cliente Git profesional"; Icon = "🦑"; Warning = "Versión gratuita para repositorios públicos" }

                @{ Key = "SourceTree"; Name = "SourceTree"; ID = "Atlassian.SourceTree"; Desc = "Cliente Git gratuito de Atlassian"; Icon = "🌲"; Warning = $null }

                # Contenedores y virtualización

                @{ Key = "DockerDesktop"; Name = "Docker Desktop"; ID = "Docker.DockerDesktop"; Desc = "Plataforma de contenedores"; Icon = "🐳"; Warning = "Requiere WSL2 en Windows. Reinicio necesario" }

                @{ Key = "Kubernetes"; Name = "kubectl"; ID = "Kubernetes.kubectl"; Desc = "CLI para Kubernetes"; Icon = "☸️"; Warning = $null }

                @{ Key = "Helm"; Name = "Helm"; ID = "Helm.Helm"; Desc = "Gestor de paquetes para Kubernetes"; Icon = "⛵"; Warning = $null }

                @{ Key = "Vagrant"; Name = "Vagrant"; ID = "HashiCorp.Vagrant"; Desc = "Gestión de máquinas virtuales"; Icon = "📦"; Warning = $null }

                # Editores principales

                @{ Key = "VSCode"; Name = "Visual Studio Code"; ID = "Microsoft.VisualStudioCode"; Desc = "Editor de código más popular"; Icon = "💻"; Warning = $null }

                @{ Key = "VisualStudio"; Name = "Visual Studio 2022 Community"; ID = "Microsoft.VisualStudio.2022.Community"; Desc = "IDE completo para Windows/.NET"; Icon = "🅰️"; Warning = "Descarga grande (~3GB). Instalación prolongada" }

                @{ Key = "VSCodeInsiders"; Name = "Visual Studio Code Insiders"; ID = "Microsoft.VisualStudioCode.Insiders"; Desc = "Versión preview de VS Code"; Icon = "💻"; Warning = "Versión inestable con características experimentales" }

                @{ Key = "JetBrainsToolbox"; Name = "JetBrains Toolbox"; ID = "JetBrains.Toolbox"; Desc = "Gestor de IDEs JetBrains"; Icon = "🧰"; Warning = $null }

                @{ Key = "SublimeText"; Name = "Sublime Text 4"; ID = "SublimeHQ.SublimeText.4"; Desc = "Editor de texto rápido y ligero"; Icon = "✨"; Warning = "Gratuito para evaluación. Licencia recomendada" }

                @{ Key = "NotepadPlusPlus"; Name = "Notepad++"; ID = "Notepad++.Notepad++"; Desc = "Editor de código mejorado"; Icon = "📝"; Warning = $null }

                # Herramientas de terminal

                @{ Key = "WindowsTerminal"; Name = "Windows Terminal"; ID = "Microsoft.WindowsTerminal"; Desc = "Terminal moderna para Windows"; Icon = "🖥️"; Warning = $null }

                @{ Key = "PowerShell7"; Name = "PowerShell 7"; ID = "Microsoft.PowerShell"; Desc = "PowerShell multiplataforma"; Icon = "⚡"; Warning = $null }

                @{ Key = "PuTTY"; Name = "PuTTY"; ID = "PuTTY.PuTTY"; Desc = "Cliente SSH/Telnet"; Icon = "🖥️"; Warning = $null }

                @{ Key = "WinSCP"; Name = "WinSCP"; ID = "WinSCP.WinSCP"; Desc = "Cliente SFTP/SCP"; Icon = "📋"; Warning = $null }

                # Utilidades de desarrollo

                @{ Key = "Postman"; Name = "Postman"; ID = "Postman.Postman"; Desc = "Plataforma de API"; Icon = "🚀"; Warning = $null }

                @{ Key = "WinMerge"; Name = "WinMerge"; ID = "WinMerge.WinMerge"; Desc = "Comparación y fusión de archivos"; Icon = "⚖️"; Warning = $null }

                @{ Key = "ProcessMonitor"; Name = "Process Monitor"; ID = "Microsoft.Sysinternals.ProcessMonitor"; Desc = "Monitor de sistema avanzado"; Icon = "🔍"; Warning = $null }

                @{ Key = "ProcessExplorer"; Name = "Process Explorer"; ID = "Microsoft.Sysinternals.ProcessExplorer"; Desc = "Gestor de tareas avanzado"; Icon = "🔍"; Warning = $null }

            )

            Animacion = @(

                # Animación 2D

                @{ Key = "ToonBoomHarmony"; Name = "Toon Boom Harmony"; ID = $null; Desc = "Animación 2D profesional"; Icon = "🎨"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.toonboom.com/products/harmony" }

                @{ Key = "TVPaint"; Name = "TVPaint Animation"; ID = $null; Desc = "Animación 2D raster"; Icon = "🖌️"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.tvpaint.com/" }

                @{ Key = "AdobeAnimate"; Name = "Adobe Animate"; ID = $null; Desc = "Animación multimedia"; Icon = "🎭"; Warning = "Requiere suscripción Adobe Creative Cloud"; URL = "https://www.adobe.com/products/animate.html" }

                @{ Key = "ClipStudioPaint"; Name = "Clip Studio Paint"; ID = $null; Desc = "Ilustración y animación"; Icon = "✒️"; Warning = "Software de pago con prueba gratuita"; URL = "https://www.clipstudio.net/" }

                @{ Key = "OpenToonz"; Name = "OpenToonz"; ID = "OpenToonz.OpenToonz"; Desc = "Animación 2D open source"; Icon = "🎬"; Warning = $null }

                @{ Key = "Pencil2D"; Name = "Pencil2D"; ID = "Pencil2D.Pencil2D"; Desc = "Animación 2D"; Icon = "✏️"; Warning = $null }

                # Animación 3D

                @{ Key = "Maya"; Name = "Autodesk Maya"; ID = $null; Desc = "Animación 3D profesional"; Icon = "🏗️"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.autodesk.com/products/maya/overview" }

                @{ Key = "Blender"; Name = "Blender"; ID = "BlenderFoundation.Blender"; Desc = "3D completo y gratuito"; Icon = "🟠"; Warning = $null }

                @{ Key = "Max3ds"; Name = "3ds Max"; ID = $null; Desc = "Modelado y animación 3D"; Icon = "🔷"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.autodesk.com/products/3ds-max/overview" }

                @{ Key = "Cinema4D"; Name = "Cinema 4D"; ID = $null; Desc = "Motion graphics 3D"; Icon = "🔵"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.maxon.net/cinema-4d" }

                @{ Key = "Houdini"; Name = "Houdini"; ID = $null; Desc = "FX y simulaciones 3D"; Icon = "🎩"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.sidefx.com/products/houdini/" }

                # Modelado y escultura

                @{ Key = "ZBrush"; Name = "ZBrush"; ID = $null; Desc = "Escultura digital"; Icon = "🗿"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://pixologic.com/zbrush/" }

                @{ Key = "Mudbox"; Name = "Mudbox"; ID = $null; Desc = "Escultura 3D Autodesk"; Icon = "🔶"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.autodesk.com/products/mudbox/overview" }

                # Texturizado

                @{ Key = "SubstancePainter"; Name = "Substance Painter"; ID = $null; Desc = "Texturizado 3D"; Icon = "🎨"; Warning = "Requiere suscripción Adobe"; URL = "https://www.adobe.com/products/substance3d-painter.html" }

                @{ Key = "SubstanceDesigner"; Name = "Substance Designer"; ID = $null; Desc = "Creación de materiales"; Icon = "🧪"; Warning = "Requiere suscripción Adobe"; URL = "https://www.adobe.com/products/substance3d-designer.html" }

                @{ Key = "QuixelMixer"; Name = "Quixel Mixer"; ID = $null; Desc = "Texturizado gratuito"; Icon = "🖼️"; Warning = "Requiere cuenta Epic Games"; URL = "https://quixel.com/mixer" }

                @{ Key = "ArmorPaint"; Name = "ArmorPaint"; ID = $null; Desc = "Texturizado open source"; Icon = "🛡️"; Warning = "Requiere descarga manual"; URL = "https://armorpaint.org/" }

                # Motores y render

                @{ Key = "UnrealEngine"; Name = "Unreal Engine"; ID = $null; Desc = "Motor gráfico AAA"; Icon = "🔺"; Warning = "Gratuito con regalías después de cierto umbral"; URL = "https://www.unrealengine.com/" }

                @{ Key = "Unity"; Name = "Unity"; ID = $null; Desc = "Motor multiplataforma"; Icon = "⬜"; Warning = "Gratuito con regalías después de cierto umbral"; URL = "https://unity.com/" }

                @{ Key = "Godot"; Name = "Godot"; ID = "GodotEngine.GodotEngine"; Desc = "Motor open source"; Icon = "🤖"; Warning = $null }

                @{ Key = "MarmosetToolbag"; Name = "Marmoset Toolbag"; ID = $null; Desc = "Render y baking"; Icon = "🟫"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://marmoset.co/toolbag/" }

                # Storyboard y preproducción

                @{ Key = "StoryboardPro"; Name = "Storyboard Pro"; ID = $null; Desc = "Storyboard profesional"; Icon = "📋"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.toonboom.com/products/storyboard-pro" }

                @{ Key = "Photoshop"; Name = "Adobe Photoshop"; ID = $null; Desc = "Edición de imágenes"; Icon = "🖼️"; Warning = "Requiere suscripción Adobe"; URL = "https://www.adobe.com/products/photoshop.html" }

                @{ Key = "Krita"; Name = "Krita"; ID = "KDE.Krita"; Desc = "Pintura digital"; Icon = "🎨"; Warning = $null }

                @{ Key = "GIMP"; Name = "GIMP"; ID = "GIMP.GIMP"; Desc = "Edición de imágenes"; Icon = "🦓"; Warning = $null }

                # Postproducción

                @{ Key = "AfterEffects"; Name = "After Effects"; ID = $null; Desc = "Motion graphics"; Icon = "🎬"; Warning = "Requiere suscripción Adobe"; URL = "https://www.adobe.com/products/aftereffects.html" }

                @{ Key = "PremierePro"; Name = "Premiere Pro"; ID = $null; Desc = "Edición de video"; Icon = "🎞️"; Warning = "Requiere suscripción Adobe"; URL = "https://www.adobe.com/products/premiere.html" }

                @{ Key = "DaVinciResolve"; Name = "DaVinci Resolve"; ID = "BlackmagicDesign.DaVinciResolve"; Desc = "Edición video profesional"; Icon = "🎥"; Warning = $null }

                @{ Key = "Nuke"; Name = "Nuke"; ID = $null; Desc = "Compositing profesional"; Icon = "☢️"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.foundry.com/products/nuke" }

                @{ Key = "Fusion"; Name = "Fusion"; ID = $null; Desc = "Compositing y motion graphics"; Icon = "⚛️"; Warning = "Versión gratuita disponible en DaVinci Resolve"; URL = "https://www.blackmagicdesign.com/products/fusion" }

                @{ Key = "OBSStudio"; Name = "OBS Studio"; ID = "OBSProject.OBSStudio"; Desc = "Streaming/Grabación"; Icon = "📺"; Warning = $null }

                # Audio

                @{ Key = "Audition"; Name = "Adobe Audition"; ID = $null; Desc = "Edición de audio profesional"; Icon = "🎙️"; Warning = "Requiere suscripción Adobe"; URL = "https://www.adobe.com/products/audition.html" }

                @{ Key = "Reaper"; Name = "Reaper"; ID = $null; Desc = "DAW profesional"; Icon = "🚜"; Warning = "Software de pago con prueba gratuita extendida"; URL = "https://www.reaper.fm/" }

                @{ Key = "Audacity"; Name = "Audacity"; ID = "Audacity.Audacity"; Desc = "Edición de audio"; Icon = "🎙️"; Warning = $null }

                @{ Key = "FMOD"; Name = "FMOD"; ID = $null; Desc = "Audio middleware"; Icon = "🔊"; Warning = "Gratuito para uso no comercial"; URL = "https://www.fmod.com/" }

                @{ Key = "Wwise"; Name = "Wwise"; ID = $null; Desc = "Audio interactivo"; Icon = "🎵"; Warning = "Gratuito para uso no comercial"; URL = "https://www.audiokinetic.com/products/wwise/" }

            )

            Mecatronica = @(

                # Programación y control

                @{ Key = "MATLAB"; Name = "MATLAB"; ID = $null; Desc = "Computación técnica"; Icon = "📊"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.mathworks.com/products/matlab.html" }

                @{ Key = "Simulink"; Name = "Simulink"; ID = $null; Desc = "Simulación multidominio"; Icon = "📈"; Warning = "Requiere MATLAB"; URL = "https://www.mathworks.com/products/simulink.html" }

                @{ Key = "LabVIEW"; Name = "LabVIEW"; ID = $null; Desc = "Programación gráfica"; Icon = "🔬"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.ni.com/labview" }

                @{ Key = "Python"; Name = "Python 3.11"; ID = "Python.Python.3.11"; Desc = "Lenguaje de programación"; Icon = "🐍"; Warning = $null }

                @{ Key = "GCC"; Name = "MinGW-w64"; ID = "MinGW.MinGW"; Desc = "Compilador C/C++"; Icon = "⚙️"; Warning = $null }

                # Microcontroladores

                @{ Key = "ArduinoIDE"; Name = "Arduino IDE"; ID = "ArduinoSA.IDE.stable"; Desc = "Programación Arduino"; Icon = "🤖"; Warning = $null }

                @{ Key = "PlatformIO"; Name = "PlatformIO IDE"; ID = "PlatformIO.PlatformIO"; Desc = "IoT desarrollo"; Icon = "📟"; Warning = $null }

                @{ Key = "MPLABX"; Name = "MPLAB X IDE"; ID = $null; Desc = "Desarrollo Microchip"; Icon = "🔷"; Warning = "Software gratuito con registro"; URL = "https://www.microchip.com/mplab/mplab-x-ide" }

                @{ Key = "STM32CubeIDE"; Name = "STM32CubeIDE"; ID = $null; Desc = "Desarrollo STM32"; Icon = "⚡"; Warning = "Requiere registro ST"; URL = "https://www.st.com/en/development-tools/stm32cubeide.html" }

                @{ Key = "KeilUVision"; Name = "Keil µVision"; ID = $null; Desc = "IDE ARM"; Icon = "🔧"; Warning = "Versión gratuita con limitaciones"; URL = "https://www2.keil.com/mdk5/uvision/" }

                # PLC

                @{ Key = "TIAPortal"; Name = "TIA Portal"; ID = $null; Desc = "Programación Siemens"; Icon = "🟡"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.siemens.com/tia-portal" }

                @{ Key = "Studio5000"; Name = "Studio 5000"; ID = $null; Desc = "Programación Allen-Bradley"; Icon = "🔴"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.rockwellautomation.com/products/software/design/studio-5000.html" }

                @{ Key = "CODESYS"; Name = "CODESYS"; ID = $null; Desc = "Desarrollo IEC 61131-3"; Icon = "📋"; Warning = "Gratuito para uso personal"; URL = "https://www.codesys.com/" }

                # Diseño electrónico

                @{ Key = "Proteus"; Name = "Proteus"; ID = $null; Desc = "Simulación electrónica"; Icon = "⚡"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.labcenter.com/" }

                @{ Key = "Multisim"; Name = "Multisim"; ID = $null; Desc = "Diseño de circuitos"; Icon = "🔌"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.ni.com/multisim" }

                @{ Key = "KiCad"; Name = "KiCad"; ID = "KiCad.KiCad"; Desc = "Diseño PCB open source"; Icon = "⚡"; Warning = $null }

                @{ Key = "AltiumDesigner"; Name = "Altium Designer"; ID = $null; Desc = "Diseño PCB profesional"; Icon = "🟦"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.altium.com/altium-designer" }

                @{ Key = "Eagle"; Name = "Autodesk Eagle"; ID = $null; Desc = "Diseño PCB Autodesk"; Icon = "🦅"; Warning = "Requiere suscripción Autodesk"; URL = "https://www.autodesk.com/products/eagle/overview" }

                @{ Key = "Fritzing"; Name = "Fritzing"; ID = "Fritzing.Fritzing"; Desc = "Diseño circuitos"; Icon = "🔌"; Warning = $null }

                # Diseño mecánico (CAD)

                @{ Key = "SolidWorks"; Name = "SolidWorks"; ID = $null; Desc = "CAD profesional"; Icon = "🔷"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.solidworks.com/" }

                @{ Key = "Inventor"; Name = "Autodesk Inventor"; ID = $null; Desc = "Diseño mecánico 3D"; Icon = "🔧"; Warning = "Requiere suscripción Autodesk"; URL = "https://www.autodesk.com/products/inventor/overview" }

                @{ Key = "Fusion360"; Name = "Autodesk Fusion 360"; ID = "Autodesk.Fusion360"; Desc = "CAD/CAM/CAE"; Icon = "🔩"; Warning = "Gratuito para uso personal/educativo" }

                @{ Key = "CATIA"; Name = "CATIA"; ID = $null; Desc = "Diseño industrial"; Icon = "✈️"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.3ds.com/products-services/catia/" }

                @{ Key = "FreeCAD"; Name = "FreeCAD"; ID = "FreeCAD.FreeCAD"; Desc = "CAD paramétrico open source"; Icon = "🔧"; Warning = $null }

                @{ Key = "LibreCAD"; Name = "LibreCAD"; ID = "LibreCAD.LibreCAD"; Desc = "CAD 2D open source"; Icon = "📐"; Warning = $null }

                # Simulación y análisis

                @{ Key = "ANSYS"; Name = "ANSYS"; ID = $null; Desc = "Simulación de ingeniería"; Icon = "🔬"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.ansys.com/" }

                @{ Key = "COMSOL"; Name = "COMSOL Multiphysics"; ID = $null; Desc = "Simulación multiphysics"; Icon = "🔮"; Warning = "Software de pago. Se abrirá página oficial"; URL = "https://www.comsol.com/" }

                @{ Key = "LTspice"; Name = "LTspice"; ID = $null; Desc = "Simulación de circuitos"; Icon = "📉"; Warning = "Gratuito de Analog Devices"; URL = "https://www.analog.com/en/design-center/design-tools-and-calculators/ltspice-simulator.html" }

                @{ Key = "Scilab"; Name = "Scilab"; ID = "Scilab.Scilab"; Desc = "Computación numérica"; Icon = "📊"; Warning = $null }

                # Robótica

                @{ Key = "ROS"; Name = "ROS 2"; ID = $null; Desc = "Sistema operativo robótico"; Icon = "🤖"; Warning = "Requiere instalación manual desde terminal"; URL = "https://docs.ros.org/en/humble/Installation.html" }

                @{ Key = "Gazebo"; Name = "Gazebo"; ID = $null; Desc = "Simulación robótica"; Icon = "🟫"; Warning = "Requiere instalación manual"; URL = "https://gazebosim.org/" }

                @{ Key = "Webots"; Name = "Webots"; ID = "Cyberbotics.Webots"; Desc = "Simulación robótica"; Icon = "🕸️"; Warning = $null }

                @{ Key = "RoboDK"; Name = "RoboDK"; ID = $null; Desc = "Simulación y programación"; Icon = "🦾"; Warning = "Versión gratuita con limitaciones"; URL = "https://robodk.com/" }

                # Impresión 3D

                @{ Key = "UltimakerCura"; Name = "Ultimaker Cura"; ID = "Ultimaker.Cura"; Desc = "Slicing impresión 3D"; Icon = "🖨️"; Warning = $null }

                @{ Key = "PrusaSlicer"; Name = "PrusaSlicer"; ID = "Prusa3D.PrusaSlicer"; Desc = "Slicing Prusa"; Icon = "🔪"; Warning = $null }

                @{ Key = "QElectroTech"; Name = "QElectroTech"; ID = "QElectroTech.QElectroTech"; Desc = "Esquemas eléctricos"; Icon = "⚡"; Warning = $null }

            )

        }

        Extras = @(

            # Compresión

            @{ Key = "WinRAR"; Name = "WinRAR"; ID = "RARLab.WinRAR"; Desc = "Compresión archivos"; Icon = "📦"; Warning = $null }

            @{ Key = "SevenZip"; Name = "7-Zip"; ID = "7zip.7zip"; Desc = "Compresión open source"; Icon = "🗜️"; Warning = $null }

            @{ Key = "PeaZip"; Name = "PeaZip"; ID = "Giorgiotani.Peazip"; Desc = "Compresión alternativa"; Icon = "🫛"; Warning = $null }

            # Búsqueda y utilidades

            @{ Key = "Everything"; Name = "Everything"; ID = "voidtools.Everything"; Desc = "Búsqueda instantánea"; Icon = "🔍"; Warning = $null }

            @{ Key = "PowerToys"; Name = "Microsoft PowerToys"; ID = "Microsoft.PowerToys"; Desc = "Utilidades avanzadas"; Icon = "⚡"; Warning = $null }

            @{ Key = "ShareX"; Name = "ShareX"; ID = "ShareX.ShareX"; Desc = "Captura pantalla"; Icon = "📸"; Warning = $null }

            @{ Key = "Greenshot"; Name = "Greenshot"; ID = "Greenshot.Greenshot"; Desc = "Captura de pantalla"; Icon = "📷"; Warning = $null }

            # Multimedia

            @{ Key = "VLC"; Name = "VLC Media Player"; ID = "VideoLAN.VLC"; Desc = "Reproductor universal"; Icon = "🟠"; Warning = $null }

            @{ Key = "MPC"; Name = "MPC-HC"; ID = "clsid2.mpc-hc"; Desc = "Reproductor ligero"; Icon = "🎬"; Warning = $null }

            @{ Key = "Spotify"; Name = "Spotify"; ID = "Spotify.Spotify"; Desc = "Música streaming"; Icon = "🎧"; Warning = $null }

            @{ Key = "foobar2000"; Name = "foobar2000"; ID = "PeterPawlowski.foobar2000"; Desc = "Reproductor audio avanzado"; Icon = "🎶"; Warning = $null }

            # Gaming

            @{ Key = "Steam"; Name = "Steam"; ID = "Valve.Steam"; Desc = "Plataforma juegos"; Icon = "🎮"; Warning = $null }

            @{ Key = "EpicGames"; Name = "Epic Games Launcher"; ID = "EpicGames.EpicGamesLauncher"; Desc = "Tienda Epic Games"; Icon = "🎯"; Warning = $null }

            @{ Key = "GOG"; Name = "GOG Galaxy"; ID = "GOG.Galaxy"; Desc = "Cliente GOG"; Icon = "👾"; Warning = $null }

            # Hardware y diagnóstico

            @{ Key = "CPUZ"; Name = "CPU-Z"; ID = "CPUID.CPU-Z"; Desc = "Información hardware"; Icon = "💻"; Warning = $null }

            @{ Key = "HWiNFO"; Name = "HWiNFO"; ID = "REALiX.HWiNFO"; Desc = "Monitoreo hardware"; Icon = "🌡️"; Warning = $null }

            @{ Key = "GPUZ"; Name = "GPU-Z"; ID = "TechPowerUp.GPU-Z"; Desc = "Info tarjeta gráfica"; Icon = "🎮"; Warning = $null }

            @{ Key = "CrystalDiskInfo"; Name = "CrystalDiskInfo"; ID = "CrystalDewWorld.CrystalDiskInfo"; Desc = "Salud discos"; Icon = "💿"; Warning = $null }

            @{ Key = "CrystalDiskMark"; Name = "CrystalDiskMark"; ID = "CrystalDewWorld.CrystalDiskMark"; Desc = "Benchmark discos"; Icon = "📊"; Warning = $null }

            # MSI Afterburner - NUEVO

            @{ Key = "MSIAfterburner"; Name = "MSI Afterburner"; ID = $null; Desc = "Overclocking y monitoreo GPU"; Icon = "🐉"; Warning = "Requiere descarga manual desde el sitio web"; URL = "https://www.msi.com/Landing/afterburner/graphics-cards" }

            # Herramientas de sistema

            @{ Key = "Rufus"; Name = "Rufus"; ID = "Rufus.Rufus"; Desc = "Crear USB booteable"; Icon = "💾"; Warning = $null }

            @{ Key = "BalenaEtcher"; Name = "balenaEtcher"; ID = "balenaEtcher"; Desc = "Flashear imágenes ISO"; Icon = "🔥"; Warning = $null }

            @{ Key = "Ventoy"; Name = "Ventoy"; ID = "Ventoy.Ventoy"; Desc = "USB multiboot"; Icon = "🔌"; Warning = $null }

            # Oficina

            @{ Key = "LibreOffice"; Name = "LibreOffice"; ID = "TheDocumentFoundation.LibreOffice"; Desc = "Suite ofimática"; Icon = "📄"; Warning = $null }

            @{ Key = "Notion"; Name = "Notion"; ID = "Notion.Notion"; Desc = "Notas y productividad"; Icon = "📓"; Warning = $null }

            @{ Key = "Obsidian"; Name = "Obsidian"; ID = "Obsidian.Obsidian"; Desc = "Notas en Markdown"; Icon = "🪨"; Warning = $null }

            # Seguridad

            @{ Key = "Bitwarden"; Name = "Bitwarden"; ID = "Bitwarden.Bitwarden"; Desc = "Gestor de contraseñas"; Icon = "🔐"; Warning = $null }

            @{ Key = "KeePass"; Name = "KeePass"; ID = "DominikReichl.KeePass"; Desc = "Password manager local"; Icon = "🗝️"; Warning = $null }

            # Desarrollo adicional

            @{ Key = "GitKraken"; Name = "GitKraken"; ID = "Axosoft.GitKraken"; Desc = "Cliente Git GUI"; Icon = "🦑"; Warning = "Versión gratuita para repositorios públicos" }

            @{ Key = "SourceTree"; Name = "SourceTree"; ID = "Atlassian.SourceTree"; Desc = "Cliente Git GUI"; Icon = "🌲"; Warning = $null }

            @{ Key = "FileZilla"; Name = "FileZilla"; ID = "TimKosse.FileZilla.Client"; Desc = "Cliente FTP"; Icon = "📂"; Warning = $null }

            # Virtualización

            @{ Key = "VirtualBox"; Name = "VirtualBox"; ID = "Oracle.VirtualBox"; Desc = "Virtualización"; Icon = "🖥️"; Warning = $null }

            @{ Key = "VMwarePlayer"; Name = "VMware Workstation Player"; ID = "VMware.WorkstationPlayer"; Desc = "Virtualización"; Icon = "💻"; Warning = "Gratuito para uso no comercial" }

        )

    }

    Linux = @{

        Navegadores = @(

            @{ Key = "Chrome"; Name = "Google Chrome"; Cmd = "wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo dpkg -i google-chrome-stable_current_amd64.deb"; Icon = "🌐" }

            @{ Key = "Firefox"; Name = "Firefox"; Cmd = "sudo apt install firefox -y"; Icon = "🦊" }

            @{ Key = "Chromium"; Name = "Chromium"; Cmd = "sudo apt install chromium-browser -y"; Icon = "🔷" }

            @{ Key = "Brave"; Name = "Brave"; Cmd = "snap install brave"; Icon = "🦁" }

            @{ Key = "Tor"; Name = "Tor Browser"; Cmd = "sudo apt install torbrowser-launcher -y"; Icon = "🧅" }

        )

        Comunicacion = @(

            @{ Key = "Discord"; Name = "Discord"; Cmd = "snap install discord"; Icon = "💬" }

            @{ Key = "Telegram"; Name = "Telegram"; Cmd = "snap install telegram-desktop"; Icon = "✈️" }

            @{ Key = "Teams"; Name = "Microsoft Teams"; Cmd = "snap install teams"; Icon = "👥" }

            @{ Key = "Zoom"; Name = "Zoom"; Cmd = "snap install zoom-client"; Icon = "📹" }

            @{ Key = "Slack"; Name = "Slack"; Cmd = "snap install slack"; Icon = "💼" }

            @{ Key = "Signal"; Name = "Signal"; Cmd = "snap install signal-desktop"; Icon = "🔐" }

        )

        Especialidad = @{

            Programacion = @(

                @{ Key = "VSCode"; Name = "VS Code"; Cmd = "snap install code --classic"; Icon = "💻" }

                @{ Key = "Git"; Name = "Git"; Cmd = "sudo apt install git -y"; Icon = "🌳" }

                @{ Key = "Python"; Name = "Python3"; Cmd = "sudo apt install python3 python3-pip -y"; Icon = "🐍" }

                @{ Key = "NodeJS"; Name = "Node.js"; Cmd = "curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt install -y nodejs"; Icon = "🟢" }

                @{ Key = "Docker"; Name = "Docker"; Cmd = "sudo apt install docker.io -y && sudo usermod -aG docker $USER"; Icon = "🐳" }

            )

            Animacion = @(

                @{ Key = "Blender"; Name = "Blender"; Cmd = "snap install blender --classic"; Icon = "🟠" }

                @{ Key = "GIMP"; Name = "GIMP"; Cmd = "sudo apt install gimp -y"; Icon = "🦓" }

                @{ Key = "Inkscape"; Name = "Inkscape"; Cmd = "sudo apt install inkscape -y"; Icon = "🎨" }

                @{ Key = "Krita"; Name = "Krita"; Cmd = "sudo apt install krita -y"; Icon = "🎨" }

                @{ Key = "OBS"; Name = "OBS Studio"; Cmd = "sudo apt install obs-studio -y"; Icon = "📺" }

                @{ Key = "Audacity"; Name = "Audacity"; Cmd = "sudo apt install audacity -y"; Icon = "🎙️" }

            )

            Mecatronica = @(

                @{ Key = "FreeCAD"; Name = "FreeCAD"; Cmd = "sudo apt install freecad -y"; Icon = "🔧" }

                @{ Key = "KiCad"; Name = "KiCad"; Cmd = "sudo apt install kicad -y"; Icon = "⚡" }

                @{ Key = "Arduino"; Name = "Arduino IDE"; Cmd = "sudo apt install arduino -y"; Icon = "🤖" }

                @{ Key = "Cura"; Name = "Ultimaker Cura"; Cmd = "snap install cura-slicer"; Icon = "🖨️" }

                @{ Key = "OpenSCAD"; Name = "OpenSCAD"; Cmd = "sudo apt install openscad -y"; Icon = "🔩" }

            )

        }

        Extras = @(

            @{ Key = "VLC"; Name = "VLC Media Player"; Cmd = "sudo apt install vlc -y"; Icon = "🟠" }

            @{ Key = "Spotify"; Name = "Spotify"; Cmd = "snap install spotify"; Icon = "🎧" }

            @{ Key = "Steam"; Name = "Steam"; Cmd = "sudo apt install steam-installer -y"; Icon = "🎮" }

        )

    }

    macOS = @{

        Navegadores = @(

            @{ Key = "Chrome"; Name = "Google Chrome"; Cmd = "brew install --cask google-chrome"; Icon = "🌐" }

            @{ Key = "Firefox"; Name = "Firefox"; Cmd = "brew install --cask firefox"; Icon = "🦊" }

            @{ Key = "Edge"; Name = "Microsoft Edge"; Cmd = "brew install --cask microsoft-edge"; Icon = "🌊" }

            @{ Key = "Brave"; Name = "Brave"; Cmd = "brew install --cask brave-browser"; Icon = "🦁" }

        )

        Comunicacion = @(

            @{ Key = "Discord"; Name = "Discord"; Cmd = "brew install --cask discord"; Icon = "💬" }

            @{ Key = "Telegram"; Name = "Telegram"; Cmd = "brew install --cask telegram-desktop"; Icon = "✈️" }

            @{ Key = "WhatsApp"; Name = "WhatsApp"; Cmd = "brew install --cask whatsapp"; Icon = "💚" }

            @{ Key = "Teams"; Name = "Microsoft Teams"; Cmd = "brew install --cask microsoft-teams"; Icon = "👥" }

            @{ Key = "Zoom"; Name = "Zoom"; Cmd = "brew install --cask zoom"; Icon = "📹" }

            @{ Key = "Slack"; Name = "Slack"; Cmd = "brew install --cask slack"; Icon = "💼" }

            @{ Key = "Signal"; Name = "Signal"; Cmd = "brew install --cask signal"; Icon = "🔐" }

        )

        Especialidad = @{

            Programacion = @(

                @{ Key = "VSCode"; Name = "VS Code"; Cmd = "brew install --cask visual-studio-code"; Icon = "💻" }

                @{ Key = "Xcode"; Name = "Xcode"; Cmd = "xcode-select --install"; Icon = "🍎" }

                @{ Key = "Git"; Name = "Git"; Cmd = "brew install git"; Icon = "🌳" }

                @{ Key = "Python"; Name = "Python3"; Cmd = "brew install python"; Icon = "🐍" }

                @{ Key = "NodeJS"; Name = "Node.js"; Cmd = "brew install node"; Icon = "🟢" }

                @{ Key = "Docker"; Name = "Docker Desktop"; Cmd = "brew install --cask docker"; Icon = "🐳" }

            )

            Animacion = @(

                @{ Key = "Blender"; Name = "Blender"; Cmd = "brew install --cask blender"; Icon = "🟠" }

                @{ Key = "GIMP"; Name = "GIMP"; Cmd = "brew install --cask gimp"; Icon = "🦓" }

                @{ Key = "Inkscape"; Name = "Inkscape"; Cmd = "brew install --cask inkscape"; Icon = "🎨" }

                @{ Key = "Krita"; Name = "Krita"; Cmd = "brew install --cask krita"; Icon = "🎨" }

                @{ Key = "OBS"; Name = "OBS Studio"; Cmd = "brew install --cask obs"; Icon = "📺" }

                @{ Key = "DaVinciResolve"; Name = "DaVinci Resolve"; Cmd = "brew install --cask davinci-resolve"; Icon = "🎥" }

                @{ Key = "FinalCutPro"; Name = "Final Cut Pro"; Cmd = "mas install 424389933"; Icon = "🎬" }

            )

            Mecatronica = @(

                @{ Key = "FreeCAD"; Name = "FreeCAD"; Cmd = "brew install --cask freecad"; Icon = "🔧" }

                @{ Key = "KiCad"; Name = "KiCad"; Cmd = "brew install --cask kicad"; Icon = "⚡" }

                @{ Key = "Arduino"; Name = "Arduino IDE"; Cmd = "brew install --cask arduino"; Icon = "🤖" }

                @{ Key = "Fusion360"; Name = "Autodesk Fusion 360"; Cmd = "brew install --cask autodesk-fusion360"; Icon = "🔩"; Warning = "Gratuito para uso personal/educativo" }

                @{ Key = "Cura"; Name = "Ultimaker Cura"; Cmd = "brew install --cask ultimaker-cura"; Icon = "🖨️" }

            )

        }

        Extras = @(

            @{ Key = "VLC"; Name = "VLC Media Player"; Cmd = "brew install --cask vlc"; Icon = "🟠" }

            @{ Key = "Spotify"; Name = "Spotify"; Cmd = "brew install --cask spotify"; Icon = "🎧" }

            @{ Key = "Steam"; Name = "Steam"; Cmd = "brew install --cask steam"; Icon = "🎮" }

        )

    }

}

# BASE DE DATOS DE SISTEMAS OPERATIVOS

$script:osDatabase = @{

    Eficientes = @(

        @{ Name = "QNX"; Desc = "RTOS para sistemas embebidos críticos"; Size = "Varía"; URL = "https://blackberry.qnx.com/en/products/qnx-software-development-platform" }

        @{ Name = "Minix 3"; Desc = "Microkernel Unix-like educativo"; Size = "~600 MB"; URL = "http://www.minix3.org/" }

        @{ Name = "seL4"; Desc = "Microkernel verificado formalmente"; Size = "~50 MB"; URL = "https://sel4.systems/" }

    )

    LinuxUltra = @(

        @{ Name = "Arch Linux"; Desc = "Rolling release minimalista"; Size = "800 MB"; URL = "https://archlinux.org/download/" }

        @{ Name = "Void Linux"; Desc = "Independiente, sin systemd"; Size = "400 MB"; URL = "https://voidlinux.org/download/" }

        @{ Name = "Alpine Linux"; Desc = "Ultra ligero, seguridad"; Size = "150 MB"; URL = "https://www.alpinelinux.org/downloads/" }

        @{ Name = "Gentoo"; Desc = "Compilación desde fuente"; Size = "400 MB"; URL = "https://www.gentoo.org/downloads/" }

    )

    LinuxLigero = @(

        @{ Name = "Lubuntu"; Desc = "Ubuntu + LXQt"; Size = "2.5 GB"; URL = "https://lubuntu.net/downloads/" }

        @{ Name = "Xubuntu"; Desc = "Ubuntu + XFCE"; Size = "2.3 GB"; URL = "https://xubuntu.org/download/" }

        @{ Name = "Linux Mint XFCE"; Desc = "Mint con XFCE"; Size = "2.4 GB"; URL = "https://linuxmint.com/download.php" }

        @{ Key = "AntiX"; Name = "AntiX"; Desc = "Debian ligero"; Size = "1.2 GB"; URL = "https://antixlinux.com/download/" }

        @{ Name = "Puppy Linux"; Desc = "Ultra portable"; Size = "400 MB"; URL = "https://puppylinux.com/" }

    )

    WindowsMod = @(

        @{ Name = "Windows Optimus"; Desc = "Optimizador de Windows"; Size = "N/A"; URL = "https://github.com/hellzerg/optimizer"; Type = "Optimizador" }

        @{ Name = "ReviOS"; Desc = "Windows optimizado para rendimiento"; Size = "3.5 GB"; URL = "https://www.revi.cc/revios"; Type = "Modificado" }

        @{ Name = "Atlas OS"; Desc = "Windows desbloqueado para gaming"; Size = "3.2 GB"; URL = "https://atlasos.net/"; Type = "Modificado" }

        @{ Key = "Tiny11"; Name = "Tiny11"; Desc = "Windows 11 minimalista"; Size = "2.1 GB"; URL = "https://tiny11.net/"; Type = "Modificado" }

    )

    Windows = @{

        "Windows 11" = @(

            @{ Edition = "Home"; Size = "5.2 GB"; URL = "https://www.microsoft.com/software-download/windows11" }

            @{ Edition = "Pro"; Size = "5.4 GB"; URL = "https://www.microsoft.com/software-download/windows11" }

            @{ Edition = "Enterprise"; Size = "5.1 GB"; URL = "https://www.microsoft.com/software-download/windows11" }

        )

        "Windows 10" = @(

            @{ Edition = "Home"; Size = "4.8 GB"; URL = "https://www.microsoft.com/software-download/windows10" }

            @{ Edition = "Pro"; Size = "5.0 GB"; URL = "https://www.microsoft.com/software-download/windows10" }

            @{ Edition = "Enterprise"; Size = "4.9 GB"; URL = "https://www.microsoft.com/software-download/windows10" }

        )

    }

    LinuxGeneral = @(

        @{ Name = "Ubuntu 24.04 LTS"; Desc = "Distribución más popular"; Size = "5.1 GB"; URL = "https://ubuntu.com/download/desktop" }

        @{ Name = "Ubuntu 22.04 LTS"; Desc = "Versión estable anterior"; Size = "4.5 GB"; URL = "https://ubuntu.com/download/desktop" }

        @{ Name = "Linux Mint Cinnamon"; Desc = "Interfaz tradicional"; Size = "2.8 GB"; URL = "https://linuxmint.com/download.php" }

        @{ Name = "Debian Stable"; Desc = "Estabilidad y seguridad"; Size = "400 MB"; URL = "https://www.debian.org/distrib/netinst" }

        @{ Name = "Fedora Workstation"; Desc = "Innovación y tecnología"; Size = "2.0 GB"; URL = "https://getfedora.org/workstation/download/" }

        @{ Name = "Kali Linux"; Desc = "Seguridad y pentesting"; Size = "4.0 GB"; URL = "https://www.kali.org/get-kali/" }

        @{ Name = "Pop!_OS"; Desc = "Optimizado para productividad"; Size = "2.5 GB"; URL = "https://pop.system76.com/" }

        @{ Name = "Manjaro KDE"; Desc = "Arch Linux fácil de usar"; Size = "3.5 GB"; URL = "https://manjaro.org/download/" }

    )

}

# FUNCIONES DE UI

function Update-SelectionCount {

    $count = $script:selectedApps.Count

    $window.FindName("TxtSelectionCount").Text = "$count seleccionadas"

    $window.FindName("TxtBtnSeleccion").Text = "Ver Selección ($count)"

    $btnInstalar = $window.FindName("BtnInstalarSeleccionadas")

    if ($count -gt 0) {

        $btnInstalar.IsEnabled = $true

        $btnInstalar.Opacity = 1.0

    } else {

        $btnInstalar.IsEnabled = $false

        $btnInstalar.Opacity = 0.5

    }

}

function Update-RemoveSelectionCount {

    $count = $script:selectedAppsToRemove.Count

    $window.FindName("TxtSelectionCount").Text = "$count para eliminar"

    $window.FindName("TxtBtnSeleccion").Text = "Ver Selección ($count)"

    $btnDesinstalar = $window.FindName("BtnDesinstalarSeleccionadas")

    if ($btnDesinstalar -ne $null) {

        if ($count -gt 0) {

            $btnDesinstalar.IsEnabled = $true

        } else {

            $btnDesinstalar.IsEnabled = $false

        }

    }

}

function Switch-View($viewName) {

    # Ocultar todas las vistas

    $window.FindName("ViewInstalar").Visibility = "Collapsed"

    $window.FindName("ViewDesinstalar").Visibility = "Collapsed"

    $window.FindName("ViewSO").Visibility = "Collapsed"

    $window.FindName("ViewTweaks").Visibility = "Collapsed"

    $window.FindName("ViewExtensiones").Visibility = "Collapsed"

    $window.FindName("ViewInfo").Visibility = "Collapsed"

    # Mostrar vista seleccionada

    $window.FindName("View$viewName").Visibility = "Visible"

    $script:currentView = $viewName

    # Actualizar tabs

    $tabs = @("BtnInstalar", "BtnDesinstalar", "BtnSO", "BtnTweaks", "BtnExtensiones", "BtnInfo")

    foreach ($tab in $tabs) {

        $btn = $window.FindName($tab)

        if ($tab -eq "Btn$viewName") {

            $btn.Foreground = Get-ColorBrush "#FF58A6FF" # Azul activo

        } else {

            $btn.Foreground = Get-ColorBrush "#FF8B949E" # Gris inactivo

        }

    }

    # Actualizar footer según la vista activa

    if ($viewName -eq "Desinstalar") {

        Update-RemoveSelectionCount

    } else {

        Update-SelectionCount

    }

}

function Load-AppsList {

    $appsList = $window.FindName("AppsList")

    $appsList.Children.Clear()

    $apps = @()

    if ($script:currentCategory -eq "Especialidad" -and $script:currentSubcategory) {

        $apps = $script:appDatabase[$script:currentPlatform].Especialidad[$script:currentSubcategory]

    } else {

        $apps = $script:appDatabase[$script:currentPlatform][$script:currentCategory]

    }

    if (-not $apps) { return }

    foreach ($app in $apps) {

        $border = New-Object System.Windows.Controls.Border

        $border.Style = $window.FindResource("AppCardStyle")

        $grid = New-Object System.Windows.Controls.Grid

        $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width = "Auto"}))

        $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width = "*"}))

        $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width = "Auto"}))

        # Checkbox

        $check = New-Object System.Windows.Controls.CheckBox

        $check.Style = $window.FindResource("ModernCheckBox")

        $check.IsChecked = $script:selectedApps -contains $app.Key

        $check.Add_Checked({

            param($sender, $e)

            $appKey = $sender.Tag

            if ($script:selectedApps -notcontains $appKey) {

                # Verificar advertencia

                $appInfo = Find-AppInfo $appKey

                if ($appInfo.Warning) {

                    $result = [System.Windows.MessageBox]::Show(

                        "Esta aplicación tiene una nota importante:`n`n$($appInfo.Warning)`n`n¿Deseas agregarla de todos modos?",

                        "Nota importante - NeXus",

                        "YesNo",

                        "Information"

                    )

                    if ($result -eq "No") {

                        $sender.IsChecked = $false

                        return

                    }

                }

                $script:selectedApps += $appKey

                Update-SelectionCount

            }

        })

        $check.Add_Unchecked({

            param($sender, $e)

            $appKey = $sender.Tag

            $script:selectedApps = $script:selectedApps | Where-Object { $_ -ne $appKey }

            Update-SelectionCount

        })

        $check.Tag = $app.Key

        [System.Windows.Controls.Grid]::SetColumn($check, 0)

        $grid.Children.Add($check)

        # Info

        $stack = New-Object System.Windows.Controls.StackPanel

        $stack.Margin = "16,0,0,0"

        [System.Windows.Controls.Grid]::SetColumn($stack, 1)

        $titleRow = New-Object System.Windows.Controls.StackPanel

        $titleRow.Orientation = "Horizontal"

        $icon = New-Object System.Windows.Controls.TextBlock

        $icon.Text = $app.Icon

        $icon.FontSize = 16

        $icon.Margin = "0,0,8,0"

        $titleRow.Children.Add($icon)

        $name = New-Object System.Windows.Controls.TextBlock

        $name.Text = $app.Name

        $name.FontSize = 14

        $name.FontWeight = "SemiBold"

        $name.Foreground = [System.Windows.Media.Brushes]::White

        $titleRow.Children.Add($name)

        # Indicador de advertencia

        if ($app.Warning) {

            $warningIcon = New-Object System.Windows.Controls.TextBlock

            $warningIcon.Text = " ⚠️"

            $warningIcon.FontSize = 14

            $warningIcon.ToolTip = $app.Warning

            $titleRow.Children.Add($warningIcon)

        }

        $stack.Children.Add($titleRow)

        $desc = New-Object System.Windows.Controls.TextBlock

        $desc.Text = $app.Desc

        $desc.FontSize = 12

        $desc.Foreground = Get-ColorBrush "#FF8B949E"

        $desc.Margin = "0,4,0,0"

        $stack.Children.Add($desc)

        if ($app.Sub) {

            $sub = New-Object System.Windows.Controls.TextBlock

            $sub.Text = $app.Sub

            $sub.FontSize = 10

            $sub.Foreground = Get-ColorBrush "#FF58A6FF"

            $sub.Margin = "0,4,0,0"

            $stack.Children.Add($sub)

        }

        $grid.Children.Add($stack)

        # Source badge

        $badge = New-Object System.Windows.Controls.Border

        $badge.Background = Get-ColorBrush "#FF21262D"

        $badge.CornerRadius = "4"

        $badge.Padding = "8,4"

        [System.Windows.Controls.Grid]::SetColumn($badge, 2)

        $badgeText = New-Object System.Windows.Controls.TextBlock

        if ($script:currentPlatform -eq "Windows") {

            if ($app.ID) {

                $badgeText.Text = "Winget"

            } else {

                $badgeText.Text = "Web"

            }

        } else {

            $badgeText.Text = "Terminal"

        }

        $badgeText.FontSize = 10

        $badgeText.Foreground = Get-ColorBrush "#FF8B949E"

        $badge.Child = $badgeText

        $grid.Children.Add($badge)

        $border.Tag = "$($app.Name)|$($app.Desc)"
        $border.Child = $grid

        $appsList.Children.Add($border)

    }

}

# Función para cargar apps instaladas (para desinstalar)

function Load-InstalledAppsList {

    $installedList = $window.FindName("InstalledAppsList")

    $installedList.Children.Clear()

    # Obtener apps instaladas según la plataforma

    $installedApps = @()

    if ($script:currentPlatform -eq "Windows") {

        # Usar winget para listar apps instaladas

        try {

            $wingetList = winget list --accept-source-agreements 2>$null | Out-String

            $lines = $wingetList -split "`n" | Select-Object -Skip 4

            foreach ($line in $lines) {

                if ($line -match "^\s*(\S.+?)\s+(\S+)\s+(\S+)\s+(\S*)") {

                    $appName = $matches[1].Trim()

                    $appId = $matches[2].Trim()

                    $version = $matches[3].Trim()

                    

                    # Filtrar solo apps con ID válido y no son componentes de Windows

                    if ($appId -and $appId -notmatch "^Microsoft\." -and $appName -notmatch "^(Name|----)") {

                        $installedApps += @{

                            Key = $appId

                            Name = $appName

                            ID = $appId

                            Version = $version

                            Icon = "📦"

                        }

                    }

                }

            }

        } catch {

            # Si winget falla, mostrar mensaje

            $errorText = New-Object System.Windows.Controls.TextBlock

            $errorText.Text = "No se pudieron obtener las aplicaciones instaladas. Asegúrate de tener Winget actualizado."

            $errorText.Foreground = Get-ColorBrush "#FFDA3633"

            $errorText.TextWrapping = "Wrap"

            $installedList.Children.Add($errorText)

            return

        }

    } elseif ($script:currentPlatform -eq "Linux") {

        # Para Linux, listar paquetes instalados

        try {

            $dpkgList = dpkg-query -W -f='${Package}|${Version}\n' 2>$null | Select-Object -First 50

            foreach ($line in $dpkgList) {

                $parts = $line -split "\|"

                if ($parts.Count -ge 2) {

                    $installedApps += @{

                        Key = $parts[0]

                        Name = $parts[0]

                        ID = $parts[0]

                        Version = $parts[1]

                        Icon = "📦"

                    }

                }

            }

        } catch {}

    } elseif ($script:currentPlatform -eq "macOS") {

        # Para macOS, listar apps de Homebrew

        try {

            $brewList = brew list --formula 2>$null | Select-Object -First 50

            foreach ($app in $brewList) {

                $installedApps += @{

                    Key = $app

                    Name = $app

                    ID = $app

                    Version = "N/A"

                    Icon = "🍺"

                }

            }

        } catch {}

    }

    if ($installedApps.Count -eq 0) {

        $emptyText = New-Object System.Windows.Controls.TextBlock

        $emptyText.Text = "No se encontraron aplicaciones instaladas o no se pudo acceder al gestor de paquetes."

        $emptyText.Foreground = Get-ColorBrush "#FF8B949E"

        $emptyText.TextWrapping = "Wrap"

        $installedList.Children.Add($emptyText)

        return

    }

    # Mostrar apps instaladas

    foreach ($app in $installedApps | Sort-Object Name -Unique) {

        $border = New-Object System.Windows.Controls.Border

        $border.Style = $window.FindResource("AppCardStyle")

        $grid = New-Object System.Windows.Controls.Grid

        $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width = "Auto"}))

        $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width = "*"}))

        $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width = "Auto"}))

        # Checkbox

        $check = New-Object System.Windows.Controls.CheckBox

        $check.Style = $window.FindResource("ModernCheckBox")

        $check.IsChecked = $script:selectedAppsToRemove -contains $app.Key

        $check.Add_Checked({

            param($sender, $e)

            $appKey = $sender.Tag

            if ($script:selectedAppsToRemove -notcontains $appKey) {

                $script:selectedAppsToRemove += $appKey

                Update-RemoveSelectionCount

            }

        })

        $check.Add_Unchecked({

            param($sender, $e)

            $appKey = $sender.Tag

            $script:selectedAppsToRemove = $script:selectedAppsToRemove | Where-Object { $_ -ne $appKey }

            Update-RemoveSelectionCount

        })

        $check.Tag = $app.Key

        [System.Windows.Controls.Grid]::SetColumn($check, 0)

        $grid.Children.Add($check)

        # Info

        $stack = New-Object System.Windows.Controls.StackPanel

        $stack.Margin = "16,0,0,0"

        [System.Windows.Controls.Grid]::SetColumn($stack, 1)

        $titleRow = New-Object System.Windows.Controls.StackPanel

        $titleRow.Orientation = "Horizontal"

        $icon = New-Object System.Windows.Controls.TextBlock

        $icon.Text = $app.Icon

        $icon.FontSize = 16

        $icon.Margin = "0,0,8,0"

        $titleRow.Children.Add($icon)

        $name = New-Object System.Windows.Controls.TextBlock

        $name.Text = $app.Name

        $name.FontSize = 14

        $name.FontWeight = "SemiBold"

        $name.Foreground = [System.Windows.Media.Brushes]::White

        $titleRow.Children.Add($name)

        $stack.Children.Add($titleRow)

        $desc = New-Object System.Windows.Controls.TextBlock

        $desc.Text = "Versión: $($app.Version) | ID: $($app.ID)"

        $desc.FontSize = 12

        $desc.Foreground = Get-ColorBrush "#FF8B949E"

        $desc.Margin = "0,4,0,0"

        $stack.Children.Add($desc)

        $grid.Children.Add($stack)

        # Source badge

        $badge = New-Object System.Windows.Controls.Border

        $badge.Background = Get-ColorBrush "#FF21262D"

        $badge.CornerRadius = "4"

        $badge.Padding = "8,4"

        [System.Windows.Controls.Grid]::SetColumn($badge, 2)

        $badgeText = New-Object System.Windows.Controls.TextBlock

        $badgeText.Text = "Instalado"

        $badgeText.FontSize = 10

        $badgeText.Foreground = Get-ColorBrush "#FF8B949E"

        $badge.Child = $badgeText

        $grid.Children.Add($badge)

        $border.Child = $grid

        $installedList.Children.Add($border)

    }

}

function Find-AppInfo($key) {

    foreach ($cat in $script:appDatabase[$script:currentPlatform].Keys) {

        if ($cat -eq "Especialidad") {

            foreach ($sub in $script:appDatabase[$script:currentPlatform][$cat].Keys) {

                $app = $script:appDatabase[$script:currentPlatform][$cat][$sub] | Where-Object { $_.Key -eq $key }

                if ($app) { return $app }

            }

        } else {

            $app = $script:appDatabase[$script:currentPlatform][$cat] | Where-Object { $_.Key -eq $key }

            if ($app) { return $app }

        }

    }

    return $null

}

function Load-OSList {

    # Eficientes

    $efList = $window.FindName("EficientesList")

    $efList.Children.Clear()

    foreach ($os in $script:osDatabase.Eficientes) {

        Add-OSButton $efList $os

    }

    # Linux Ultra

    $luList = $window.FindName("LinuxUltraList")

    $luList.Children.Clear()

    foreach ($os in $script:osDatabase.LinuxUltra) {

        Add-OSButton $luList $os

    }

    # Windows Mod

    $wmList = $window.FindName("WindowsModList")

    $wmList.Children.Clear()

    foreach ($os in $script:osDatabase.WindowsMod) {

        Add-OSButton $wmList $os

    }

    # Windows Official

    $woList = $window.FindName("WindowsOfficialList")

    $woList.Children.Clear()

    foreach ($ver in $script:osDatabase.Windows.Keys) {

        $btn = New-Object System.Windows.Controls.Button

        $btn.Background = "Transparent"

        $btn.BorderThickness = "0"

        $btn.Padding = "0,8"

        $btn.HorizontalContentAlignment = "Left"

        $btn.Cursor = "Hand"

        $stack = New-Object System.Windows.Controls.StackPanel

        $name = New-Object System.Windows.Controls.TextBlock

        $name.Text = $ver

        $name.FontSize = 13

        $name.Foreground = [System.Windows.Media.Brushes]::White

        $stack.Children.Add($name)

        $btn.Content = $stack

        $btn.Add_Click({

            param($sender, $e)

            $url = $script:osDatabase.Windows[$ver][0].URL

            Start-Process $url

        }.GetNewClosure())

        $woList.Children.Add($btn)

    }

    # Linux General

    $lgList = $window.FindName("LinuxGeneralList")

    $lgList.Children.Clear()

    foreach ($os in $script:osDatabase.LinuxGeneral) {

        Add-OSButton $lgList $os

    }

}

function Add-OSButton($panel, $os) {

    $btn = New-Object System.Windows.Controls.Button

    $btn.Background = "Transparent"

    $btn.BorderThickness = "0"

    $btn.Padding = "0,8"

    $btn.HorizontalContentAlignment = "Left"

    $btn.Cursor = "Hand"

    $stack = New-Object System.Windows.Controls.StackPanel

    $name = New-Object System.Windows.Controls.TextBlock

    $name.Text = $os.Name

    $name.FontSize = 13

    $name.Foreground = [System.Windows.Media.Brushes]::White

    $stack.Children.Add($name)

    $desc = New-Object System.Windows.Controls.TextBlock

    $desc.Text = "$($os.Desc) | $($os.Size)"

    $desc.FontSize = 11

    $desc.Foreground = Get-ColorBrush "#FF8B949E"

    $stack.Children.Add($desc)

    $btn.Content = $stack

    $btn.Add_Click({

        param($sender, $e)

        $result = [System.Windows.MessageBox]::Show(

            "Se abrirá el navegador para descargar:`n`n$($os.Name)`nTamaño: $($os.Size)`n`n¿Continuar؟",

            "Descargar Sistema Operativo - NeXus",

            "YesNo",

            "Question"

        )

        if ($result -eq "Yes") {

            Start-Process $os.URL

        }

    }.GetNewClosure())

    $panel.Children.Add($btn)

}

# EVENT HANDLERS - Navigation

$window.FindName("BtnInstalar").Add_Click({

    Switch-View "Instalar"

    $window.FindName("SubcategoryPanel").Visibility = "Collapsed"

    $script:currentCategory = "Navegadores"

    $script:currentSubcategory = $null

    Update-CategorySelection

    Load-AppsList

})

$window.FindName("BtnDesinstalar").Add_Click({

    Switch-View "Desinstalar"

    $script:selectedAppsToRemove = @()

    Update-RemoveSelectionCount

    Load-InstalledAppsList

})

$window.FindName("BtnSO").Add_Click({

    Switch-View "SO"

    Load-OSList

})

$window.FindName("BtnTweaks").Add_Click({ Switch-View "Tweaks" })

$window.FindName("BtnExtensiones").Add_Click({ Switch-View "Extensiones" })

$window.FindName("BtnInfo").Add_Click({ Switch-View "Info" })

# Event Handlers - Platform buttons

$window.FindName("BtnPlatformWindows").Add_Click({

    $script:currentPlatform = "Windows"

    $window.FindName("TxtPlatform").Text = "Windows"

    $window.FindName("BtnPlatformWindows").Tag = "Selected"

    $window.FindName("BtnPlatformLinux").Tag = $null

    $window.FindName("BtnPlatformMac").Tag = $null

    if ($script:currentView -eq "Desinstalar") {

        Load-InstalledAppsList

    } else {

        Load-AppsList

    }

})

$window.FindName("BtnPlatformLinux").Add_Click({

    $script:currentPlatform = "Linux"

    $window.FindName("TxtPlatform").Text = "Linux"

    $window.FindName("BtnPlatformWindows").Tag = $null

    $window.FindName("BtnPlatformLinux").Tag = "Selected"

    $window.FindName("BtnPlatformMac").Tag = $null

    if ($script:currentView -eq "Desinstalar") {

        Load-InstalledAppsList

    } else {

        Load-AppsList

    }

})

$window.FindName("BtnPlatformMac").Add_Click({

    $script:currentPlatform = "macOS"

    $window.FindName("TxtPlatform").Text = "macOS"

    $window.FindName("BtnPlatformWindows").Tag = $null

    $window.FindName("BtnPlatformLinux").Tag = $null

    $window.FindName("BtnPlatformMac").Tag = "Selected"

    if ($script:currentView -eq "Desinstalar") {

        Load-InstalledAppsList

    } else {

        Load-AppsList

    }

})

# Event Handlers - Category buttons

function Update-CategorySelection {

    $window.FindName("BtnCatNavegadores").Tag = if ($script:currentCategory -eq "Navegadores") { "Selected" } else { $null }

    $window.FindName("BtnCatComunicacion").Tag = if ($script:currentCategory -eq "Comunicacion") { "Selected" } else { $null }

    $window.FindName("BtnCatEspecialidad").Tag = if ($script:currentCategory -eq "Especialidad") { "Selected" } else { $null }

    $window.FindName("BtnCatExtras").Tag = if ($script:currentCategory -eq "Extras") { "Selected" } else { $null }

    $window.FindName("BtnSubProgramacion").Tag = if ($script:currentSubcategory -eq "Programacion") { "Selected" } else { $null }

    $window.FindName("BtnSubAnimacion").Tag = if ($script:currentSubcategory -eq "Animacion") { "Selected" } else { $null }

    $window.FindName("BtnSubMecatronica").Tag = if ($script:currentSubcategory -eq "Mecatronica") { "Selected" } else { $null }

}

$window.FindName("BtnCatNavegadores").Add_Click({

    $script:currentCategory = "Navegadores"

    $script:currentSubcategory = $null

    $window.FindName("SubcategoryPanel").Visibility = "Collapsed"

    Update-CategorySelection

    Load-AppsList

})

$window.FindName("BtnCatComunicacion").Add_Click({

    $script:currentCategory = "Comunicacion"

    $script:currentSubcategory = $null

    $window.FindName("SubcategoryPanel").Visibility = "Collapsed"

    Update-CategorySelection

    Load-AppsList

})

$window.FindName("BtnCatEspecialidad").Add_Click({

    $script:currentCategory = "Especialidad"

    $window.FindName("SubcategoryPanel").Visibility = "Visible"

    if (-not $script:currentSubcategory) {

        $script:currentSubcategory = "Programacion"

    }

    Update-CategorySelection

    Load-AppsList

})

$window.FindName("BtnCatExtras").Add_Click({

    $script:currentCategory = "Extras"

    $script:currentSubcategory = $null

    $window.FindName("SubcategoryPanel").Visibility = "Collapsed"

    Update-CategorySelection

    Load-AppsList

})

# Subcategorías

$window.FindName("BtnSubProgramacion").Add_Click({

    $script:currentSubcategory = "Programacion"

    Update-CategorySelection

    Load-AppsList

})

$window.FindName("BtnSubAnimacion").Add_Click({

    $script:currentSubcategory = "Animacion"

    Update-CategorySelection

    Load-AppsList

})

$window.FindName("BtnSubMecatronica").Add_Click({

    $script:currentSubcategory = "Mecatronica"

    Update-CategorySelection

    Load-AppsList

})

# Select All / None

$window.FindName("BtnSelectAll").Add_Click({

    $apps = @()

    if ($script:currentCategory -eq "Especialidad" -and $script:currentSubcategory) {

        $apps = $script:appDatabase[$script:currentPlatform].Especialidad[$script:currentSubcategory]

    } else {

        $apps = $script:appDatabase[$script:currentPlatform][$script:currentCategory]

    }

    $result = [System.Windows.MessageBox]::Show(

        "¿Deseas seleccionar todas las aplicaciones de esta categoría? ($($apps.Count) apps)",

        "Seleccionar todas - NeXus",

        "YesNo",

        "Question"

    )

    if ($result -eq "Yes") {

        foreach ($app in $apps) {

            if ($script:selectedApps -notcontains $app.Key) {

                $script:selectedApps += $app.Key

            }

        }

        Load-AppsList

        Update-SelectionCount

    }

})

$window.FindName("BtnSelectNone").Add_Click({

    $result = [System.Windows.MessageBox]::Show(

        "¿Deseas limpiar la selección actual?",

        "Limpiar selección - NeXus",

        "YesNo",

        "Question"

    )

    if ($result -eq "Yes") {

        $script:selectedApps = @()

        Load-AppsList

        Update-SelectionCount

    }

})

# Instalar seleccionadas

$window.FindName("BtnInstalarSeleccionadas").Add_Click({

    if ($script:selectedApps.Count -eq 0) { return }

    $result = [System.Windows.MessageBox]::Show(
        "Se instalarán $($script:selectedApps.Count) aplicaciones.`n`n¿Desea continuar?",
        "Confirmar Instalación - NeXus", "YesNo", "Question"
    )
    if ($result -ne "Yes") { return }

    # Ventana de progreso
    [xml]$progressXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="NeXus Instalando" Width="560" Height="360"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        WindowStartupLocation="CenterScreen" Topmost="True" ResizeMode="NoResize">
    <Border Background="#FF0F1419" CornerRadius="12" BorderBrush="#FF30363D" BorderThickness="1">
        <StackPanel Margin="28,22,28,22">
            <TextBlock Text="&#x1F4E6; Instalando Aplicaciones" FontFamily="Segoe UI"
                       FontSize="17" FontWeight="SemiBold" Foreground="White" Margin="0,0,0,4"/>
            <TextBlock x:Name="SubTitle" FontFamily="Segoe UI" FontSize="12"
                       Foreground="#FF8B949E" Margin="0,0,0,18"/>
            <TextBlock x:Name="AppNameLabel" FontFamily="Segoe UI" FontSize="14"
                       FontWeight="SemiBold" Foreground="#FF58A6FF" Margin="0,0,0,6" TextWrapping="Wrap"/>
            <Border Background="#FF1C2128" CornerRadius="4" Height="10" Margin="0,0,0,4">
                <Border x:Name="BarIndividual" Background="#FF238636" CornerRadius="4"
                        HorizontalAlignment="Left" Width="0"/>
            </Border>
            <TextBlock x:Name="PctLabel" FontFamily="Consolas" FontSize="11"
                       Foreground="#FF6E7681" Margin="0,0,0,14"/>
            <TextBlock Text="Progreso total" FontFamily="Segoe UI" FontSize="12"
                       Foreground="#FF8B949E" Margin="0,0,0,4"/>
            <Border Background="#FF1C2128" CornerRadius="4" Height="8" Margin="0,0,0,4">
                <Border x:Name="BarTotal" Background="#FF58A6FF" CornerRadius="4"
                        HorizontalAlignment="Left" Width="0"/>
            </Border>
            <TextBlock x:Name="TotalLabel" FontFamily="Segoe UI" FontSize="11"
                       Foreground="#FF8B949E" Margin="0,0,0,14"/>
            <Border x:Name="PathPanel" Background="#FF161B22" CornerRadius="6"
                    Padding="12,8" Visibility="Collapsed">
                <StackPanel>
                    <TextBlock Text="&#x1F4C2; Instalado en:" FontFamily="Segoe UI" FontSize="11"
                               Foreground="#FF8B949E" Margin="0,0,0,3"/>
                    <TextBlock x:Name="PathLabel" FontFamily="Consolas" FontSize="11"
                               Foreground="#FF58A6FF" TextWrapping="Wrap"/>
                </StackPanel>
            </Border>
        </StackPanel>
    </Border>
</Window>
"@

    $pReader  = New-Object System.Xml.XmlNodeReader($progressXaml)
    $pWindow  = [Windows.Markup.XamlReader]::Load($pReader)
    $pWindow.Show()
    $pWindow.Dispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Render)

    $pAppName   = $pWindow.FindName("AppNameLabel")
    $pSubTitle  = $pWindow.FindName("SubTitle")
    $pBarInd    = $pWindow.FindName("BarIndividual")
    $pBarTotal  = $pWindow.FindName("BarTotal")
    $pPct       = $pWindow.FindName("PctLabel")
    $pTotalLbl  = $pWindow.FindName("TotalLabel")
    $pPathPanel = $pWindow.FindName("PathPanel")
    $pPathLabel = $pWindow.FindName("PathLabel")

    $installed  = 0
    $failed     = 0
    $totalApps  = $script:selectedApps.Count
    $results    = @()
    $barMax     = 504

    foreach ($appKey in $script:selectedApps) {
        $app = Find-AppInfo $appKey
        if (-not $app) { continue }
        $appNum = $installed + $failed + 1

        $pWindow.Dispatcher.Invoke([Action]{
            $pAppName.Text  = "Instalando: $($app.Name)"
            $pSubTitle.Text = "App $appNum de $totalApps  —  $($app.Desc)"
            $pBarInd.Width  = 0
            $pPct.Text      = "0%  •  Iniciando..."
            $pPathPanel.Visibility = "Collapsed"
            $pBarTotal.Width = [Math]::Round(($appNum - 1) / $totalApps * $barMax)
            $pTotalLbl.Text  = "$($installed + $failed) de $totalApps completadas"
        }, [System.Windows.Threading.DispatcherPriority]::Render)

        $foundExe  = $null
        $installOk = $false

        try {
            if ($script:currentPlatform -eq "Windows") {
                if ($app.ID) {

                    $job = Start-Job -ScriptBlock {
                        param($id)
                        $p = Start-Process -FilePath "winget" `
                            -ArgumentList "install","--id",$id,`
                                          "--accept-package-agreements",`
                                          "--accept-source-agreements","--silent" `
                            -Wait -PassThru -WindowStyle Hidden
                        return $p.ExitCode
                    } -ArgumentList $app.ID

                    $pct     = 0
                    $elapsed = 0
                    $estSecs = 45

                    while ($job.State -eq "Running") {
                        Start-Sleep -Milliseconds 400
                        $elapsed += 0.4
                        $pct      = [Math]::Min(90, [Math]::Round(90 * (1 - [Math]::Exp(-$elapsed / $estSecs * 2.5))))
                        $remain   = [Math]::Max(0, [Math]::Round($estSecs - $elapsed))
                        $pctCopy  = $pct
                        $remCopy  = $remain
                        $pWindow.Dispatcher.Invoke([Action]{
                            $pBarInd.Width = [Math]::Round($pctCopy / 100 * $barMax)
                            $pPct.Text     = "$pctCopy%  •  ~$remCopy seg restantes"
                        }, [System.Windows.Threading.DispatcherPriority]::Render)
                    }

                    $exitCode = Receive-Job $job
                    Remove-Job $job

                    $pWindow.Dispatcher.Invoke([Action]{
                        $pBarInd.Width = $barMax
                        $pPct.Text     = "100%  •  Completado"
                    }, [System.Windows.Threading.DispatcherPriority]::Render)

                    if ($exitCode -eq 0 -or $null -eq $exitCode) {
                        $installOk = $true
                        $installed++
                        $exeName     = ($app.Name -replace '[^a-zA-Z0-9]', '').ToLower()
                        $searchPaths = @(
                            $env:ProgramFiles,
                            ${env:ProgramFiles(x86)},
                            "$env:LOCALAPPDATA\Programs",
                            "$env:LOCALAPPDATA\Microsoft\WindowsApps"
                        )

                        $cmdFound = Get-Command $exeName -ErrorAction SilentlyContinue
                        if ($cmdFound) { $foundExe = $cmdFound.Source }

                        if (-not $foundExe) {
                            foreach ($spath in $searchPaths) {
                                $exe = Get-ChildItem -Path $spath -Filter "*.exe" -Recurse `
                                    -ErrorAction SilentlyContinue |
                                    Where-Object { $_.Name -notmatch 'uninstall|setup|update|helper|crash|report' } |
                                    Where-Object { $_.BaseName.ToLower() -like "*$exeName*" } |
                                    Select-Object -First 1
                                if ($exe) { $foundExe = $exe.FullName; break }
                            }
                        }

                        $pathText = if ($foundExe) { $foundExe } else { "Instalado via winget — ruta no localizada automaticamente." }
                        $pWindow.Dispatcher.Invoke([Action]{
                            $pPathLabel.Text       = $pathText
                            $pPathPanel.Visibility = "Visible"
                        }, [System.Windows.Threading.DispatcherPriority]::Render)

                        if ($foundExe) {
                            $catFolder = "C:\Nexus\Apps\$script:currentCategory"
                            if ($script:currentCategory -eq "Especialidad" -and $script:currentSubcategory) {
                                $catFolder = "C:\Nexus\Apps\Especialidad\$script:currentSubcategory"
                            }
                            if (-not (Test-Path $catFolder)) { New-Item -ItemType Directory -Path $catFolder -Force | Out-Null }
                            $wsh      = New-Object -ComObject WScript.Shell
                            $sc       = $wsh.CreateShortcut("$catFolder\$($app.Name).lnk")
                            $sc.TargetPath       = $foundExe
                            $sc.WorkingDirectory = Split-Path $foundExe
                            $sc.Description      = $app.Desc
                            $sc.Save()
                        }

                        $results += [PSCustomObject]@{ Name=$app.Name; Path=$pathText; Status="OK" }

                    } else {
                        $failed++
                        $results += [PSCustomObject]@{ Name=$app.Name; Path=$null; Status="FAIL" }
                    }

                } elseif ($app.URL) {
                    Start-Process $app.URL
                    $installed++
                    $pWindow.Dispatcher.Invoke([Action]{
                        $pBarInd.Width = $barMax
                        $pPct.Text     = "100%  •  Abierto en navegador"
                        $pPathLabel.Text       = $app.URL
                        $pPathPanel.Visibility = "Visible"
                    }, [System.Windows.Threading.DispatcherPriority]::Render)
                    $results += [PSCustomObject]@{ Name=$app.Name; Path=$app.URL; Status="WEB" }
                }

            } elseif ($script:currentPlatform -eq "Linux") {
                Invoke-Expression $app.Cmd
                if ($LASTEXITCODE -eq 0) { $installed++ } else { $failed++ }
            } elseif ($script:currentPlatform -eq "macOS") {
                Invoke-Expression $app.Cmd
                if ($LASTEXITCODE -eq 0) { $installed++ } else { $failed++ }
            }

        } catch {
            $failed++
            $results += [PSCustomObject]@{ Name=$app.Name; Path=$null; Status="ERR: $_" }
        }

        Start-Sleep -Milliseconds 700

        $done = $installed + $failed
        $pWindow.Dispatcher.Invoke([Action]{
            $pBarTotal.Width = [Math]::Round($done / $totalApps * $barMax)
            $pTotalLbl.Text  = "$done de $totalApps completadas"
        }, [System.Windows.Threading.DispatcherPriority]::Render)
    }

    $pWindow.Close()

    $lines = @("Exitosas: $installed    Fallidas: $failed", "")
    foreach ($r in $results) {
        $icon = switch ($r.Status) { "OK" {"OK"} "FAIL" {"FALLO"} "WEB" {"WEB"} default {"ERR"} }
        $lines += "[$icon]  $($r.Name)"
        if ($r.Path) { $lines += "       Ruta: $($r.Path)" }
    }
    $lines += @("", "Algunas apps pueden requerir reinicio.")

    [System.Windows.MessageBox]::Show(
        ($lines -join "`n"),
        "NeXus — Instalacion Completada", "OK", "Information"
    )

    $script:selectedApps = @()
    Update-SelectionCount
    Load-AppsList

})
# Event Handler para el botón de desinstalar (ahora en XAML)

$btnDesinstalar = $window.FindName("BtnDesinstalarSeleccionadas")

if ($btnDesinstalar -ne $null) {

    $btnDesinstalar.Add_Click({

        if ($script:selectedAppsToRemove.Count -eq 0) { return }

        $result = [System.Windows.MessageBox]::Show(

            "Se desinstalarán $($script:selectedAppsToRemove.Count) aplicaciones.`n`n¿Estás seguro? Esta acción no se puede deshacer.",

            "Confirmar Desinstalación - NeXus",

            "YesNo",

            "Warning"

        )

        if ($result -eq "Yes") {

            $removed = 0

            $failed = 0

            foreach ($appKey in $script:selectedAppsToRemove) {

                try {

                    if ($script:currentPlatform -eq "Windows") {

                        Start-Process -FilePath "winget" -ArgumentList "uninstall", "--id", $appKey, "--silent" -Wait -WindowStyle Hidden

                        $removed++

                    } elseif ($script:currentPlatform -eq "Linux") {

                        Invoke-Expression "sudo apt remove $appKey -y"

                        if ($LASTEXITCODE -eq 0) { $removed++ } else { $failed++ }

                    } elseif ($script:currentPlatform -eq "macOS") {

                        Invoke-Expression "brew uninstall $appKey"

                        if ($LASTEXITCODE -eq 0) { $removed++ } else { $failed++ }

                    }

                } catch {

                    $failed++

                }

            }

            [System.Windows.MessageBox]::Show(

                "Desinstalación completada.`n`n✅ Exitosas: $removed`n❌ Fallidas: $failed",

                "NeXus - Desinstalación Completada",

                "OK",

                "Information"

            )

            $script:selectedAppsToRemove = @()

            Update-RemoveSelectionCount

            Load-InstalledAppsList

        }

    })

}

# Tweaks con confirmaciones y advertencias amigables

$window.FindName("BtnTweakPerformance").Add_Click({

    $result = [System.Windows.MessageBox]::Show(

        "Esta optimización desactivará efectos visuales y ajustará servicios para mejorar el rendimiento.`n`n💡 Puedes revertir estos cambios usando 'Restaurar valores predeterminados'.`n`n¿Deseas continuar?",

        "Optimizar Rendimiento - NeXus",

        "YesNo",

        "Question"

    )

    if ($result -eq "Yes") {

        try {

            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -ErrorAction SilentlyContinue

            Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0 -ErrorAction SilentlyContinue

            powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c | Out-Null

            [System.Windows.MessageBox]::Show(

                "✅ Optimizaciones aplicadas correctamente.`n`nLos cambios tomarán efecto después de reiniciar sesión.",

                "NeXus - Optimización Completada",

                "OK",

                "Information"

            )

        } catch {

            [System.Windows.MessageBox]::Show(

                "❌ Error al aplicar optimizaciones: $_",

                "NeXus - Error",

                "OK",

                "Error"

            )

        }

    }

})

$window.FindName("BtnTweakPrivacy").Add_Click({

    $result = [System.Windows.MessageBox]::Show(

        "Se desactivarán la telemetría, diagnósticos y anuncios personalizados.`n`n💡 Esto no afectará el funcionamiento normal de Windows.`n`n¿Deseas continuar?",

        "Mejorar Privacidad - NeXus",

        "YesNo",

        "Question"

    )

    if ($result -eq "Yes") {

        try {

            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0 -ErrorAction SilentlyContinue

            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -ErrorAction SilentlyContinue

            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0 -ErrorAction SilentlyContinue

            [System.Windows.MessageBox]::Show(

                "✅ Configuración de privacidad aplicada.`n`nTu privacidad ha sido mejorada.",

                "NeXus - Privacidad",

                "OK",

                "Information"

            )

        } catch {

            [System.Windows.MessageBox]::Show(

                "❌ Error al aplicar configuración: $_",

                "NeXus - Error",

                "OK",

                "Error"

            )

        }

    }

})

$window.FindName("BtnTweakGaming").Add_Click({

    $result = [System.Windows.MessageBox]::Show(

        "Se activará el Modo Juego y se optimizarán configuraciones para gaming.`n`n💡 Esto puede mejorar los FPS en juegos.`n`n¿Deseas continuar?",

        "Optimizar para Gaming - NeXus",

        "YesNo",

        "Question"

    )

    if ($result -eq "Yes") {

        try {

            Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1 -ErrorAction SilentlyContinue

            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 -ErrorAction SilentlyContinue

            [System.Windows.MessageBox]::Show(

                "✅ Optimizaciones para gaming aplicadas.`n`n¡Listo para jugar!",

                "NeXus - Gaming",

                "OK",

                "Information"

            )

        } catch {

            [System.Windows.MessageBox]::Show(

                "❌ Error al aplicar optimizaciones: $_",

                "NeXus - Error",

                "OK",

                "Error"

            )

        }

    }

})

$window.FindName("BtnTweakLaptop").Add_Click({

    $result = [System.Windows.MessageBox]::Show(

        "Se configurará el plan de energía para extender la duración de la batería.`n`n💡 Ideal para usar desconectado.`n`n¿Deseas continuar?",

        "Optimizar Laptop - NeXus",

        "YesNo",

        "Question"

    )

    if ($result -eq "Yes") {

        try {

            powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e | Out-Null

            powercfg /change standby-timeout-ac 30 | Out-Null

            powercfg /change standby-timeout-dc 15 | Out-Null

            [System.Windows.MessageBox]::Show(

                "✅ Configuración para laptop aplicada.`n`nLa batería durará más tiempo.",

                "NeXus - Laptop",

                "OK",

                "Information"

            )

        } catch {

            [System.Windows.MessageBox]::Show(

                "❌ Error al aplicar configuración: $_",

                "NeXus - Error",

                "OK",

                "Error"

            )

        }

    }

})

$window.FindName("BtnTweakClean").Add_Click({

    $result = [System.Windows.MessageBox]::Show(

        "Se eliminarán archivos temporales y se vaciará la papelera.`n`n💡 Esta acción libera espacio en disco de forma segura.`n`n¿Deseas continuar?",

        "Limpiar Sistema - NeXus",

        "YesNo",

        "Question"

    )

    if ($result -eq "Yes") {

        try {

            Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

            Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

            [System.Windows.MessageBox]::Show(

                "✅ Limpieza completada.`n`nEl espacio libre ha sido optimizado.",

                "NeXus - Limpieza",

                "OK",

                "Information"

            )

        } catch {

            [System.Windows.MessageBox]::Show(

                "❌ Error al limpiar: $_",

                "NeXus - Error",

                "OK",

                "Error"

            )

        }

    }

})

$window.FindName("BtnTweakRestore").Add_Click({

    $result = [System.Windows.MessageBox]::Show(

        "Se restaurarán los valores predeterminados de Windows.`n`n⚠️ Esto revertirá todas las optimizaciones aplicadas.`n`n¿Deseas continuar?",

        "Restaurar Configuración - NeXus",

        "YesNo",

        "Warning"

    )

    if ($result -eq "Yes") {

        try {

            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 0 -ErrorAction SilentlyContinue

            powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e | Out-Null

            [System.Windows.MessageBox]::Show(

                "✅ Configuración restaurada.`n`nWindows ha vuelto a sus valores predeterminados.",

                "NeXus - Restauración",

                "OK",

                "Information"

            )

        } catch {

            [System.Windows.MessageBox]::Show(

                "❌ Error al restaurar: $_",

                "NeXus - Error",

                "OK",

                "Error"

            )

        }

    }

})

# Extensiones

$window.FindName("BtnExtVSCode").Add_Click({

    $result = [System.Windows.MessageBox]::Show(

        "Se instalarán las extensiones recomendadas para VS Code:`n`n• Python`n• ESLint`n• Prettier`n• GitLens`n• Docker`n• C/C++`n• Arduino`n• Live Server`n`n¿Deseas continuar?",

        "Instalar Extensiones VS Code - NeXus",

        "YesNo",

        "Question"

    )

    if ($result -eq "Yes") {

        $extensions = @("ms-python.python", "dbaeumer.vscode-eslint", "esbenp.prettier-vscode", "eamodio.gitlens", "ms-azuretools.vscode-docker", "ms-vscode.cpptools", "vsciot-vscode.vscode-arduino", "ritwickdey.LiveServer")

        foreach ($ext in $extensions) {

            Start-Process -FilePath "code" -ArgumentList "--install-extension", $ext, "--force" -Wait -WindowStyle Hidden

        }

        [System.Windows.MessageBox]::Show("✅ Extensiones instaladas correctamente.", "NeXus", "OK", "Information")

    }

})

$window.FindName("BtnExtChrome").Add_Click({

    $urls = @(

        "https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm",

        "https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb",

        "https://chrome.google.com/webstore/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh"

    )

    foreach ($url in $urls) { Start-Process $url }

})

$window.FindName("BtnExtFirefox").Add_Click({

    $urls = @(

        "https://addons.mozilla.org/firefox/addon/ublock-origin/",

        "https://addons.mozilla.org/firefox/addon/bitwarden-password-manager/",

        "https://addons.mozilla.org/firefox/addon/darkreader/"

    )

    foreach ($url in $urls) { Start-Process $url }

})

$window.FindName("BtnExtPowerToys").Add_Click({

    Start-Process "powertoys"

})

# Ver selección

$window.FindName("BtnVerSeleccion").Add_Click({

    if ($script:currentView -eq "Desinstalar") {

        if ($script:selectedAppsToRemove.Count -eq 0) {

            [System.Windows.MessageBox]::Show("No hay aplicaciones seleccionadas para desinstalar.", "NeXus - Selección", "OK", "Information")

        } else {

            $list = $script:selectedAppsToRemove -join "`n• "

            [System.Windows.MessageBox]::Show("Aplicaciones seleccionadas para eliminar:`n`n• $list", "NeXus - Selección", "OK", "Information")

        }

    } else {

        if ($script:selectedApps.Count -eq 0) {

            [System.Windows.MessageBox]::Show("No hay aplicaciones seleccionadas.", "NeXus - Selección", "OK", "Information")

        } else {

            $list = $script:selectedApps -join "`n• "

            [System.Windows.MessageBox]::Show("Aplicaciones seleccionadas:`n`n• $list", "NeXus - Selección", "OK", "Information")

        }

    }

})

# Barra de búsqueda - filtra por nombre de app

$window.FindName("SearchBox").Add_TextChanged({
    $query = $window.FindName("SearchBox").Text.ToLower().Trim()
    foreach ($child in $window.FindName("AppsList").Children) {
        if ($query -eq "" -or ($child.Tag -and $child.Tag.ToLower() -like "*$query*")) {
            $child.Visibility = "Visible"
        } else { $child.Visibility = "Collapsed" }
    }
})

# Crear estructura de carpetas C:\Nexus

$script:nexusFolders = @(
    "C:\Nexus",
    "C:\Nexus\Apps",
    "C:\Nexus\Apps\Navegadores",
    "C:\Nexus\Apps\Comunicacion",
    "C:\Nexus\Apps\Especialidad",
    "C:\Nexus\Apps\Especialidad\Programacion",
    "C:\Nexus\Apps\Especialidad\Animacion",
    "C:\Nexus\Apps\Especialidad\Mecatronica",
    "C:\Nexus\Apps\Extras",
    "C:\Nexus\Logs",
    "C:\Nexus\Config",
    "C:\Nexus\Cache",
    "C:\Nexus\Backups"
)
foreach ($folder in $script:nexusFolders) {
    if (-not (Test-Path $folder)) { New-Item -ItemType Directory -Path $folder -Force | Out-Null }
}

# =====================================================
# SPLASH SCREEN CON ANIMACIÓN GLITCH - NEXUS v1.8.2
# Duración total: ~4.5 segundos
#   Fase 0 — Glitch caótico:      0.0s – 1.6s  (20 ticks × 80ms)
#   Fase 1 — Glitch moderado:     1.6s – 2.8s  (15 ticks × 80ms)
#   Fase 2 — Estabilización:      2.8s – 3.6s  (10 ticks × 80ms)
#   Fase 3 — Borde + logo fijo:   3.6s – 4.2s  ( 8 ticks × 80ms)
#   Fase 4 — Flash + pausa:       4.2s – 4.5s  ( 4 ticks × 80ms)
#   Fase 5 — Fade out y cierre:   4.5s – 5.0s  ( 6 ticks × 80ms)
# =====================================================
function Show-GlitchSplash {

    # ── Character map del logo (extraído del arte original) ────────────────
    $script:logoMap = @(
    '                                                              ',
    '                                                              ',
    '                                                              ',
    '                                                              ',
    '                                                              ',
    '                                                              ',
    '                                                              ',
    '                           .,iGC;,.                           ',
    '                            .,f81.                            ',
    '                            ,.;G@C:                           ',
    '                          .;,,ifG#O1                          ',
    '                         ii:::;1fG88f,                        ',
    '                      ..ii,,,,:i1fCGCf;                       ',
    '             ,:     ..,1i.,,,,:i1tfCCLt:.      ,:             ',
    '             fL;: .,,:i1,,,:;i11tLCGGCfti:,: ,;1L             ',
    '          .:;fffftfft111;;;1ffftfLLLLff111tt11ffLi:,.         ',
    '               .,,:;i11:,,. ., .i1i1:,;1i;:,. ...             ',
    '                    .;1fftt;,;.,.:tfLLf1;,                    ',
    '                     . ;t1LL1ii;ifGGi:  ..                    ',
    '                        . ,;ttii11;:  .                       ',
    '                           .;1LL;:..           .....          ',
    '                            ..;1. . .....,,:::,,.             ',
    '                    .  ...,:;;::1t1i;;;;:,,.                  ',
    '             1Ot1:i8.1Gttti:1LCCOLi;Oi. iC if11ti             ',
    '           . ;1 :;1t.;f111i:i11i1;:,ti::i1 :i;;ii             ',
    '           ,,..,,,:;;:,::,,:,.   ...                          '
)

    # ── XAML ───────────────────────────────────────────────────────────────
    [xml]$splashXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Width="720" Height="520"
        WindowStyle="None" AllowsTransparency="True"
        Background="Transparent"
        WindowStartupLocation="CenterScreen"
        Topmost="True" ShowInTaskbar="False">
    <Grid x:Name="RootGrid">
        <Rectangle x:Name="BgRect" Fill="#FF060A10" RadiusX="14" RadiusY="14"/>

        <!-- Panel superior: arte ASCII del logo -->
        <StackPanel x:Name="AsciiPanel"
                    HorizontalAlignment="Center" VerticalAlignment="Top"
                    Margin="0,28,0,0" Opacity="1">
            <TextBlock x:Name="AsciiArt"
                       FontFamily="Consolas" FontSize="11" FontWeight="Normal"
                       Foreground="#FFB0C8E0" TextWrapping="NoWrap"
                       HorizontalAlignment="Center"
                       LineHeight="13"/>
        </StackPanel>

        <!-- Panel inferior: texto NEXUS (oculto al inicio) -->
        <Canvas HorizontalAlignment="Center" VerticalAlignment="Center"
                Width="460" Height="120" Margin="0,40,0,0">

            <TextBlock x:Name="SliceTop" Text="NEXUS"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="White" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.Clip><RectangleGeometry Rect="0,0,460,36"/></TextBlock.Clip>
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransSliceTop"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="SliceMid" Text="NEXUS"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="White" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.Clip><RectangleGeometry Rect="0,36,460,26"/></TextBlock.Clip>
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransSliceMid"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="SliceBot" Text="NEXUS"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="White" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.Clip><RectangleGeometry Rect="0,62,460,58"/></TextBlock.Clip>
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransSliceBot"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="GlitchR" Text="NEXUS"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#CCFF1133" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransR"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="GlitchB" Text="NEXUS"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#CC1144FF" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransB"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="GlitchG" Text="NEXUS"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#8800FF88" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransG"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="MainText" Text="NEXUS"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="White" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransMain"/></TextBlock.RenderTransform>
            </TextBlock>
            <Border x:Name="LogoBorder" Canvas.Left="12" Canvas.Top="-12"
                    Width="0" Height="96" BorderBrush="White" BorderThickness="2.5"
                    Background="Transparent" Opacity="0"/>
        </Canvas>

        <!-- Flash de blackout -->
        <Rectangle x:Name="BlackFlash" Fill="Black" RadiusX="14" RadiusY="14" Opacity="0"/>

        <!-- Scanline -->
        <Rectangle x:Name="ScanH" Fill="#33FFFFFF" Height="3"
                   VerticalAlignment="Top" Opacity="0" RadiusX="1" RadiusY="1"/>

        <!-- Versión -->
        <TextBlock x:Name="VersionTag"
                   Text="v1.8.2  —  Sistema de Instalación Multiplataforma"
                   FontFamily="Consolas" FontSize="11" Foreground="#FF58A6FF"
                   HorizontalAlignment="Center" VerticalAlignment="Bottom"
                   Margin="0,0,0,14" Opacity="0"/>
    </Grid>
</Window>
"@

    $script:splashReader = New-Object System.Xml.XmlNodeReader($splashXaml)
    $script:splash       = [Windows.Markup.XamlReader]::Load($script:splashReader)

    $script:asciiArt     = $script:splash.FindName("AsciiArt")
    $script:asciiPanel   = $script:splash.FindName("AsciiPanel")
    $script:mainText     = $script:splash.FindName("MainText")
    $script:sliceTop     = $script:splash.FindName("SliceTop")
    $script:sliceMid     = $script:splash.FindName("SliceMid")
    $script:sliceBot     = $script:splash.FindName("SliceBot")
    $script:glitchR      = $script:splash.FindName("GlitchR")
    $script:glitchB      = $script:splash.FindName("GlitchB")
    $script:glitchG      = $script:splash.FindName("GlitchG")
    $script:transMain    = $script:splash.FindName("TransMain")
    $script:transR       = $script:splash.FindName("TransR")
    $script:transB       = $script:splash.FindName("TransB")
    $script:transG       = $script:splash.FindName("TransG")
    $script:transSliceTop = $script:splash.FindName("TransSliceTop")
    $script:transSliceMid = $script:splash.FindName("TransSliceMid")
    $script:transSliceBot = $script:splash.FindName("TransSliceBot")
    $script:border       = $script:splash.FindName("LogoBorder")
    $script:version      = $script:splash.FindName("VersionTag")
    $script:scanH        = $script:splash.FindName("ScanH")
    $script:blackFlash   = $script:splash.FindName("BlackFlash")

    # Inicializar ASCII art con el mapa completo
    $script:asciiArt.Text = $script:logoMap -join "`n"

    $script:rng = New-Object System.Random

    # Tabla de sustitución de glifos por letra
    $script:glyphMap = @(
        @('N','И','Й','ℕ','Ɲ','ท','₦','Π','Ν'),
        @('E','Ξ','Ε','€','Ê','ε','3','∃','Ë'),
        @('X','✗','×','Χ','χ','Ж','⊗','╳','ж'),
        @('U','∪','Ü','υ','Ʉ','ų','µ','Ū','ʊ'),
        @('S','5','$','§','Ś','ς','Ƨ','Š','∫')
    )
    $script:baseLetters  = @('N','E','X','U','S')
    $script:letterState  = @($false,$false,$false,$false,$false)

    # Chars para corromper el arte ASCII
    $script:noiseChars = @('#','@','%','&','!','?','0','1','|','/','\\','+','=','~','^','*')

    # Copia limpia de las filas del mapa
    $script:cleanRows    = $script:logoMap.Clone()
    $script:corruptRows  = $script:logoMap.Clone()

    $script:tick  = 0
    $script:scanY = 0.0

    # Timer 50ms
    # FASES:
    #  0 — ASCII logo aparece + glitch suave ASCII     ticks  1-30  (1.5s)
    #  1 — ASCII se corrompe y desintegra              ticks 31-55  (1.25s)
    #  2 — Blackout + NEXUS emerge caótico             ticks 56-65  (0.5s)
    #  3 — Glitch RGB agresivo + slices                ticks 66-100 (1.75s)
    #  4 — Letras se corrigen una a una                ticks101-125 (1.25s)
    #  5 — Estabilización                              ticks126-138 (0.65s)
    #  6 — Borde + versión                             ticks139-150 (0.55s)
    #  7 — Flash cian                                  ticks151-156 (0.3s)
    #  8 — Fade out                                    ticks157-168 (0.6s)
    $script:timer          = New-Object System.Windows.Threading.DispatcherTimer
    $script:timer.Interval = [TimeSpan]::FromMilliseconds(50)

    $script:timer.Add_Tick({
        $script:tick++
        $t   = $script:tick
        $rng = $script:rng

        function Get-GlitchedText {
            $out = ""
            for ($i = 0; $i -lt 5; $i++) {
                if ($script:letterState[$i]) {
                    $pool = $script:glyphMap[$i]
                    $out += $pool[$rng.Next(0,$pool.Count)]
                } else { $out += $script:baseLetters[$i] }
            }
            return $out
        }

        # ── FASE 0: ASCII logo aparece + glitch suave (1-30) ─────────────
        if ($t -le 30) {
            # Fade in progresivo del arte
            $fadeIn = [Math]::Min(1.0, $t / 18.0)
            $script:asciiPanel.Opacity = $fadeIn

            # Glitch suave: cada 3 ticks corrompe 1-3 chars aleatorios
            if ($t % 3 -eq 0) {
                $rows = $script:corruptRows
                $numCorrupt = $rng.Next(1, 4)
                for ($c = 0; $c -lt $numCorrupt; $c++) {
                    $rowIdx = $rng.Next(6, $rows.Count)
                    $row    = $rows[$rowIdx]
                    if ($row.Length -gt 2) {
                        $colIdx = $rng.Next(0, $row.Length)
                        $newChar = $script:noiseChars[$rng.Next(0,$script:noiseChars.Count)]
                        $rows[$rowIdx] = $row.Substring(0,$colIdx) + $newChar + $row.Substring($colIdx+1)
                    }
                }
                $script:corruptRows = $rows
                $script:asciiArt.Text = $script:corruptRows -join "`n"
            } else {
                # Restaura a limpio en ticks no corruptos → efecto parpadeo suave
                $script:asciiArt.Text = $script:cleanRows -join "`n"
            }

            $script:scanH.Opacity = 0.15
            $script:scanY = ($script:scanY + 8) % 520
            $script:scanH.Margin = [System.Windows.Thickness]::new(0,$script:scanY,0,0)
        }

        # ── FASE 1: ASCII se corrompe y desintegra (31-55) ───────────────
        elseif ($t -le 55) {
            $localT   = $t - 30   # 1..25
            $chaos    = $localT / 25.0

            # Aumenta cantidad de chars corrompidos exponencialmente
            $numCorrupt = [Math]::Min(80, [Math]::Round($chaos * $chaos * 120))
            $rows = $script:corruptRows
            for ($c = 0; $c -lt $numCorrupt; $c++) {
                $rowIdx = $rng.Next(0, $rows.Count)
                $row    = $rows[$rowIdx]
                if ($row.Trim().Length -gt 0) {
                    # También reemplaza espacios hacia el final
                    $colIdx = $rng.Next(0, $row.Length)
                    $newChar = if ($chaos -gt 0.6 -and $rng.Next(0,3) -eq 0) { " " } `
                               else { $script:noiseChars[$rng.Next(0,$script:noiseChars.Count)] }
                    $rows[$rowIdx] = $row.Substring(0,$colIdx) + $newChar + $row.Substring($colIdx+1)
                }
            }
            $script:corruptRows = $rows
            $script:asciiArt.Text = $script:corruptRows -join "`n"

            # Panel ASCII se desvanece al final de la fase
            $fadeOut = [Math]::Max(0.0, 1.0 - (($localT - 15) / 10.0))
            $script:asciiPanel.Opacity = $fadeOut

            # Flashes de blackout intermitentes al final
            if ($localT -gt 18 -and $rng.Next(0,4) -eq 0) {
                $script:blackFlash.Opacity = 0.7
            } else {
                $script:blackFlash.Opacity = 0.0
            }

            $script:scanY = ($script:scanY + 15) % 520
            $script:scanH.Margin  = [System.Windows.Thickness]::new(0,$script:scanY,0,0)
            $script:scanH.Opacity = 0.2 + $chaos * 0.3
        }

        # ── FASE 2: Blackout + NEXUS emerge caótico (56-65) ──────────────
        elseif ($t -le 65) {
            $script:asciiPanel.Opacity = 0.0
            $localT = $t - 55   # 1..10

            if ($localT % 2 -eq 1) {
                $script:blackFlash.Opacity = 0.95
                $script:mainText.Opacity   = 0.0
                $script:glitchR.Opacity    = 0.0
                $script:glitchB.Opacity    = 0.0
            } else {
                $script:blackFlash.Opacity = 0.0
                for ($i=0;$i -lt 5;$i++) { $script:letterState[$i] = ($rng.Next(0,2) -eq 1) }
                $script:mainText.Text    = Get-GlitchedText
                $script:mainText.Opacity = 1.0
                $script:transMain.X      = $rng.Next(-18,18)
                $script:transMain.Y      = $rng.Next(-9,9)
                $script:glitchR.Opacity  = 0.8
                $script:transR.X         = $rng.Next(12,28)
                $script:glitchB.Opacity  = 0.8
                $script:transB.X         = $rng.Next(-28,-12)
            }
            $script:scanH.Opacity = 0.5
            $script:scanY = ($script:scanY + 35) % 520
            $script:scanH.Margin = [System.Windows.Thickness]::new(0,$script:scanY,0,0)
        }

        # ── FASE 3: Glitch RGB agresivo + slices (66-100) ────────────────
        elseif ($t -le 100) {
            $script:blackFlash.Opacity = if ($rng.Next(0,5) -eq 0) { 0.8 } else { 0.0 }

            for ($i=0;$i -lt 5;$i++) { $script:letterState[$i] = ($rng.Next(0,3) -ne 0) }
            $glitched = Get-GlitchedText

            $script:mainText.Text    = $glitched
            $script:mainText.Opacity = 0.85 + $rng.NextDouble() * 0.15
            $script:transMain.X      = $rng.Next(-10,10)
            $script:transMain.Y      = $rng.Next(-5,5)

            $script:glitchR.Text    = $glitched
            $script:glitchR.Opacity = 0.55 + $rng.NextDouble() * 0.45
            $script:transR.X        = $rng.Next(12,28)
            $script:transR.Y        = $rng.Next(-4,4)

            $script:glitchB.Text    = $glitched
            $script:glitchB.Opacity = 0.55 + $rng.NextDouble() * 0.45
            $script:transB.X        = $rng.Next(-28,-12)
            $script:transB.Y        = $rng.Next(-4,4)

            $script:glitchG.Text    = $glitched
            $script:glitchG.Opacity = $rng.NextDouble() * 0.35
            $script:transG.X        = $rng.Next(-6,6)
            $script:transG.Y        = $rng.Next(-8,8)

            $script:sliceTop.Text   = $glitched; $script:sliceTop.Opacity = 1.0
            $script:transSliceTop.X = $rng.Next(-30,30)
            $script:sliceMid.Text   = $glitched
            $script:sliceMid.Opacity = if ($rng.Next(0,3) -eq 0) { 0.0 } else { 1.0 }
            $script:transSliceMid.X = $rng.Next(-20,20)
            $script:sliceBot.Text   = $glitched; $script:sliceBot.Opacity = 1.0
            $script:transSliceBot.X = $rng.Next(-25,25)

            $script:scanY = ($script:scanY + 22) % 520
            $script:scanH.Margin  = [System.Windows.Thickness]::new(0,$script:scanY,0,0)
            $script:scanH.Opacity = 0.25 + $rng.NextDouble() * 0.35
        }

        # ── FASE 4: Letras se corrigen una a una (101-125) ───────────────
        elseif ($t -le 125) {
            $script:blackFlash.Opacity = 0.0
            $localT    = $t - 100   # 1..25
            $fixedCount = [Math]::Floor($localT / 5)
            for ($i=0;$i -lt 5;$i++) {
                $script:letterState[$i] = if ($i -lt $fixedCount) { $false } else { ($rng.Next(0,2) -eq 1) }
            }
            $txt = Get-GlitchedText
            $script:mainText.Text = $txt; $script:mainText.Opacity = 1.0
            $script:transMain.X   = if ($localT -lt 20) { $rng.Next(-5,5)*(1-$localT/20.0) } else { 0 }
            $script:transMain.Y   = 0

            $sliceAmt = [Math]::Max(0, 25-$localT)
            $script:sliceTop.Text = $txt; $script:transSliceTop.X = $rng.Next(-$sliceAmt,$sliceAmt+1)
            $script:sliceMid.Text = $txt; $script:transSliceMid.X = $rng.Next(-$sliceAmt,$sliceAmt+1)
            $script:sliceBot.Text = $txt; $script:transSliceBot.X = $rng.Next(-$sliceAmt,$sliceAmt+1)

            $cf = [Math]::Max(0, 1.0-($localT/25.0))
            $script:glitchR.Opacity = $cf*0.5; $script:transR.X = 18*$cf
            $script:glitchB.Opacity = $cf*0.5; $script:transB.X = -18*$cf
            $script:glitchG.Opacity = 0

            $script:scanY = ($script:scanY+12) % 520
            $script:scanH.Margin  = [System.Windows.Thickness]::new(0,$script:scanY,0,0)
            $script:scanH.Opacity = $cf*0.2
        }

        # ── FASE 5: Estabilización (126-138) ─────────────────────────────
        elseif ($t -le 138) {
            $inv = 1.0-(($t-125)/13.0)
            $script:mainText.Text = "NEXUS"; $script:transMain.X = 0; $script:transMain.Y = 0
            $script:glitchR.Opacity = 0; $script:glitchB.Opacity = 0
            $script:sliceTop.Opacity = $inv*0.6; $script:transSliceTop.X = $rng.Next(-6,6)*$inv
            $script:sliceMid.Opacity = $inv*0.4; $script:transSliceMid.X = $rng.Next(-4,4)*$inv
            $script:sliceBot.Opacity = $inv*0.6; $script:transSliceBot.X = $rng.Next(-6,6)*$inv
            $script:scanH.Opacity = $inv*0.1; $script:blackFlash.Opacity = 0
        }

        # ── FASE 6: Borde crece + versión (139-150) ──────────────────────
        elseif ($t -le 150) {
            $p = ($t-138)/12.0
            $script:sliceTop.Opacity = 0; $script:sliceMid.Opacity = 0; $script:sliceBot.Opacity = 0
            $script:mainText.Text = "NEXUS"; $script:scanH.Opacity = 0
            $script:border.Width   = [Math]::Round(394*$p)
            $script:border.Opacity = $p
            $script:version.Opacity = $p*0.95
        }

        # ── FASE 7: Flash cian (151-156) ──────────────────────────────────
        elseif ($t -le 156) {
            $script:border.Width = 394; $script:border.Opacity = 1
            $script:version.Opacity = 0.95
            switch ($t) {
                151 { $script:mainText.Foreground = [System.Windows.Media.Brushes]::Cyan  }
                152 { $script:mainText.Foreground = [System.Windows.Media.Brushes]::White }
                154 { $script:mainText.Foreground = [System.Windows.Media.Brushes]::Cyan  }
                155 { $script:mainText.Foreground = [System.Windows.Media.Brushes]::White }
            }
        }

        # ── FASE 8: Fade out (157-168) ───────────────────────────────────
        elseif ($t -le 168) {
            $script:splash.Opacity = [Math]::Max(0.0, 1.0-(($t-156)/12.0))
        }
        else {
            $script:timer.Stop()
            $script:splash.Close()
        }
    })

    $script:splash.Add_ContentRendered({ $script:timer.Start() })
    $script:splash.ShowDialog() | Out-Null
}

Show-GlitchSplash

# Inicializar

Load-AppsList

# Mostrar ventana principal

$window.ShowDialog() | Out-Null
