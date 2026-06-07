param(
    [string]$BasePath = "C:\Users\fcoca\DIAMANTE",
    [int]$BackendPort = 8010,
    [int]$FrontendPort = 5173,
    [switch]$NoBrowser,
    [switch]$Strict
)

$ErrorActionPreference = "Stop"

# Trap global para capturar excepciones no manejadas y asegurar rollback + ledger
trap {
    Write-Host "❌ EXCEPTION: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "📝 Stack: $($_.ScriptStackTrace)" -ForegroundColor Yellow
    $ledgerEntry = @{
        event = "orchestrator_exception"
        timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        message = $_.Exception.Message
        stack = $_.ScriptStackTrace
        recovery = "initiating_rollback"
    } | ConvertTo-Json -Depth 5
    Add-Content -Path (Join-Path $BasePath "LOGS_DIAMANTE\ledger.jsonl") -Value $ledgerEntry
    # Rollback seguro: detener procesos Python y Node
    Stop-Process -Name python -ErrorAction SilentlyContinue
    Stop-Process -Name node -ErrorAction SilentlyContinue
    Write-Host "🔄 Rollback completado. Revisar logs para diagnóstico." -ForegroundColor Cyan
    exit 1
}

# Función de validación de pilares (pre-checklist)
function Test-DiamantePillars {
    param([string]$BackendUrl = "http://127.0.0.1:8010")
    $pillars = @("Automatizacion","Adaptativa","Autoaprendizaje","Escalabilidad","Autoajuste","Integracion")
    $results = @()
    try {
        $resp = Invoke-RestMethod -Uri "$BackendUrl/api/v1/compliance/summary" -TimeoutSec 10 -ErrorAction Stop
    } catch {
        foreach ($p in $pillars) { $results += @{ pillar = $p; status = "❌ FAIL"; error = $_.Exception.Message } }
        return $results
    }
    foreach ($pillar in $pillars) {
        $pillarData = $resp.pillars | Where-Object { $_.label -eq $pillar }
        if ($null -eq $pillarData) {
            $results += @{ pillar = $pillar; status = "❌ FAIL"; pct = 0 }
        } else {
            $pct = $pillarData.pct
            $status = if ($pct -ge 85) { "✅ OK" } else { "⚠️ WARN" }
            $results += @{ pillar = $pillar; status = $status; pct = $pct }
        }
    }
    return $results
}

# Función de validación de roadmap (hitos)
function Test-DiamanteRoadmap {
    param([string]$BackendUrl = "http://127.0.0.1:8010")
    $roadmapItems = @(
        @{ phase = "v14.0"; milestone = "Backend FastAPI activo"; endpoint = "/health" },
        @{ phase = "v14.1"; milestone = "Frontend conectado"; endpoint = "/api/v1/dashboard/summary" },
        @{ phase = "v14.2"; milestone = "Validación externa"; endpoint = "/api/v1/external-validation/game/horizonte" },
        @{ phase = "v14.3"; milestone = "Orquestador resiliente"; endpoint = "/api/v1/audit/continuous/quick-status" }
    )
    $results = @()
    foreach ($item in $roadmapItems) {
        try {
            Invoke-RestMethod -Uri "$BackendUrl$($item.endpoint)" -TimeoutSec 10 -ErrorAction Stop | Out-Null
            $results += @{ phase = $item.phase; milestone = $item.milestone; status = "✅ OK" }
        } catch {
            $results += @{ phase = $item.phase; milestone = $item.milestone; status = "⏳ PENDING"; error = $_.Exception.Message }
        }
    }
    return $results
}

$scriptsPath = Join-Path $BasePath "Scripts"
$frontendPath = Join-Path $scriptsPath "frontend"
$venvPython = Join-Path $BasePath ".venv\Scripts\python.exe"
$systemPython = "C:\Program Files\Python311\python.exe"
$npmCmd = "C:\Program Files\nodejs\npm.cmd"
$monitorScript = Join-Path $scriptsPath "monitor_diamante_stack.ps1"
$logDir = Join-Path $BasePath "LOGS"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}
$logFile = Join-Path $logDir "start_diamante_resilient.log"

function Write-LaunchLog {
    param([string]$Message)
    $ts = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$ts | $Message" | Out-File -FilePath $logFile -Encoding utf8 -Append
    Write-Host $Message
}

function Get-PreferredPython {
    if (Test-Path $venvPython) {
        return $venvPython
    }
    return $systemPython
}

function Test-Url {
    param([string]$Url, [int]$TimeoutSec = 5)
    try {
        $null = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec $TimeoutSec
        return $true
    } catch {
        return $false
    }
}

function Wait-Url {
    param(
        [string]$Url,
        [int]$TimeoutSec = 45
    )
    $start = Get-Date
    while (((Get-Date) - $start).TotalSeconds -lt $TimeoutSec) {
        if (Test-Url -Url $Url -TimeoutSec 4) {
            return $true
        }
        Start-Sleep -Seconds 2
    }
    return $false
}

function Get-ListenerPids {
    param([int]$Port)
    $conn = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
    if (-not $conn) {
        return @()
    }
    return @($conn | Select-Object -ExpandProperty OwningProcess -Unique)
}

function Clear-ListeningPort {
    param([int]$Port)
    $listenerProcessIds = Get-ListenerPids -Port $Port
    foreach ($procId in $listenerProcessIds) {
        if ($procId -gt 0) {
            try {
                Stop-Process -Id $procId -Force -ErrorAction Stop
                Write-LaunchLog "Port $Port released by stopping PID $procId."
            } catch {
                Write-LaunchLog "Unable to stop PID $procId on port $Port (continuing)."
            }
        }
    }
}

