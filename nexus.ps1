#Requires -RunAsAdministrator

<#

.SYNOPSIS

NeXus WPF GUI v1.9.0 - Sistema de Automatizacion Multiplataforma

.DESCRIPTION

Interfaz gráfica moderna para NeXus usando WPF desde PowerShell.

Versión completa con todas las funcionalidades del programa original.

.VERSION

1.9.0

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

        Title="NEXUS v1.9.0 - Sistema de Instalación Multiplataforma"

        Height="750" Width="1200"

        WindowStartupLocation="CenterScreen"

        Background="#FF0F1419"

        FontFamily="Segoe UI"

        MinWidth="900" MinHeight="600">

    <Window.Resources>

        <!-- Colores del tema -->

        <SolidColorBrush x:Key="BgDark" Color="#FF0D0B1A"/>

        <SolidColorBrush x:Key="BgSidebar" Color="#FF13102A"/>

        <SolidColorBrush x:Key="BgCard" Color="#FF1A1535"/>

        <SolidColorBrush x:Key="BgHover" Color="#FF201840"/>

        <SolidColorBrush x:Key="AccentBlue" Color="#FF9D6FFF"/>

        <SolidColorBrush x:Key="AccentGreen" Color="#FF238636"/>

        <SolidColorBrush x:Key="AccentYellow" Color="#FFD29922"/>

        <SolidColorBrush x:Key="AccentRed" Color="#FFDA3633"/>

        <SolidColorBrush x:Key="TextPrimary" Color="#FFE8E0FF"/>

        <SolidColorBrush x:Key="TextSecondary" Color="#FF9080BB"/>

        <SolidColorBrush x:Key="TextMuted" Color="#FF6B5F9E"/>

        <SolidColorBrush x:Key="BorderColor" Color="#FF3D2F6B"/>

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

        <!-- Shimmer placeholder style -->
        <Style x:Key="ShimmerStyle" TargetType="Border">
            <Setter Property="Background">
                <Setter.Value>
                    <LinearGradientBrush StartPoint="0,0" EndPoint="1,0">
                        <GradientStop Color="#FF1A1535" Offset="0"/>
                        <GradientStop Color="#FF2A2050" Offset="0.5"/>
                        <GradientStop Color="#FF1A1535" Offset="1"/>
                    </LinearGradientBrush>
                </Setter.Value>
            </Setter>
            <Setter Property="CornerRadius" Value="8"/>
            <Setter Property="Margin" Value="0,0,0,8"/>
            <Setter Property="Height" Value="56"/>
        </Style>

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

                <Border Width="46" Height="46" Background="Transparent" CornerRadius="23" Margin="0,0,14,0" ClipToBounds="False">
                    <Grid>
                        <!-- Glitch layers (invisible normally) -->
                        <Image x:Name="LogoGlitchR" Width="46" Height="46" Stretch="Uniform" Opacity="0">
                            <Image.RenderTransform><TranslateTransform x:Name="TransLogoR"/></Image.RenderTransform>
                        </Image>
                        <Image x:Name="LogoGlitchB" Width="46" Height="46" Stretch="Uniform" Opacity="0">
                            <Image.RenderTransform><TranslateTransform x:Name="TransLogoB"/></Image.RenderTransform>
                        </Image>
                        <Image x:Name="LogoImage"   Width="46" Height="46" Stretch="Uniform" RenderOptions.BitmapScalingMode="HighQuality">
                            <Image.RenderTransform><TranslateTransform x:Name="TransLogoMain"/></Image.RenderTransform>
                        </Image>
                    </Grid>
                </Border>

                <StackPanel VerticalAlignment="Center">

                    <TextBlock FontSize="24" FontWeight="Bold" FontFamily="Segoe UI Light">
                        <Run Text="Ne" Foreground="#FFD8CCFF" FontWeight="Light"/><Run Text="X" Foreground="#FF9D6FFF" FontWeight="Black" FontSize="26"/><Run Text="us" Foreground="#FFD8CCFF" FontWeight="Light"/>
                    </TextBlock>

                    <TextBlock Text="Sistema de Instalación Multiplataforma v1.9.0" FontSize="11" Foreground="{StaticResource TextMuted}"/>

                </StackPanel>

            </StackPanel>

            <!-- Navigation Tabs -->

            <StackPanel Grid.Column="1" Orientation="Horizontal" HorizontalAlignment="Center">

                <Button x:Name="BtnInstalar" Content="Instalar Apps" Tag="📦" Style="{StaticResource HeaderButtonStyle}" Foreground="{StaticResource AccentBlue}"/>

                <Button x:Name="BtnDesinstalar" Content="Desinstalar" Tag="🗑️" Style="{StaticResource HeaderButtonStyle}"/>

                <Button x:Name="BtnEjecutar" Content="Mis Apps" Tag="▶" Style="{StaticResource HeaderButtonStyle}"/>

                <Button x:Name="BtnHardware" Content="Hardware" Tag="🖥️" Style="{StaticResource HeaderButtonStyle}"/>

                <Button x:Name="BtnSO" Content="Sistemas Operativos" Tag="💿" Style="{StaticResource HeaderButtonStyle}"/>

                <Button x:Name="BtnTweaks" Content="Optimizaciones" Tag="⚡" Style="{StaticResource HeaderButtonStyle}"/>

                <Button x:Name="BtnExtensiones" Content="Extensiones" Tag="🧩" Style="{StaticResource HeaderButtonStyle}"/>

                <Button x:Name="BtnInfo" Content="Info/Guía" Tag="ℹ️" Style="{StaticResource HeaderButtonStyle}"/>
                <Button x:Name="BtnTheme" Content="☀" Tag="🌙"
                        Style="{StaticResource HeaderButtonStyle}"
                        ToolTip="Alternar tema claro/oscuro"
                        Foreground="#FF9D6FFF" FontSize="15"
                        Padding="10,8"/>

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

                <!-- Vista: Mis Apps -->

                <Grid x:Name="ViewEjecutar" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Border Grid.Row="0" Background="{StaticResource BgSidebar}" BorderBrush="{StaticResource BorderColor}" BorderThickness="0,0,0,1" Padding="20,16">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="Auto"/>
                            </Grid.ColumnDefinitions>
                            <StackPanel Grid.Column="0">
                                <TextBlock Text="▶  Mis Aplicaciones" FontSize="20" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                <TextBlock Text="Apps del catálogo NeXus detectadas en tu sistema. Haz clic en ▶ para abrirlas." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap"/>
                            </StackPanel>
                            <Border Grid.Column="1" Background="{StaticResource BgCard}" CornerRadius="6" Padding="12,8" Margin="16,0,0,0" VerticalAlignment="Center">
                                <StackPanel Orientation="Horizontal">
                                    <TextBlock Text="🔍" Foreground="{StaticResource TextMuted}" Margin="0,0,8,0" VerticalAlignment="Center"/>
                                    <TextBox x:Name="SearchBoxEjecutar" Background="Transparent" BorderThickness="0" Foreground="{StaticResource TextPrimary}" CaretBrush="{StaticResource AccentBlue}" Width="200" FontSize="13" VerticalAlignment="Center"/>
                                </StackPanel>
                            </Border>
                        </Grid>
                    </Border>
                    <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" Margin="20">
                        <StackPanel x:Name="EjecutarAppsList"/>
                    </ScrollViewer>
                </Grid>

                <!-- Vista: Hardware / Escáner de compatibilidad -->

                <Grid x:Name="ViewHardware" Visibility="Collapsed">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <Border Grid.Row="0" Background="{StaticResource BgSidebar}" BorderBrush="{StaticResource BorderColor}" BorderThickness="0,0,0,1" Padding="20,16">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="Auto"/>
                            </Grid.ColumnDefinitions>
                            <StackPanel Grid.Column="0">
                                <TextBlock Text="🖥️  Escáner de Hardware" FontSize="20" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                <TextBlock x:Name="HwSubtitle" Text="Analiza tu equipo y descubre qué apps son compatibles con tu hardware." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap"/>
                            </StackPanel>
                            <Button x:Name="BtnScanHardware" Grid.Column="1" Padding="18,10" Cursor="Hand" BorderThickness="0" Background="#FF9D6FFF" Foreground="White" VerticalAlignment="Center" Margin="16,0,0,0">
                                <StackPanel Orientation="Horizontal">
                                    <TextBlock x:Name="BtnScanIcon" Text="🔍" Margin="0,0,6,0"/>
                                    <TextBlock Text="ESCANEAR"/>
                                </StackPanel>
                            </Button>
                        </Grid>
                    </Border>
                    <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" Margin="20">
                        <StackPanel x:Name="HardwareResultsList"/>
                    </ScrollViewer>
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

                                <Border x:Name="CardRendimiento" Style="{StaticResource AppCardStyle}" Margin="0,0,12,12">

                                    <StackPanel>

                                        <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                                        <TextBlock x:Name="IcoRendimiento" Text="🚀" FontSize="20" Margin="0,0,8,0" VerticalAlignment="Center">
                                            <TextBlock.RenderTransform>
                                                <TranslateTransform x:Name="TransIcoRendimiento"/>
                                            </TextBlock.RenderTransform>
                                        </TextBlock>
                                        <TextBlock Text="Rendimiento" FontSize="18" FontWeight="Bold" Foreground="White" VerticalAlignment="Center"/>
                                    </StackPanel>

                                        <TextBlock Text="Desactiva efectos visuales, optimiza servicios y activa plan de alto rendimiento. Ideal para equipos con hardware limitado."

                                                   TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,8,0,16"/>

                                        <Button x:Name="BtnTweakPerformance" Content="Aplicar optimización" Style="{StaticResource ActionButtonStyle}"/>

                                    </StackPanel>

                                </Border>

                                <Border x:Name="CardPrivacidad" Style="{StaticResource AppCardStyle}" Margin="0,0,0,12">

                                    <StackPanel>

                                        <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                                        <TextBlock x:Name="IcoPrivacidad" Text="🔒" FontSize="20" Margin="0,0,8,0" VerticalAlignment="Center">
                                            <TextBlock.RenderTransform>
                                                <TranslateTransform x:Name="TransIcoPrivacidad"/>
                                            </TextBlock.RenderTransform>
                                        </TextBlock>
                                        <TextBlock Text="Privacidad" FontSize="18" FontWeight="Bold" Foreground="White" VerticalAlignment="Center"/>
                                    </StackPanel>

                                        <TextBlock Text="Desactiva telemetría, diagnósticos, anuncios personalizados y Cortana. Mejora tu privacidad sin afectar el funcionamiento."

                                                   TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,8,0,16"/>

                                        <Button x:Name="BtnTweakPrivacy" Content="Aplicar privacidad" Style="{StaticResource ActionButtonStyle}"/>

                                    </StackPanel>

                                </Border>

                                <Border x:Name="CardGaming" Style="{StaticResource AppCardStyle}" Margin="0,0,12,0">

                                    <StackPanel>

                                        <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                                        <TextBlock x:Name="IcoGaming" Text="🎮" FontSize="20" Margin="0,0,8,0" VerticalAlignment="Center">
                                            <TextBlock.RenderTransform>
                                                <TranslateTransform x:Name="TransIcoGaming"/>
                                            </TextBlock.RenderTransform>
                                        </TextBlock>
                                        <TextBlock Text="Gaming" FontSize="18" FontWeight="Bold" Foreground="White" VerticalAlignment="Center"/>
                                    </StackPanel>

                                        <TextBlock Text="Activa Game Mode, desactiva Xbox Game Bar y optimiza para juegos. Mejora los FPS y reduce la latencia."

                                                   TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,8,0,16"/>

                                        <Button x:Name="BtnTweakGaming" Content="Aplicar gaming" Style="{StaticResource ActionButtonStyle}"/>

                                    </StackPanel>

                                </Border>

                                <Border x:Name="CardLaptop" Style="{StaticResource AppCardStyle}">

                                    <StackPanel>

                                        <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                                        <TextBlock x:Name="IcoLaptop" Text="💻" FontSize="20" Margin="0,0,8,0" VerticalAlignment="Center">
                                            <TextBlock.RenderTransform>
                                                <TranslateTransform x:Name="TransIcoLaptop"/>
                                            </TextBlock.RenderTransform>
                                        </TextBlock>
                                        <TextBlock Text="Laptop" FontSize="18" FontWeight="Bold" Foreground="White" VerticalAlignment="Center"/>
                                    </StackPanel>

                                        <TextBlock Text="Configura plan de energía equilibrado, reduce brillo automático y optimiza suspensión. Extiende la duración de la batería."

                                                   TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,8,0,16"/>

                                        <Button x:Name="BtnTweakLaptop" Content="Aplicar laptop" Style="{StaticResource ActionButtonStyle}"/>

                                    </StackPanel>

                                </Border>

                            </UniformGrid>

                            <Border x:Name="CardLimpieza" Style="{StaticResource AppCardStyle}" Margin="0,12,0,0">

                                <StackPanel>

                                    <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                                        <TextBlock x:Name="IcoLimpieza" Text="🧹" FontSize="20" Margin="0,0,8,0" VerticalAlignment="Center">
                                            <TextBlock.RenderTransform>
                                                <TranslateTransform x:Name="TransIcoLimpieza"/>
                                            </TextBlock.RenderTransform>
                                        </TextBlock>
                                        <TextBlock Text="Limpieza del Sistema" FontSize="18" FontWeight="Bold" Foreground="White" VerticalAlignment="Center"/>
                                    </StackPanel>

                                    <TextBlock Text="Elimina archivos temporales, vacía la papelera y libera espacio en disco de forma segura."

                                               TextWrapping="Wrap" Foreground="{StaticResource TextSecondary}" Margin="0,8,0,16"/>

                                    <Button x:Name="BtnTweakClean" Content="Limpiar sistema" Style="{StaticResource WarningButtonStyle}"/>

                                </StackPanel>

                            </Border>


                            <!-- Tarjeta Seguridad Profunda (Tron-style) -->

                            <Border x:Name="CardSeguridad" Style="{StaticResource AppCardStyle}" Margin="0,12,0,0">

                                <StackPanel>

                                    <StackPanel Orientation="Horizontal" VerticalAlignment="Center" Margin="0,0,0,8">

                                        <TextBlock Text="🛡️" FontSize="22" Margin="0,0,10,0" VerticalAlignment="Center"/>

                                        <StackPanel VerticalAlignment="Center">

                                            <TextBlock Text="Limpieza de Seguridad Profunda" FontSize="18" FontWeight="Bold" Foreground="White"/>

                                            <TextBlock Text="Basado en Tron Script — eliminación segura de malware, adware y residuos" FontSize="11" Foreground="{StaticResource TextMuted}"/>

                                        </StackPanel>

                                    </StackPanel>

                                    <Border Background="#FF1A0D2E" BorderBrush="#FF9D6FFF" BorderThickness="1" CornerRadius="6" Padding="14,10" Margin="0,0,0,14">

                                        <StackPanel>

                                            <TextBlock TextWrapping="Wrap" FontSize="12" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,6">

                                                <Run Text="✅ Fase 1 — "/>

                                                <Run Text="Limpieza de temporales y caché del sistema" Foreground="{StaticResource TextPrimary}"/>

                                            </TextBlock>

                                            <TextBlock TextWrapping="Wrap" FontSize="12" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,6">

                                                <Run Text="✅ Fase 2 — "/>

                                                <Run Text="Eliminación de adware/PUPs con Windows Defender" Foreground="{StaticResource TextPrimary}"/>

                                            </TextBlock>

                                            <TextBlock TextWrapping="Wrap" FontSize="12" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,6">

                                                <Run Text="✅ Fase 3 — "/>

                                                <Run Text="Limpieza del registro de entradas maliciosas conocidas" Foreground="{StaticResource TextPrimary}"/>

                                            </TextBlock>

                                            <TextBlock TextWrapping="Wrap" FontSize="12" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,6">

                                                <Run Text="✅ Fase 4 — "/>

                                                <Run Text="Reparación de componentes de Windows (DISM + SFC)" Foreground="{StaticResource TextPrimary}"/>

                                            </TextBlock>

                                            <TextBlock TextWrapping="Wrap" FontSize="12" Foreground="{StaticResource TextSecondary}">

                                                <Run Text="✅ Fase 5 — "/>

                                                <Run Text="Limpieza de DNS, Winsock y red" Foreground="{StaticResource TextPrimary}"/>

                                            </TextBlock>

                                        </StackPanel>

                                    </Border>

                                    <Border Background="#FF1A0A00" BorderBrush="{StaticResource AccentYellow}" BorderThickness="1" CornerRadius="6" Padding="12,8" Margin="0,0,0,14">

                                        <StackPanel Orientation="Horizontal">

                                            <TextBlock Text="⚠️" FontSize="14" Margin="0,0,8,0" VerticalAlignment="Center"/>

                                            <TextBlock Text="Se ejecuta en segundo plano. No elimina software legítimo instalado. Requiere privilegios de administrador. Se recomienda crear un punto de restauración antes." TextWrapping="Wrap" FontSize="11" Foreground="{StaticResource AccentYellow}" VerticalAlignment="Center"/>

                                        </StackPanel>

                                    </Border>

                                    <Button x:Name="BtnTweakSecurity" Content="🛡️  Iniciar Limpieza de Seguridad" Background="#FF1A0D2E"
                                            Foreground="#FF9D6FFF" BorderBrush="#FF9D6FFF" BorderThickness="1"
                                            Padding="18,10" HorizontalAlignment="Left" Cursor="Hand" FontWeight="SemiBold"/>

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
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>

                    <!-- Header -->
                    <StackPanel Grid.Row="0" Margin="20,20,20,0">
                        <TextBlock Text="🧩 Extensiones y Complementos" FontSize="26" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                        <TextBlock Text="Selecciona la plataforma y luego instala las extensiones que necesites." Foreground="{StaticResource TextSecondary}" Margin="0,0,0,16"/>
                    </StackPanel>

                    <!-- Tab selector -->
                    <StackPanel Grid.Row="1" Orientation="Horizontal" Margin="20,0,20,12">
                        <Button x:Name="BtnExtTabVS"     Content="💻 VS Code"   Tag="Selected" Style="{StaticResource HeaderButtonStyle}" Margin="0,0,6,0"/>
                        <Button x:Name="BtnExtTabChrome" Content="🌐 Chrome"    Tag=""         Style="{StaticResource HeaderButtonStyle}" Margin="0,0,6,0"/>
                        <Button x:Name="BtnExtTabFF"     Content="🦊 Firefox"   Tag=""         Style="{StaticResource HeaderButtonStyle}" Margin="0,0,6,0"/>
                        <Button x:Name="BtnExtTabPT"     Content="⚙️ PowerToys" Tag=""         Style="{StaticResource HeaderButtonStyle}" Margin="0,0,6,0"/>
                        <Button x:Name="BtnExtTabBrave"  Content="🦁 Brave"     Tag=""         Style="{StaticResource HeaderButtonStyle}"/>
                    </StackPanel>

                    <!-- Panels por plataforma -->
                    <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto" Margin="20,0,20,20">
                        <StackPanel>

                            <!-- VS Code panel -->
                            <StackPanel x:Name="PanelExtVS">
                                <TextBlock Text="Extensiones recomendadas para VS Code" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,12"/>
                                <UniformGrid Columns="2">
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,8,8">
                                        <StackPanel>
                                            <TextBlock Text="🐍 Python" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Soporte completo Python, IntelliSense, depurador." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtVS_Python" Content="Instalar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,0,8">
                                        <StackPanel>
                                            <TextBlock Text="✨ Prettier + ESLint" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Formateador de código y linter para JS/TS." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtVS_Prettier" Content="Instalar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,8,8">
                                        <StackPanel>
                                            <TextBlock Text="🔍 GitLens" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Historial Git, blame y comparación de ramas." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtVS_GitLens" Content="Instalar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,0,8">
                                        <StackPanel>
                                            <TextBlock Text="🐳 Docker" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Gestión de contenedores Docker directamente en VS." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtVS_Docker" Content="Instalar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,8,0">
                                        <StackPanel>
                                            <TextBlock Text="⚡ Live Server" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Servidor local con recarga automática del navegador." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtVS_LiveServer" Content="Instalar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,0,0">
                                        <StackPanel>
                                            <TextBlock Text="🔧 C/C++ + Arduino" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Soporte C/C++ e integración con placas Arduino." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtVS_Cpp" Content="Instalar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                </UniformGrid>
                                <Button x:Name="BtnExtVSCode" Content="📦 Instalar TODAS las extensiones VS Code" Style="{StaticResource ActionButtonStyle}" Margin="0,16,0,0" Padding="20,12"/>
                            </StackPanel>

                            <!-- Chrome panel -->
                            <StackPanel x:Name="PanelExtChrome" Visibility="Collapsed">
                                <TextBlock Text="Extensiones recomendadas para Google Chrome" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,12"/>
                                <UniformGrid Columns="2">
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,8,8">
                                        <StackPanel>
                                            <TextBlock Text="🛡️ uBlock Origin" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Bloqueador de anuncios y rastreadores eficiente." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtCh_uBlock" Content="Instalar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,0,8">
                                        <StackPanel>
                                            <TextBlock Text="🔐 Bitwarden" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Gestor de contraseñas open source." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtCh_Bitwarden" Content="Instalar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,8,8">
                                        <StackPanel>
                                            <TextBlock Text="🌙 Dark Reader" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Modo oscuro para todas las páginas web." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtCh_DarkReader" Content="Instalar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,0,8">
                                        <StackPanel>
                                            <TextBlock Text="⚛️ React DevTools" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Inspección de componentes React en el navegador." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtCh_React" Content="Instalar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                </UniformGrid>
                                <Button x:Name="BtnExtChrome" Content="🌐 Abrir Chrome Web Store" Style="{StaticResource ActionButtonStyle}" Margin="0,16,0,0" Padding="20,12"/>
                            </StackPanel>

                            <!-- Firefox panel -->
                            <StackPanel x:Name="PanelExtFF" Visibility="Collapsed">
                                <TextBlock Text="Extensiones recomendadas para Firefox" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,12"/>
                                <UniformGrid Columns="2">
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,8,8">
                                        <StackPanel>
                                            <TextBlock Text="🛡️ uBlock Origin" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Bloqueador de anuncios para Firefox." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtFF_uBlock" Content="Instalar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,0,8">
                                        <StackPanel>
                                            <TextBlock Text="🔐 Bitwarden" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Gestor de contraseñas para Firefox." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtFF_Bitwarden" Content="Instalar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,8,0">
                                        <StackPanel>
                                            <TextBlock Text="🌙 Dark Reader" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Modo oscuro para Firefox." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtFF_DarkReader" Content="Instalar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,0,0">
                                        <StackPanel>
                                            <TextBlock Text="🎬 Vimium-FF" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Navegación por teclado estilo Vim." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtFF_Vimium" Content="Instalar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                </UniformGrid>
                                <Button x:Name="BtnExtFirefox" Content="🦊 Abrir Firefox Add-ons" Style="{StaticResource ActionButtonStyle}" Margin="0,16,0,0" Padding="20,12"/>
                            </StackPanel>

                            <!-- PowerToys panel -->
                            <StackPanel x:Name="PanelExtPT" Visibility="Collapsed">
                                <TextBlock Text="Módulos de Microsoft PowerToys" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,12"/>
                                <UniformGrid Columns="2">
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,8,8">
                                        <StackPanel>
                                            <TextBlock Text="🔍 PowerToys Run" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Lanzador rápido de aplicaciones (Alt+Space)." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtPT_Run" Content="Configurar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,0,8">
                                        <StackPanel>
                                            <TextBlock Text="🎨 Color Picker" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Selector de colores en pantalla (Win+Shift+C)." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtPT_Color" Content="Configurar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,8,0">
                                        <StackPanel>
                                            <TextBlock Text="📐 FancyZones" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Organización avanzada de ventanas en zonas." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtPT_Zones" Content="Configurar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,0,0">
                                        <StackPanel>
                                            <TextBlock Text="⌨️ Keyboard Manager" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Reasigna teclas y atajos de teclado." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtPT_Keyboard" Content="Configurar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                </UniformGrid>
                                <Button x:Name="BtnExtPowerToys" Content="⚙️ Abrir PowerToys" Style="{StaticResource ActionButtonStyle}" Margin="0,16,0,0" Padding="20,12"/>
                            </StackPanel>

                            <!-- Brave panel -->
                            <StackPanel x:Name="PanelExtBrave" Visibility="Collapsed">
                                <TextBlock Text="Extensiones recomendadas para Brave Browser" Foreground="{StaticResource TextSecondary}" Margin="0,0,0,12"/>
                                <UniformGrid Columns="2">
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,8,8">
                                        <StackPanel>
                                            <TextBlock Text="🔐 Bitwarden" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Gestor de contraseñas compatible con Brave." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtBr_Bitwarden" Content="Instalar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                    <Border Style="{StaticResource AppCardStyle}" Margin="0,0,0,8">
                                        <StackPanel>
                                            <TextBlock Text="🌙 Dark Reader" FontSize="15" FontWeight="Bold" Foreground="White" Margin="0,0,0,4"/>
                                            <TextBlock Text="Modo oscuro para Brave." Foreground="{StaticResource TextSecondary}" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                            <Button x:Name="BtnExtBr_DarkReader" Content="Instalar" Style="{StaticResource ActionButtonStyle}"/>
                                        </StackPanel>
                                    </Border>
                                </UniformGrid>
                                <Button x:Name="BtnExtBrave" Content="🦁 Abrir Chrome Web Store en Brave" Style="{StaticResource ActionButtonStyle}" Margin="0,16,0,0" Padding="20,12"/>
                            </StackPanel>

                        </StackPanel>
                    </ScrollViewer>
                </Grid>

                <Grid x:Name="ViewInfo" Visibility="Collapsed">

                    <ScrollViewer VerticalScrollBarVisibility="Auto" Margin="20">

                        <StackPanel MaxWidth="800">

                            <TextBlock Text="ℹ️ Acerca de NeXus" FontSize="28" FontWeight="Bold" Foreground="White" Margin="0,0,0,8"/>

                            <TextBlock Text="Sistema de Instalación Multiplataforma v1.9.0"

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

            <Button x:Name="BtnSalir" Grid.Column="3"
                    Margin="0,0,10,0" Padding="0"
                    Cursor="Hand" BorderThickness="0" Background="Transparent">
                <Button.Template>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="ExitBorder"
                                Background="#1ADA3633"
                                BorderBrush="#66DA3633"
                                BorderThickness="1"
                                CornerRadius="8"
                                Padding="14,0">
                            <StackPanel Orientation="Horizontal"
                                        VerticalAlignment="Center"
                                        Height="38">
                                <!-- Icono power -->
                                <Border Width="22" Height="22"
                                        CornerRadius="11"
                                        Background="#33DA3633"
                                        Margin="0,0,9,0"
                                        VerticalAlignment="Center">
                                    <TextBlock Text="&#x23FB;"
                                               FontSize="12"
                                               Foreground="#FFDA3633"
                                               HorizontalAlignment="Center"
                                               VerticalAlignment="Center"/>
                                </Border>
                                <!-- Texto -->
                                <StackPanel VerticalAlignment="Center">
                                    <TextBlock Text="SALIR"
                                               FontFamily="Segoe UI"
                                               FontSize="11"
                                               FontWeight="Bold"
                                               Foreground="#FFDA3633"/>
                                    <TextBlock Text="nexus v1.9.0"
                                               FontFamily="Consolas"
                                               FontSize="9"
                                               Foreground="#88DA3633"/>
                                </StackPanel>
                            </StackPanel>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="ExitBorder"
                                        Property="Background" Value="#33DA3633"/>
                                <Setter TargetName="ExitBorder"
                                        Property="BorderBrush" Value="#CCDA3633"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="ExitBorder"
                                        Property="Background" Value="#55DA3633"/>
                                <Setter TargetName="ExitBorder"
                                        Property="BorderBrush" Value="#FFDA3633"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Button.Template>
            </Button>

            <Button x:Name="BtnInstalarSeleccionadas" Grid.Column="2" Background="{StaticResource AccentGreen}" Foreground="White"

                    BorderThickness="0" Padding="24,10" Margin="0,0,20,0" Cursor="Hand" IsEnabled="False" Opacity="0.5">

                <StackPanel Orientation="Horizontal">

                    <TextBlock Text="🚀" Margin="0,0,6,0"/>

                    <TextBlock Text="INSTALAR SELECCIONADAS"/>

                </StackPanel>

            </Button>

        </Grid>

        <!-- Toast notification overlay -->
        <Border x:Name="ToastContainer"
                VerticalAlignment="Bottom" HorizontalAlignment="Right"
                Margin="0,0,20,20" Padding="16,12" CornerRadius="8"
                Background="#EE1A1535" BorderBrush="#FF9D6FFF" BorderThickness="1"
                Opacity="0" IsHitTestVisible="False" Panel.ZIndex="999">
            <StackPanel Orientation="Horizontal">
                <TextBlock x:Name="ToastIcon" FontSize="16" Margin="0,0,10,0" VerticalAlignment="Center"/>
                <StackPanel VerticalAlignment="Center">
                    <TextBlock x:Name="ToastTitle" FontSize="13" FontWeight="SemiBold"
                               Foreground="#FFE8E0FF" FontFamily="Segoe UI"/>
                    <TextBlock x:Name="ToastMsg" FontSize="11"
                               Foreground="#FF9080BB" FontFamily="Segoe UI"
                               TextWrapping="Wrap" MaxWidth="280"/>
                </StackPanel>
            </StackPanel>
        </Border>

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

