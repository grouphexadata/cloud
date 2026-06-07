param(
    [int]$MaxRetries = 3,
    [int]$RetryDelaySeconds = 5,
    [int]$HealthPort = 8010,
    [string]$AppHost = '127.0.0.1',
    [int]$AppPort = 8010
)

$BasePath = Resolve-Path -Path (Join-Path $PSScriptRoot "..")
$pythonExe = Join-Path $BasePath ".venv\Scripts\python.exe"
if (-not (Test-Path $pythonExe)) {
    $pythonExe = "python"
}

$logDir = Join-Path $BasePath "LOGS"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}
$logFile = Join-Path $logDir "backend_watchdog_start.log"

function Write-Log {
    param([string]$Level, [string]$Message)
    $timestamp = (Get-Date).ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
    "$timestamp [$Level] $Message" | Out-File -FilePath $logFile -Append -Encoding utf8
    Write-Host "$timestamp [$Level] $Message"
}

function Test-PortOpen {
    param([int]$Port)
    return Test-NetConnection -ComputerName $AppHost -Port $Port -InformationLevel Quiet
}

Write-Log "INFO" "Iniciando start_with_watchdog.ps1. Target port: $AppPort. MaxRetries: $MaxRetries."

$existing = Get-NetTCPConnection -LocalPort 8000 -State Listen -ErrorAction SilentlyContinue
if ($existing) {
    foreach ($conn in $existing) {
        try {
            $procInfo = Get-CimInstance -ClassName Win32_Process -Filter "ProcessId=$($conn.OwningProcess)"
            if ($procInfo.CommandLine -match 'backend\.app\.main') {
                Write-Log "WARN" "Proceso backend detectado en puerto 8000 (PID=$($conn.OwningProcess)). Se terminará antes de reiniciar en el puerto correcto."
                Stop-Process -Id $conn.OwningProcess -Force -ErrorAction SilentlyContinue
            } else {
                Write-Log "WARN" "Puerto 8000 ocupado por PID $($conn.OwningProcess) que no parece ser backend.app.main; no se termina automáticamente."
            }
        } catch {
            Write-Log "ERROR" "Error al inspeccionar proceso en puerto 8000: $_"
        }
    }
}

if (Test-PortOpen -Port $AppPort) {
    Write-Log "INFO" "El puerto $AppPort ya está ocupado. No se iniciará un nuevo backend." 
    exit 0
}

for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
    Write-Log "INFO" "Intento $attempt de $MaxRetries para iniciar backend en puerto $AppPort."
    $process = Start-Process -FilePath $pythonExe -ArgumentList "-m uvicorn backend.app.main:app --host $AppHost --port $AppPort --app-dir Scripts" -WorkingDirectory $BasePath -WindowStyle Minimized -PassThru
    Start-Sleep -Seconds 6
    if (Test-PortOpen -Port $AppPort) {
        Write-Log "INFO" "Backend iniciado correctamente en puerto $AppPort (PID=$($process.Id))."
        exit 0
    }

    Write-Log "WARN" "Intento $attempt falló. Backend no responde en puerto $AppPort. Terminando proceso PID=$($process.Id)."
    Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds $RetryDelaySeconds
}

Write-Log "ERROR" "No se pudo iniciar el backend en el puerto $AppPort tras $MaxRetries intentos."
exit 1
