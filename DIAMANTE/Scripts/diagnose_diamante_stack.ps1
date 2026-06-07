param(
    [string]$BackendHost = '127.0.0.1',
    [int]$BackendPort = 8010,
    [int]$FrontendPort = 5173,
    [int]$TimeoutSec = 10
)

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[OK]   $Message" -ForegroundColor Green
}

function Write-Failure {
    param([string]$Message)
    Write-Host "[FAIL] $Message" -ForegroundColor Red
}

function Test-Endpoint {
    param(
        [string]$Url,
        [string]$Label
    )
    try {
        $response = Invoke-WebRequest -Uri $Url -TimeoutSec $TimeoutSec -UseBasicParsing -ErrorAction Stop
        $status = $response.StatusCode
        if ($response.Content -and $response.Content.Trim().Length -gt 0) {
            $msg = "[OK]   $Label → $Url (HTTP $status)"
            Write-Success "$Label → $Url (HTTP $status)"
            $global:ReportLines += $msg
            return $true
        }
        $msg = "[WARN] $Label → $Url returned HTTP $status but body is empty"
        Write-Failure "$Label → $Url returned HTTP $status but body is empty"
        $global:ReportLines += $msg
        return $false
    } catch {
        $msg = "[ERR]  $Label → $Url error: $($_.Exception.Message)"
        Write-Failure "$Label → $Url error: $($_.Exception.Message)"
        $global:ReportLines += $msg
        return $false
    }
}

# Inicializar contenedor de líneas para reporte
$global:ReportLines = @()

Write-Info "Iniciando diagnóstico DIAMANTE"
Write-Info "Backend: http://${BackendHost}:${BackendPort}"
Write-Info "Frontend: http://${BackendHost}:${FrontendPort}"

$backendRoot = "http://${BackendHost}:${BackendPort}"
$frontendRoot = "http://${BackendHost}:${FrontendPort}"

$checks = @(
    @{ Url = "$backendRoot/health"; Label = 'Backend health' },
    @{ Url = "$backendRoot/api/v1/dashboard/summary"; Label = 'Dashboard summary' },
    @{ Url = "$backendRoot/api/v1/audit/continuous/latest"; Label = 'Audit latest' },
    @{ Url = "$backendRoot/api/v1/compliance/summary"; Label = 'Compliance summary' },
    @{ Url = $frontendRoot; Label = 'Frontend root' }
)

$allOk = $true
foreach ($check in $checks) {
    $ok = Test-Endpoint -Url $check.Url -Label $check.Label
    if (-not $ok) { $allOk = $false }
}

Write-Host ''
Write-Info "Verificando procesos asociados"

$backendPids = Get-NetTCPConnection -LocalPort $BackendPort -State Listen -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique
$frontendPids = Get-NetTCPConnection -LocalPort $FrontendPort -State Listen -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique

if ($backendPids) {
    foreach ($procId in $backendPids) {
        $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue
        Write-Success "Puerto $BackendPort escuchado por PID $procId ($($proc.ProcessName))"
    }
} else {
    Write-Failure "No se encontró ningún proceso escuchando en el puerto $BackendPort"
}

if ($frontendPids) {
    foreach ($procId in $frontendPids) {
        $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue
        Write-Success "Puerto $FrontendPort escuchado por PID $procId ($($proc.ProcessName))"
    }
} else {
    Write-Failure "No se encontró ningún proceso escuchando en el puerto $FrontendPort"
}
Write-Host ''

# Generar reporte persistente en LOGS
$base = Resolve-Path -Path (Join-Path $PSScriptRoot "..")
$logDir = Join-Path $base "LOGS"
if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }
$ts = (Get-Date).ToString('yyyyMMdd_HHmmss')
$reportPath = Join-Path $logDir "diagnosis_$ts.txt"

$header = @(
    "DIAGNOSIS DIAMANTE",
    "Timestamp: $(Get-Date -Format o)",
    "Backend: http://${BackendHost}:${BackendPort}",
    "Frontend: http://${BackendHost}:${FrontendPort}",
    ""
)

$body = $global:ReportLines + "" + @("Procesos detectados:")
if ($backendPids) {
    foreach ($procId in $backendPids) {
        $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue
        $body += "Backend PID $procId ($($proc.ProcessName))"
    }
} else { $body += "Backend: no listener detected" }
if ($frontendPids) {
    foreach ($procId in $frontendPids) {
        $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue
        $body += "Frontend PID $procId ($($proc.ProcessName))"
    }
} else { $body += "Frontend: no listener detected" }

($header + $body) | Out-File -FilePath $reportPath -Encoding utf8
Write-Info "Reporte guardado en: $reportPath"

if ($allOk) {
    Write-Info "Diagnóstico completado: el stack DIAMANTE parece estar operativo."
    exit 0
} else {
    Write-Failure "Diagnóstico completado: se detectaron fallos en algunos endpoints o servicios."
    exit 1
}