# ── TOAST ELEMENTS (resolved after window loads) ──────────────────────
$script:_toastEl      = $window.FindName("ToastContainer")
$script:_toastIconEl  = $window.FindName("ToastIcon")
$script:_toastTitleEl = $window.FindName("ToastTitle")
$script:_toastMsgEl   = $window.FindName("ToastMsg")
$script:_toastTick    = 0
$script:_toastWait    = 25

# Single persistent DispatcherTimer for toast fade
$script:_toastTimer          = New-Object System.Windows.Threading.DispatcherTimer
$script:_toastTimer.Interval = [TimeSpan]::FromMilliseconds(100)
$script:_toastTimer.Add_Tick({
    $script:_toastTick++
    if ($script:_toastTick -le $script:_toastWait) { return }
    $fadeTick = $script:_toastTick - $script:_toastWait
    $o = [Math]::Max(0.0, 1.0 - $fadeTick * 0.10)
    if ($script:_toastEl) { $script:_toastEl.Opacity = $o }
    if ($o -le 0) {
        $script:_toastTimer.Stop()
        $script:_toastTick = 0
    }
})

# ── THEME STATE ────────────────────────────────────────────────────────
$script:isDarkTheme = $true

# ── TOAST SYSTEM ──────────────────────────────────────────────────────
function Show-Toast {
    param(
        [string]$Title,
        [string]$Message,
        [string]$Icon = "OK",
        [int]$DurationMs = 3000
    )
    if (-not $script:_toastEl) { return }
    try {
        $script:_toastIconEl.Text  = $Icon
        $script:_toastTitleEl.Text = $Title
        $script:_toastMsgEl.Text   = $Message
        $script:_toastEl.Opacity   = 1.0
        $script:_toastWait    = [Math]::Round($DurationMs / 100)
        $script:_toastTick    = 0
        if ($script:_toastTimer -and $script:_toastTimer.IsEnabled) {
            $script:_toastTimer.Stop()
        }
        $script:_toastTimer.Start()
    } catch {}
}

# ── SHIMMER LOADER ─────────────────────────────────────────────────────
function Show-Shimmer {
    param($ListControl, [int]$Count = 6)
    $ListControl.Children.Clear()
    for ($s = 0; $s -lt $Count; $s++) {
        $sh = New-Object System.Windows.Controls.Border
        $sh.Style = $window.FindResource("ShimmerStyle")

        # Animate shimmer offset with a simple timer-driven gradient shift
        $ListControl.Children.Add($sh)
    }
}

# ── THEME TOGGLE ───────────────────────────────────────────────────────
function Apply-Theme {
    param([bool]$Dark)
    $res = $window.Resources
    if ($Dark) {
        $res["BgDark"]    = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FF0D0B1A")
        $res["BgSidebar"] = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FF13102A")
        $res["BgCard"]    = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FF1A1535")
        $res["BgHover"]   = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FF201840")
        $res["BorderColor"]   = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FF3D2F6B")
        $res["TextPrimary"]   = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FFE8E0FF")
        $res["TextSecondary"] = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FF9080BB")
        $res["TextMuted"]     = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FF6B5F9E")
        $window.Background    = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FF0D0B1A")
        $window.FindName("BtnTheme").Content = "☀"
    } else {
        $res["BgDark"]    = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FFF0EDF8")
        $res["BgSidebar"] = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FFE4DFF5")
        $res["BgCard"]    = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FFFFFFFF")
        $res["BgHover"]   = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FFD8D0F0")
        $res["BorderColor"]   = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FFBBAAE0")
        $res["TextPrimary"]   = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FF1A1035")
        $res["TextSecondary"] = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FF4A3880")
        $res["TextMuted"]     = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FF7060A0")
        $window.Background    = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#FFF0EDF8")
        $window.FindName("BtnTheme").Content = "🌙"
    }
}

# Cargar la imagen del logo

$logoImage = $window.FindName("LogoImage")

# Logo embebido como base64 (no requiere archivo externo)
$logoB64 = "iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAAWh0lEQVR42u1dXWwc13X+zp3ZJSUgDyFpCHoQgiLyT1GboeyHQkH6EMBIY0ukRP+rahtboNXqJ5Yby1bcxmpiJ41kS23kynZjq7aLVHVr2ZbINSXHSOGHtjGKwrYsuahB0igCPxiCKQZFAHHJnbmnD/femTvD2V/uLneGvNJiluTuLDnfd77z3bt7zwFWxspYGStjZayMlbEyVsayG5T1P/CGnhEiEIgEAAKBIn82gcBg6xmsv2YwSzAYF2dO8AoBUgS4IAGCAPRR3QigkADfP3C0YD/v+4f3D8IADwaY9T0JhgRYHSXLTBGC0g/4DiI4IHKgjgICQke8Bp9EADyB8L1HflRIOtcPn/zeYEQBAhWQACSYJaQ+Mnww+2D4uDjzIq8QoI3j+p4dJDToQgMvyLXAdoL7CnQBIkWAR/c/VgCAG7+BTfY5338b4wBw6MgPB8MUwBr8kAgKeKMGHhg+JCsySPj4KGVkoHRF+wgJciHIgYAbRL0Iot+xSGAdoYjw8EP7E8GPk+DI0aNDDGZYKSAgQHD0Q/BhCOBBsg/JXmrShNv50X4fCbhQwLs60hUJiFyImPwTBAQc+qO7Hvplwumma7ooYhW23bH73fj3f/bq0a9K8pljaUDCB7MCn8mDZA8DvbtIsgcJDx/NvMQrBGhI5l0IykXAjxAAdgpwyCbBYsa2O3ZfU44YDEnMEkw+JPusjwiOUASwb/09O0kRofPSg+hE8Pt7dlKOViEn7Ntq5Gg1XFqtvqZVyInV5IrVpI6r4IpVcEkdk8alT3HClvok+TePKUcAc35XRF/f/L4uqd8zJ1ZHf39ahf6enbSiABWBv59UxOfg6GOgAFYaIHIo6gGixu+24e3XlHuNS5/ixJp1GEkigQX+dYkXi7qJSXLgA8iH1GrA7JOEB2afg+innFaBEiSXQOxioHc3SS7hwswLHaEGHcPIgd5dMfDzGvhICiCVAuLGzwGRoOGtd19tnfLlhJf5XX0cX7NuAfjGGA7r43cTnn/v6JnXJy1jyPZ0UAZHD5K9kAgo6e/Nw9dkkFzC+cvP8bInQH/PTnJEHg7lQ/CRgxB5HfU5Cgigo96QQCmBAJGDoS3DNvjxCD5tgAdUlO97dv1J+wHHdk/dBOAIsIAIZnxsf1EYHZ00swG1NuCzAT+cEZhbiSU8SDkPiVJAAp/n4ct5XJh5npclAQZ6d5ECPkYApQAR4C35B8EJ1gEGt2y5Onba68oADwAn4sAnkOA6ACO1EGF87OxksC5gZgPwmdkPwY8QYZ4V8CEBlCrML5kaLBkBNvTtIYe6EBIgZx1zKh0Es4BgykeGBJuHBisBb8CvCfgyRDiiv0wiQkQNzo69NcUw00MNPnw2U0PJJU2EEiSXWBHApANFAJ/n8MH0M7wsCHBj3wPkBFHfBYdycEReA5+HY03/iFw9HXTqAT6Q+3qAr4EIFdPCucLPp5glazOowIcHDvxACT6UF5BcYl8aEsxpEszj/emnObMEUJKvol4Bru+ryNcmMDB/JIJ8rwhw69Ati8rzTSBCTf7gXOHtKTUbsNcFfEiU2JhBnQrYAC95DooQSg3alRLaRoCBvt3koAuO6IJLXUHedyivfIDQ5k9FPjmUM2v8dOvQLetrzPNNBT6BCNtr9QcWESDZY4avo91jlRJKkLJkIp+NH/B4Dr6cg485nJ9+ljNBgA29e8gRXVDRr2/K+ZOd/0PgXTjk4tahW5tm8JpIgmpGMUKCtwr/OsV6fcBnDwzPIkLEB+iUMBfe5Bw+uNxaX9ByAmzo20sOqahXwAfGT6cDY/5cIsrBIRebhja3zODZY++mk/uOj28/1h4i/GJKvXvoKSJwCb5FAp/nILUS+FIRwNNE+GD6OKeSACH43QgVIA+HuqzpXy5YABrcMnR1wmmaLvd7N53cBwDHx7cfs+83yShWJMK5wttT0jKFxgtYswE2PsCXc/C42FISUHvB74JLXSSEbfyU6avi7psOfD0/q9Mf1DRjODv21pRtCo0hlHIeHs+xnQZaSYKWEEDl/O4AfH0kB3k4osuK/DyGtmxdUuBbSISajOL42JuTvkUCaVIA5uHLOfa4GJJAFpvuCZpOgIHe3eSKbjjUDXW0CBDM/fO0deudbTF4jeb5FhPh4/jjC6NnJrUhDKaGAQF4Dp4swuciPFnE+cvNmx1Qc8HfFUR+QAJl/IL5f5l36q4rZ/DaEfWtOk+9RrEwOjqpp4O2D2BlBhX4RgmatU7QVALc1PdgUvSTcf4J4C+p3HcqEc6cOTVpzwg8LnJcBd6b/klnEeDGvgdIRf4qTYAuOBr8u27b0XLgFzuta9PUMW4UKxLhjdMnJ4KFIS6yJ40SzMLjYlOWjZtCgA19e2Pgd8OhbvqDhR+tqgh8p0V9G/xBEhEW+INXX//7CZ0GOFQBRYLFzgwWTYCB3l3q41jUDUcf//iu/ddWyPMLDF5agG/z1HEBEf7pteMTnizqmYEigCdnF+UHFk2AN4/wm+b+k0efHPzWXY9cmxaDl0Z/cPLU0xPf+c4DY+brg4ceHHx/+lj7CWADHx+XPsX+NOf5JSLCdn23LBHWrAtWHBeMzftp85IQwN5kkfDJ2tTm+U4kwpp1Kl0kXfO2EiAJ/AQSbFpuwLdyxrBmnbqula55IyRo5cfCMy33tYzFvNlkrpmlCC0ZrSTAopZv0xr1SSRYzN+079n1J2NqUGEhbh+9V6chrDsFbOjdQ65Yhb888FShkgdYbnLfjr/xn3889U65a/6jpw4OqrWB2bo+XFqXAvT37tQf1c4tyD9J8rXUwB/bPfWlfc+u/1WWFKHcNVefqfAg2EN/7066cLm2vQZ1KcBA7x7K6X1xI/c8fq12pkes6d+JRsBvBfAA1gL4TBPyV1lRhGO7p7ab2QAAnPga+gDg8tZDGz2+Ak/OoiRncb7Gt42p9ui/n8zGTFesxo67H7vWWugxU5bhWgnQhFW0Lw19G59Xe9zY3+KqxZCgXa9T6/XQfuA0gPHCNgW+GZ9vfWKjIsAVeDyLWlSg5hQQ7s5RGzaWIgdmedip4fj49mM3/9vUc0mPKwBfA3AU6hgZV5157N1LWw5uFORCcG0Y1fSosDJHuE2rE6Z1OurWAvjy0Ldx+h1rY/dvZjEM4BM7FTTrdWI/M6/T1PGL31u/q5ICFLbhPysHqov+nhG6UKVSSU31AeKbM4k6s67E162J0hdW4TSAL8d8QWbG4CsLq538321/s5FieymrK3tNBHD07hxDBCdtxaXWZjFtDL6CQ+b+lTte+CrBieymomYQoL/nfiJrb55RgU4dy0kFNAnuHXwF95pt8+EWeoXVV3orVyURtUR/rCATCXLTeK3WZpUECkhdLENXTwlwq2LzRGXzt4MIuiIHLBJ0ZmmhWlQgk6kAgFZnJ1DqADdy0N8zQg0RgOxijORAQJBmWcdfED0LWDapwC6XI+AEOJnvN0YA0gWYggKM+ggnzddqbTYVQFBQHHOBGjRAgBt67lNlWJBQjZNEKi7KclKBpDK5JnVXSgOisqTY1bbjpVdTMT5ZLipglJkCxY6XzXXqUwD7ifqkZJ0wNesAy0UFdEV0soKVAkWg8sY98bvXf/Feiuf8eBHmFI1loQLJRbKdSCDfkJAGRMXoD0yFqbUvdMX9dC0ELgcVUJiEvREMbtVStyjrDe1a+1btfVCqPACg3gj6JPOLQ2QHp7m/0MPVpgCgKOiRE0Z77mRABdZmRQHsrigKWgGQUYZk5V5AgN/54rfIlnr9j0ISqFOlbHwG4JNspwKDkbDxozBoFSHiPsBNziX2zeq2pb2AOiKNJKi0OPRZ6hWAoPpeEQEcxTH8J6qlAB3jFMa+MYHRWzpHxlUgCNIohuWxW6gAiWBTjEupHRlWAYo4gZAQALh88ha1nDRIMeaEKaSA/WHNTKoAlcEtwC/xgZUIQAHeGesumfFpIUUoQAt8XVUFyCDk9anA2tQLQMXvVlUA1rdMj8xNC7nm73KtKYDN/0zRwVKBqqkgnYMjYWya4JZDUlQ/mX4Sc0CKtFMik4aQy6k4x37OlaeBzAwQV+AQZ0kRMjQttBpex1Q8bIStGuJW9QDqgeZJmhSI35aFIUyf/DMnYFgeOzcB/tiDZRj3Rh04UyYxEypggjWSrmO6zTDd0CsowH//+h9U96voP0b4Pc5KEsjWtNBgJG38gvsqkOWCruaiLJt0h2yjAsH3sjlNrDotTIUCRFyaAlypgQzSQY2zAAmwkX4ZJYPum7syLew0BkiLBHbAyhiGNRAgaI6sn2RMhJ0asjSyYAgD4A0R2ES9jOBZEwE++vXLQRdM9UQ/eiKWyOiopAIdToAoPgFuwff8Bfm/4kKQ/UTdG5etk2fOBKRdBXTkc6SzORsS+GXTtlueURp4iqUDypYHqHNa2NkKYDWyXqjafuLzyirAxZmXWHfDhmqL7odsymgKSLMKhGD7kftSY1euVIxbWVZ8SMMoso7wkfGROhVglmGK5hB4owblhqjMKj/ogq1OKpn1/ayOKirQwQoQgq1a14dfV8KrIgEuzrzIDC+QEmZPHbPtAaotDnWoAsSj3gtSd6VKYVW3+MhAATT47LNkD4VteLmwDS9nXAVSMy2UgT/zWcILcYNX8XlVCXBh5gVmfULFMg9feH3PL83PC9vw3eWUCuxahB2nAOxBqk7ligDw8GGVaqE1bfIzTJLsoef0gXfjP4+XLF1ZHFoCBVD5nqUmgmpZ71V9nlvbyRX4ksqfsLBNlS+9eVtyidNylS87XQXMp4J+M4th4wHeOREtRNUZJlBhxFoFDGZNIcDFmRM80LuLJHu4tOXgxjWjj0dUQFetfAhVikU3o117VqeFi70uQZBa4FcrE1szAZTJMCcu4fOtT2y86sxj7wLAyL9jGusAAOOXPq1+nmbUyzejUhVvU9PXVPFezGjl6zRyHUz/IAAjukMbJHtsgy/h1XSuhvsF/MXDjxfKPe6eR9d/vR3M/9//mVpd7TG/9dvrryyWAK16nXqLZ5uOIUnj8JFDg430C6ir5KdECZJdSA47hiS1Lzm2e2p7rX0D4mXS6/l9mgFura/TzO4jjZDe7huUdM0VNib6SzX/Lg31DHri0eML+gXFf6FGu4ek0B+0/O+zu4RUuuY/OPzwYEt7BgHAB5efYeB4LQ8dMS3PGlGDLBFhMcDXZwRLdYHfEAHqGIapJ5YzERpJbTHgTTue8WrPe6+BHsKpaB2bxgaSTYh6u3XsOIATlVrHHjy0b/D96afbT4CkUaZ59KK6hqdFDZoEPKyoN4HTWc2jk4hg5qSxcV2CGmSSCE2UeyDsHP5xwjpAQIQfHH5k8L8+f6r97eODaWDfPsqJVXCoG65YBZe6afudD1xTIxEWlRY6hQitkPty4J889fSEx0X25Cx8LqIkZ/F+A7m/aQQY6N1FGng4+uiKbnKoG3ffPnJNGRIkEiFt7WZbKffx5/zL6ycmfC7Ck0X2uAhfzsLjIjw5i/OXn1s6AgDAhr695GoFUErQDYe6yaUuOKILtw//YVuI0C4SNBn4inL/+ul/nPDlHDyeg89F9mQRvgbe4yI+mD6+qE9oN60WzI19D8RI0AWHuskRXXCpC7cNb6+UFlJjFBslWhm5H7YesgD8N06fnPB4Dr404M9FwG/E9beMAABwU9+DpKNfq0AXXE0Ch/IQlKetW++8Oo1poZ15/syZU5OS59nneajoL7LPcwijv4j3pn/SlL0ZTSXAQO8uckS38QGKCCoNkEMhCRzKY3DLllQQoZ15vjA6OunzPALwVfSzln94sgiV/4uLyvstI4Aiwe4kFdAkyFskyEFQDpuGNrWFCI2QoJ1yXxg9M+lzyQJ/XoNfRDz6z19+tmk7s1pSD25D755ACZQH0ARAHo7ogqA8HMqROrrYNLS5Egna7g+aLPcVgR8fe3PSZw+S5+FziaWWfR8WAVQagC+L+r2Y5o2WFQTc0LeXrOiHSgFdcKmLhFBKYEigOl7m6Nahb66vUQ0A1P9uYzVw25nnz469NSVRYmmB7/M8pJyHx3Ps85xJATAqsFjH31YClCdBHg6pdBAqgUoHujcx3TL4jVqJ0BR/sBivYL9Pn5Dny0T92Unz6SrJpTDyVd63839LwW85AaIk0AQQthnsgvICeTjkElEOjmp8TIJcfHPw5rYQoV15/uzYW1MMj332wFyCz54GvgSf52A7f5/N3L914LeFAKEnCNOAIkIeDuW1D1AkEOSSQzkQXEUEcuiWwd9fX48/aIQErZb7c4WfTzH7Cnh4UGYvBF9HP/tSR74l/83O+UtCAAAY6NtNDrpgFoYEGR+gpoVC5CAQpAJNBAeCXCJyUEdaaBkRLLlPAn4B+OcKb0/pDRvM8C3gS+ojXLKkZV9FvuR5BAs/mMP56WdbXoehrVWhB3p3BesBjshDBJ7A9gKhKRS6JbrVvr4t/qAZef7s2LlJe0ON2qkTmj6T+82UT/IclAIoFWjWPL+jCGAvG4drAsoHKELoqSHcwBQSuUE7dNUT1wWRiKeGpLQQEKFREjSW589NxrdnMXtsTJ+PgABa8ksKfE2EZizvdjwBlDncY68OWmYwp4mQgwiIELSuJ0UK1ciyyiLSoohQr9yPj41Pmkoc6pO5PrOJfC7pfRUlBXyQ94P8r83eM20vvbOkjQFUSsgHfkBQzhAAgvKkp4WaCC5C8B3V2Fq3td08NFjXQlIlIjQi94XR0UmzPZv13vyknTqS51lLv04B8wEB2iX5HUUAAOjv2Ul6RqAJkFeAi7xRgAgRKPAFDkTQz1gpQuz9hYpqEPcHCcBXlfux0dOTpgCTZJ/Vfnwv2EUdAl9Su3bkPCQ8Dbw2gHIeF2aeX7KiWx3TGmSgdxfFFMCYwSD6Ban1AT07sHrjOqpZMhwQEbZsuf1qILF2wSGbCGvWhT/Q29ps4JO2vd8LAGfOvDapCzJxWIrN7MoNop/tjRox8wfJpSWL+o4kgFKD+4NVwZAIuaQ0QEYNtBJYzZIJBIeGh+/5jzIEgPl0bdKwPtGcSIA3Tp+cUAUYg8gPS+ko88cL5b8UAV5yCRdmXuiIUntuJxHAXJT+np3EwoPgkrVEnINgV5lBclgTgIgcCHasTucCBFHu4n5sp4akj1eXk3sAOPXGSxPx0mtJlTnCLdqlkADw4MvSksp90ujILtAXZp7nkt7kWJKzesPjFZT4CoINkOrI1g3hrVj23OW2WJmvK6mDJ4uIvk74+vr3gcfq9yzJcKOmuXUa+B2nAPb4aOZFBoDre+4jya79ZpEygqzvswCRC2KHBQn9tZOY2l557bmJB/+s8ToVHs8GFVNlUIXT06nALs/iRSL/o5mXOrayascSICRCePH6e0aIghmBY9IByKQAdqBI4PDLr/54IwV9j4XpiFqT5/nZqb+eAHijKbYMcLT4YqQEa7SIlqnSUUtxhk4YqWwQeEPPDjJLxGp10LEMobBmB5oAJCKt1Q/s//NCOQ9w+MhfDdp195krEyDwANrwXdTKlZbhppEA9kW+oWeEhAaf4ECwXhdgASLVMp3YIoAlAjHjp2W+aJXHNwoQN34yUkTzYkqiPTMKUGl8pfdPyFYAggBIp4FY++uDBw4HVU4eP3xgEECk6wbrjhuRYtnw8eHln2amWno2e8RGCPGnFE8BdkddM+x2i/EU8OHlv8t8K9WVsTJWxspYGStjZSyv8f92c6uRUCC0JwAAAABJRU5ErkJggg=="
$logoBytes  = [Convert]::FromBase64String($logoB64)
$logoStream = New-Object System.IO.MemoryStream(,$logoBytes)
$logoBitmap = New-Object System.Windows.Media.Imaging.BitmapImage
$logoBitmap.BeginInit()
$logoBitmap.StreamSource = $logoStream
$logoBitmap.CacheOption  = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
$logoBitmap.EndInit()
$logoStream.Close()
$logoImage.Source = $logoBitmap

