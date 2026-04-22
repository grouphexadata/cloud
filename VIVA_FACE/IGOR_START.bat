@echo off
SETLOCAL EnableDelayedExpansion

echo ==========================================
echo  VIVA_FACE_LAB v5.0 [MODO IGOR] - DEBUG
echo ==========================================

:: 1. Check for Node.js
where node >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Node.js no encontrado.
    pause
    exit /b
)

:: 2. Start Backend
echo [1/2] Iniciando Backend en puerto 7892...
cd /d "C:\Users\fcoca\VIVA_FACE\backend"

:: Intentar forzar el uso del venv local si conda no está
if exist "venv\Scripts\python.exe" (
    echo [INFO] Usando entorno venv local...
    start "VIVA_BACKEND" cmd /k "venv\Scripts\python.exe -m uvicorn app.main:app --reload --host 0.0.0.0 --port 7892"
) else (
    echo [ERROR] No se encontró 'backend\venv'. Por favor corre 'install_deps_admin.ps1' primero.
    pause
    exit /b
)

:: 3. Start Frontend
echo [2/2] Iniciando Frontend en puerto 7891...
cd /d "C:\Users\fcoca\VIVA_FACE\frontend"

start "VIVA_FRONTEND" cmd /k "npm run dev"

echo.
echo ==========================================
echo  REVISA LA VENTANA "VIVA_BACKEND"
echo  Si ves un error rojo, cópialo aquí.
echo ==========================================
pause
