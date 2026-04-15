@echo off
echo Iniciando VIVA_FACE_LAB...

:: Start backend
cd /d C:\Users\fcoca\VIVA_FACE\backend
start cmd /k "conda activate VIVA_FACE && uvicorn app.main:app --reload --host 0.0.0.0 --port 8000"

:: Wait 3 seconds
timeout /t 3 /nobreak >nul

:: Start frontend
cd /d C:\Users\fcoca\VIVA_FACE\frontend
start cmd /k "npm run dev"

echo Servicios iniciados en ventanas separadas.