# Apply same source to glitch layers
$logoGlitchR = $window.FindName("LogoGlitchR")
$logoGlitchB = $window.FindName("LogoGlitchB")
if ($logoGlitchR) { $logoGlitchR.Source = $logoBitmap }
if ($logoGlitchB) { $logoGlitchB.Source = $logoBitmap }

# Color tint for glitch layers via OpacityMask
$logoGlitchR.OpacityMask = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#88FF2244")
$logoGlitchB.OpacityMask = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#882255FF")

# ── Logo glitch: fires every ~3 min, runs 0.8s intense glitch ────────
$script:_lgRng      = New-Object System.Random
$script:_lgFrame    = 0
$script:_lgActive   = $false
$script:_lgMain     = $window.FindName("TransLogoMain")
$script:_lgR        = $window.FindName("TransLogoR")
$script:_lgB        = $window.FindName("TransLogoB")
$script:_lgImgR     = $logoGlitchR
$script:_lgImgB     = $logoGlitchB
$script:_lgImg      = $logoImage

# Fast glitch timer (50ms) — only active during glitch burst
$script:_lgFastTimer = New-Object System.Windows.Threading.DispatcherTimer
$script:_lgFastTimer.Interval = [TimeSpan]::FromMilliseconds(50)
$script:_lgFastTimer.Add_Tick({
    $script:_lgFrame++
    if ($script:_lgFrame -gt 16) {
        # End glitch — restore
        $script:_lgFastTimer.Stop()
        $script:_lgFrame  = 0
        $script:_lgActive = $false
        if ($script:_lgMain) { $script:_lgMain.X = 0; $script:_lgMain.Y = 0 }
        if ($script:_lgR)    { $script:_lgR.X    = 0; $script:_lgR.Y    = 0 }
        if ($script:_lgB)    { $script:_lgB.X    = 0; $script:_lgB.Y    = 0 }
        if ($script:_lgImgR) { $script:_lgImgR.Opacity = 0 }
        if ($script:_lgImgB) { $script:_lgImgB.Opacity = 0 }
        if ($script:_lgImg)  { $script:_lgImg.Opacity  = 1 }
        return
    }
    $r = $script:_lgRng
    # Alternate blackout and glitch
    if ($script:_lgFrame % 2 -eq 0) {
        if ($script:_lgImg)  { $script:_lgImg.Opacity  = 0.0 }
        if ($script:_lgImgR) { $script:_lgImgR.Opacity = 0.0 }
        if ($script:_lgImgB) { $script:_lgImgB.Opacity = 0.0 }
    } else {
        if ($script:_lgImg)  { $script:_lgImg.Opacity  = 1.0 }
        if ($script:_lgMain) { $script:_lgMain.X = $r.Next(-4,4); $script:_lgMain.Y = $r.Next(-2,2) }
        if ($script:_lgImgR) { $script:_lgImgR.Opacity = 0.6 + $r.NextDouble()*0.4 }
        if ($script:_lgR)    { $script:_lgR.X = $r.Next(3,8);  $script:_lgR.Y = $r.Next(-2,2) }
        if ($script:_lgImgB) { $script:_lgImgB.Opacity = 0.6 + $r.NextDouble()*0.4 }
        if ($script:_lgB)    { $script:_lgB.X = $r.Next(-8,-3); $script:_lgB.Y = $r.Next(-2,2) }
    }
})

# Slow interval timer — triggers glitch burst every ~3 min
$script:_lgSlowTimer = New-Object System.Windows.Threading.DispatcherTimer
$script:_lgSlowTimer.Interval = [TimeSpan]::FromSeconds(180)
$script:_lgSlowTimer.Add_Tick({
    if (-not $script:_lgActive) {
        $script:_lgActive = $true
        $script:_lgFrame  = 0
        $script:_lgFastTimer.Start()
    }
})
$script:_lgSlowTimer.Start()

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

    $window.FindName("ViewEjecutar").Visibility = "Collapsed"

    $window.FindName("ViewHardware").Visibility = "Collapsed"

    $window.FindName("ViewSO").Visibility = "Collapsed"

    $window.FindName("ViewTweaks").Visibility = "Collapsed"

    $window.FindName("ViewExtensiones").Visibility = "Collapsed"

    $window.FindName("ViewInfo").Visibility = "Collapsed"

    # Mostrar vista seleccionada

    $window.FindName("View$viewName").Visibility = "Visible"

    $script:currentView = $viewName

    # Actualizar tabs

    $tabs = @("BtnInstalar", "BtnDesinstalar", "BtnEjecutar", "BtnHardware", "BtnSO", "BtnTweaks", "BtnExtensiones", "BtnInfo")

    foreach ($tab in $tabs) {

        $btn = $window.FindName($tab)

        if ($tab -eq "Btn$viewName") {

            $btn.Foreground = Get-ColorBrush "#FF9D6FFF" # Púrpura activo

        } else {

            $btn.Foreground = Get-ColorBrush "#FF8B949E" # Gris inactivo

        }

    }

    # Actualizar footer según la vista activa

    if ($viewName -eq "Desinstalar") {

        Update-RemoveSelectionCount

    } elseif ($viewName -eq "Ejecutar") {

        Load-EjecutarAppsList

    } elseif ($viewName -eq "Hardware") {

        # No auto-scan: el usuario presiona el botón

    } else {

        Update-SelectionCount

    }

}

function Load-AppsList {
    # Show shimmer placeholders while loading
    $appsList = $window.FindName("AppsList")
    if ($appsList) { Show-Shimmer -ListControl $appsList -Count 5 }
    $window.Dispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Render)

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

            $warningIcon.Cursor = [System.Windows.Input.Cursors]::Help

            # Styled tooltip
            $tt = New-Object System.Windows.Controls.ToolTip
            $ttPanel = New-Object System.Windows.Controls.StackPanel
            $ttPanel.Margin = [System.Windows.Thickness]::new(4)

            $ttHeader = New-Object System.Windows.Controls.TextBlock
            $ttHeader.Text = "⚠️  Advertencia"
            $ttHeader.FontWeight = "SemiBold"
            $ttHeader.FontSize = 12
            $ttHeader.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.Colors]::Orange
            $ttHeader.Margin = [System.Windows.Thickness]::new(0,0,0,4)

            $ttBody = New-Object System.Windows.Controls.TextBlock
            $ttBody.Text = $app.Warning
            $ttBody.FontSize = 11
            $ttBody.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.Colors]::White
            $ttBody.TextWrapping = "Wrap"
            $ttBody.MaxWidth = 280

            $ttPanel.Children.Add($ttHeader)
            $ttPanel.Children.Add($ttBody)
            $tt.Content = $ttPanel
            $tt.Background = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF1A1535"))
            $tt.BorderBrush = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9D6FFF"))
            $tt.BorderThickness = [System.Windows.Thickness]::new(1)
            $tt.Padding = [System.Windows.Thickness]::new(10,8,10,8)
            $warningIcon.ToolTip = $tt

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

            $sub.Foreground = Get-ColorBrush "#FF9D6FFF"

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

    # Stop any previous timers
    if ($script:_spinTimer)  { $script:_spinTimer.Stop();  $script:_spinTimer  = $null }
    if ($script:_pollTimer)  { $script:_pollTimer.Stop();  $script:_pollTimer  = $null }
    if ($script:_searchJob)  { Remove-Job $script:_searchJob -Force -ErrorAction SilentlyContinue; $script:_searchJob = $null }

    # ── Loader UI ─────────────────────────────────────────────────────
    $loaderPanel = New-Object System.Windows.Controls.StackPanel
    $loaderPanel.HorizontalAlignment = "Center"
    $loaderPanel.VerticalAlignment   = "Center"
    $loaderPanel.Margin = [System.Windows.Thickness]::new(0,60,0,0)

    $loaderIcon = New-Object System.Windows.Controls.TextBlock
    $loaderIcon.Text = "🔍"
    $loaderIcon.FontSize = 42
    $loaderIcon.HorizontalAlignment = "Center"
    $loaderIcon.Margin = [System.Windows.Thickness]::new(0,0,0,18)
    $loaderPanel.Children.Add($loaderIcon)

    $loaderTitle = New-Object System.Windows.Controls.TextBlock
    $loaderTitle.Text      = "Buscando aplicaciones instaladas..."
    $loaderTitle.FontFamily = "Segoe UI"
    $loaderTitle.FontSize  = 15
    $loaderTitle.FontWeight = "SemiBold"
    $loaderTitle.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FFE8E0FF"))
    $loaderTitle.HorizontalAlignment = "Center"
    $loaderTitle.Margin = [System.Windows.Thickness]::new(0,0,0,5)
    $loaderPanel.Children.Add($loaderTitle)

    $loaderSub = New-Object System.Windows.Controls.TextBlock
    $loaderSub.Text      = "Revisando winget, disco y registro de Windows"
    $loaderSub.FontFamily = "Segoe UI"
    $loaderSub.FontSize  = 11
    $loaderSub.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF6B5F9E"))
    $loaderSub.HorizontalAlignment = "Center"
    $loaderSub.Margin = [System.Windows.Thickness]::new(0,0,0,24)
    $loaderPanel.Children.Add($loaderSub)

    # 5 puntos animados
    $dotsPanel = New-Object System.Windows.Controls.StackPanel
    $dotsPanel.Orientation = "Horizontal"
    $dotsPanel.HorizontalAlignment = "Center"
    $dotsPanel.Margin = [System.Windows.Thickness]::new(0,0,0,20)
    $script:_dotRefs = @()
    for ($di = 0; $di -lt 5; $di++) {
        $dot = New-Object System.Windows.Controls.Border
        $dot.Width  = 10; $dot.Height = 10
        $dot.CornerRadius = [System.Windows.CornerRadius]::new(5)
        $dot.Background   = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF3D2F6B"))
        $dot.Margin = [System.Windows.Thickness]::new(5,0,5,0)
        $dotsPanel.Children.Add($dot)
        $script:_dotRefs += $dot
    }
    $loaderPanel.Children.Add($dotsPanel)

    # Barra deslizante
    $barOuter = New-Object System.Windows.Controls.Border
    $barOuter.Width = 300; $barOuter.Height = 5
    $barOuter.CornerRadius = [System.Windows.CornerRadius]::new(3)
    $barOuter.Background = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF201840"))
    $barOuter.ClipToBounds = $true
    $barOuter.HorizontalAlignment = "Center"

    $script:_barFill = New-Object System.Windows.Controls.Border
    $script:_barFill.Width  = 80; $script:_barFill.Height = 5
    $script:_barFill.CornerRadius = [System.Windows.CornerRadius]::new(3)
    $script:_barFill.Background = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9D6FFF"))
    $script:_barFill.HorizontalAlignment = "Left"
    $script:_barFill.RenderTransform = New-Object System.Windows.Media.TranslateTransform
    $barOuter.Child = $script:_barFill
    $loaderPanel.Children.Add($barOuter)

    $installedList.Children.Add($loaderPanel)
    $installedList.Dispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Render)

    # ── Timer de animación (hilo UI — no se bloquea) ──────────────────
    $script:_spinFrame = 0
    $script:_barPos    = -80.0
    $script:_barDir    = 1
    $script:_spinTimer = New-Object System.Windows.Threading.DispatcherTimer
    $script:_spinTimer.Interval = [TimeSpan]::FromMilliseconds(55)
    $script:_spinTimer.Add_Tick({
        $script:_spinFrame++
        # Barra
        $script:_barPos += $script:_barDir * 8
        if ($script:_barPos -gt 300)  { $script:_barDir = -1 }
        if ($script:_barPos -lt -80)  { $script:_barDir =  1 }
        if ($script:_barFill) { ($script:_barFill.RenderTransform).X = $script:_barPos }
        # Puntos
        $active = $script:_spinFrame % 5
        for ($di2 = 0; $di2 -lt 5; $di2++) {
            $on  = ($di2 -eq $active) -or ($di2 -eq (($active+1)%5))
            $col = if ($on) { "#FF9D6FFF" } else { "#FF3D2F6B" }
            $sz  = if ($on) { 13 } else { 10 }
            if ($script:_dotRefs[$di2]) {
                $script:_dotRefs[$di2].Background = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString($col))
                $script:_dotRefs[$di2].Width  = $sz
                $script:_dotRefs[$di2].Height = $sz
            }
        }
    })
    $script:_spinTimer.Start()

    # ── Búsqueda en background (Job) ──────────────────────────────────
    $currentPlatform = $script:currentPlatform
    $appDb           = $script:appDatabase

    $script:_searchJob = Start-Job -ScriptBlock {
        param($platform, $db)

        $found = @()

        if ($platform -eq "Windows") {
            # Winget IDs instalados
            $wgIds = @{}
            try {
                $raw = & winget list --accept-source-agreements 2>$null
                foreach ($ln in $raw) {
                    if ($ln -match '\s+([\w][\w\.\-]+\.[\w][\w\.\-]+)\s') {
                        $wgIds[$matches[1].Trim()] = $true
                    }
                }
            } catch {}

            $sPaths = @(
                $env:ProgramFiles,
                ${env:ProgramFiles(x86)},
                "$env:LOCALAPPDATA\Programs"
            )

            foreach ($catName in $db["Windows"].Keys) {
                $catItems = $db["Windows"][$catName]
                $flat = @()
                if ($catItems -is [hashtable]) {
                    foreach ($v in $catItems.Values) { $flat += $v }
                } else { $flat = $catItems }

                foreach ($app in $flat) {
                    if (-not $app -or -not $app.Name) { continue }
                    $ok = $false; $path = $null

                    if ($app.ID -and $wgIds.ContainsKey($app.ID)) { $ok = $true }

                    if (-not $ok -and $app.Name) {
                        $exeName = ($app.Name -replace '[^a-zA-Z0-9]','').ToLower()
                        foreach ($sp in $sPaths) {
                            if (-not $sp -or -not (Test-Path $sp)) { continue }
                            $hit = Get-ChildItem $sp -Filter "*.exe" -Recurse -Depth 4 -ErrorAction SilentlyContinue |
                                Where-Object { $_.Name -notmatch 'uninstall|setup|update|helper|crash|report' } |
                                Where-Object { $_.BaseName.ToLower() -like "*$exeName*" } |
                                Select-Object -First 1
                            if ($hit) { $ok = $true; $path = $hit.FullName; break }
                        }
                    }

                    if (-not $ok) {
                        $nameLow = $app.Name.ToLower()
                        $regRoots = @(
                            'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
                            'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall',
                            'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
                        )
                        foreach ($rr in $regRoots) {
                            if (-not (Test-Path $rr -ErrorAction SilentlyContinue)) { continue }
                            foreach ($sk in (Get-ChildItem $rr -ErrorAction SilentlyContinue)) {
                                try {
                                    $p = $sk | Get-ItemProperty -ErrorAction Stop
                                    if ($p.DisplayName -and $p.DisplayName.ToLower() -like "*$nameLow*") {
                                        $ok = $true
                                        $path = $p.InstallLocation
                                        break
                                    }
                                } catch { continue }
                            }
                            if ($ok) { break }
                        }
                    }

                    if ($ok) {
                        $found += [PSCustomObject]@{
                            Key      = if ($app.Key) { $app.Key } else { $app.Name }
                            Name     = $app.Name
                            ID       = $app.ID
                            Desc     = $app.Desc
                            Icon     = if ($app.Icon) { $app.Icon } else { "📦" }
                            Category = $catName
                            Path     = $path
                        }
                    }
                }
            }
            $found = $found | Sort-Object Name -Unique
        }
        return $found
    } -ArgumentList $currentPlatform, $appDb

    # ── Timer de sondeo: verifica si el Job terminó ───────────────────
    $script:_installedListRef = $installedList
    $script:_pollTimer = New-Object System.Windows.Threading.DispatcherTimer
    $script:_pollTimer.Interval = [TimeSpan]::FromMilliseconds(300)
    $script:_pollTimer.Add_Tick({
        if (-not $script:_searchJob) { $script:_pollTimer.Stop(); return }
        if ($script:_searchJob.State -notin @("Completed","Failed","Stopped")) { return }

        # Job terminó — detener animaciones
        $script:_pollTimer.Stop()
        if ($script:_spinTimer) { $script:_spinTimer.Stop(); $script:_spinTimer = $null }

        $detectedApps = @()
        try { $detectedApps = Receive-Job $script:_searchJob } catch {}
        Remove-Job $script:_searchJob -Force -ErrorAction SilentlyContinue
        $script:_searchJob = $null

        $iList = $script:_installedListRef
        $iList.Children.Clear()

        if ($detectedApps.Count -eq 0) {
            $wrap = New-Object System.Windows.Controls.StackPanel
            $wrap.HorizontalAlignment = "Center"
            $wrap.Margin = [System.Windows.Thickness]::new(0,40,0,0)
            $ico = New-Object System.Windows.Controls.TextBlock
            $ico.Text = "📭"; $ico.FontSize = 40; $ico.HorizontalAlignment = "Center"
            $ico.Margin = [System.Windows.Thickness]::new(0,0,0,12)
            $t1 = New-Object System.Windows.Controls.TextBlock
            $t1.Text = "No se encontraron aplicaciones instaladas por NeXus"
            $t1.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9080BB"))
            $t1.FontSize = 14; $t1.TextAlignment = "Center"
            $t2 = New-Object System.Windows.Controls.TextBlock
            $t2.Text = "Instala aplicaciones desde 'Instalar Apps' y aparecerán aquí."
            $t2.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF6B5F9E"))
            $t2.FontSize = 12; $t2.TextAlignment = "Center"; $t2.TextWrapping = "Wrap"
            $t2.Margin = [System.Windows.Thickness]::new(0,6,0,0)
            $wrap.Children.Add($ico); $wrap.Children.Add($t1); $wrap.Children.Add($t2)
            $iList.Children.Add($wrap)
            return
        }

        foreach ($group in ($detectedApps | Group-Object Category)) {
            $hdr = New-Object System.Windows.Controls.TextBlock
            $hdr.Text = "  📁  $($group.Name.ToUpper())"
            $hdr.FontSize = 11; $hdr.FontWeight = "SemiBold"
            $hdr.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9D6FFF"))
            $hdr.Margin = [System.Windows.Thickness]::new(0,16,0,6)
            $iList.Children.Add($hdr)

            foreach ($app in $group.Group) {
                $border = New-Object System.Windows.Controls.Border
                $border.Style = $window.FindResource("AppCardStyle")

                $grid = New-Object System.Windows.Controls.Grid
                foreach ($w in @("Auto","*","Auto")) {
                    $cd = New-Object System.Windows.Controls.ColumnDefinition; $cd.Width = $w
                    $grid.ColumnDefinitions.Add($cd)
                }

                $chk = New-Object System.Windows.Controls.CheckBox
                $chk.Style = $window.FindResource("ModernCheckBox")
                $chk.Tag   = $app.Key
                $chk.IsChecked = $script:selectedAppsToRemove -contains $app.Key
                $chk.Add_Checked({
                    $k = $this.Tag
                    if ($script:selectedAppsToRemove -notcontains $k) {
                        $script:selectedAppsToRemove += $k; Update-RemoveSelectionCount
                    }
                })
                $chk.Add_Unchecked({
                    $k = $this.Tag
                    $script:selectedAppsToRemove = $script:selectedAppsToRemove | Where-Object { $_ -ne $k }
                    Update-RemoveSelectionCount
                })
                [System.Windows.Controls.Grid]::SetColumn($chk, 0)
                $grid.Children.Add($chk)

                $info = New-Object System.Windows.Controls.StackPanel
                $info.Margin = [System.Windows.Thickness]::new(12,0,0,0)
                $row = New-Object System.Windows.Controls.StackPanel; $row.Orientation = "Horizontal"
                $icoTb = New-Object System.Windows.Controls.TextBlock
                $icoTb.Text = "$($app.Icon)  "; $icoTb.FontSize = 14; $icoTb.VerticalAlignment = "Center"
                $nameTb = New-Object System.Windows.Controls.TextBlock
                $nameTb.Text = $app.Name; $nameTb.FontSize = 14; $nameTb.FontWeight = "SemiBold"
                $nameTb.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FFE8E0FF"))
                $nameTb.VerticalAlignment = "Center"
                $row.Children.Add($icoTb); $row.Children.Add($nameTb); $info.Children.Add($row)
                if ($app.Desc) {
                    $desc = New-Object System.Windows.Controls.TextBlock
                    $desc.Text = $app.Desc; $desc.FontSize = 12
                    $desc.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9080BB"))
                    $desc.Margin = [System.Windows.Thickness]::new(0,2,0,0)
                    $info.Children.Add($desc)
                }
                if ($app.Path) {
                    $pathTb = New-Object System.Windows.Controls.TextBlock
                    $pathTb.Text = "📂  $($app.Path)"; $pathTb.FontSize = 10
                    $pathTb.FontFamily = "Consolas"
                    $pathTb.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9D6FFF"))
                    $pathTb.TextTrimming = "CharacterEllipsis"
                    $pathTb.Margin = [System.Windows.Thickness]::new(0,3,0,0)
                    $info.Children.Add($pathTb)
                }
                [System.Windows.Controls.Grid]::SetColumn($info, 1); $grid.Children.Add($info)

                $badge = New-Object System.Windows.Controls.Border
                $badge.Background = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF201840"))
                $badge.CornerRadius = [System.Windows.CornerRadius]::new(4)
                $badge.Padding = [System.Windows.Thickness]::new(8,3,8,3)
                $badge.VerticalAlignment = "Center"
                $bt = New-Object System.Windows.Controls.TextBlock
                $bt.Text = if ($app.ID -and $app.ID -match '\.') { "Winget" } else { "Manual" }
                $bt.FontSize = 11
                $bt.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9080BB"))
                $badge.Child = $bt
                [System.Windows.Controls.Grid]::SetColumn($badge, 2); $grid.Children.Add($badge)

                $border.Child = $grid
                $iList.Children.Add($border)
            }
        }
    })
    $script:_pollTimer.Start()
}
# ── Caché de registro (se construye una sola vez por sesión) ──────────
$script:_regCache     = $null
$script:_regCacheTime = [datetime]::MinValue