function Start-BackendService {
    if (Test-Url -Url "http://127.0.0.1:$BackendPort/health" -TimeoutSec 4) {
        Write-LaunchLog "Backend already healthy on port $BackendPort."
        return
    }

    Clear-ListeningPort -Port $BackendPort
    $pythonExe = Get-PreferredPython
    Start-Process -FilePath $pythonExe -WorkingDirectory $BasePath -ArgumentList "-m uvicorn backend.app.main:app --host 127.0.0.1 --port $BackendPort --app-dir Scripts" -WindowStyle Minimized | Out-Null
    Write-LaunchLog "Backend start triggered on port $BackendPort."

    if (-not (Wait-Url -Url "http://127.0.0.1:$BackendPort/health" -TimeoutSec 60)) {
        throw "Backend did not become healthy on port $BackendPort."
    }
    Write-LaunchLog "Backend healthy on port $BackendPort."
}

function Start-FrontendService {
    if (-not (Test-Path $npmCmd)) {
        Write-LaunchLog "Frontend skipped: npm not found at $npmCmd."
        return
    }

    if (Test-Url -Url "http://127.0.0.1:$FrontendPort" -TimeoutSec 4) {
        Write-LaunchLog "Frontend already reachable on port $FrontendPort."
        return
    }

    Clear-ListeningPort -Port $FrontendPort

    $nodeModules = Join-Path $frontendPath "node_modules"
    if (-not (Test-Path $nodeModules)) {
        Write-LaunchLog "node_modules missing. Running npm install..."
        & $npmCmd install --prefix $frontendPath | Out-Null
    }

    Start-Process -FilePath $npmCmd -WorkingDirectory $frontendPath -ArgumentList "run dev -- --host 127.0.0.1 --port $FrontendPort" -WindowStyle Minimized | Out-Null
    Write-LaunchLog "Frontend start triggered on port $FrontendPort."

    if (-not (Wait-Url -Url "http://127.0.0.1:$FrontendPort" -TimeoutSec 60)) {
        Write-LaunchLog "Frontend did not respond on port $FrontendPort within timeout."
        return
    }
    Write-LaunchLog "Frontend reachable on port $FrontendPort."
}

function Invoke-ChecklistGeneration {
    $url = "http://127.0.0.1:$BackendPort/api/v1/checklist/vanguardia/generate?force_snapshot=true"
    try {
        $result = Invoke-RestMethod -Method Post -Uri $url -TimeoutSec 240
        Write-LaunchLog "Checklist generated: trace_signature=$($result.trace_signature) estado=$($result.estado) compatibilidad=$($result.compatibilidad_pct)%"
    } catch {
        Write-LaunchLog "Checklist generation failed at startup: $($_.Exception.Message)"
    }
}

function Start-HealthMonitor {
    if (-not (Test-Path $monitorScript)) {
        Write-LaunchLog "Monitor script not found: $monitorScript"
        return
    }

    $existing = Get-CimInstance Win32_Process -Filter "name = 'powershell.exe' OR name = 'pwsh.exe'" -ErrorAction SilentlyContinue |
        Where-Object { $_.CommandLine -like "*monitor_diamante_stack.ps1*" }
    if ($existing) {
        Write-LaunchLog "Health monitor already running."
        return
    }

    $monitorArgs = @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", $monitorScript,
        "-BasePath", $BasePath,
        "-BackendPort", "$BackendPort",
        "-FrontendPort", "$FrontendPort"
    )
    Start-Process -FilePath "powershell.exe" -ArgumentList $monitorArgs -WindowStyle Minimized | Out-Null
    Write-LaunchLog "Health monitor started."
}

Write-LaunchLog "=== DIAMANTE resilient start begin ==="
Start-BackendService
Start-FrontendService

# Ejecutar checks de pilares y roadmap antes de generar checklist oficial
Write-LaunchLog "🔍 Ejecutando pre-checklists (pillars + roadmap)..."
$pillarResults = Test-DiamantePillars -BackendUrl "http://127.0.0.1:$BackendPort"
foreach ($r in $pillarResults) { Write-LaunchLog "Pillar: $($r.pillar) status=$($r.status) pct=$($r.pct)" }
$failed = $pillarResults | Where-Object { $_.status -eq "❌ FAIL" }
if ($failed -and $failed.Count -gt 0) {
    Write-LaunchLog "⚠️  $($failed.Count) pillar(s) failed. Registering warning in ledger."
    $entry = @{ event="checklist_pillars_warning"; failed=$failed; timestamp=(Get-Date).ToUniversalTime().ToString("o") } | ConvertTo-Json -Depth 6
    Add-Content -Path (Join-Path $BasePath "LOGS_DIAMANTE\ledger.jsonl") -Value $entry
}
$roadmapResults = Test-DiamanteRoadmap -BackendUrl "http://127.0.0.1:$BackendPort"
foreach ($r in $roadmapResults) { Write-LaunchLog "Roadmap: $($r.phase) $($r.milestone) status=$($r.status)" }
$pending = $roadmapResults | Where-Object { $_.status -ne "✅ OK" }
if ($pending -and $pending.Count -gt 0) {
    Write-LaunchLog "ℹ️  $($pending.Count) roadmap milestone(s) pending."
}

Invoke-ChecklistGeneration
Start-HealthMonitor

if (-not $NoBrowser) {
    Start-Process "http://127.0.0.1:$FrontendPort" | Out-Null
    Write-LaunchLog "Browser opened at http://127.0.0.1:$FrontendPort"
}

Write-LaunchLog "=== DIAMANTE resilient start complete ==="
