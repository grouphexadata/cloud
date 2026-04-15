# VIVA_FACE_LAB

Sistema avanzado de reconocimiento facial *GPU-First* optimizado para NVIDIA RTX 3050 Ti con fallback automático a CPU. 
Arquitectura **FastAPI + React + InsightFace (buffalo_l) + FAISS**.

## 🚀 Inicio Rápido en Windows 11 (Sin Docker)

Este proyecto fue optimizado para ejecutarse localmente sin requerir Docker (usa SQLite) y con un tema oscuro premium ("glassmorphism").

### 1. Instalación del Backend (Miniconda)

Abre Anaconda Prompt o PowerShell:

```powershell
# 1. Crear entorno
conda create -n VIVA_FACE python=3.11 -y
conda activate VIVA_FACE

# 2. Instalar dependencias base
cd C:\Users\fcoca\VIVA_FACE\backend
pip install -r requirements.txt

# 3. Instalar FAISS GPU
conda install -c conda-forge faiss-gpu=1.7.4 cudatoolkit=11.8 -y

# 4. Descargar e instalar InsightFace
# Descarga `insightface-0.7.3-cp311-cp311-win_amd64.whl` de GitHub Releases
pip install ruta\a\insightface-0.7.3-cp311-cp311-win_amd64.whl
```

### 2. Instalación del Frontend

Abre otra terminal:

```powershell
cd C:\Users\fcoca\VIVA_FACE\frontend
npm install
```

### 3. Ejecución en 1 Clic

En la raíz del proyecto (`C:\Users\fcoca\VIVA_FACE`), haz doble clic en el archivo:
- `quick_start.bat`

Esto levantará automáticamente `uvicorn` (Backend en el puerto 8000) y `vite` (Frontend en el puerto 5173).

## 🧪 Pruebas y Benchmarks Automáticos

```powershell
# Suite completa de tests con reporte de cobertura
cd backend
test_all.bat

# Benchmark de latencias de la GPU (Detección, Embedding, Búsqueda FAISS)
python benchmark.py

# Prueba rápida del motor con imagen sintética o real
python test_engine.py
```