function Get-RegCache {
    # Reconstruir caché solo si tiene más de 2 minutos de antigüedad
    if ($script:_regCache -and ([datetime]::Now - $script:_regCacheTime).TotalSeconds -lt 120) {
        return $script:_regCache
    }
    $map = @{}
    $roots = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
    )
    foreach ($r in $roots) {
        if (-not (Test-Path $r -ErrorAction SilentlyContinue)) { continue }
        foreach ($sk in (Get-ChildItem $r -ErrorAction SilentlyContinue)) {
            try {
                $p = $sk | Get-ItemProperty -ErrorAction Stop
                if (-not $p.DisplayName) { continue }
                $k = ($p.DisplayName.ToLower() -replace '[^a-z0-9]','')
                if (-not $map.ContainsKey($k)) {
                    $map[$k] = [PSCustomObject]@{
                        Location  = $p.InstallLocation
                        Uninst    = $p.UninstallString
                        Version   = $p.DisplayVersion
                    }
                }
            } catch { continue }
        }
    }
    $script:_regCache     = $map
    $script:_regCacheTime = [datetime]::Now
    return $map
}

function Find-ExeForApp($appName, $installLocation) {
    # Primero: dentro del InstallLocation si existe
    if ($installLocation -and (Test-Path $installLocation -ErrorAction SilentlyContinue)) {
        $hit = Get-ChildItem $installLocation -Filter "*.exe" -Depth 2 -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -notmatch 'uninstall|setup|update|helper|crash|report|redist|vcredist' } |
            Sort-Object Length -Descending | Select-Object -First 1
        if ($hit) { return $hit.FullName }
    }
    # Segundo: acceso directo en menú de inicio (rápido, sin escaneo de disco)
    $startMenuPaths = @(
        "$env:APPDATA\Microsoft\Windows\Start Menu\Programs",
        "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
    )
    $norm = ($appName -replace '[^a-zA-Z0-9 ]','').Trim()
    foreach ($smp in $startMenuPaths) {
        if (-not (Test-Path $smp -ErrorAction SilentlyContinue)) { continue }
        $lnk = Get-ChildItem $smp -Filter "*.lnk" -Recurse -Depth 3 -ErrorAction SilentlyContinue |
            Where-Object { $_.BaseName -like "*$norm*" } | Select-Object -First 1
        if ($lnk) { return $lnk.FullName }
    }
    return $null
}

function Load-EjecutarAppsList {
    param([string]$Filter = "")

    $list = $window.FindName("EjecutarAppsList")
    if (-not $list) { return }
    $list.Children.Clear()

    # ── Mostrar loader animado ────────────────────────────────────────
    $loaderPanel = New-Object System.Windows.Controls.StackPanel
    $loaderPanel.HorizontalAlignment = "Center"
    $loaderPanel.VerticalAlignment   = "Center"
    $loaderPanel.Margin = [System.Windows.Thickness]::new(0,60,0,0)

    $loaderIcon = New-Object System.Windows.Controls.TextBlock
    $loaderIcon.Text = "▶"; $loaderIcon.FontSize = 44
    $loaderIcon.HorizontalAlignment = "Center"
    $loaderIcon.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9D6FFF"))
    $loaderIcon.Margin = [System.Windows.Thickness]::new(0,0,0,16)
    $loaderPanel.Children.Add($loaderIcon)

    $loaderTitle = New-Object System.Windows.Controls.TextBlock
    $loaderTitle.Text = "Buscando tus aplicaciones..."
    $loaderTitle.FontFamily = "Segoe UI"; $loaderTitle.FontSize = 15; $loaderTitle.FontWeight = "SemiBold"
    $loaderTitle.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FFE8E0FF"))
    $loaderTitle.HorizontalAlignment = "Center"; $loaderTitle.Margin = [System.Windows.Thickness]::new(0,0,0,6)
    $loaderPanel.Children.Add($loaderTitle)

    $loaderSub = New-Object System.Windows.Controls.TextBlock
    $loaderSub.Text = "Consultando registro del sistema..."
    $loaderSub.FontFamily = "Segoe UI"; $loaderSub.FontSize = 11
    $loaderSub.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF6B5F9E"))
    $loaderSub.HorizontalAlignment = "Center"; $loaderSub.Margin = [System.Windows.Thickness]::new(0,0,0,22)
    $loaderPanel.Children.Add($loaderSub)

    # Barra de progreso indeterminada
    $barOuter = New-Object System.Windows.Controls.Border
    $barOuter.Width = 280; $barOuter.Height = 5; $barOuter.CornerRadius = [System.Windows.CornerRadius]::new(3)
    $barOuter.Background = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF201840"))
    $barOuter.ClipToBounds = $true; $barOuter.HorizontalAlignment = "Center"
    $script:_ejBarFill = New-Object System.Windows.Controls.Border
    $script:_ejBarFill.Width = 80; $script:_ejBarFill.Height = 5
    $script:_ejBarFill.CornerRadius = [System.Windows.CornerRadius]::new(3)
    $script:_ejBarFill.Background = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9D6FFF"))
    $script:_ejBarFill.HorizontalAlignment = "Left"
    $script:_ejBarFill.RenderTransform = New-Object System.Windows.Media.TranslateTransform
    $barOuter.Child = $script:_ejBarFill
    $loaderPanel.Children.Add($barOuter)
    $list.Children.Add($loaderPanel)
    $list.Dispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Render)

    # Iniciar animación barra
    if ($script:_ejSpinTimer) { $script:_ejSpinTimer.Stop() }
    $script:_ejBarPos = -80.0; $script:_ejBarDir2 = 1
    $script:_ejSpinTimer = New-Object System.Windows.Threading.DispatcherTimer
    $script:_ejSpinTimer.Interval = [TimeSpan]::FromMilliseconds(50)
    $script:_ejSpinTimer.Add_Tick({
        $script:_ejBarPos += $script:_ejBarDir2 * 9
        if ($script:_ejBarPos -gt 280)  { $script:_ejBarDir2 = -1 }
        if ($script:_ejBarPos -lt -80)  { $script:_ejBarDir2 =  1 }
        if ($script:_ejBarFill) { ($script:_ejBarFill.RenderTransform).X = $script:_ejBarPos }
    })
    $script:_ejSpinTimer.Start()

    # ── Búsqueda en background usando caché de registro ───────────────
    $currentFilter = $Filter
    $appDb = $script:appDatabase
    $platform = $script:currentPlatform

    if ($script:_ejSearchJob) { Remove-Job $script:_ejSearchJob -Force -ErrorAction SilentlyContinue }

    $script:_ejSearchJob = Start-Job -ScriptBlock {
        param($db, $platform, $filter)

        $found = [System.Collections.Generic.List[object]]::new()
        if ($platform -ne "Windows") { return $found }

        # Caché de registro (dentro del job)
        $regMap = @{}
        $roots = @(
            'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
            'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall',
            'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
        )
        foreach ($r in $roots) {
            if (-not (Test-Path $r -ErrorAction SilentlyContinue)) { continue }
            foreach ($sk in (Get-ChildItem $r -ErrorAction SilentlyContinue)) {
                try {
                    $p = $sk | Get-ItemProperty -ErrorAction Stop
                    if (-not $p.DisplayName) { continue }
                    $k = ($p.DisplayName.ToLower() -replace '[^a-z0-9]','')
                    if (-not $regMap.ContainsKey($k)) {
                        $regMap[$k] = @{ Location = $p.InstallLocation; Uninst = $p.UninstallString }
                    }
                } catch { continue }
            }
        }

        # Índice de accesos directos del menú inicio (mucho más rápido que escanear disco)
        $lnkMap = @{}
        $startMenuPaths = @(
            "$env:APPDATA\Microsoft\Windows\Start Menu\Programs",
            "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
        )
        foreach ($smp in $startMenuPaths) {
            if (-not (Test-Path $smp -ErrorAction SilentlyContinue)) { continue }
            foreach ($lnk in (Get-ChildItem $smp -Filter "*.lnk" -Recurse -Depth 3 -ErrorAction SilentlyContinue)) {
                $k = ($lnk.BaseName.ToLower() -replace '[^a-z0-9]','')
                if (-not $lnkMap.ContainsKey($k)) { $lnkMap[$k] = $lnk.FullName }
            }
        }

        foreach ($catN in $db["Windows"].Keys) {
            $ci = $db["Windows"][$catN]
            $flat = @()
            if ($ci -is [hashtable]) { foreach ($v in $ci.Values) { $flat += $v } } else { $flat = $ci }

            foreach ($app in $flat) {
                if (-not $app -or -not $app.Name) { continue }
                if ($filter -and $app.Name -notmatch [regex]::Escape($filter) -and $app.Desc -notmatch [regex]::Escape($filter)) { continue }

                $isInstalled = $false; $exePath = $null
                $normName = ($app.Name.ToLower() -replace '[^a-z0-9]','')

                # 1. Registro
                foreach ($k in $regMap.Keys) {
                    if ($k -like "*$normName*" -or ($normName.Length -gt 3 -and $normName -like "*$k*")) {
                        $isInstalled = $true
                        $loc = $regMap[$k].Location
                        if ($loc -and (Test-Path $loc -ErrorAction SilentlyContinue)) {
                            $hit = Get-ChildItem $loc -Filter "*.exe" -Depth 2 -ErrorAction SilentlyContinue |
                                Where-Object { $_.Name -notmatch 'uninstall|setup|update|helper|crash|report|redist' } |
                                Sort-Object Length -Descending | Select-Object -First 1
                            if ($hit) { $exePath = $hit.FullName }
                        }
                        break
                    }
                }

                # 2. Menú de inicio (índice ya construido — sin escaneo de disco)
                if (-not $exePath) {
                    foreach ($k in $lnkMap.Keys) {
                        if ($k -like "*$normName*" -or ($normName.Length -gt 3 -and $normName -like "*$k*")) {
                            $exePath = $lnkMap[$k]; break
                        }
                    }
                }

                # 3. LocalAppData\Programs (solo si no se encontró — con depth 3)
                if ($isInstalled -and -not $exePath) {
                    $localProgs = "$env:LOCALAPPDATA\Programs"
                    if (Test-Path $localProgs -ErrorAction SilentlyContinue) {
                        $hit = Get-ChildItem $localProgs -Filter "*.exe" -Recurse -Depth 3 -ErrorAction SilentlyContinue |
                            Where-Object { $_.Name -notmatch 'uninstall|setup|update|helper|crash|report|redist' } |
                            Where-Object { ($_.BaseName.ToLower() -replace '[^a-z0-9]','') -like "*$normName*" } |
                            Select-Object -First 1
                        if ($hit) { $exePath = $hit.FullName }
                    }
                }

                if ($isInstalled -or $exePath) {
                    $found.Add([PSCustomObject]@{
                        Name     = $app.Name
                        Desc     = if ($app.Desc) { $app.Desc } else { "" }
                        Icon     = if ($app.Icon) { $app.Icon } else { "📦" }
                        Category = $catN
                        ExePath  = $exePath
                        Key      = if ($app.Key) { $app.Key } else { $app.Name }
                    })
                }
            }
        }
        return $found
    } -ArgumentList $appDb, $platform, $currentFilter

    # ── Poll timer: renderiza cuando el job termina ───────────────────
    if ($script:_ejPollTimer) { $script:_ejPollTimer.Stop() }
    $script:_ejPollTimer = New-Object System.Windows.Threading.DispatcherTimer
    $script:_ejPollTimer.Interval = [TimeSpan]::FromMilliseconds(300)
    $script:_ejPollTimer.Add_Tick({
        if (-not $script:_ejSearchJob) { $script:_ejPollTimer.Stop(); return }
        if ($script:_ejSearchJob.State -notin @("Completed","Failed","Stopped")) { return }

        $script:_ejPollTimer.Stop()
        if ($script:_ejSpinTimer) { $script:_ejSpinTimer.Stop(); $script:_ejSpinTimer = $null }

        $results = @()
        try { $results = @(Receive-Job $script:_ejSearchJob) } catch {}
        Remove-Job $script:_ejSearchJob -Force -ErrorAction SilentlyContinue
        $script:_ejSearchJob = $null

        $lst = $window.FindName("EjecutarAppsList")
        if (-not $lst) { return }
        $lst.Children.Clear()

        if ($results.Count -eq 0) {
            $wp = New-Object System.Windows.Controls.StackPanel
            $wp.HorizontalAlignment = "Center"; $wp.Margin = [System.Windows.Thickness]::new(0,60,0,0)
            $ic = New-Object System.Windows.Controls.TextBlock
            $ic.Text = "🔍"; $ic.FontSize = 42; $ic.HorizontalAlignment = "Center"
            $ic.Margin = [System.Windows.Thickness]::new(0,0,0,14)
            $t1 = New-Object System.Windows.Controls.TextBlock
            $t1.Text = "No se encontraron apps del catálogo instaladas"
            $t1.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9080BB"))
            $t1.FontSize = 14; $t1.TextAlignment = "Center"; $t1.TextWrapping = "Wrap"
            $wp.Children.Add($ic); $wp.Children.Add($t1); $lst.Children.Add($wp)
            return
        }

        foreach ($group in ($results | Group-Object Category | Sort-Object Name)) {
            $hdr = New-Object System.Windows.Controls.TextBlock
            $hdr.Text = "  📁  $($group.Name.ToUpper())"
            $hdr.FontSize = 11; $hdr.FontWeight = "SemiBold"
            $hdr.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9D6FFF"))
            $hdr.Margin = [System.Windows.Thickness]::new(0,18,0,8)
            $lst.Children.Add($hdr)

            foreach ($app in ($group.Group | Sort-Object Name)) {
                $card = New-Object System.Windows.Controls.Border
                $card.Style = $window.FindResource("AppCardStyle")

                $grid = New-Object System.Windows.Controls.Grid
                foreach ($w in @("Auto","*","Auto")) {
                    $cd = New-Object System.Windows.Controls.ColumnDefinition; $cd.Width = $w
                    $grid.ColumnDefinitions.Add($cd)
                }

                $icoTb = New-Object System.Windows.Controls.TextBlock
                $icoTb.Text = "$($app.Icon)  "; $icoTb.FontSize = 22; $icoTb.VerticalAlignment = "Center"
                [System.Windows.Controls.Grid]::SetColumn($icoTb, 0); $grid.Children.Add($icoTb)

                $info = New-Object System.Windows.Controls.StackPanel
                $info.Margin = [System.Windows.Thickness]::new(8,0,0,0); $info.VerticalAlignment = "Center"
                $nameTb = New-Object System.Windows.Controls.TextBlock
                $nameTb.Text = $app.Name; $nameTb.FontSize = 14; $nameTb.FontWeight = "SemiBold"
                $nameTb.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FFE8E0FF"))
                $info.Children.Add($nameTb)
                if ($app.Desc) {
                    $descTb = New-Object System.Windows.Controls.TextBlock
                    $descTb.Text = $app.Desc; $descTb.FontSize = 12
                    $descTb.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9080BB"))
                    $descTb.Margin = [System.Windows.Thickness]::new(0,2,0,0)
                    $info.Children.Add($descTb)
                }
                if ($app.ExePath) {
                    $pathTb = New-Object System.Windows.Controls.TextBlock
                    $pathTb.Text = "  $($app.ExePath)"; $pathTb.FontSize = 10; $pathTb.FontFamily = "Consolas"
                    $pathTb.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF6B5F9E"))
                    $pathTb.TextTrimming = "CharacterEllipsis"
                    $pathTb.Margin = [System.Windows.Thickness]::new(0,3,0,0)
                    $info.Children.Add($pathTb)
                }
                [System.Windows.Controls.Grid]::SetColumn($info, 1); $grid.Children.Add($info)

                # Botón ▶ Abrir
                $btn = New-Object System.Windows.Controls.Button
                $btn.Padding = [System.Windows.Thickness]::new(16,8,16,8)
                $btn.Cursor  = [System.Windows.Input.Cursors]::Hand
                $btn.VerticalAlignment = "Center"
                $btn.Background  = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF1A1535"))
                $btn.BorderBrush = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9D6FFF"))
                $btn.BorderThickness = [System.Windows.Thickness]::new(1)
                $btn.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9D6FFF"))
                if (-not $app.ExePath) { $btn.Opacity = 0.5; $btn.ToolTip = "Ejecutable no localizado" }

                $bc = New-Object System.Windows.Controls.StackPanel; $bc.Orientation = "Horizontal"
                $bp = New-Object System.Windows.Controls.TextBlock; $bp.Text = "▶ "; $bp.FontSize = 11; $bp.VerticalAlignment = "Center"
                $bl = New-Object System.Windows.Controls.TextBlock; $bl.Text = "Abrir"; $bl.FontSize = 12; $bl.FontWeight = "SemiBold"; $bl.VerticalAlignment = "Center"
                $bc.Children.Add($bp); $bc.Children.Add($bl); $btn.Content = $bc

                $btn.Tag = $app.ExePath
                $btn.Add_Click({
                    param($s, $e)
                    $p = $s.Tag
                    try {
                        if ($p) { Start-Process $p }
                        else {
                            [System.Windows.MessageBox]::Show(
                                "No se localizó el ejecutable. Búscalo en el menú de inicio.",
                                "NeXus — App no localizada","OK","Information")
                        }
                    } catch {
                        [System.Windows.MessageBox]::Show("Error al abrir: $_","NeXus","OK","Warning")
                    }
                }.GetNewClosure())

                [System.Windows.Controls.Grid]::SetColumn($btn, 2); $grid.Children.Add($btn)
                $card.Child = $grid; $lst.Children.Add($card)
            }
        }
    })
    $script:_ejPollTimer.Start()
}


# ── ESCÁNER DE HARDWARE ───────────────────────────────────────────────────

# Requerimientos mínimos por categoría de app
$script:hwRequirements = @{
    "Animacion"   = @{ RAM_GB = 8;  GPU_VRAM_GB = 2; CPU_CORES = 4; Desc = "Animación 3D/2D requiere mínimo 8 GB RAM, GPU dedicada recomendada" }
    "Mecatronica" = @{ RAM_GB = 4;  GPU_VRAM_GB = 0; CPU_CORES = 2; Desc = "Mecatrónica es ligera, compatible con la mayoría de equipos" }
    "Programacion"= @{ RAM_GB = 4;  GPU_VRAM_GB = 0; CPU_CORES = 2; Desc = "Programación básica funciona en equipos de gama baja" }
    "Navegadores" = @{ RAM_GB = 2;  GPU_VRAM_GB = 0; CPU_CORES = 1; Desc = "Navegadores modernos funcionan en equipos básicos" }
    "Comunicacion"= @{ RAM_GB = 2;  GPU_VRAM_GB = 0; CPU_CORES = 1; Desc = "Apps de comunicación son ligeras" }
    "Extras"      = @{ RAM_GB = 2;  GPU_VRAM_GB = 0; CPU_CORES = 1; Desc = "Herramientas variadas, mayormente compatibles" }
}

# Requerimientos por app individual (overrides de categoría)
$script:appHwReqs = @{
    "Blender"       = @{ RAM_GB = 8;  GPU_VRAM_GB = 4; CPU_CORES = 6; Note = "Recomendado: 16 GB RAM + GPU dedicada" }
    "DaVinciResolve"= @{ RAM_GB = 16; GPU_VRAM_GB = 4; CPU_CORES = 8; Note = "Requiere GPU dedicada con mínimo 4 GB VRAM" }
    "AfterEffects"  = @{ RAM_GB = 16; GPU_VRAM_GB = 2; CPU_CORES = 6; Note = "De pago — requiere suscripción Adobe CC" }
    "Unity"         = @{ RAM_GB = 8;  GPU_VRAM_GB = 1; CPU_CORES = 4; Note = "Recomendado: 16 GB RAM para proyectos grandes" }
    "UnrealEngine"  = @{ RAM_GB = 16; GPU_VRAM_GB = 8; CPU_CORES = 8; Note = "Motor AAA — requiere hardware potente" }
    "Fusion360"     = @{ RAM_GB = 4;  GPU_VRAM_GB = 1; CPU_CORES = 4; Note = "Requiere internet para uso online" }
    "Krita"         = @{ RAM_GB = 4;  GPU_VRAM_GB = 0; CPU_CORES = 2; Note = "Open source, relativamente ligero" }
    "GIMP"          = @{ RAM_GB = 2;  GPU_VRAM_GB = 0; CPU_CORES = 2; Note = "Ligero, compatible con casi cualquier equipo" }
    "Kdenlive"      = @{ RAM_GB = 4;  GPU_VRAM_GB = 1; CPU_CORES = 4; Note = "Editor de video open source" }
    "Audacity"      = @{ RAM_GB = 2;  GPU_VRAM_GB = 0; CPU_CORES = 1; Note = "Editor de audio muy ligero" }
    "VirtualBox"    = @{ RAM_GB = 8;  GPU_VRAM_GB = 0; CPU_CORES = 4; Note = "Necesitas RAM extra para las VMs" }
    "VMwarePlayer"  = @{ RAM_GB = 8;  GPU_VRAM_GB = 0; CPU_CORES = 4; Note = "Necesitas RAM extra para las VMs" }
    "Anaconda"      = @{ RAM_GB = 4;  GPU_VRAM_GB = 0; CPU_CORES = 2; Note = "Puede ocupar hasta 5 GB de disco" }
}

