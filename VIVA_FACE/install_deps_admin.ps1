<#
.SYNOPSIS
Script automatizado para entorno VIVA_FACE_LAB.

.DESCRIPTION
Descarga e instala Microsoft Visual C++ Redistributable (necesario para Greenlet/SQLite) 
y el paquete pre-compilado de InsightFace para Python 3.11 en Windows.

IMPORTANTE: Ejecutar como Administrador.
#>

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " VIVA_FACE_LAB - Instalador de Dependencias" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Comprobar privilegios de administrador
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-Not $isAdmin) {
    Write-Host "ERROR: Este script DEBE ejecutarse como Administrador." -ForegroundColor Red
    Write-Host "Haz clic derecho sobre este archivo y selecciona 'Ejecutar con PowerShell'." -ForegroundColor Yellow
    Pause
    Exit
}

$backendPath = "C:\Users\fcoca\VIVA_FACE\backend"
Set-Location $backendPath

Write-Host "`n[1/3] Descargando e instalando Visual C++ Redistributable (Soluciona DLL greenlet)..." -ForegroundColor Yellow
$vcUrl = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
$vcPath = "C:\Users\fcoca\Downloads\vc_redist.x64.exe"
Invoke-WebRequest -Uri $vcUrl -OutFile $vcPath -UseBasicParsing
Write-Host "Instalando VC++ Redist (Modo Silencioso)..." -ForegroundColor DarkGray
Start-Process -FilePath $vcPath -ArgumentList "/install", "/passive", "/norestart" -Wait
Write-Host "Visual C++ Redistributable instalado con exito." -ForegroundColor Green


Write-Host "`n[2/3] Descargando binario InsightFace (WHL precompilado para Python 3.11)..." -ForegroundColor Yellow
$wheelUrl = "https://github.com/Gourieff/sd-webui-reactor/releases/download/v1.1.2/insightface-0.7.3-cp311-cp311-win_amd64.whl"
$wheelPath = "C:\Users\fcoca\Downloads\insightface-0.7.3-cp311-cp311-win_amd64.whl"
Invoke-WebRequest -Uri $wheelUrl -OutFile $wheelPath -UseBasicParsing
Write-Host "Descarga de WHL completada." -ForegroundColor Green


Write-Host "`n[3/3] Instalando InsightFace y reparando modulos de base de datos..." -ForegroundColor Yellow
# Forzamos reinstalacion global o en el entorno del usuario
python -m pip install setuptools wheel --upgrade
python -m pip install $wheelPath
python -m pip install greenlet --force-reinstall

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "             PROCESO COMPLETADO            " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Todo el hardware interno base esta listo. Ya puedes arrancar tu backend." -ForegroundColor Green
Pause
