@echo off
echo Iniciando VIVA_FACE_LAB...

:: Start backend
cd /d C:\Users\fcoca\VIVA_FACE\VIVA_FACE_LAB
start cmd /k ".\.venv\Scripts\python.exe -m uvicorn app.main:app --app-dir backend --host 127.0.0.1 --port 8010"

:: Wait 3 seconds
timeout /t 3 /nobreak >nul

:: Start frontend
cd /d C:\Users\fcoca\VIVA_FACE\VIVA_FACE_LAB\frontend
start cmd /k "npm run dev"

echo Servicios iniciados en ventanas separadas.