function Start-HardwareScan {
    $hwList = $window.FindName("HardwareResultsList")
    if (-not $hwList) { return }
    $hwList.Children.Clear()

    $btnScan = $window.FindName("BtnScanHardware")
    $btnIcon = $window.FindName("BtnScanIcon")
    if ($btnScan) { $btnScan.IsEnabled = $false }

    # ── Loader animado ────────────────────────────────────────────────
    $scanPanel = New-Object System.Windows.Controls.StackPanel
    $scanPanel.HorizontalAlignment = "Center"; $scanPanel.Margin = [System.Windows.Thickness]::new(0,50,0,0)

    $scanIco = New-Object System.Windows.Controls.TextBlock
    $scanIco.Text = "🖥️"; $scanIco.FontSize = 48; $scanIco.HorizontalAlignment = "Center"
    $scanIco.Margin = [System.Windows.Thickness]::new(0,0,0,16)
    $scanPanel.Children.Add($scanIco)

    $scanTitle = New-Object System.Windows.Controls.TextBlock
    $scanTitle.Text = "Analizando hardware..."; $scanTitle.FontSize = 16; $scanTitle.FontWeight = "SemiBold"
    $scanTitle.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FFE8E0FF"))
    $scanTitle.HorizontalAlignment = "Center"; $scanTitle.Margin = [System.Windows.Thickness]::new(0,0,0,6)
    $scanPanel.Children.Add($scanTitle)
    $script:_scanStatusRef = $scanTitle

    $scanSteps = @("Detectando procesador...", "Midiendo RAM instalada...", "Identificando GPU...", "Verificando almacenamiento...", "Calculando compatibilidad...")
    $script:_scanStep = 0

    $scanSub = New-Object System.Windows.Controls.TextBlock
    $scanSub.Text = $scanSteps[0]; $scanSub.FontSize = 12
    $scanSub.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9D6FFF"))
    $scanSub.HorizontalAlignment = "Center"; $scanSub.Margin = [System.Windows.Thickness]::new(0,0,0,24)
    $scanPanel.Children.Add($scanSub)
    $script:_scanSubRef = $scanSub
    $script:_scanSteps  = $scanSteps

    # Barra de progreso determinada
    $barOut = New-Object System.Windows.Controls.Border
    $barOut.Width = 320; $barOut.Height = 8; $barOut.CornerRadius = [System.Windows.CornerRadius]::new(4)
    $barOut.Background = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF201840"))
    $barOut.HorizontalAlignment = "Center"
    $script:_hwBarFill = New-Object System.Windows.Controls.Border
    $script:_hwBarFill.Width = 0; $script:_hwBarFill.Height = 8
    $script:_hwBarFill.CornerRadius = [System.Windows.CornerRadius]::new(4)
    $script:_hwBarFill.Background = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9D6FFF"))
    $script:_hwBarFill.HorizontalAlignment = "Left"
    $barOut.Child = $script:_hwBarFill
    $scanPanel.Children.Add($barOut)
    $hwList.Children.Add($scanPanel)
    $hwList.Dispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Render)

    # ── Job de escaneo de hardware ─────────────────────────────────────
    $script:_hwJob = Start-Job -ScriptBlock {
        $result = @{}

        # CPU
        try {
            $cpu = Get-CimInstance Win32_Processor -ErrorAction Stop | Select-Object -First 1
            $result.CPU_Name   = $cpu.Name.Trim()
            $result.CPU_Cores  = [int]$cpu.NumberOfCores
            $result.CPU_Threads= [int]$cpu.NumberOfLogicalProcessors
            $result.CPU_GHz    = [math]::Round($cpu.MaxClockSpeed / 1000, 1)
        } catch { $result.CPU_Name = "Desconocido"; $result.CPU_Cores = 1; $result.CPU_GHz = 0 }

        # RAM
        try {
            $ram = Get-CimInstance Win32_PhysicalMemory -ErrorAction Stop
            $result.RAM_Total_GB = [math]::Round(($ram | Measure-Object -Property Capacity -Sum).Sum / 1GB, 1)
        } catch {
            try {
                $os = Get-CimInstance Win32_OperatingSystem
                $result.RAM_Total_GB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
            } catch { $result.RAM_Total_GB = 0 }
        }

        # GPU
        try {
            $gpus = Get-CimInstance Win32_VideoController -ErrorAction Stop | Where-Object { $_.AdapterRAM -gt 0 }
            if ($gpus) {
                $gpu = $gpus | Sort-Object AdapterRAM -Descending | Select-Object -First 1
                $result.GPU_Name    = $gpu.Name.Trim()
                $result.GPU_VRAM_GB = [math]::Round($gpu.AdapterRAM / 1GB, 1)
            } else {
                $result.GPU_Name = "Integrada / Desconocida"; $result.GPU_VRAM_GB = 0
            }
        } catch { $result.GPU_Name = "Desconocida"; $result.GPU_VRAM_GB = 0 }

        # Disco
        try {
            $disk = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" -ErrorAction Stop |
                Sort-Object FreeSpace -Descending | Select-Object -First 1
            $result.Disk_Free_GB  = [math]::Round($disk.FreeSpace / 1GB, 1)
            $result.Disk_Total_GB = [math]::Round($disk.Size / 1GB, 1)
        } catch { $result.Disk_Free_GB = 0; $result.Disk_Total_GB = 0 }

        # OS
        try {
            $os2 = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
            $result.OS_Name    = $os2.Caption.Trim()
            $result.OS_Version = $os2.Version
        } catch { $result.OS_Name = "Windows"; $result.OS_Version = "" }

        return $result
    }

    # ── Poll timer del escáner ─────────────────────────────────────────
    $script:_hwPollStep = 0
    $script:_hwPollTimer = New-Object System.Windows.Threading.DispatcherTimer
    $script:_hwPollTimer.Interval = [TimeSpan]::FromMilliseconds(500)
    $script:_hwPollTimer.Add_Tick({
        # Avanzar animación de pasos
        $script:_hwPollStep++
        $stepIdx = [Math]::Min($script:_hwPollStep - 1, $script:_scanSteps.Count - 1)
        $pct = [Math]::Min(90, $script:_hwPollStep * 18)
        if ($script:_scanSubRef)  { $script:_scanSubRef.Text  = $script:_scanSteps[$stepIdx] }
        if ($script:_hwBarFill)   { $script:_hwBarFill.Width  = [Math]::Round($pct / 100 * 320) }

        if (-not $script:_hwJob -or $script:_hwJob.State -notin @("Completed","Failed","Stopped")) { return }

        $script:_hwPollTimer.Stop()
        if ($script:_hwBarFill)  { $script:_hwBarFill.Width  = 320 }
        if ($script:_scanSubRef) { $script:_scanSubRef.Text  = "¡Análisis completo!" }

        $hw = $null
        try { $hw = Receive-Job $script:_hwJob } catch {}
        Remove-Job $script:_hwJob -Force -ErrorAction SilentlyContinue
        $script:_hwJob = $null

        $hwL = $window.FindName("HardwareResultsList")
        if (-not $hwL) { return }
        $hwL.Children.Clear()

        if (-not $hw) {
            $err = New-Object System.Windows.Controls.TextBlock
            $err.Text = "No se pudo obtener la información de hardware."
            $err.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FFDA3633"))
            $err.FontSize = 14; $err.Margin = [System.Windows.Thickness]::new(0,40,0,0); $err.TextAlignment = "Center"
            $hwL.Children.Add($err)
            $btnScanEl = $window.FindName("BtnScanHardware"); if ($btnScanEl) { $btnScanEl.IsEnabled = $true }
            return
        }

        # ── Panel de resumen de hardware ──────────────────────────────
        $summaryBorder = New-Object System.Windows.Controls.Border
        $summaryBorder.Background = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF13102A"))
        $summaryBorder.BorderBrush = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF3D2F6B"))
        $summaryBorder.BorderThickness = [System.Windows.Thickness]::new(1)
        $summaryBorder.CornerRadius = [System.Windows.CornerRadius]::new(10)
        $summaryBorder.Padding = [System.Windows.Thickness]::new(24,18,24,18)
        $summaryBorder.Margin = [System.Windows.Thickness]::new(0,0,0,24)

        $summaryGrid = New-Object System.Windows.Controls.Grid
        foreach ($i in 1..4) {
            $cd = New-Object System.Windows.Controls.ColumnDefinition; $cd.Width = "*"
            $summaryGrid.ColumnDefinitions.Add($cd)
        }

        $hwItems = @(
            @{ Icon="🧠"; Label="Procesador"; Value="$($hw.CPU_Name)"; Sub="$($hw.CPU_Cores) núcleos · $($hw.CPU_GHz) GHz" },
            @{ Icon="💾"; Label="Memoria RAM"; Value="$($hw.RAM_Total_GB) GB"; Sub="RAM instalada" },
            @{ Icon="🎮"; Label="GPU"; Value="$($hw.GPU_Name)"; Sub="VRAM: $($hw.GPU_VRAM_GB) GB" },
            @{ Icon="💿"; Label="Almacenamiento"; Value="$($hw.Disk_Free_GB) GB libre"; Sub="de $($hw.Disk_Total_GB) GB total" }
        )

        for ($i = 0; $i -lt $hwItems.Count; $i++) {
            $item = $hwItems[$i]
            $cell = New-Object System.Windows.Controls.StackPanel
            $cell.HorizontalAlignment = "Center"; $cell.Margin = [System.Windows.Thickness]::new(8,0,8,0)

            $cellIco = New-Object System.Windows.Controls.TextBlock
            $cellIco.Text = $item.Icon; $cellIco.FontSize = 28; $cellIco.HorizontalAlignment = "Center"
            $cellIco.Margin = [System.Windows.Thickness]::new(0,0,0,6)
            $cell.Children.Add($cellIco)

            $cellLabel = New-Object System.Windows.Controls.TextBlock
            $cellLabel.Text = $item.Label; $cellLabel.FontSize = 10; $cellLabel.FontWeight = "Bold"
            $cellLabel.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9D6FFF"))
            $cellLabel.HorizontalAlignment = "Center"; $cellLabel.Margin = [System.Windows.Thickness]::new(0,0,0,3)
            $cell.Children.Add($cellLabel)

            $cellVal = New-Object System.Windows.Controls.TextBlock
            $cellVal.Text = $item.Value; $cellVal.FontSize = 12; $cellVal.FontWeight = "SemiBold"
            $cellVal.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FFE8E0FF"))
            $cellVal.HorizontalAlignment = "Center"; $cellVal.TextWrapping = "Wrap"; $cellVal.TextAlignment = "Center"
            $cell.Children.Add($cellVal)

            $cellSub = New-Object System.Windows.Controls.TextBlock
            $cellSub.Text = $item.Sub; $cellSub.FontSize = 10
            $cellSub.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF6B5F9E"))
            $cellSub.HorizontalAlignment = "Center"; $cellSub.TextAlignment = "Center"
            $cell.Children.Add($cellSub)

            [System.Windows.Controls.Grid]::SetColumn($cell, $i)
            $summaryGrid.Children.Add($cell)
        }
        $summaryBorder.Child = $summaryGrid
        $hwL.Children.Add($summaryBorder)

        # ── Compatibilidad por categoría ──────────────────────────────
        $compatTitle = New-Object System.Windows.Controls.TextBlock
        $compatTitle.Text = "  🎯  COMPATIBILIDAD POR CATEGORÍA"
        $compatTitle.FontSize = 12; $compatTitle.FontWeight = "Bold"
        $compatTitle.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9D6FFF"))
        $compatTitle.Margin = [System.Windows.Thickness]::new(0,0,0,12)
        $hwL.Children.Add($compatTitle)

        $categories = @(
            @{ Name="Navegadores";  Req=@{ RAM_GB=2; GPU_VRAM_GB=0; CPU_CORES=1 }; Icon="🌐"; AppsNote="" }
            @{ Name="Comunicación"; Req=@{ RAM_GB=2; GPU_VRAM_GB=0; CPU_CORES=1 }; Icon="💬"; AppsNote="" }
            @{ Name="Programación"; Req=@{ RAM_GB=4; GPU_VRAM_GB=0; CPU_CORES=2 }; Icon="💻"; AppsNote="IDEs como IntelliJ recomiendan 8 GB" }
            @{ Name="Mecatrónica";  Req=@{ RAM_GB=4; GPU_VRAM_GB=1; CPU_CORES=2 }; Icon="⚙️"; AppsNote="CAD y simulación requieren GPU básica" }
            @{ Name="Animación 2D"; Req=@{ RAM_GB=4; GPU_VRAM_GB=0; CPU_CORES=2 }; Icon="🎨"; AppsNote="Krita, Inkscape y GIMP son ligeros" }
            @{ Name="Animación 3D"; Req=@{ RAM_GB=8; GPU_VRAM_GB=2; CPU_CORES=4 }; Icon="🟠"; AppsNote="Blender: recomendado 16 GB + GPU dedicada" }
            @{ Name="Video/Audio";  Req=@{ RAM_GB=8; GPU_VRAM_GB=2; CPU_CORES=4 }; Icon="🎬"; AppsNote="DaVinci Resolve requiere GPU con 4 GB VRAM" }
            @{ Name="Virtualización";Req=@{ RAM_GB=8; GPU_VRAM_GB=0; CPU_CORES=4 }; Icon="🖥️"; AppsNote="Reserva RAM extra para las VMs" }
            @{ Name="Extras/Herram.";Req=@{ RAM_GB=2; GPU_VRAM_GB=0; CPU_CORES=1 }; Icon="🎁"; AppsNote="" }
        )

        foreach ($cat in $categories) {
            $ramOk  = $hw.RAM_Total_GB  -ge $cat.Req.RAM_GB
            $gpuOk  = $hw.GPU_VRAM_GB   -ge $cat.Req.GPU_VRAM_GB
            $cpuOk  = $hw.CPU_Cores     -ge $cat.Req.CPU_CORES
            $allOk  = $ramOk -and $gpuOk -and $cpuOk

            # Color del borde según compatibilidad
            $borderCol = if ($allOk) { "#FF1D4A2A" } elseif ($ramOk -and $cpuOk) { "#FF3A2E00" } else { "#FF3A1515" }
            $accentCol = if ($allOk) { "#FF4CAF50" } elseif ($ramOk -and $cpuOk) { "#FFFFB300" } else { "#FFDA3633" }
            $statusTxt = if ($allOk) { "✅  Compatible" } elseif ($ramOk -and $cpuOk) { "⚠️  Parcialmente compatible" } else { "❌  Puede tener problemas" }

            $catBorder = New-Object System.Windows.Controls.Border
            $catBorder.Background = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString($borderCol))
            $catBorder.BorderBrush = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString($accentCol))
            $catBorder.BorderThickness = [System.Windows.Thickness]::new(1)
            $catBorder.CornerRadius = [System.Windows.CornerRadius]::new(8)
            $catBorder.Padding = [System.Windows.Thickness]::new(16,12,16,12)
            $catBorder.Margin = [System.Windows.Thickness]::new(0,0,0,8)

            $catGrid = New-Object System.Windows.Controls.Grid
            $cdA = New-Object System.Windows.Controls.ColumnDefinition; $cdA.Width = "Auto"
            $cdS = New-Object System.Windows.Controls.ColumnDefinition; $cdS.Width = "*"
            $cdR = New-Object System.Windows.Controls.ColumnDefinition; $cdR.Width = "Auto"
            $catGrid.ColumnDefinitions.Add($cdA); $catGrid.ColumnDefinitions.Add($cdS); $catGrid.ColumnDefinitions.Add($cdR)

            $catIco = New-Object System.Windows.Controls.TextBlock
            $catIco.Text = $cat.Icon; $catIco.FontSize = 22; $catIco.VerticalAlignment = "Center"
            $catIco.Margin = [System.Windows.Thickness]::new(0,0,12,0)
            [System.Windows.Controls.Grid]::SetColumn($catIco, 0); $catGrid.Children.Add($catIco)

            $catInfo = New-Object System.Windows.Controls.StackPanel; $catInfo.VerticalAlignment = "Center"
            $catName = New-Object System.Windows.Controls.TextBlock
            $catName.Text = $cat.Name; $catName.FontSize = 14; $catName.FontWeight = "SemiBold"
            $catName.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FFE8E0FF"))
            $catInfo.Children.Add($catName)

            $reqLine = "RAM: $($cat.Req.RAM_GB) GB · CPU: $($cat.Req.CPU_CORES) núcleos"
            if ($cat.Req.GPU_VRAM_GB -gt 0) { $reqLine += " · GPU: $($cat.Req.GPU_VRAM_GB) GB VRAM" }
            $catReq = New-Object System.Windows.Controls.TextBlock
            $catReq.Text = $reqLine; $catReq.FontSize = 11
            $catReq.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9080BB"))
            $catInfo.Children.Add($catReq)

            if ($cat.AppsNote) {
                $catNote = New-Object System.Windows.Controls.TextBlock
                $catNote.Text = "💡 $($cat.AppsNote)"; $catNote.FontSize = 10
                $catNote.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9D6FFF"))
                $catNote.Margin = [System.Windows.Thickness]::new(0,2,0,0)
                $catInfo.Children.Add($catNote)
            }

            [System.Windows.Controls.Grid]::SetColumn($catInfo, 1); $catGrid.Children.Add($catInfo)

            $statusBadge = New-Object System.Windows.Controls.Border
            $statusBadge.Background = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString($borderCol))
            $statusBadge.BorderBrush = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString($accentCol))
            $statusBadge.BorderThickness = [System.Windows.Thickness]::new(1)
            $statusBadge.CornerRadius = [System.Windows.CornerRadius]::new(6)
            $statusBadge.Padding = [System.Windows.Thickness]::new(12,6,12,6)
            $statusBadge.VerticalAlignment = "Center"; $statusBadge.Margin = [System.Windows.Thickness]::new(12,0,0,0)
            $statusTb = New-Object System.Windows.Controls.TextBlock
            $statusTb.Text = $statusTxt; $statusTb.FontSize = 12; $statusTb.FontWeight = "SemiBold"
            $statusTb.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString($accentCol))
            $statusBadge.Child = $statusTb
            [System.Windows.Controls.Grid]::SetColumn($statusBadge, 2); $catGrid.Children.Add($statusBadge)

            $catBorder.Child = $catGrid
            $hwL.Children.Add($catBorder)
        }

        # Botón para ir a instalar apps compatibles
        $goBtn = New-Object System.Windows.Controls.Button
        $goBtn.Content = "📦  Ver apps compatibles en Instalar Apps"
        $goBtn.Padding = [System.Windows.Thickness]::new(20,12,20,12)
        $goBtn.Cursor = [System.Windows.Input.Cursors]::Hand
        $goBtn.Margin = [System.Windows.Thickness]::new(0,20,0,0)
        $goBtn.Background = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF1A1535"))
        $goBtn.BorderBrush = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9D6FFF"))
        $goBtn.BorderThickness = [System.Windows.Thickness]::new(1)
        $goBtn.Foreground = [System.Windows.Media.SolidColorBrush]([System.Windows.Media.ColorConverter]::ConvertFromString("#FF9D6FFF"))
        $goBtn.FontSize = 13; $goBtn.HorizontalAlignment = "Center"
        $goBtn.Add_Click({ Switch-View "Instalar" })
        $hwL.Children.Add($goBtn)

        # Rehabilitar el botón escanear
        $btnScanEl2 = $window.FindName("BtnScanHardware"); if ($btnScanEl2) { $btnScanEl2.IsEnabled = $true }
    })
    $script:_hwPollTimer.Start()
}


# ══════════════════════════════════════════════════════════════════════
# LIMPIEZA DE SEGURIDAD PROFUNDA — inspirada en Tron Script
# Fases: Temporales → Defender → Registro → DISM+SFC → Red
# NO desinstala software legítimo ni modifica configuración de usuario
# ══════════════════════════════════════════════════════════════════════

