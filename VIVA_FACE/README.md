# VIVA_FACE_LAB

Sistema OSINT visual para busqueda inversa de imagenes con multiples fuentes.
Arquitectura **FastAPI + React + SQLite + proveedores web (Bing/Yandex/TinEye)**.

## 🚀 Inicio Rápido en Windows 11 (Sin Docker)

Este proyecto fue optimizado para ejecutarse localmente sin requerir Docker (usa SQLite) y con un tema oscuro premium ("glassmorphism").

### 1. Instalacion del Backend

Abre Anaconda Prompt o PowerShell:

```powershell
# 1. Crear entorno
python -m venv .venv
.\.venv\Scripts\Activate.ps1

# 2. Instalar dependencias base
cd C:\Users\fcoca\VIVA_FACE\VIVA_FACE_LAB\backend
pip install -r requirements.txt
```

### 2. Instalación del Frontend

Abre otra terminal:

```powershell
cd C:\Users\fcoca\VIVA_FACE\VIVA_FACE_LAB\frontend
npm install
```

### 3. Ejecución en 1 Clic

En la raiz del proyecto (`C:\Users\fcoca\VIVA_FACE\VIVA_FACE_LAB`), haz doble clic en el archivo:
- `quick_start.bat`

Esto levantará automáticamente `uvicorn` (Backend en el puerto 8010) y `vite` (Frontend en el puerto 5173).

## 🧪 Pruebas rapidas

```powershell
# Suite de endpoints
cd C:\Users\fcoca\VIVA_FACE\VIVA_FACE_LAB
.\.venv\Scripts\python.exe -m pytest backend\tests\test_endpoints.py -q

# Build frontend
cd frontend
npm run build
```

## ⚠️ Breaking changes (OSINT-only)

- Se elimino el flujo de reconocimiento local (FaceEngine/FAISS).
- Se eliminaron los endpoints `/api/v1/enroll` y `/api/v1/users`.
- `/api/v1/recognize` ahora devuelve solo payload OSINT (`weather`, `events`, `sources`).

## 🔎 Búsqueda Inversa de Imágenes (Múltiples Fuentes vía API)

Endpoints disponibles:

- `POST /api/v1/osint/visual-search/yandex` (multi-fuente: Bing API/Bing Web fallback + Yandex + TinEye)
- `GET /api/v1/osint/visual-search/multi-url` (multi-fuente estable por URL pública: Bing Web + Yandex + TinEye)
- `GET /api/v1/osint/yandex/reverse-image` (Yandex por URL pública)
- `GET /api/v1/osint/diagnostics` (diagnóstico de conectividad/configuración)

Base URL backend local:

- `http://127.0.0.1:8010`

### Variables de entorno mínimas (backend/.env)

```env
# Puertos y CORS
PORT=8010
CORS_ORIGINS=http://localhost:5173,http://127.0.0.1:5173

# Proveedores reverse image
YANDEX_ENABLED=true
BING_VISUAL_SEARCH_KEY=tu_clave

# Bright Data (opcional, para escenarios restringidos)
BRIGHTDATA_ENABLED=false
BRIGHTDATA_API_KEY=
BRIGHTDATA_HOST=brd.superproxy.io
BRIGHTDATA_PORT=33335
BRIGHTDATA_USERNAME=
BRIGHTDATA_PASSWORD=
```

### Pruebas rápidas (PowerShell)

Diagnóstico de prerequisitos de red/proveedores:

```powershell
Invoke-RestMethod -Method Get -Uri "http://127.0.0.1:8010/api/v1/osint/diagnostics" | ConvertTo-Json -Depth 8
```

Reverse search por URL (Yandex):

```powershell
Invoke-RestMethod -Method Get -Uri "http://127.0.0.1:8010/api/v1/osint/yandex/reverse-image?image_url=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2Fa%2Fa7%2FCamponotus_flavomarginatus_ant.jpg%2F320px-Camponotus_flavomarginatus_ant.jpg&limit=8" | ConvertTo-Json -Depth 8
```

Reverse search multi-fuente por archivo:

```powershell
curl.exe -X POST "http://127.0.0.1:8010/api/v1/osint/visual-search/yandex" -F "file=@C:\ruta\a\imagen.jpg"
```

Reverse search multi-fuente por URL pública (recomendado para validar proveedores):

```powershell
Invoke-RestMethod -Method Get -Uri "http://127.0.0.1:8010/api/v1/osint/visual-search/multi-url?image_url=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2Fa%2Fa7%2FCamponotus_flavomarginatus_ant.jpg%2F320px-Camponotus_flavomarginatus_ant.jpg&min_score=1" | ConvertTo-Json -Depth 8
```

### Checklist de bloqueos comunes (antivirus / firewall / proxy / TLS)

1. Permitir `python.exe` y `uvicorn` en Firewall de Windows (entrada y salida).
2. Si hay antivirus con inspección HTTPS/TLS, excluir el proceso de backend o importar el certificado corporativo al store de Windows y del entorno Python.
3. Si hay proxy corporativo, configurar `HTTPS_PROXY`/`HTTP_PROXY` en el entorno y validar salida HTTPS a:
	- `api.bing.microsoft.com`
	- `www.bing.com`
	- `yandex.com`
	- `catbox.moe`, `litterbox.catbox.moe`, `0x0.st`
4. Verificar DNS y TLS usando `GET /api/v1/osint/diagnostics`.
5. No se requiere plugin del navegador para estos endpoints API.

Si `result_count=0`, revisar primero `osint/diagnostics` y luego credenciales/configuración de proveedores.
El flujo `Recognize` también depende de estos mismos proveedores para rellenar `events`.
Si en `Recognize` no aparecen eventos con archivo local, puedes usar `Manual OSINT Search` con una URL pública de imagen para activar fallback multi-fuente por URL.
