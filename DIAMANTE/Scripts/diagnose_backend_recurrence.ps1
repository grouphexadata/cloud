param(
    [string]$BasePath = (Join-Path $PSScriptRoot ".."),
    [string]$ValidationTime = "2026-06-08T19:45:22Z"
)

Set-Location -Path $BasePath

Write-Host "=== Diagnóstico Forense de Reincidencia DIAMANTE ===" -ForegroundColor Cyan

$portInfo = netstat -ano | Select-String ':8010'
if ($portInfo) {
    $processId = ($portInfo.Line -split '\s+')[-1]
    $proc = Get-Process -Id $processId -ErrorAction SilentlyContinue
    Write-Host "Puerto 8010: ESCUCHANDO (PID=$processId, Proceso=$($proc.ProcessName))" -ForegroundColor Green
} else {
    Write-Host "Puerto 8010: NO ESCUCHANDO (Backend caído)" -ForegroundColor Red
}

$logs = Get-ChildItem Scripts\backend\app\logs -Filter "*.log" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($logs) {
    Write-Host "`n=== Últimos 50 registros de $($logs.Name) ===" -ForegroundColor Cyan
    Get-Content $logs.FullName -Tail 50 | Select-String "ERROR|Exception|Traceback|KeyboardInterrupt|Timeout|Memory|crash" -Context 2
} else {
    Write-Host "No se encontraron logs en Scripts\backend\app\logs" -ForegroundColor Yellow
}

$zombies = Get-Process | Where-Object { $_.ProcessName -like '*python*' -or $_.ProcessName -like '*uvicorn*' } | Select-Object ProcessName, Id, StartTime, CPU
Write-Host "`n=== Procesos Python/UVicorn activos ===" -ForegroundColor Cyan
$zombies | Format-Table -AutoSize

$currentTime = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
Write-Host "`nValidación: $ValidationTime | Actual: $currentTime" -ForegroundColor Yellow