function Start-SecurityClean {

    # Ventana de progreso
    [xml]$scXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="NeXus — Limpieza de Seguridad" Width="580" Height="370"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        WindowStartupLocation="CenterScreen" Topmost="True" ResizeMode="NoResize">
    <Border Background="#FF0D0B1A" CornerRadius="12" BorderBrush="#FF9D6FFF" BorderThickness="1">
        <StackPanel Margin="28,22,28,22">
            <StackPanel Orientation="Horizontal" Margin="0,0,0,16">
                <TextBlock Text="🛡️" FontSize="22" Margin="0,0,10,0" VerticalAlignment="Center"/>
                <TextBlock Text="Limpieza de Seguridad Profunda" FontFamily="Segoe UI"
                           FontSize="17" FontWeight="SemiBold" Foreground="#FFE8E0FF" VerticalAlignment="Center"/>
            </StackPanel>
            <TextBlock x:Name="ScPhaseLabel" FontFamily="Segoe UI" FontSize="13"
                       FontWeight="SemiBold" Foreground="#FF9D6FFF" Margin="0,0,0,6" TextWrapping="Wrap"/>
            <TextBlock x:Name="ScDetailLabel" FontFamily="Segoe UI" FontSize="11"
                       Foreground="#FF9080BB" Margin="0,0,0,10" TextWrapping="Wrap"/>
            <Border Background="#FF1A1535" CornerRadius="4" Height="8" Margin="0,0,0,6">
                <Border x:Name="ScBarPhase" Background="#FF9D6FFF" CornerRadius="4"
                        HorizontalAlignment="Left" Width="0"/>
            </Border>
            <TextBlock x:Name="ScPctLabel" FontFamily="Consolas" FontSize="11"
                       Foreground="#FF6B5F9E" Margin="0,0,0,14"/>
            <Border Background="#FF1A1535" CornerRadius="4" Height="6">
                <Border x:Name="ScBarTotal" Background="#FF4CAF50" CornerRadius="4"
                        HorizontalAlignment="Left" Width="0"/>
            </Border>
            <TextBlock x:Name="ScTotalLabel" FontFamily="Segoe UI" FontSize="11"
                       Foreground="#FF9080BB" Margin="0,6,0,14"/>
            <Border Background="#FF13102A" CornerRadius="6" Padding="12,8" Height="80">
                <ScrollViewer VerticalScrollBarVisibility="Auto">
                    <TextBlock x:Name="ScLog" FontFamily="Consolas" FontSize="10"
                               Foreground="#FF6B5F9E" TextWrapping="Wrap"/>
                </ScrollViewer>
            </Border>
        </StackPanel>
    </Border>
</Window>
"@
    $scReader = New-Object System.Xml.XmlNodeReader($scXaml)
    $scWin    = [Windows.Markup.XamlReader]::Load($scReader)
    $scWin.Show()
    $scWin.Dispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Render)

    $scPhase   = $scWin.FindName("ScPhaseLabel")
    $scDetail  = $scWin.FindName("ScDetailLabel")
    $scBarP    = $scWin.FindName("ScBarPhase")
    $scPct     = $scWin.FindName("ScPctLabel")
    $scBarT    = $scWin.FindName("ScBarTotal")
    $scTotal   = $scWin.FindName("ScTotalLabel")
    $scLog     = $scWin.FindName("ScLog")
    $scBarMax  = 520

    function Update-ScUI($phase, $detail, $phasePct, $totalPct, $log) {
        $p=$phase; $d=$detail; $pp=$phasePct; $tp=$totalPct; $l=$log; $bm=$scBarMax
        $scWin.Dispatcher.Invoke([Action]{
            $scPhase.Text  = $p; $scDetail.Text = $d
            $scBarP.Width  = [Math]::Round($pp/100*$bm)
            $scPct.Text    = "$pp%  •  Fase en curso..."
            $scBarT.Width  = [Math]::Round($tp/100*$bm)
            $scTotal.Text  = "Progreso total: $tp%"
            if ($l) { $scLog.Text += "`n$l" }
        }, [System.Windows.Threading.DispatcherPriority]::Render)
    }

    $totalPhases = 5

    # ── FASE 1: Limpieza de archivos temporales ───────────────────────
    Update-ScUI "Fase 1/5 — Limpieza de temporales" "Eliminando archivos temp, caché y prefetch..." 0 0 "[INICIO] Limpieza de seguridad NeXus"

    $job1 = Start-Job -ScriptBlock {
        $removed = 0; $log = @()

        # Temporales del sistema y usuario
        $tempPaths = @(
            $env:TEMP, $env:TMP,
            "$env:WINDIR\Temp",
            "$env:WINDIR\Prefetch",
            "$env:LOCALAPPDATA\Temp",
            "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
            "$env:LOCALAPPDATA\Microsoft\Windows\WebCache"
        )
        foreach ($tp in $tempPaths) {
            if (-not $tp -or -not (Test-Path $tp -ErrorAction SilentlyContinue)) { continue }
            try {
                $files = Get-ChildItem $tp -Recurse -Force -ErrorAction SilentlyContinue |
                    Where-Object { -not $_.PSIsContainer }
                foreach ($f in $files) {
                    try { Remove-Item $f.FullName -Force -ErrorAction Stop; $removed++ } catch {}
                }
                $log += "  Limpiado: $tp ($($files.Count) archivos)"
            } catch {}
        }

        # Papelera
        try { Clear-RecycleBin -Force -ErrorAction SilentlyContinue; $log += "  Papelera vaciada" } catch {}

        # Limpieza con cleanmgr (silencioso)
        try {
            $sageset = "StateFlags0099"
            $cleanKeys = @(
                "Temporary Files","Temporary Internet Files","Downloaded Program Files",
                "Recycle Bin","Thumbnails","Windows Error Reporting"
            )
            foreach ($ck in $cleanKeys) {
                $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$ck"
                if (Test-Path $regPath) { Set-ItemProperty $regPath -Name $sageset -Value 2 -ErrorAction SilentlyContinue }
            }
            Start-Process "cleanmgr.exe" -ArgumentList "/sagerun:99" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
            $log += "  Disk Cleanup (cleanmgr) ejecutado"
        } catch {}

        return @{ Removed = $removed; Log = $log }
    }

    # Animar fase 1
    $elapsed = 0
    while ($job1.State -eq "Running") {
        Start-Sleep -Milliseconds 400; $elapsed += 0.4
        $pct = [Math]::Min(85, [Math]::Round($elapsed * 8))
        Update-ScUI "Fase 1/5 — Limpieza de temporales" "Borrando archivos..." $pct 5 $null
    }
    $r1 = Receive-Job $job1; Remove-Job $job1 -Force
    Update-ScUI "Fase 1/5 ✅ Completada" "Temporales eliminados: $($r1.Removed) archivos" 100 20 ($r1.Log -join "`n")
    Start-Sleep -Milliseconds 600

    # ── FASE 2: Windows Defender — escaneo rápido + limpieza PUPs ────
    Update-ScUI "Fase 2/5 — Escaneo con Windows Defender" "Ejecutando escaneo rápido de amenazas..." 0 20 "[FASE 2] Iniciando Windows Defender"

    $job2 = Start-Job -ScriptBlock {
        $log = @()
        try {
            # Actualizar firmas
            Update-MpSignature -ErrorAction SilentlyContinue
            $log += "  Firmas de Defender actualizadas"

            # Escaneo rápido
            Start-MpScan -ScanType QuickScan -ErrorAction SilentlyContinue
            $log += "  Escaneo rápido completado"

            # Obtener amenazas detectadas y limpiarlas
            $threats = Get-MpThreat -ErrorAction SilentlyContinue
            if ($threats) {
                foreach ($t in $threats) {
                    try {
                        Remove-MpThreat -ThreatID $t.ThreatID -ErrorAction SilentlyContinue
                        $log += "  Amenaza eliminada: $($t.ThreatName)"
                    } catch {}
                }
            } else {
                $log += "  Sin amenazas detectadas por Defender"
            }

            # Limpiar historial de cuarentena antiguo (más de 30 días)
            $quarPath = "$env:ProgramData\Microsoft\Windows Defender\Quarantine"
            if (Test-Path $quarPath) {
                $old = Get-ChildItem $quarPath -Recurse -ErrorAction SilentlyContinue |
                    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }
                foreach ($o in $old) { try { Remove-Item $o.FullName -Force -ErrorAction SilentlyContinue } catch {} }
                $log += "  Cuarentena antigua limpiada ($($old.Count) entradas)"
            }
        } catch {
            $log += "  Defender no disponible o sin permisos: $_"
        }
        return $log
    }

    $elapsed = 0
    while ($job2.State -eq "Running") {
        Start-Sleep -Milliseconds 500; $elapsed += 0.5
        $pct = [Math]::Min(85, [Math]::Round($elapsed * 4))
        Update-ScUI "Fase 2/5 — Escaneo con Windows Defender" "Escaneando amenazas activas..." $pct 30 $null
    }
    $r2 = Receive-Job $job2; Remove-Job $job2 -Force
    Update-ScUI "Fase 2/5 ✅ Completada" "Defender ejecutado" 100 40 ($r2 -join "`n")
    Start-Sleep -Milliseconds 600

    # ── FASE 3: Limpieza de registro (entradas maliciosas conocidas) ──
    Update-ScUI "Fase 3/5 — Limpieza de registro" "Eliminando entradas de adware/PUPs conocidas..." 0 40 "[FASE 3] Analizando registro"

    $job3 = Start-Job -ScriptBlock {
        $log = @(); $removed = 0

        # Rutas de inicio automático sospechosas (Run keys)
        $runKeys = @(
            "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
            "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",
            "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
        )

        # Nombres de procesos/claves conocidos de adware y PUPs (no afectan software legítimo)
        $knownBad = @(
            "conduit","sweetim","babylon","searchprotect","tbcore","mywebsearch",
            "delta toolbar","iminent","wajam","crossrider","pirrit","superfish",
            "savingsslider","dealply","shopperz","istart","browsefox","adpeak",
            "adware","spigot","opencandy","installcore","iobit_monitor_daemon",
            "reimage","pc speed maximizer","driver booster.*nag","advanced systemcare.*popup"
        )

        foreach ($rk in $runKeys) {
            if (-not (Test-Path $rk -ErrorAction SilentlyContinue)) { continue }
            try {
                $props = Get-ItemProperty $rk -ErrorAction SilentlyContinue
                if (-not $props) { continue }
                foreach ($prop in ($props.PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' })) {
                    $val = [string]$prop.Value
                    $matched = $false
                    foreach ($bad in $knownBad) {
                        if ($val -match $bad -or $prop.Name -match $bad) { $matched = $true; break }
                    }
                    if ($matched) {
                        try {
                            Remove-ItemProperty -Path $rk -Name $prop.Name -Force -ErrorAction Stop
                            $log += "  Eliminado de Run: $($prop.Name) = $val"
                            $removed++
                        } catch {}
                    }
                }
            } catch { continue }
        }

        # Limpiar extensiones de navegador huérfanas del registro (IE/Legacy)
        $ieKeys = @(
            "HKCU:\SOFTWARE\Microsoft\Internet Explorer\Extensions",
            "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Extensions"
        )
        foreach ($iek in $ieKeys) {
            if (-not (Test-Path $iek -ErrorAction SilentlyContinue)) { continue }
            Get-ChildItem $iek -ErrorAction SilentlyContinue | ForEach-Object {
                try {
                    $p = $_ | Get-ItemProperty -ErrorAction SilentlyContinue
                    if ($p.ButtonText -match ($knownBad -join '|')) {
                        Remove-Item $_.PSPath -Recurse -Force -ErrorAction SilentlyContinue
                        $log += "  Extensión IE sospechosa eliminada: $($p.ButtonText)"
                        $removed++
                    }
                } catch {}
            }
        }

        if ($removed -eq 0) { $log += "  Registro limpio, sin entradas maliciosas detectadas" }
        return @{ Log = $log; Removed = $removed }
    }

    $elapsed = 0
    while ($job3.State -eq "Running") {
        Start-Sleep -Milliseconds 400; $elapsed += 0.4
        $pct = [Math]::Min(90, [Math]::Round($elapsed * 12))
        Update-ScUI "Fase 3/5 — Limpieza de registro" "Analizando claves Run y extensiones..." $pct 50 $null
    }
    $r3 = Receive-Job $job3; Remove-Job $job3 -Force
    Update-ScUI "Fase 3/5 ✅ Completada" "Entradas eliminadas: $($r3.Removed)" 100 60 ($r3.Log -join "`n")
    Start-Sleep -Milliseconds 600

    # ── FASE 4: DISM + SFC (reparación de Windows) ───────────────────
    Update-ScUI "Fase 4/5 — Reparación de Windows" "Ejecutando SFC y DISM para restaurar archivos del sistema..." 0 60 "[FASE 4] Reparación de integridad del sistema"

    $job4 = Start-Job -ScriptBlock {
        $log = @()
        try {
            # SFC rápido (solo verificación, no reparación completa que tarda mucho)
            $sfcResult = & sfc /verifyonly 2>&1 | Out-String
            if ($sfcResult -match "no encontró ninguna infracción" -or $sfcResult -match "did not find any integrity violations") {
                $log += "  SFC: Sin infracciones de integridad detectadas"
            } else {
                # Si hay infracciones, lanzar reparación
                Start-Process "sfc.exe" -ArgumentList "/scannow" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
                $log += "  SFC: Reparación ejecutada"
            }
        } catch { $log += "  SFC no disponible: $_" }

        try {
            # DISM — solo limpieza de componentes obsoletos (no reparación completa)
            $dismResult = Start-Process "dism.exe" -ArgumentList "/Online /Cleanup-Image /StartComponentCleanup /ResetBase" -Wait -PassThru -WindowStyle Hidden -ErrorAction SilentlyContinue
            if ($dismResult.ExitCode -eq 0) { $log += "  DISM: Componentes obsoletos limpiados" }
            else { $log += "  DISM: Limpieza completada (código $($dismResult.ExitCode))" }
        } catch { $log += "  DISM no disponible: $_" }

        return $log
    }

    $elapsed = 0
    while ($job4.State -eq "Running") {
        Start-Sleep -Milliseconds 800; $elapsed += 0.8
        $pct = [Math]::Min(88, [Math]::Round($elapsed * 3))
        Update-ScUI "Fase 4/5 — Reparación de Windows" "SFC + DISM en ejecución (puede tardar unos minutos)..." $pct 75 $null
    }
    $r4 = Receive-Job $job4; Remove-Job $job4 -Force
    Update-ScUI "Fase 4/5 ✅ Completada" "SFC y DISM finalizados" 100 80 ($r4 -join "`n")
    Start-Sleep -Milliseconds 600

    # ── FASE 5: Reparación de red (DNS, Winsock) ─────────────────────
    Update-ScUI "Fase 5/5 — Reparación de red" "Limpiando DNS cache, reseteando Winsock y TCP/IP..." 0 80 "[FASE 5] Limpieza y reparación de red"

    $job5 = Start-Job -ScriptBlock {
        $log = @()
        try { & ipconfig /flushdns 2>&1 | Out-Null; $log += "  DNS cache limpiado" } catch {}
        try { & netsh winsock reset catalog 2>&1 | Out-Null; $log += "  Winsock reseteado" } catch {}
        try { & netsh int ip reset 2>&1 | Out-Null; $log += "  TCP/IP reseteado" } catch {}
        try { & netsh int ipv6 reset 2>&1 | Out-Null; $log += "  IPv6 reseteado" } catch {}
        try {
            # Limpiar archivo hosts de entradas maliciosas (conserva localhost)
            $hostsPath = "$env:WINDIR\System32\drivers\etc\hosts"
            if (Test-Path $hostsPath) {
                $lines = Get-Content $hostsPath -ErrorAction SilentlyContinue
                $clean = $lines | Where-Object {
                    $_ -match '^\s*#' -or $_ -match '^\s*$' -or $_ -match 'localhost' -or
                    # Solo conservar entradas que apuntan a 127.0.0.1 o ::1 (no redirecciones maliciosas a otras IPs)
                    ($_ -match '^\s*127\.0\.0\.1' -or $_ -match '^\s*::1' -or $_ -match '^\s*0\.0\.0\.0')
                }
                if ($clean.Count -lt $lines.Count) {
                    $clean | Set-Content $hostsPath -ErrorAction SilentlyContinue
                    $log += "  Hosts: $($lines.Count - $clean.Count) entradas sospechosas eliminadas"
                } else {
                    $log += "  Archivo hosts limpio, sin entradas maliciosas"
                }
            }
        } catch { $log += "  No se pudo revisar hosts: $_" }
        return $log
    }

    $elapsed = 0
    while ($job5.State -eq "Running") {
        Start-Sleep -Milliseconds 350; $elapsed += 0.35
        $pct = [Math]::Min(90, [Math]::Round($elapsed * 20))
        Update-ScUI "Fase 5/5 — Reparación de red" "Ejecutando netsh y flushdns..." $pct 90 $null
    }
    $r5 = Receive-Job $job5; Remove-Job $job5 -Force
    Update-ScUI "Fase 5/5 ✅ Completada" "Red reparada. Se recomienda reiniciar el equipo." 100 100 ($r5 -join "`n")
    Start-Sleep -Milliseconds 800

    $scWin.Close()

    Show-Toast -Title "🛡️ Limpieza de Seguridad Completada" `
               -Message "5 fases completadas. Reinicia el equipo para aplicar todos los cambios." `
               -Icon "🛡️" -DurationMs 5000
}


# ════════════════════════════════════════════════════════════════════════
# TABLA DE POST-INSTALACIÓN — rutas y comandos por app
# ════════════════════════════════════════════════════════════════════════
$script:postInstall = @{
    "NodeJS"        = @{ ExeHint="node.exe"; NeedsPath=$true; SetupCmds=@("npm install -g npm@latest") }
    "Python"        = @{ ExeHint="python.exe"; NeedsPath=$true; SetupCmds=@("python -m pip install --upgrade pip") }
    "Git"           = @{ ExeHint="git.exe"; NeedsPath=$true; SetupCmds=@() }
    "VSCode"        = @{ ExeHint="Code.exe"; ExeDirs=@("$env:LOCALAPPDATA\Programs\Microsoft VS Code") }
    "Anaconda"      = @{ ExeHint="anaconda-navigator.exe"; SetupCmds=@("conda update -n base -c defaults conda -y") }
    "DockerDesktop" = @{ ExeHint="Docker Desktop.exe"; ExeDirs=@("$env:ProgramFiles\Docker\Docker") }
    "PostgreSQL"    = @{ ExeHint="pgAdmin4.exe"; SetupCmds=@("net start postgresql-x64-15") }
    "Ruby"          = @{ ExeHint="ruby.exe"; NeedsPath=$true; SetupCmds=@("gem update --system") }
    "Go"            = @{ ExeHint="go.exe"; NeedsPath=$true }
    "Rust"          = @{ ExeHint="rustup.exe"; SetupCmds=@("rustup update stable") }
    "PowerShell7"   = @{ ExeHint="pwsh.exe"; ExeDirs=@("$env:ProgramFiles\PowerShell\7") }
    "Blender"       = @{ ExeHint="blender.exe" }
    "Krita"         = @{ ExeHint="krita.exe" }
    "GIMP"          = @{ ExeHint="gimp-2.10.exe"; ExeDirs=@("$env:ProgramFiles\GIMP 2\bin","$env:ProgramFiles\GIMP 3\bin") }
    "Inkscape"      = @{ ExeHint="inkscape.exe" }
    "OpenToonz"     = @{ ExeHint="OpenToonz.exe" }
    "Pencil2D"      = @{ ExeHint="pencil2d.exe" }
    "DaVinciResolve"= @{ ExeHint="Resolve.exe"; ExeDirs=@("$env:ProgramFiles\Blackmagic Design\DaVinci Resolve") }
    "Kdenlive"      = @{ ExeHint="kdenlive.exe" }
    "Audacity"      = @{ ExeHint="Audacity.exe" }
    "VLC"           = @{ ExeHint="vlc.exe" }
    "OBSStudio"     = @{ ExeHint="obs64.exe"; ExeDirs=@("$env:ProgramFiles\obs-studio\bin\64bit") }
    "ArduinoIDE"    = @{ ExeHint="arduino_debug.exe"; ExeDirs=@("$env:ProgramFiles\Arduino IDE") }
    "KiCad"         = @{ ExeHint="kicad.exe" }
    "FreeCAD"       = @{ ExeHint="FreeCAD.exe" }
    "Fusion360"     = @{ ExeHint="Fusion360.exe"; ExeDirs=@("$env:LOCALAPPDATA\Autodesk\webdeploy\production") }
    "Chrome"        = @{ ExeHint="chrome.exe"; ExeDirs=@("$env:ProgramFiles\Google\Chrome\Application","${env:ProgramFiles(x86)}\Google\Chrome\Application") }
    "Firefox"       = @{ ExeHint="firefox.exe"; ExeDirs=@("$env:ProgramFiles\Mozilla Firefox") }
    "Brave"         = @{ ExeHint="brave.exe"; ExeDirs=@("$env:ProgramFiles\BraveSoftware\Brave-Browser\Application") }
    "Opera"         = @{ ExeHint="opera.exe"; ExeDirs=@("$env:LOCALAPPDATA\Programs\Opera") }
    "OperaGX"       = @{ ExeHint="opera.exe"; ExeDirs=@("$env:LOCALAPPDATA\Programs\Opera GX") }
    "Discord"       = @{ ExeHint="Discord.exe"; ExeDirs=@("$env:LOCALAPPDATA\Discord") }
    "Telegram"      = @{ ExeHint="Telegram.exe"; ExeDirs=@("$env:APPDATA\Telegram Desktop") }
    "Slack"         = @{ ExeHint="slack.exe"; ExeDirs=@("$env:LOCALAPPDATA\slack") }
    "Zoom"          = @{ ExeHint="Zoom.exe"; ExeDirs=@("$env:APPDATA\Zoom\bin") }
    "Teams"         = @{ ExeHint="Teams.exe"; ExeDirs=@("$env:LOCALAPPDATA\Microsoft\Teams\current") }
    "WhatsApp"      = @{ ExeHint="WhatsApp.exe"; ExeDirs=@("$env:LOCALAPPDATA\WhatsApp") }
    "Rufus"         = @{ ExeHint="rufus*.exe"; ExeDirs=@("$env:ProgramFiles\Rufus","${env:ProgramFiles(x86)}\Rufus","$env:LOCALAPPDATA\Microsoft\WinGet\Packages") }
    "7Zip"          = @{ ExeHint="7zFM.exe"; ExeDirs=@("$env:ProgramFiles\7-Zip","${env:ProgramFiles(x86)}\7-Zip") }
    "Notepadpp"     = @{ ExeHint="notepad++.exe"; ExeDirs=@("$env:ProgramFiles\Notepad++","${env:ProgramFiles(x86)}\Notepad++") }
    "VirtualBox"    = @{ ExeHint="VirtualBox.exe"; ExeDirs=@("$env:ProgramFiles\Oracle\VirtualBox") }
    "Wireshark"     = @{ ExeHint="Wireshark.exe"; ExeDirs=@("$env:ProgramFiles\Wireshark") }
    "Malwarebytes"  = @{ ExeHint="mbam.exe"; ExeDirs=@("$env:ProgramFiles\Malwarebytes\Anti-Malware") }
}


function Resolve-AppExe {
    param([string]$AppKey, [string]$AppName)
    $hint  = $null; $extra = @()
    if ($script:postInstall -and $script:postInstall.ContainsKey($AppKey)) {
        $pi = $script:postInstall[$AppKey]
        $hint = $pi.ExeHint
        if ($pi.ExeDirs) { $extra = $pi.ExeDirs }
    }
    $normName = ($AppName -replace '[^a-zA-Z0-9]','').ToLower()
    if (-not $hint) { $hint = "$normName.exe" }

    # 1. Rutas especificas de postInstall
    foreach ($dir in $extra) {
        if (-not $dir -or -not (Test-Path $dir -ErrorAction SilentlyContinue)) { continue }
        $hit = Get-ChildItem $dir -Filter $hint -Recurse -Depth 3 -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -notmatch 'uninstall|setup|update|crash|helper' } |
            Select-Object -First 1
        if ($hit) { return $hit.FullName }
    }

    # 2. Registro de Windows
    $regRoots = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
    )
    foreach ($rr in $regRoots) {
        if (-not (Test-Path $rr -ErrorAction SilentlyContinue)) { continue }
        foreach ($sk in (Get-ChildItem $rr -ErrorAction SilentlyContinue)) {
            try {
                $p = $sk | Get-ItemProperty -ErrorAction Stop
                if (-not $p.DisplayName) { continue }
                $dn = ($p.DisplayName.ToLower() -replace '[^a-z0-9]','')
                if ($dn -like "*$normName*" -and $p.InstallLocation) {
                    $loc = $p.InstallLocation
                    if (Test-Path $loc -ErrorAction SilentlyContinue) {
                        $hit = Get-ChildItem $loc -Filter $hint -Recurse -Depth 3 -ErrorAction SilentlyContinue |
                            Where-Object { $_.Name -notmatch 'uninstall|setup|update|crash|helper' } |
                            Sort-Object Length -Descending | Select-Object -First 1
                        if ($hit) { return $hit.FullName }
                        $hit2 = Get-ChildItem $loc -Filter '*.exe' -Depth 2 -ErrorAction SilentlyContinue |
                            Where-Object { $_.Name -notmatch 'uninstall|setup|update|crash|helper' } |
                            Sort-Object Length -Descending | Select-Object -First 1
                        if ($hit2) { return $hit2.FullName }
                    }
                }
            } catch { continue }
        }
    }

    # 3. Menu de inicio
    $smpaths = @(
        "$env:APPDATA\Microsoft\Windows\Start Menu\Programs",
        "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
    )
    foreach ($smp in $smpaths) {
        if (-not (Test-Path $smp -ErrorAction SilentlyContinue)) { continue }
        $lnk = Get-ChildItem $smp -Filter '*.lnk' -Recurse -Depth 3 -ErrorAction SilentlyContinue |
            Where-Object { ($_.BaseName.ToLower() -replace '[^a-z0-9]','') -like "*$normName*" } |
            Select-Object -First 1
        if ($lnk) { return $lnk.FullName }
    }

    # 4. Program Files y WinGet
    $sdirs = @($env:ProgramFiles, ${env:ProgramFiles(x86)},
               "$env:LOCALAPPDATA\Programs",
               "$env:LOCALAPPDATA\Microsoft\WinGet\Packages")
    foreach ($sd in $sdirs) {
        if (-not $sd -or -not (Test-Path $sd -ErrorAction SilentlyContinue)) { continue }
        $hit = Get-ChildItem $sd -Filter $hint -Recurse -Depth 5 -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -notmatch 'uninstall|setup|update|crash|helper' } |
            Select-Object -First 1
        if ($hit) { return $hit.FullName }
    }
    return $null
}

function New-DesktopShortcut {
    param([string]$AppName, [string]$ExePath, [string]$Desc, [string]$Category)
    if (-not $ExePath) { return $false }
    if ($ExePath -notmatch '\.lnk$' -and -not (Test-Path $ExePath -ErrorAction SilentlyContinue)) { return $false }
    try {
        $wsh = New-Object -ComObject WScript.Shell
        # Escritorio del usuario
        $desktop = [Environment]::GetFolderPath('Desktop')
        $sc1 = $wsh.CreateShortcut("$desktop\$AppName.lnk")
        $sc1.TargetPath = $ExePath
        if ($ExePath -notmatch '\.lnk$') { $sc1.WorkingDirectory = (Split-Path $ExePath -ErrorAction SilentlyContinue) }
        $sc1.Description = $Desc
        $sc1.Save()
        # Carpeta interna NeXus
        $catDir = "C:\Nexus\Apps\$Category"
        if (-not (Test-Path $catDir)) { New-Item -ItemType Directory -Path $catDir -Force | Out-Null }
        $sc2 = $wsh.CreateShortcut("$catDir\$AppName.lnk")
        $sc2.TargetPath = $ExePath
        if ($ExePath -notmatch '\.lnk$') { $sc2.WorkingDirectory = (Split-Path $ExePath -ErrorAction SilentlyContinue) }
        $sc2.Description = $Desc
        $sc2.Save()
        return $true
    } catch { return $false }
}

function Invoke-PostInstall {
    param([string]$AppKey, [string]$ExePath)
    $msgs = @()
    if (-not $script:postInstall -or -not $script:postInstall.ContainsKey($AppKey)) { return $msgs }
    $pi = $script:postInstall[$AppKey]
    if ($pi.NeedsPath -and $ExePath -and (Test-Path $ExePath -ErrorAction SilentlyContinue)) {
        $exeDir = Split-Path $ExePath
        $curPath = [Environment]::GetEnvironmentVariable('PATH','Machine')
        if ($curPath -notlike "*$exeDir*") {
            try {
                [Environment]::SetEnvironmentVariable('PATH',"$curPath;$exeDir",'Machine')
                $msgs += "PATH actualizado: $exeDir"
            } catch { $msgs += "No se pudo actualizar PATH" }
        }
    }
    foreach ($cmd in $pi.SetupCmds) {
        try { & cmd.exe /c $cmd 2>&1 | Out-Null; $msgs += "OK: $cmd" }
        catch { $msgs += "Fallo: $cmd" }
    }
    return $msgs
}

function Invoke-LaunchApp {
    param([string]$AppKey, [string]$AppName)
    $exe = Resolve-AppExe -AppKey $AppKey -AppName $AppName
    if ($exe) {
        try { Start-Process $exe }
        catch {
            [System.Windows.MessageBox]::Show(
                "No se pudo abrir $AppName.`nRuta: $exe`n`nError: $_",
                "NeXus — Error al abrir", "OK", "Warning")
        }
    } else {
        [System.Windows.MessageBox]::Show(
            "No se encontro el ejecutable de '$AppName'.`n`nPrueba buscarlo en el menu de inicio de Windows.",
            "NeXus — App no localizada", "OK", "Information")
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

        $verCopy = $ver
        $btn.Add_Click({

            param($sender, $e)

            $entries = $script:osDatabase.Windows[$verCopy]
            if ($entries -and $entries.Count -gt 0 -and $entries[0].URL) {
                Start-Process $entries[0].URL
            } else {
                [System.Windows.MessageBox]::Show(
                    "No se encontro URL para '$verCopy'.",
                    "NeXus - Error", "OK", "Warning"
                )
            }

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

$window.FindName("BtnEjecutar").Add_Click({ Switch-View "Ejecutar" })

$window.FindName("BtnHardware").Add_Click({ Switch-View "Hardware" })

$window.FindName("BtnScanHardware").Add_Click({ Start-HardwareScan })

# Buscador de Mis Apps en vivo
$window.FindName("SearchBoxEjecutar").Add_TextChanged({
    if ($script:currentView -eq "Ejecutar") {
        Load-EjecutarAppsList -Filter $window.FindName("SearchBoxEjecutar").Text.Trim()
    }
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
                       FontWeight="SemiBold" Foreground="#FF9D6FFF" Margin="0,0,0,6" TextWrapping="Wrap"/>
            <Border Background="#FF1C2128" CornerRadius="4" Height="10" Margin="0,0,0,4">
                <Border x:Name="BarIndividual" Background="#FF238636" CornerRadius="4"
                        HorizontalAlignment="Left" Width="0"/>
            </Border>
            <TextBlock x:Name="PctLabel" FontFamily="Consolas" FontSize="11"
                       Foreground="#FF6E7681" Margin="0,0,0,14"/>
            <TextBlock Text="Progreso total" FontFamily="Segoe UI" FontSize="12"
                       Foreground="#FF8B949E" Margin="0,0,0,4"/>
            <Border Background="#FF1C2128" CornerRadius="4" Height="8" Margin="0,0,0,4">
                <Border x:Name="BarTotal" Background="#FF9D6FFF" CornerRadius="4"
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
                               Foreground="#FF9D6FFF" TextWrapping="Wrap"/>
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
            $pSubTitle.Text = "App $appNum de $totalApps  •  Se creara acceso directo en el Escritorio al terminar"
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

                        # Intentar resolver exe con logica mejorada si no se encontro antes
                        if (-not $foundExe) {
                            $foundExe = Resolve-AppExe -AppKey $appKey -AppName $app.Name
                        }
                        if ($foundExe) {
                            $cat = if ($script:currentCategory -eq "Especialidad" -and $script:currentSubcategory) {
                                $script:currentSubcategory } else { $script:currentCategory }
                            # Acceso directo en Escritorio + carpeta Nexus
                            New-DesktopShortcut -AppName $app.Name -ExePath $foundExe -Desc $app.Desc -Category $cat | Out-Null
                            # Post-instalacion: PATH, comandos de setup
                            Invoke-PostInstall -AppKey $appKey -ExePath $foundExe | Out-Null
                            $pWindow.Dispatcher.Invoke([Action]{
                                $pPathLabel.Text       = $foundExe
                                $pPathPanel.Visibility = "Visible"
                            }, [System.Windows.Threading.DispatcherPriority]::Render)
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

    $shortcutsOk = ($results | Where-Object { $_.Status -eq "OK" -and $_.Path }).Count
    $lines = @("Exitosas: $installed    Fallidas: $failed", "")
    foreach ($r in $results) {
        $icon = switch ($r.Status) { "OK" {"OK"} "FAIL" {"FALLO"} "WEB" {"WEB"} default {"ERR"} }
        $lines += "[$icon]  $($r.Name)"
        if ($r.Path -and $r.Path -notmatch '^http') { $lines += "   Ruta: $($r.Path)" }
    }
    if ($shortcutsOk -gt 0) {
        $lines += @("", "Se crearon $shortcutsOk accesos directos en el Escritorio.")
        $lines += "Tambien en: C:\Nexus\Apps\"
    }
    $lines += @("", "Algunas apps pueden requerir reinicio del equipo.")

    $iconRes = if ($failed -eq 0) { "✅" } else { "⚠️" }
    $titleRes = if ($failed -eq 0) { "Instalación completada" } else { "Instalación con errores" }
    $msgRes = "Exitosas: $installed  |  Fallidas: $failed"
    Show-Toast -Title $titleRes -Message $msgRes -Icon $iconRes -DurationMs 4000

    $script:selectedApps = @()
    Update-SelectionCount
    Load-AppsList

})
# ── Tweaks card hover animations ─────────────────────────────────────
$script:_tweakAnimRng = New-Object System.Random

# Animation definitions per card:
# Each entry: { TransformName, AnimFunc }
# AnimFunc receives ($t, $rng, $trans) and sets X/Y

function Start-TweakAnim {
    param([string]$TransName, [string]$AnimType)
    if ($script:_tweakTimer) { $script:_tweakTimer.Stop() }
    $script:_tweakTrans    = $window.FindName($TransName)
    $script:_tweakAnimType = $AnimType
    $script:_tweakT        = 0
    $script:_tweakTimer    = New-Object System.Windows.Threading.DispatcherTimer
    $script:_tweakTimer.Interval = [TimeSpan]::FromMilliseconds(40)
    $script:_tweakTimer.Add_Tick({
        $script:_tweakT++
        $t   = $script:_tweakT
        $tr  = $script:_tweakTrans
        $rng = $script:_tweakAnimRng
        if (-not $tr) { $script:_tweakTimer.Stop(); return }
        switch ($script:_tweakAnimType) {
            "rocket" {
                # 🚀 Sube y baja como un cohete despegando
                $tr.Y = -[Math]::Round([Math]::Sin($t * 0.4) * 5)
                $tr.X = [Math]::Round([Math]::Sin($t * 0.6) * 1.5)
            }
            "lock" {
                # 🔒 Vibración horizontal rápida (como si temblara al cerrar)
                $tr.X = if ($t % 2 -eq 0) { $rng.Next(-3,3) } else { -$rng.Next(-3,3) }
                $tr.Y = $rng.Next(-1,2)
            }
            "gamepad" {
                # 🎮 Movimiento circular (como si girase)
                $tr.X = [Math]::Round([Math]::Sin($t * 0.35) * 4)
                $tr.Y = [Math]::Round([Math]::Cos($t * 0.5)  * 3)
            }
            "laptop" {
                # 💻 Pulso suave arriba/abajo (como batería que late)
                $tr.Y = -[Math]::Round([Math]::Abs([Math]::Sin($t * 0.3)) * 4)
                $tr.X = 0
            }
            "broom" {
                # 🧹 Barre de lado a lado
                $tr.X = [Math]::Round([Math]::Sin($t * 0.5) * 6)
                $tr.Y = [Math]::Round([Math]::Abs([Math]::Sin($t * 0.5)) * 2)
            }
        }
    })
    $script:_tweakTimer.Start()
}

function Stop-TweakAnim {
    if ($script:_tweakTimer) { $script:_tweakTimer.Stop(); $script:_tweakTimer = $null }
    if ($script:_tweakTrans) { $script:_tweakTrans.X = 0; $script:_tweakTrans.Y = 0 }
}

# Wire MouseEnter/Leave for each card
$tweakCards = @(
    @{ Card="CardRendimiento"; Trans="TransIcoRendimiento"; Anim="rocket"  },
    @{ Card="CardPrivacidad";  Trans="TransIcoPrivacidad";  Anim="lock"    },
    @{ Card="CardGaming";      Trans="TransIcoGaming";      Anim="gamepad" },
    @{ Card="CardLaptop";      Trans="TransIcoLaptop";      Anim="laptop"  },
    @{ Card="CardLimpieza";    Trans="TransIcoLimpieza";    Anim="broom"   }
)

foreach ($tc in $tweakCards) {
    $card      = $window.FindName($tc.Card)
    $transName = $tc.Trans
    $animType  = $tc.Anim
    if ($card) {
        $card.Add_MouseEnter({ Start-TweakAnim -TransName $transName -AnimType $animType }.GetNewClosure())
        $card.Add_MouseLeave({ Stop-TweakAnim })
    }
}

# Handler: Botón Salir
# Theme toggle handler
$window.FindName("BtnTheme").Add_Click({
    $script:isDarkTheme = -not $script:isDarkTheme
    Apply-Theme -Dark $script:isDarkTheme
    $themeLabel = if ($script:isDarkTheme) { "Oscuro" } else { "Claro" }
    Show-Toast -Title "Tema $themeLabel" -Message "Interfaz actualizada correctamente." -Icon "🎨" -DurationMs 2000
})

$window.FindName("BtnSalir").Add_Click({
    $r = [System.Windows.MessageBox]::Show(
        "¿Deseas cerrar NeXus?`n`nTodos los procesos en curso se detendrán.",
        "Salir — NeXus v1.9.0",
        "YesNo",
        "Question"
    )
    if ($r -eq "Yes") { $window.Close() }
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
            $failed  = 0
            $totalU  = $script:selectedAppsToRemove.Count
            $barMaxU = 504

            # Progress window for uninstall
            [xml]$upXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="NeXus — Desinstalando" Width="520" Height="220"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        WindowStartupLocation="CenterScreen" Topmost="True" ResizeMode="NoResize">
    <Border Background="#FF0D0B1A" CornerRadius="12" BorderBrush="#FF9D6FFF" BorderThickness="1">
        <StackPanel Margin="28,20,28,20">
            <TextBlock Text="&#x1F5D1;  Desinstalando Aplicaciones" FontFamily="Segoe UI"
                       FontSize="16" FontWeight="SemiBold" Foreground="#FFE8E0FF" Margin="0,0,0,14"/>
            <TextBlock x:Name="UAppName" FontFamily="Segoe UI" FontSize="13"
                       FontWeight="SemiBold" Foreground="#FF9D6FFF" Margin="0,0,0,8" TextWrapping="Wrap"/>
            <Border Background="#FF1A1535" CornerRadius="4" Height="10" Margin="0,0,0,6">
                <Border x:Name="UBarInd" Background="#FFDA3633" CornerRadius="4"
                        HorizontalAlignment="Left" Width="0"/>
            </Border>
            <TextBlock x:Name="UPct" FontFamily="Consolas" FontSize="11"
                       Foreground="#FF6B5F9E" Margin="0,0,0,14"/>
            <Border Background="#FF1A1535" CornerRadius="4" Height="8">
                <Border x:Name="UBarTotal" Background="#FF9D6FFF" CornerRadius="4"
                        HorizontalAlignment="Left" Width="0"/>
            </Border>
            <TextBlock x:Name="UTotalLbl" FontFamily="Segoe UI" FontSize="11"
                       Foreground="#FF9080BB" Margin="0,6,0,0"/>
        </StackPanel>
    </Border>
</Window>
"@
            $upReader = New-Object System.Xml.XmlNodeReader($upXaml)
            $upWin    = [Windows.Markup.XamlReader]::Load($upReader)
            $upWin.Show()
            $upWin.Dispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Render)

            $uAppName  = $upWin.FindName("UAppName")
            $uBarInd   = $upWin.FindName("UBarInd")
            $uPct      = $upWin.FindName("UPct")
            $uBarTotal = $upWin.FindName("UBarTotal")
            $uTotalLbl = $upWin.FindName("UTotalLbl")

            foreach ($appKey in $script:selectedAppsToRemove) {

                $appNum = $removed + $failed + 1
                $upWin.Dispatcher.Invoke([Action]{
                    $uAppName.Text  = "Desinstalando: $appKey"
                    $uBarInd.Width  = 0
                    $uPct.Text      = "0%  •  Iniciando..."
                    $uBarTotal.Width = [Math]::Round(($appNum-1) / $totalU * $barMaxU)
                    $uTotalLbl.Text  = "$($removed+$failed) de $totalU completadas"
                }, [System.Windows.Threading.DispatcherPriority]::Render)

                try {
                    if ($script:currentPlatform -eq "Windows") {

                        # ── Resolver nombre e ID winget real desde la base de datos ──
                        $appInfo      = $null
                        $realWingetId = $null
                        $displayName  = $appKey
                        foreach ($catN in $script:appDatabase["Windows"].Keys) {
                            $ci = $script:appDatabase["Windows"][$catN]
                            $fl = @()
                            if ($ci -is [hashtable]) { foreach ($v in $ci.Values) { $fl += $v } } else { $fl = $ci }
                            $h = $fl | Where-Object { $_.Key -eq $appKey -or $_.Name -eq $appKey } | Select-Object -First 1
                            if ($h) { $appInfo = $h; break }
                        }
                        if ($appInfo) {
                            if ($appInfo.ID)   { $realWingetId = $appInfo.ID }
                            if ($appInfo.Name) { $displayName  = $appInfo.Name }
                        }

                        # Actualizar UI con nombre legible
                        $dispCopy = $displayName
                        $upWin.Dispatcher.Invoke([Action]{
                            $uAppName.Text = "Desinstalando: $dispCopy"
                        }, [System.Windows.Threading.DispatcherPriority]::Render)

                        # ── Buscar UninstallString en registro por nombre real ──
                        $nativeUninst = $null
                        $searchNorm   = ($displayName.ToLower() -replace '[^a-z0-9]','')
                        $regRoots = @(
                            'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
                            'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall',
                            'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
                        )
                        foreach ($rr in $regRoots) {
                            if (-not (Test-Path $rr -ErrorAction SilentlyContinue)) { continue }
                            foreach ($sk in (Get-ChildItem $rr -ErrorAction SilentlyContinue)) {
                                try {
                                    $p2 = $sk | Get-ItemProperty -ErrorAction Stop
                                    if (-not $p2.DisplayName -or -not $p2.UninstallString) { continue }
                                    # Filtrar entradas de Microsoft Store (no ejecutables)
                                    if ($p2.UninstallString -match 'ms-windows-store|MicrosoftStore') { continue }
                                    $dn = ($p2.DisplayName.ToLower() -replace '[^a-z0-9]','')
                                    if ($dn -like "*$searchNorm*" -or $searchNorm -like "*$dn*") {
                                        $nativeUninst = $p2.UninstallString
                                        break
                                    }
                                } catch { continue }
                            }
                            if ($nativeUninst) { break }
                        }

                        $job = Start-Job -ScriptBlock {
                            param($wingetId, $nativeU, $dispName)
                            $code = 1

                            # Estrategia 1: desinstalador nativo del registro (silencioso)
                            if ($nativeU) {
                                try {
                                    $exe = $null; $arg = ""
                                    if ($nativeU -match '^\s*"([^"]+)"\s*(.*)$') {
                                        $exe = $Matches[1]; $arg = $Matches[2]
                                    } elseif ($nativeU -match 'MsiExec') {
                                        $exe = "msiexec.exe"
                                        $arg = ($nativeU -replace 'MsiExec\.exe\s*/I','/X' -replace 'MsiExec\.exe\s*','')
                                    } elseif ($nativeU -match '^\s*(\S+\.exe)\s*(.*)$') {
                                        $exe = $Matches[1]; $arg = $Matches[2]
                                    }
                                    if ($exe -and (Test-Path $exe -ErrorAction SilentlyContinue)) {
                                        $silentArg = ("$arg /S /SILENT /VERYSILENT /NORESTART /QUIET").Trim()
                                        $pr = Start-Process $exe -ArgumentList $silentArg -Wait -PassThru -WindowStyle Hidden
                                        $code = $pr.ExitCode
                                    }
                                } catch { $code = 1 }
                            }

                            # Estrategia 2: winget uninstall con ID real
                            if ($code -ne 0 -and $wingetId) {
                                try {
                                    $pr = Start-Process "winget" `
                                        -ArgumentList @("uninstall","--id",$wingetId,"--silent","--force","--accept-source-agreements","--disable-interactivity") `
                                        -Wait -PassThru -WindowStyle Hidden
                                    $code = $pr.ExitCode
                                } catch { $code = 1 }
                            }

                            # Estrategia 3: winget uninstall por nombre
                            if ($code -ne 0 -and $dispName) {
                                try {
                                    $pr = Start-Process "winget" `
                                        -ArgumentList @("uninstall","--name",$dispName,"--silent","--force","--accept-source-agreements","--disable-interactivity") `
                                        -Wait -PassThru -WindowStyle Hidden
                                    $code = $pr.ExitCode
                                } catch { $code = 1 }
                            }

                            # Estrategia 4: msiexec con GUID directo
                            if ($code -ne 0 -and $nativeU -and $nativeU -match '\{[A-F0-9\-]{36}\}') {
                                try {
                                    $guid = [regex]::Match($nativeU, '\{[A-F0-9\-]{36}\}').Value
                                    $pr   = Start-Process "msiexec.exe" -ArgumentList "/x `"$guid`" /qn /norestart" -Wait -PassThru -WindowStyle Hidden
                                    $code = $pr.ExitCode
                                } catch { $code = 1 }
                            }

                            return $code
                        } -ArgumentList $realWingetId, $nativeUninst, $displayName

                        $elapsed = 0; $estSecs = 25
                        while ($job.State -eq "Running") {
                            Start-Sleep -Milliseconds 300
                            $elapsed += 0.3
                            $pct = [Math]::Min(90, [Math]::Round(90*(1-[Math]::Exp(-$elapsed/$estSecs*3))))
                            $rem = [Math]::Max(0, [Math]::Round($estSecs - $elapsed))
                            $pctC = $pct; $remC = $rem
                            $upWin.Dispatcher.Invoke([Action]{
                                $uBarInd.Width = [Math]::Round($pctC/100*$barMaxU)
                                $uPct.Text     = "$pctC%  •  ~$remC seg restantes"
                            }, [System.Windows.Threading.DispatcherPriority]::Render)
                        }
                        $exitCode = Receive-Job $job; Remove-Job $job
                        $upWin.Dispatcher.Invoke([Action]{
                            $uBarInd.Width = $barMaxU; $uPct.Text = "100%  •  Completado"
                        }, [System.Windows.Threading.DispatcherPriority]::Render)
                        if ($exitCode -eq 0 -or $null -eq $exitCode) { $removed++ } else { $failed++ }

                    } elseif ($script:currentPlatform -eq "Linux") {
                        Invoke-Expression "sudo apt remove $appKey -y"
                        if ($LASTEXITCODE -eq 0) { $removed++ } else { $failed++ }
                    } elseif ($script:currentPlatform -eq "macOS") {
                        Invoke-Expression "brew uninstall $appKey"
                        if ($LASTEXITCODE -eq 0) { $removed++ } else { $failed++ }
                    }
                } catch { $failed++ }

                Start-Sleep -Milliseconds 400
                $doneU = $removed + $failed
                $upWin.Dispatcher.Invoke([Action]{
                    $uBarTotal.Width = [Math]::Round($doneU / $totalU * $barMaxU)
                    $uTotalLbl.Text  = "$doneU de $totalU completadas"
                }, [System.Windows.Threading.DispatcherPriority]::Render)
            }

            $upWin.Close()

            Show-Toast -Title "Desinstalación completada" -Message "Eliminadas: $removed  |  Fallidas: $failed" -Icon "🗑️" -DurationMs 3500
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

$window.FindName("BtnTweakSecurity").Add_Click({
    $r = [System.Windows.MessageBox]::Show(
        "Esta función ejecutará 5 fases de limpieza de seguridad:`n`n" +
        "  1. Temporales y caché del sistema`n" +
        "  2. Escaneo con Windows Defender`n" +
        "  3. Registro (adware/PUPs conocidos)`n" +
        "  4. Reparación de Windows (SFC + DISM)`n" +
        "  5. Limpieza de DNS y Winsock`n`n" +
        "⚠️ Requiere privilegios de administrador.`n" +
        "No elimina software legítimo instalado.`n`n" +
        "¿Deseas continuar?",
        "Limpieza de Seguridad — NeXus v1.9.0",
        "YesNo", "Warning"
    )
    if ($r -eq "Yes") { Start-SecurityClean }
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

# ── Tab switcher for extensions ─────────────────────────────────────
function Switch-ExtTab {
    param([string]$Active)
    $tabs   = @("VS","Chrome","FF","PT","Brave")
    $panels = @("PanelExtVS","PanelExtChrome","PanelExtFF","PanelExtPT","PanelExtBrave")
    $btns   = @("BtnExtTabVS","BtnExtTabChrome","BtnExtTabFF","BtnExtTabPT","BtnExtTabBrave")
    for ($ti = 0; $ti -lt $tabs.Count; $ti++) {
        $isActive = ($tabs[$ti] -eq $Active)
        $window.FindName($panels[$ti]).Visibility = if ($isActive) { "Visible" } else { "Collapsed" }
        $window.FindName($btns[$ti]).Tag           = if ($isActive) { "Selected" } else { "" }
    }
}

$window.FindName("BtnExtTabVS").Add_Click({     Switch-ExtTab "VS" })
$window.FindName("BtnExtTabChrome").Add_Click({ Switch-ExtTab "Chrome" })
$window.FindName("BtnExtTabFF").Add_Click({     Switch-ExtTab "FF" })
$window.FindName("BtnExtTabPT").Add_Click({     Switch-ExtTab "PT" })
$window.FindName("BtnExtTabBrave").Add_Click({  Switch-ExtTab "Brave" })

# ── VS Code individual extension buttons ─────────────────────────────
function Install-VSExt { param([string[]]$Ids)
    foreach ($id in $Ids) {
        Start-Process "code" -ArgumentList "--install-extension",$id,"--force" -Wait -WindowStyle Hidden
    }
    Show-Toast -Title "VS Code" -Message "Extensiones instaladas correctamente." -Icon "✅"
}

$window.FindName("BtnExtVS_Python").Add_Click({    Install-VSExt @("ms-python.python") })
$window.FindName("BtnExtVS_Prettier").Add_Click({  Install-VSExt @("dbaeumer.vscode-eslint","esbenp.prettier-vscode") })
$window.FindName("BtnExtVS_GitLens").Add_Click({   Install-VSExt @("eamodio.gitlens") })
$window.FindName("BtnExtVS_Docker").Add_Click({    Install-VSExt @("ms-azuretools.vscode-docker") })
$window.FindName("BtnExtVS_LiveServer").Add_Click({Install-VSExt @("ritwickdey.LiveServer") })
$window.FindName("BtnExtVS_Cpp").Add_Click({       Install-VSExt @("ms-vscode.cpptools","vsciot-vscode.vscode-arduino") })

$window.FindName("BtnExtVSCode").Add_Click({
    Install-VSExt @("ms-python.python","dbaeumer.vscode-eslint","esbenp.prettier-vscode",
                    "eamodio.gitlens","ms-azuretools.vscode-docker","ms-vscode.cpptools",
                    "vsciot-vscode.vscode-arduino","ritwickdey.LiveServer")
})

# ── Chrome/Brave/FF individual buttons → open specific store URL ─────
$chromeUrls = @{
    "BtnExtCh_uBlock"    = "https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm"
    "BtnExtCh_Bitwarden" = "https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb"
    "BtnExtCh_DarkReader"= "https://chrome.google.com/webstore/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh"
    "BtnExtCh_React"     = "https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi"
    "BtnExtBr_Bitwarden" = "https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb"
    "BtnExtBr_DarkReader"= "https://chrome.google.com/webstore/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh"
    "BtnExtChrome"       = "https://chrome.google.com/webstore"
    "BtnExtBrave"        = "https://chrome.google.com/webstore"
}
foreach ($btn in $chromeUrls.Keys) {
    $url = $chromeUrls[$btn]
    $window.FindName($btn).Add_Click({ Start-Process $url }.GetNewClosure())
}

$ffUrls = @{
    "BtnExtFF_uBlock"    = "https://addons.mozilla.org/firefox/addon/ublock-origin/"
    "BtnExtFF_Bitwarden" = "https://addons.mozilla.org/firefox/addon/bitwarden-password-manager/"
    "BtnExtFF_DarkReader"= "https://addons.mozilla.org/firefox/addon/darkreader/"
    "BtnExtFF_Vimium"    = "https://addons.mozilla.org/firefox/addon/vimium-ff/"
    "BtnExtFirefox"      = "https://addons.mozilla.org/es/firefox/extensions/"
}
foreach ($btn in $ffUrls.Keys) {
    $url = $ffUrls[$btn]
    $window.FindName($btn).Add_Click({ Start-Process $url }.GetNewClosure())
}

# PowerToys module buttons → open PowerToys settings
foreach ($btn in @("BtnExtPT_Run","BtnExtPT_Color","BtnExtPT_Zones","BtnExtPT_Keyboard","BtnExtPowerToys")) {
    $window.FindName($btn).Add_Click({ Start-Process "ms-settings:appsfeatures" })
}

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
                       FontWeight="SemiBold" Foreground="#FF9D6FFF" Margin="0,0,0,6" TextWrapping="Wrap"/>
            <Border Background="#FF1C2128" CornerRadius="4" Height="10" Margin="0,0,0,4">
                <Border x:Name="BarIndividual" Background="#FF238636" CornerRadius="4"
                        HorizontalAlignment="Left" Width="0"/>
            </Border>
            <TextBlock x:Name="PctLabel" FontFamily="Consolas" FontSize="11"
                       Foreground="#FF6E7681" Margin="0,0,0,14"/>
            <TextBlock Text="Progreso total" FontFamily="Segoe UI" FontSize="12"
                       Foreground="#FF8B949E" Margin="0,0,0,4"/>
            <Border Background="#FF1C2128" CornerRadius="4" Height="8" Margin="0,0,0,4">
                <Border x:Name="BarTotal" Background="#FF9D6FFF" CornerRadius="4"
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
                               Foreground="#FF9D6FFF" TextWrapping="Wrap"/>
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

    $iconRes = if ($failed -eq 0) { "✅" } else { "⚠️" }
    $titleRes = if ($failed -eq 0) { "Instalación completada" } else { "Instalación con errores" }
    $msgRes = "Exitosas: $installed  |  Fallidas: $failed"
    Show-Toast -Title $titleRes -Message $msgRes -Icon $iconRes -DurationMs 4000

    $script:selectedApps = @()
    Update-SelectionCount
    Load-AppsList

})
# Handler: Botón Salir
# Theme toggle handler
$window.FindName("BtnTheme").Add_Click({
    $script:isDarkTheme = -not $script:isDarkTheme
    Apply-Theme -Dark $script:isDarkTheme
    $themeLabel = if ($script:isDarkTheme) { "Oscuro" } else { "Claro" }
    Show-Toast -Title "Tema $themeLabel" -Message "Interfaz actualizada correctamente." -Icon "🎨" -DurationMs 2000
})

$window.FindName("BtnSalir").Add_Click({
    $r = [System.Windows.MessageBox]::Show(
        "¿Deseas cerrar NeXus?`n`nTodos los procesos en curso se detendrán.",
        "Salir — NeXus v1.9.0",
        "YesNo",
        "Question"
    )
    if ($r -eq "Yes") { $window.Close() }
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
            $failed  = 0
            $totalU  = $script:selectedAppsToRemove.Count
            $barMaxU = 504

            # Progress window for uninstall
            [xml]$upXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="NeXus — Desinstalando" Width="520" Height="220"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        WindowStartupLocation="CenterScreen" Topmost="True" ResizeMode="NoResize">
    <Border Background="#FF0D0B1A" CornerRadius="12" BorderBrush="#FF9D6FFF" BorderThickness="1">
        <StackPanel Margin="28,20,28,20">
            <TextBlock Text="&#x1F5D1;  Desinstalando Aplicaciones" FontFamily="Segoe UI"
                       FontSize="16" FontWeight="SemiBold" Foreground="#FFE8E0FF" Margin="0,0,0,14"/>
            <TextBlock x:Name="UAppName" FontFamily="Segoe UI" FontSize="13"
                       FontWeight="SemiBold" Foreground="#FF9D6FFF" Margin="0,0,0,8" TextWrapping="Wrap"/>
            <Border Background="#FF1A1535" CornerRadius="4" Height="10" Margin="0,0,0,6">
                <Border x:Name="UBarInd" Background="#FFDA3633" CornerRadius="4"
                        HorizontalAlignment="Left" Width="0"/>
            </Border>
            <TextBlock x:Name="UPct" FontFamily="Consolas" FontSize="11"
                       Foreground="#FF6B5F9E" Margin="0,0,0,14"/>
            <Border Background="#FF1A1535" CornerRadius="4" Height="8">
                <Border x:Name="UBarTotal" Background="#FF9D6FFF" CornerRadius="4"
                        HorizontalAlignment="Left" Width="0"/>
            </Border>
            <TextBlock x:Name="UTotalLbl" FontFamily="Segoe UI" FontSize="11"
                       Foreground="#FF9080BB" Margin="0,6,0,0"/>
        </StackPanel>
    </Border>
</Window>
"@
            $upReader = New-Object System.Xml.XmlNodeReader($upXaml)
            $upWin    = [Windows.Markup.XamlReader]::Load($upReader)
            $upWin.Show()
            $upWin.Dispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Render)

            $uAppName  = $upWin.FindName("UAppName")
            $uBarInd   = $upWin.FindName("UBarInd")
            $uPct      = $upWin.FindName("UPct")
            $uBarTotal = $upWin.FindName("UBarTotal")
            $uTotalLbl = $upWin.FindName("UTotalLbl")

            foreach ($appKey in $script:selectedAppsToRemove) {

                $appNum = $removed + $failed + 1
                $upWin.Dispatcher.Invoke([Action]{
                    $uAppName.Text  = "Desinstalando: $appKey"
                    $uBarInd.Width  = 0
                    $uPct.Text      = "0%  •  Iniciando..."
                    $uBarTotal.Width = [Math]::Round(($appNum-1) / $totalU * $barMaxU)
                    $uTotalLbl.Text  = "$($removed+$failed) de $totalU completadas"
                }, [System.Windows.Threading.DispatcherPriority]::Render)

                try {
                    if ($script:currentPlatform -eq "Windows") {

                        # Buscar desinstalador nativo en registro (más fiable que winget para apps como Opera)
                        $nativeUninst = $null
                        $searchName   = ($appKey -split '\.')[-1].ToLower()
                        $regRoots = @(
                            'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
                            'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall',
                            'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
                        )
                        foreach ($rr in $regRoots) {
                            if (-not (Test-Path $rr -ErrorAction SilentlyContinue)) { continue }
                            foreach ($sk in (Get-ChildItem $rr -ErrorAction SilentlyContinue)) {
                                try {
                                    $p2 = $sk | Get-ItemProperty -ErrorAction Stop
                                    $dn = if ($p2.DisplayName) { $p2.DisplayName.ToLower() } else { "" }
                                    if ($dn -like "*$searchName*" -and $p2.UninstallString) {
                                        $nativeUninst = $p2.UninstallString
                                        break
                                    }
                                } catch { continue }
                            }
                            if ($nativeUninst) { break }
                        }

                        $job = Start-Job -ScriptBlock {
                            param($appId, $nativeU)
                            $code = 1

                            # Estrategia 1: desinstalador nativo del registro
                            if ($nativeU) {
                                try {
                                    if ($nativeU -match '^\s*"([^"]+)"\s*(.*)$') {
                                        $exe = $Matches[1]; $arg = $Matches[2]
                                    } elseif ($nativeU -match '^\s*(\S+\.exe)\s*(.*)$') {
                                        $exe = $Matches[1]; $arg = $Matches[2]
                                    } else {
                                        $exe = $nativeU; $arg = ""
                                    }
                                    $silentArgs = ($arg + " /S /SILENT /VERYSILENT /NORESTART /QUIET").Trim()
                                    if (Test-Path $exe) {
                                        $pr = Start-Process $exe -ArgumentList $silentArgs -Wait -PassThru -WindowStyle Hidden
                                        $code = $pr.ExitCode
                                    }
                                } catch { $code = 1 }
                            }

                            # Estrategia 2: winget con --force
                            if ($code -ne 0) {
                                try {
                                    $pr = Start-Process "winget" `
                                        -ArgumentList "uninstall","--id",$appId,"--silent","--force","--accept-source-agreements" `
                                        -Wait -PassThru -WindowStyle Hidden
                                    $code = $pr.ExitCode
                                } catch { $code = 1 }
                            }

                            # Estrategia 3: msiexec si hay GUID
                            if ($code -ne 0 -and $nativeU -and $nativeU -match '\{[A-F0-9\-]{36}\}') {
                                try {
                                    $guid = [regex]::Match($nativeU, '\{[A-F0-9\-]{36}\}').Value
                                    $pr   = Start-Process "msiexec.exe" -ArgumentList "/x `"$guid`" /qn /norestart" -Wait -PassThru -WindowStyle Hidden
                                    $code = $pr.ExitCode
                                } catch { $code = 1 }
                            }

                            return $code
                        } -ArgumentList $appKey, $nativeUninst

                        $elapsed = 0; $estSecs = 25
                        while ($job.State -eq "Running") {
                            Start-Sleep -Milliseconds 300
                            $elapsed += 0.3
                            $pct = [Math]::Min(90, [Math]::Round(90*(1-[Math]::Exp(-$elapsed/$estSecs*3))))
                            $rem = [Math]::Max(0, [Math]::Round($estSecs - $elapsed))
                            $pctC = $pct; $remC = $rem
                            $upWin.Dispatcher.Invoke([Action]{
                                $uBarInd.Width = [Math]::Round($pctC/100*$barMaxU)
                                $uPct.Text     = "$pctC%  •  ~$remC seg restantes"
                            }, [System.Windows.Threading.DispatcherPriority]::Render)
                        }
                        $exitCode = Receive-Job $job; Remove-Job $job
                        $upWin.Dispatcher.Invoke([Action]{
                            $uBarInd.Width = $barMaxU; $uPct.Text = "100%  •  Completado"
                        }, [System.Windows.Threading.DispatcherPriority]::Render)
                        if ($exitCode -eq 0 -or $null -eq $exitCode) { $removed++ } else { $failed++ }

                    } elseif ($script:currentPlatform -eq "Linux") {
                        Invoke-Expression "sudo apt remove $appKey -y"
                        if ($LASTEXITCODE -eq 0) { $removed++ } else { $failed++ }
                    } elseif ($script:currentPlatform -eq "macOS") {
                        Invoke-Expression "brew uninstall $appKey"
                        if ($LASTEXITCODE -eq 0) { $removed++ } else { $failed++ }
                    }
                } catch { $failed++ }

                Start-Sleep -Milliseconds 400
                $doneU = $removed + $failed
                $upWin.Dispatcher.Invoke([Action]{
                    $uBarTotal.Width = [Math]::Round($doneU / $totalU * $barMaxU)
                    $uTotalLbl.Text  = "$doneU de $totalU completadas"
                }, [System.Windows.Threading.DispatcherPriority]::Render)
            }

            $upWin.Close()

            Show-Toast -Title "Desinstalación completada" -Message "Eliminadas: $removed  |  Fallidas: $failed" -Icon "🗑️" -DurationMs 3500
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
# SPLASH SCREEN CON ANIMACIÓN GLITCH - NEXUS v1.9.0
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
        <Rectangle x:Name="BgRect" Fill="#FF08051A" RadiusX="14" RadiusY="14"/>

        <!-- Canvas para glitch TV de bloques de color -->
        <Canvas x:Name="GlitchTV" Width="720" Height="520"
                HorizontalAlignment="Left" VerticalAlignment="Top"
                Opacity="0" ClipToBounds="True">
            <!-- 48 rectángulos de bloque — se colorean y posicionan por código -->
            <Rectangle x:Name="GB00" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB01" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB02" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB03" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB04" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB05" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB06" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB07" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB08" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB09" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB10" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB11" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB12" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB13" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB14" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB15" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB16" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB17" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB18" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB19" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB20" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB21" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB22" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB23" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB24" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB25" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB26" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB27" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB28" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB29" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB30" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB31" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB32" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB33" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB34" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB35" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB36" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB37" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB38" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB39" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB40" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB41" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB42" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB43" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB44" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB45" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB46" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
            <Rectangle x:Name="GB47" Width="0" Height="0" Canvas.Left="0" Canvas.Top="0"/>
        </Canvas>

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

            <TextBlock x:Name="SliceTop" Text="NeXus"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#FFE8E0FF" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.Clip><RectangleGeometry Rect="0,0,460,36"/></TextBlock.Clip>
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransSliceTop"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="SliceMid" Text="NeXus"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#FFE8E0FF" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.Clip><RectangleGeometry Rect="0,36,460,26"/></TextBlock.Clip>
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransSliceMid"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="SliceBot" Text="NeXus"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#FFE8E0FF" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.Clip><RectangleGeometry Rect="0,62,460,58"/></TextBlock.Clip>
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransSliceBot"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="GlitchR" Text="NeXus"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#CCFF1133" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransR"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="GlitchB" Text="NeXus"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#CC1144FF" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransB"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="GlitchG" Text="NeXus"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#8800FF88" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransG"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="MainText" Text="NeXus"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#FFE8E0FF" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransMain"/></TextBlock.RenderTransform>
            </TextBlock>
            <!-- Scanline glitch layers — franjas horizontales para efecto de corte -->
            <TextBlock x:Name="ScanA" Text="NeXus"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#FFFF1177" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.Clip><RectangleGeometry x:Name="ClipA" Rect="0,0,460,10"/></TextBlock.Clip>
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransScanA" X="0" Y="0"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="ScanB" Text="NeXus"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#FF00EEFF" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.Clip><RectangleGeometry x:Name="ClipB" Rect="0,14,460,8"/></TextBlock.Clip>
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransScanB" X="0" Y="0"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="ScanC" Text="NeXus"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#FFFF1177" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.Clip><RectangleGeometry x:Name="ClipC" Rect="0,26,460,6"/></TextBlock.Clip>
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransScanC" X="0" Y="0"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="ScanD" Text="NeXus"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#FF00EEFF" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.Clip><RectangleGeometry x:Name="ClipD" Rect="0,36,460,9"/></TextBlock.Clip>
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransScanD" X="0" Y="0"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="ScanE" Text="NeXus"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#FFFF1177" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.Clip><RectangleGeometry x:Name="ClipE" Rect="0,50,460,7"/></TextBlock.Clip>
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransScanE" X="0" Y="0"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="ScanF" Text="NeXus"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#FF00EEFF" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.Clip><RectangleGeometry x:Name="ClipF" Rect="0,62,460,10"/></TextBlock.Clip>
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransScanF" X="0" Y="0"/></TextBlock.RenderTransform>
            </TextBlock>
            <TextBlock x:Name="ScanG" Text="NeXus"
                       FontFamily="Consolas" FontSize="72" FontWeight="Bold"
                       Foreground="#FFE8E0FF" Opacity="0" Canvas.Left="30" Canvas.Top="0">
                <TextBlock.Clip><RectangleGeometry x:Name="ClipG" Rect="0,76,460,8"/></TextBlock.Clip>
                <TextBlock.RenderTransform><TranslateTransform x:Name="TransScanG" X="0" Y="0"/></TextBlock.RenderTransform>
            </TextBlock>

            <Border x:Name="LogoBorder" Canvas.Left="12" Canvas.Top="-12"
                    Width="0" Height="96" BorderBrush="#FF9D6FFF" BorderThickness="2.5"
                    Background="Transparent" Opacity="0"/>
        </Canvas>

        <!-- Flash de blackout -->
        <Rectangle x:Name="BlackFlash" Fill="Black" RadiusX="14" RadiusY="14" Opacity="0"/>

        <!-- Scanline -->
        <Rectangle x:Name="ScanH" Fill="#33FFFFFF" Height="3"
                   VerticalAlignment="Top" Opacity="0" RadiusX="1" RadiusY="1"/>

        <!-- Versión -->
        <TextBlock x:Name="VersionTag"
                   Text="v1.9.0  —  Sistema de Instalación Multiplataforma"
                   FontFamily="Consolas" FontSize="11" Foreground="#FF9D6FFF"
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
    $script:scanA        = $script:splash.FindName("ScanA")
    $script:scanB        = $script:splash.FindName("ScanB")
    $script:scanC        = $script:splash.FindName("ScanC")
    $script:scanD        = $script:splash.FindName("ScanD")
    $script:scanE        = $script:splash.FindName("ScanE")
    $script:scanF        = $script:splash.FindName("ScanF")
    $script:scanG        = $script:splash.FindName("ScanG")
    $script:transScanA   = $script:splash.FindName("TransScanA")
    $script:transScanB   = $script:splash.FindName("TransScanB")
    $script:transScanC   = $script:splash.FindName("TransScanC")
    $script:transScanD   = $script:splash.FindName("TransScanD")
    $script:transScanE   = $script:splash.FindName("TransScanE")
    $script:transScanF   = $script:splash.FindName("TransScanF")
    $script:transScanG   = $script:splash.FindName("TransScanG")

    # Inicializar ASCII art con el mapa completo
    # Glitch TV canvas and block references
    $script:glitchTV = $script:splash.FindName("GlitchTV")
    $script:glitchBlocks = @()
    for ($gi = 0; $gi -le 47; $gi++) {
        $name = "GB{0:D2}" -f $gi
        $script:glitchBlocks += $script:splash.FindName($name)
    }

    # TV glitch color palette (CMYK-style vibrant)
    $script:tvColors = @(
        "#FF7B2FFF","#FF9D6FFF","#FFB44FFF","#FF5533CC","#FF3311AA",
        "#FF00CCFF","#FF0088CC","#FFCC00FF","#FF6600CC","#FF4400AA",
        "#FFAAAAFF","#FF221155","#FF110033","#FF330066","#FF220044",
        "#FF8855EE","#FF5522BB","#FF9911DD","#FF3300FF","#FF110088"
    )

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

        # Helper: redraw TV glitch blocks randomly
    function Update-GlitchTV {
        param([double]$Intensity = 1.0)
        $r = $script:rng
        $cols = $script:tvColors
        foreach ($rect in $script:glitchBlocks) {
            # Random block: x 0-700, y 0-520, w 20-200, h 4-40
            $w = $r.Next(10, [int](70 * $Intensity) + 15)
            $h = $r.Next(2,  [int](14  * $Intensity) + 4)
            $x = $r.Next(0, 720)
            $y = $r.Next(0, 520)
            $colorHex = $cols[$r.Next(0, $cols.Count)]
            $color = [System.Windows.Media.ColorConverter]::ConvertFromString($colorHex)
            $rect.Fill   = New-Object System.Windows.Media.SolidColorBrush($color)
            $rect.Width  = $w
            $rect.Height = $h
            [System.Windows.Controls.Canvas]::SetLeft($rect, $x)
            [System.Windows.Controls.Canvas]::SetTop($rect,  $y)
        }
    }

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

    $script:timer.Add_Tick({
        $script:tick++
        $t   = $script:tick
        $rng = $script:rng

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

            # Activar TV glitch en esta fase
            Update-GlitchTV -Intensity 1.0
            $script:glitchTV.Opacity = 0.45

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
            Update-GlitchTV -Intensity 0.8
            $script:glitchTV.Opacity = 0.30
            $script:blackFlash.Opacity = if ($rng.Next(0,5) -eq 0) { 0.8 } else { 0.0 }

            for ($i=0;$i -lt 5;$i++) { $script:letterState[$i] = ($rng.Next(0,3) -ne 0) }
            $glitched = Get-GlitchedText

            $script:mainText.Text    = $glitched
            $script:mainText.Opacity = 0.85 + $rng.NextDouble() * 0.15
            $script:transMain.X      = $rng.Next(-10,10)
            $script:transMain.Y      = $rng.Next(-5,5)

            $script:glitchR.Text    = $glitched
            $script:glitchR.Opacity = 0.7 + $rng.NextDouble() * 0.3
            $script:transR.X        = $rng.Next(18,36)
            $script:transR.Y        = $rng.Next(-4,4)

            $script:glitchB.Text    = $glitched
            $script:glitchB.Opacity = 0.7 + $rng.NextDouble() * 0.3
            $script:transB.X        = $rng.Next(-36,-18)
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
            # TV glitch desaparece mientras las letras se estabilizan
            $tvFade = [Math]::Max(0, 1.0 - ($localT / 25.0))
            if ($tvFade -gt 0) { Update-GlitchTV -Intensity ($tvFade * 0.6) }
            $script:glitchTV.Opacity = $tvFade * 0.25
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
            $script:glitchTV.Opacity = 0
            $inv = 1.0-(($t-125)/13.0)
            $script:mainText.Text = "NeXus"; $script:transMain.X = 0; $script:transMain.Y = 0
            $script:glitchR.Opacity = 0; $script:glitchB.Opacity = 0
            $script:sliceTop.Opacity = $inv*0.6; $script:transSliceTop.X = $rng.Next(-6,6)*$inv
            $script:sliceMid.Opacity = $inv*0.4; $script:transSliceMid.X = $rng.Next(-4,4)*$inv
            $script:sliceBot.Opacity = $inv*0.6; $script:transSliceBot.X = $rng.Next(-6,6)*$inv
            $script:scanH.Opacity = $inv*0.1; $script:blackFlash.Opacity = 0
        }

        # ── FASE 6: Borde crece (139-148) ───────────────────────────────
        elseif ($t -le 148) {
            $p = ($t - 138) / 10.0
            $script:sliceTop.Opacity = 0; $script:sliceMid.Opacity = 0; $script:sliceBot.Opacity = 0
            $script:glitchR.Opacity  = 0; $script:glitchB.Opacity  = 0
            $script:scanH.Opacity    = 0; $script:blackFlash.Opacity = 0
            $script:mainText.Text    = "NEXUS"
            $script:transMain.X = 0; $script:transMain.Y = 0
            $script:border.Width   = [Math]::Round(394 * $p)
            $script:border.Opacity = $p
            $script:version.Opacity = $p * 0.9
        }

        # ── FASE 7: Logo estable 1s + glitch explosivo final (149-168) ───
        elseif ($t -le 168) {
            $localT = $t - 148   # 1..20

            # Ticks 1-4: logo quieto, se aprecia el rectángulo completo
            if ($localT -le 4) {
                $script:border.Width = 394; $script:border.Opacity = 1
                $script:version.Opacity = 0.9
                $script:mainText.Text = "NeXus"
                $script:mainText.Foreground = [System.Windows.Media.Brushes]::White
                $script:transMain.X = 0; $script:transMain.Y = 0
                $script:glitchR.Opacity = 0; $script:glitchB.Opacity = 0
                $script:blackFlash.Opacity = 0
            }
            # Ticks 5-14: GLITCH EXPLOSIVO con scanlines cortando las letras
            elseif ($localT -le 14) {
                $gIdx = $localT - 5   # 0..9

                # Ocultar texto principal — las scanlines lo reemplazan
                $script:mainText.Opacity = 0
                $script:glitchR.Opacity  = 0
                $script:glitchB.Opacity  = 0
                $script:glitchG.Opacity  = 0

                # Activar capas de scanline con desplazamientos alternos
                # Cada franja se mueve independientemente — efecto corte de TV
                $glitched = Get-GlitchedText

                $script:scanA.Text = $glitched
                $script:scanA.Opacity = if ($rng.Next(0,3) -ne 0) { 1.0 } else { 0.0 }
                $script:transScanA.X = $rng.Next(-30, 30)

                $script:scanB.Text = $glitched
                $script:scanB.Opacity = if ($rng.Next(0,3) -ne 0) { 1.0 } else { 0.0 }
                $script:transScanB.X = $rng.Next(-45, 45)

                $script:scanC.Text = $glitched
                $script:scanC.Opacity = if ($rng.Next(0,4) -ne 0) { 1.0 } else { 0.0 }
                $script:transScanC.X = $rng.Next(-20, 20)

                $script:scanD.Text = $glitched
                $script:scanD.Opacity = if ($rng.Next(0,3) -ne 0) { 1.0 } else { 0.0 }
                $script:transScanD.X = $rng.Next(-38, 38)

                $script:scanE.Text = $glitched
                $script:scanE.Opacity = if ($rng.Next(0,3) -ne 0) { 1.0 } else { 0.0 }
                $script:transScanE.X = $rng.Next(-52, 52)

                $script:scanF.Text = $glitched
                $script:scanF.Opacity = if ($rng.Next(0,4) -ne 0) { 1.0 } else { 0.0 }
                $script:transScanF.X = $rng.Next(-28, 28)

                $script:scanG.Text = $glitched
                $script:scanG.Opacity = if ($rng.Next(0,3) -ne 0) { 1.0 } else { 0.0 }
                $script:transScanG.X = $rng.Next(-42, 42)

                # Blackout en ticks pares
                $script:blackFlash.Opacity = if ($gIdx % 2 -eq 0) { 0.85 } else { 0.0 }

                # TV glitch en máxima intensidad durante el glitch explosivo
                Update-GlitchTV -Intensity 1.0
                $script:glitchTV.Opacity = 0.55
                $script:border.Opacity = $rng.NextDouble() * 0.6
                $script:scanH.Opacity  = 0.5
                $script:scanY = ($script:scanY + 40) % 520
                $script:scanH.Margin = [System.Windows.Thickness]::new(0,$script:scanY,0,0)
            }
            # Ticks 15-20: estabilización, apagar scanlines, preparar split
            else {
                $script:blackFlash.Opacity = 0
                $script:glitchTV.Opacity = 0
                $script:scanA.Opacity = 0; $script:scanB.Opacity = 0
                $script:scanC.Opacity = 0; $script:scanD.Opacity = 0
                $script:scanE.Opacity = 0; $script:scanF.Opacity = 0
                $script:scanG.Opacity = 0; $script:scanH.Opacity = 0
                $script:mainText.Text = "NeXus"; $script:mainText.Opacity = 1
                $script:mainText.Foreground = [System.Windows.Media.Brushes]::White
                $script:transMain.X = 0; $script:transMain.Y = 0
                $script:glitchR.Opacity = 0; $script:glitchB.Opacity = 0
                $script:border.Width = 394; $script:border.Opacity = 1
                $script:sliceTop.Text = "NeXus"; $script:sliceTop.Opacity = 0
                $script:sliceBot.Text = "NeXus"; $script:sliceBot.Opacity = 0
                $script:version.Opacity = 0.9
            }
        }

        # ── FASE 8: NEXUS estático con borde, fade out suave (169-182) ──
        elseif ($t -le 182) {
            $localT  = $t - 168   # 1..14
            $fade    = [Math]::Max(0, 1.0 - $localT / 14.0)

            $script:mainText.Text    = "NEXUS"
            $script:mainText.Opacity = $fade
            $script:mainText.Foreground = [System.Windows.Media.Brushes]::White
            $script:transMain.X = 0; $script:transMain.Y = 0
            $script:border.Width = 394; $script:border.Opacity = $fade
            $script:version.Opacity  = $fade * 0.9
            $script:glitchTV.Opacity = 0
            $script:blackFlash.Opacity = 0
            $script:sliceTop.Opacity = 0; $script:sliceBot.Opacity = 0
            $script:sliceMid.Opacity = 0
            $script:scanA.Opacity = 0; $script:scanB.Opacity = 0
            $script:scanC.Opacity = 0; $script:scanD.Opacity = 0
            $script:scanE.Opacity = 0; $script:scanF.Opacity = 0
            $script:scanG.Opacity = 0
            $script:splash.Opacity = $fade
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
