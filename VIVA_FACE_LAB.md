A continuación, te presento una lista de requerimientos completa y detallada para tu proyecto, comenzando desde las habilidades y herramientas necesarias. Toda la configuración está optimizada para tu laptop UNIVAC con Windows 11, 16 GB de RAM y la GPU NVIDIA GeForce RTX 3050 Ti.

---

## 🧠 1. Habilidades y conocimientos previos necesarios

| Área | Habilidades requeridas | Nivel sugerido |
|---|---|---|
| Python | POO, manejo de entornos virtuales, async/await, type hints | Intermedio-Avanzado |
| FastAPI | Creación de endpoints REST, validación con Pydantic, middlewares | Intermedio |
| React | Hooks (useState, useEffect), componentes funcionales, manejo de estado | Intermedio |
| Visión por Computadora | Conceptos de embeddings faciales, similitud coseno/euclidiana, MTCNN | Básico-Intermedio |
| Git/GitHub | Commits, ramas, PRs, resolución de conflictos | Básico |
| Docker | Dockerfiles, docker-compose, volúmenes, redes | Básico-Intermedio |
| Bases de Datos | PostgreSQL, Redis, FAISS (índices vectoriales) | Intermedio |
| MLOps Básico | Versionado de modelos, monitoreo de drift, logging | Básico |

---

## 💻 2. Software Base y Herramientas de Desarrollo

### 2.1. Instalación de Software Base

Ejecuta estos pasos desde PowerShell como Administrador:

| Software | Versión | Propósito | Enlace de Descarga |
|---|---|---|---|
| Python | 3.11.x | Lenguaje principal. Versiones 3.10/3.11 son las más estables con InsightFace | [python.org](https://python.org) |
| Git | 2.44+ | Control de versiones | [git-scm.com](https://git-scm.com) |
| Visual Studio Code | Latest | Editor de código principal | [code.visualstudio.com](https://code.visualstudio.com) |
| Docker Desktop | Latest (con WSL2) | Contenerización para despliegue | [docker.com](https://docker.com) |
| Node.js | 20.x LTS | Runtime para React/Vite | [nodejs.org](https://nodejs.org) |
| NVIDIA Driver | 545.xx o superior | Soporte GPU para CUDA (RTX 3050 Ti) | [nvidia.com](https://nvidia.com) |
| CUDA Toolkit | 11.8 | Aceleración GPU para PyTorch/InsightFace | [developer.nvidia.com](https://developer.nvidia.com/cuda-toolkit) |
| cuDNN | 8.9.x (compatible con CUDA 11.8) | Librería de redes neuronales profundas | [developer.nvidia.com/cudnn](https://developer.nvidia.com/cudnn) |
| Miniconda | Latest | Gestor de entornos (alternativa a venv, recomendado para FAISS) | [docs.conda.io](https://docs.conda.io) |

### 2.2. Extensiones Recomendadas para VS Code

| Extensión | Propósito |
|---|---|
| Python (Microsoft) | Soporte completo para Python: debugging, IntelliSense, testing |
| Pylance | Análisis de tipos y autocompletado avanzado |
| Black Formatter | Formateo automático de código Python |
| Ruff | Linting ultrarrápido para Python |
| ES7+ React/Redux/React-Native snippets | Snippets para React |
| Tailwind CSS IntelliSense | Autocompletado para clases de Tailwind |
| Prettier | Formateo para JavaScript/TypeScript/CSS |
| Docker (Microsoft) | Gestión de contenedores desde el editor |
| GitLens | Visualización avanzada de Git |
| Thunder Client | Cliente REST para probar APIs |

---

## 🐍 3. Creación del Entorno Virtual VIVA_FACE

Abre PowerShell y ejecuta:

```powershell
# Navegar a la carpeta del usuario
cd C:\Users\fcoca

# Crear el entorno virtual
python -m venv VIVA_FACE

# Activar el entorno
.\VIVA_FACE\Scripts\Activate.ps1
```

⚠️ **Importante**: Si PowerShell muestra un error de políticas de ejecución, ejecuta primero:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Verificación**: El prompt debe cambiar a `(VIVA_FACE) PS C:\Users\fcoca>`

### 3.1. Alternativa con Conda (Recomendada para FAISS-GPU)

```powershell
# Crear entorno con Python 3.11
conda create -n VIVA_FACE python=3.11 -y

# Activar entorno
conda activate VIVA_FACE
```

---

## 📦 4. Dependencias Python (Backend)

Crea un archivo `requirements.txt` en la raíz del proyecto (`C:\Users\fcoca\VIVA_FACE\`) con el siguiente contenido:

```txt
# ===== FRAMEWORK PRINCIPAL =====
fastapi==0.115.0
uvicorn[standard]==0.30.0
pydantic==2.8.0
pydantic-settings==2.4.0

# ===== RECONOCIMIENTO FACIAL =====
# InsightFace (instalación manual con .whl, ver sección 4.1)
opencv-python-headless==4.10.0.84
numpy==1.26.4
scikit-learn==1.5.0
Pillow==10.4.0

# ===== BASE DE DATOS =====
asyncpg==0.29.0
sqlalchemy==2.0.30
alembic==1.13.0
redis==5.0.0

# ===== FAISS (instalación manual, ver sección 4.2) =====
# faiss-gpu  (vía conda) o faiss-cpu (vía pip)

# ===== CLIENTES HTTP =====
httpx==0.27.0
requests==2.32.0

# ===== UTILIDADES =====
python-dotenv==1.0.0
python-multipart==0.0.9
tenacity==8.5.0
loguru==0.7.0

# ===== APIs EXTERNAS =====
# Open-Meteo
openmeteo-requests==1.2.0
requests-cache==1.2.0

# GDELT
gdelt==0.1.6  # Cliente no oficial pero funcional

# ===== TESTING =====
pytest==8.2.0
pytest-asyncio==0.23.0
pytest-cov==5.0.0

# ===== DESPLIEGUE =====
gunicorn==22.0.0
```

### 4.1. Instalación Manual de InsightFace (Crítica en Windows)

InsightFace **NO** se instala correctamente con `pip install insightface` en Windows debido a dependencias de compilación en C++. La solución es descargar el archivo `.whl` precompilado.

```powershell
# 1. Descargar el .whl correspondiente a tu Python
# Para Python 3.11: insightface-0.7.3-cp311-cp311-win_amd64.whl
# Enlace: https://github.com/Gourieff/InsightFace-REST/releases

# 2. Instalar desde el archivo descargado
pip install "C:\Users\fcoca\Downloads\insightface-0.7.3-cp311-cp311-win_amd64.whl"

# 3. Instalar ONNX Runtime con soporte GPU (para RTX 3050 Ti)
pip install onnxruntime-gpu==1.18.0
```

### 4.2. Instalación de FAISS-GPU (con Conda)

FAISS-GPU en Windows se instala mejor a través de Conda, no de pip.

```powershell
# Si usas Conda:
conda activate VIVA_FACE
conda install -c conda-forge -c pytorch faiss-gpu=1.7.4 cudatoolkit=11.8 -y
```

### 4.3. Instalación Completa

```powershell
# Activar entorno
.\VIVA_FACE\Scripts\Activate.ps1

# Instalar dependencias base
pip install -r requirements.txt

# Instalar InsightFace desde .whl (manual)
pip install "ruta\al\archivo\insightface-0.7.3-cp311-cp311-win_amd64.whl"

# Verificar instalación
python -c "import insightface; print(insightface.__version__)"
```

---

## ⚛️ 5. Dependencias Frontend (React + Vite)

```powershell
# Navegar a la carpeta del proyecto
cd C:\Users\fcoca\VIVA_FACE

# Crear proyecto React con Vite
npm create vite@latest frontend -- --template react

# Entrar a la carpeta frontend
cd frontend

# Instalar dependencias
npm install

# Instalar dependencias adicionales
npm install axios @tanstack/react-query tailwindcss @tailwindcss/vite react-router-dom
npm install react-webcam react-dropzone framer-motion

# Instalar dependencias de desarrollo
npm install -D @types/react @types/react-dom @vitejs/plugin-react
npm install -D eslint prettier eslint-config-prettier
npm install -D vitest @testing-library/react @testing-library/jest-dom
```

---

## 🐳 6. Docker y Herramientas de Contenerización

### 6.1. Configurar Docker Desktop con WSL2 y GPU

Para aprovechar la RTX 3050 Ti en contenedores Docker, es necesario configurar WSL2 correctamente:

```powershell
# 1. Instalar WSL2 (si no está instalado)
wsl --install

# 2. Establecer WSL2 como versión predeterminada
wsl --set-default-version 2

# 3. Instalar una distribución de Linux (Ubuntu recomendada)
wsl --install -d Ubuntu

# 4. Verificar que Docker Desktop use WSL2
# Abrir Docker Desktop → Settings → General → "Use the WSL 2 based engine"
# Settings → Resources → WSL Integration → Habilitar "Ubuntu"
```

### 6.2. Archivos Docker Necesarios

**Dockerfile.backend**
```dockerfile
FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**Dockerfile.frontend**
```dockerfile
FROM node:20-alpine as build
WORKDIR /app
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**docker-compose.yml**
```yaml
version: '3.8'

services:
  backend:
    build:
      context: .
      dockerfile: Dockerfile.backend
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/facedb
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis
    volumes:
      - ./models:/app/models

  frontend:
    build:
      context: .
      dockerfile: Dockerfile.frontend
    ports:
      - "3000:80"
    depends_on:
      - backend

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
      - POSTGRES_DB=facedb
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:
```

---

## 🔌 7. Plugins y Extensiones Esenciales

### 7.1. Backend (Python)

| Plugin/Librería | Propósito |
|---|---|
| fastapi | Framework API REST asíncrono |
| uvicorn | Servidor ASGI de alto rendimiento |
| pydantic | Validación de datos y serialización |
| sqlalchemy + asyncpg | ORM asíncrono para PostgreSQL |
| redis | Caché y almacenamiento de sesiones |
| alembic | Migraciones de base de datos |
| httpx | Cliente HTTP asíncrono |
| tenacity | Reintentos automáticos con backoff exponencial |
| loguru | Logging estructurado y colorizado |
| faiss-gpu | Búsqueda vectorial eficiente con GPU |
| insightface | Reconocimiento facial (SCRFD + ArcFace) |
| opencv-python-headless | Manipulación de imágenes sin GUI |
| scikit-learn | Utilidades de machine learning (normalización, métricas) |

### 7.2. Frontend (React)

| Plugin/Librería | Propósito |
|---|---|
| react | Framework UI |
| vite | Build tool ultrarrápido |
| tailwindcss | Framework CSS utilitario |
| @tanstack/react-query | Gestión de estado asíncrono y caché |
| axios | Cliente HTTP para llamadas a API |
| react-router-dom | Enrutamiento del lado del cliente |
| react-webcam | Componente para acceder a la cámara |
| react-dropzone | Componente drag-and-drop para subir archivos |
| framer-motion | Animaciones fluidas y profesionales |

### 7.3. DevOps / MLOps

| Herramienta | Propósito |
|---|---|
| pre-commit | Hooks para validar código antes de commits |
| black | Formateador de código Python |
| ruff | Linter rápido para Python |
| pytest | Framework de testing |
| prometheus-client | Métricas para monitoreo |
| Grafana | Dashboards de monitoreo |
| GitHub Actions | CI/CD automatizado |

---

## 🛠️ 8. Configuración del Proyecto

### 8.1. Estructura de Carpetas Sugerida

```
C:\Users\fcoca\VIVA_FACE\
│
├── backend/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py                 # Punto de entrada FastAPI
│   │   ├── config.py               # Configuración con Pydantic Settings
│   │   ├── api/
│   │   │   ├── __init__.py
│   │   │   ├── v1/
│   │   │   │   ├── __init__.py
│   │   │   │   ├── endpoints/
│   │   │   │   │   ├── enroll.py
│   │   │   │   │   ├── recognize.py
│   │   │   │   │   └── verify.py
│   │   ├── core/
│   │   │   ├── face_engine.py      # Motor InsightFace
│   │   │   ├── vector_store.py     # FAISS wrapper
│   │   │   ├── weather.py          # Cliente Open-Meteo
│   │   │   └── events.py           # Cliente GDELT
│   │   ├── db/
│   │   │   ├── models.py           # Modelos SQLAlchemy
│   │   │   └── session.py          # Conexión a DB
│   │   └── schemas/
│   │       └── face.py             # Modelos Pydantic
│   ├── tests/
│   ├── models/                     # Modelos preentrenados
│   ├── requirements.txt
│   └── Dockerfile
│
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── CameraCapture.jsx
│   │   │   ├── ImageUploader.jsx
│   │   │   ├── RecognitionResult.jsx
│   │   │   └── EnrollmentForm.jsx
│   │   ├── pages/
│   │   │   ├── Home.jsx
│   │   │   ├── Enroll.jsx
│   │   │   └── Recognize.jsx
│   │   ├── services/
│   │   │   └── api.js              # Cliente Axios
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── package.json
│   └── vite.config.js
│
├── docker-compose.yml
├── .env.example
├── .gitignore
├── .pre-commit-config.yaml
└── README.md
```

---

## 🔐 9. APIs Externas Gratuitas (Open Source)

| API | Endpoint | Propósito en el proyecto | Rate Limit | Cliente Python |
|---|---|---|---|---|
| Open-Meteo | `api.open-meteo.com/v1/forecast` | Datos meteorológicos para contextualizar accesos (ej. "Acceso con lluvia") | ~10k req/día | `openmeteo-requests` |
| GDELT | `api.gdeltproject.org/api/v2/doc/doc` | Eventos geopolíticos para análisis de riesgo por ubicación | Sin límite estricto | `gdelt` |

---

## 📋 10. Checklist de Verificación

| Tarea | Estado |
|---|---|
| [ ] Python 3.11 instalado y en PATH | ⬜ |
| [ ] Git instalado y configurado | ⬜ |
| [ ] VS Code con extensiones instaladas | ⬜ |
| [ ] Node.js 20.x LTS instalado | ⬜ |
| [ ] Docker Desktop con WSL2 habilitado | ⬜ |
| [ ] NVIDIA Driver actualizado | ⬜ |
| [ ] CUDA 11.8 instalado | ⬜ |
| [ ] Entorno virtual `VIVA_FACE` creado | ⬜ |
| [ ] `requirements.txt` instalado | ⬜ |
| [ ] InsightFace instalado desde .whl | ⬜ |
| [ ] FAISS-GPU instalado (vía Conda) | ⬜ |
| [ ] Proyecto React creado con Vite | ⬜ |
| [ ] Tailwind CSS configurado | ⬜ |
| [ ] `docker-compose.yml` funcional | ⬜ |
| [ ] Prueba de reconocimiento facial exitosa | ⬜ |

---

---

Perfecto. Vamos a desarrollar en detalle el **motor de reconocimiento facial**, que es el corazón del proyecto. Implementaremos:

1. **Detección y alineación** con `SCRFD` (InsightFace).
2. **Extracción de embeddings** con `ArcFace` (512 dimensiones).
3. **Índice vectorial** con `FAISS` para búsqueda rápida.
4. **Enriquecimiento contextual** con Open-Meteo (clima) y GDELT (eventos).

Todo el código estará listo para copiar y pegar en tu estructura `backend/`.

---

## 🧬 1. Arquitectura del Motor de Reconocimiento

```text
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Imagen        │────▶│  FaceEngine     │────▶│  FAISS Index    │
│   (numpy array) │     │  (InsightFace)  │     │  + PostgreSQL   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                              │                           │
                              ▼                           ▼
                       Embedding (512d)           Búsqueda por similitud
                              │                           │
                              └───────────┬───────────────┘
                                          ▼
                               ┌─────────────────────┐
                               │  Resultado +        │
                               │  Contexto (clima,   │
                               │  eventos)           │
                               └─────────────────────┘
```

---

## 📁 2. Archivos a Crear en `backend/app/core/`

Dentro de `C:\Users\fcoca\VIVA_FACE\backend\app\core\`, crea los siguientes archivos:

### 2.1. `face_engine.py` – Motor de reconocimiento facial

```python
"""
Motor de reconocimiento facial usando InsightFace (SCRFD + ArcFace).
Optimizado para GPU NVIDIA RTX 3050 Ti.
"""
import os
from typing import List, Tuple, Optional
import numpy as np
import cv2
from loguru import logger
import insightface
from insightface.app import FaceAnalysis

class FaceEngine:
    def __init__(self, model_root: str = "models", device: str = "cuda"):
        """
        Inicializa el motor de reconocimiento facial.
        
        Args:
            model_root: Carpeta donde se descargarán/cargarán los modelos.
            device: "cuda" para GPU, "cpu" para CPU.
        """
        self.device = device
        self.model_root = model_root
        os.makedirs(model_root, exist_ok=True)
        
        # Inicializar InsightFace con detección y reconocimiento
        self.app = FaceAnalysis(
            name="buffalo_l",          # Modelo SCRFD-10G + ArcFace
            root=model_root,
            providers=['CUDAExecutionProvider', 'CPUExecutionProvider'] if device == 'cuda' else ['CPUExecutionProvider']
        )
        self.app.prepare(ctx_id=0 if device == 'cuda' else -1, det_size=(640, 640))
        logger.info(f"FaceEngine inicializado en {device.upper()}. Modelos en {model_root}")
    
    def detect_faces(self, image: np.ndarray, max_num: int = 10) -> List[dict]:
        """
        Detecta todos los rostros en una imagen.
        
        Args:
            image: numpy array BGR (formato OpenCV).
            max_num: Número máximo de rostros a detectar.
            
        Returns:
            Lista de diccionarios con 'bbox', 'kps' (5 puntos clave) y 'det_score'.
        """
        if image is None or image.size == 0:
            return []
        
        # Convertir a RGB si es necesario (InsightFace espera RGB)
        if len(image.shape) == 3 and image.shape[2] == 3:
            rgb_image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        else:
            rgb_image = image
        
        faces = self.app.get(rgb_image, max_num=max_num)
        return faces
    
    def get_embedding(self, face_image: np.ndarray) -> Optional[np.ndarray]:
        """
        Extrae el embedding de un único rostro ya recortado.
        
        Args:
            face_image: Imagen recortada del rostro (BGR o RGB).
            
        Returns:
            Vector numpy de 512 dimensiones, normalizado L2, o None si falla.
        """
        if face_image is None or face_image.size == 0:
            return None
        
        # Asegurar RGB
        if len(face_image.shape) == 3 and face_image.shape[2] == 3:
            rgb_face = cv2.cvtColor(face_image, cv2.COLOR_BGR2RGB)
        else:
            rgb_face = face_image
        
        # InsightFace necesita una lista de imágenes
        faces = self.app.get(rgb_face, max_num=1)
        if not faces:
            return None
        
        # El embedding ya viene normalizado L2 por defecto
        embedding = faces[0].normed_embedding
        return embedding
    
    def align_face(self, image: np.ndarray, face_info: dict, target_size: Tuple[int, int] = (112, 112)) -> np.ndarray:
        """
        Alinea y recorta un rostro usando los puntos clave detectados.
        Utiliza transformación afín basada en ojos.
        
        Args:
            image: Imagen original (BGR).
            face_info: Diccionario con 'kps' (puntos clave) y 'bbox'.
            target_size: Tamaño de salida (ancho, alto).
            
        Returns:
            Imagen del rostro alineado en BGR.
        """
        # InsightFace ya proporciona un método para obtener el rostro alineado
        # pero implementamos uno propio para mayor control.
        kps = face_info['kps']  # (5,2) puntos: ojos, nariz, comisuras
        if kps is None or len(kps) < 2:
            # Fallback: recorte simple con bounding box
            bbox = face_info['bbox'].astype(int)
            x1, y1, x2, y2 = bbox[0], bbox[1], bbox[2], bbox[3]
            x1, y1 = max(0, x1), max(0, y1)
            x2, y2 = min(image.shape[1], x2), min(image.shape[0], y2)
            face_crop = image[y1:y2, x1:x2]
            return cv2.resize(face_crop, target_size)
        
        # Puntos de referencia estándar para ArcFace (112x112)
        # Coordenadas esperadas de ojos (alineación frontal)
        src = np.array([
            kps[0],  # ojo izquierdo
            kps[1],  # ojo derecho
        ], dtype=np.float32)
        
        # Puntos destino para un rostro alineado de 112x112
        dst = np.array([
            [38.2946, 51.6963],   # ojo izquierdo (coordenadas ArcFace)
            [73.5318, 51.6963]    # ojo derecho
        ], dtype=np.float32)
        
        # Calcular matriz de transformación afín (solo rotación y escala)
        M = cv2.estimateAffinePartial2D(src, dst)[0]
        if M is None:
            # Fallback a recorte simple
            bbox = face_info['bbox'].astype(int)
            x1, y1, x2, y2 = bbox[0], bbox[1], bbox[2], bbox[3]
            x1, y1 = max(0, x1), max(0, y1)
            x2, y2 = min(image.shape[1], x2), min(image.shape[0], y2)
            face_crop = image[y1:y2, x1:x2]
            return cv2.resize(face_crop, target_size)
        
        # Aplicar transformación
        aligned_face = cv2.warpAffine(image, M, target_size, flags=cv2.INTER_LINEAR)
        return aligned_face
    
    def extract_embeddings_from_image(self, image: np.ndarray) -> List[Tuple[np.ndarray, dict]]:
        """
        Detecta rostros, alinea y extrae embeddings de una imagen completa.
        
        Args:
            image: Imagen BGR.
            
        Returns:
            Lista de tuplas (embedding, face_info) para cada rostro detectado.
        """
        faces = self.detect_faces(image)
        results = []
        for face in faces:
            aligned = self.align_face(image, face)
            emb = self.get_embedding(aligned)
            if emb is not None:
                results.append((emb, face))
        return results
```

---

### 2.2. `vector_store.py` – Índice FAISS para búsqueda eficiente

```python
"""
Gestión de vectores faciales con FAISS (GPU) y PostgreSQL para metadatos.
"""
import os
import pickle
import numpy as np
import faiss
from typing import List, Tuple, Dict, Optional
from loguru import logger

class VectorStore:
    def __init__(self, dimension: int = 512, index_path: str = "models/face_index.faiss", use_gpu: bool = True):
        self.dimension = dimension
        self.index_path = index_path
        self.use_gpu = use_gpu
        self.index = None
        self.id_map = []  # Mapea posición en índice -> user_id (str)
        
        if os.path.exists(index_path):
            self.load()
        else:
            self._create_new_index()
    
    def _create_new_index(self):
        """Crea un índice FAISS plano (L2) nuevo."""
        self.index = faiss.IndexFlatL2(self.dimension)
        if self.use_gpu and faiss.get_num_gpus() > 0:
            logger.info("Moviendo índice FAISS a GPU")
            self.index = faiss.index_cpu_to_gpu(faiss.StandardGpuResources(), 0, self.index)
        self.id_map = []
        logger.info("Nuevo índice FAISS creado.")
    
    def add_embeddings(self, user_id: str, embeddings: List[np.ndarray]) -> int:
        """
        Agrega uno o varios embeddings asociados a un usuario.
        Retorna el número total de vectores en el índice.
        """
        if not embeddings:
            return self.index.ntotal if self.index else 0
        
        # Asegurar float32 y forma correcta
        emb_array = np.vstack(embeddings).astype(np.float32)
        
        # Agregar al índice
        self.index.add(emb_array)
        # Extender el mapeo de IDs
        self.id_map.extend([user_id] * len(embeddings))
        
        logger.debug(f"Agregados {len(embeddings)} embeddings para usuario {user_id}")
        return self.index.ntotal
    
    def search(self, query_embedding: np.ndarray, k: int = 5, threshold: float = 0.6) -> List[Tuple[str, float]]:
        """
        Busca los k vecinos más cercanos.
        
        Args:
            query_embedding: Vector de consulta (512,).
            k: Número de resultados a devolver.
            threshold: Distancia L2 máxima para considerar una coincidencia (menor = más estricto).
            
        Returns:
            Lista de tuplas (user_id, distancia) ordenadas por distancia ascendente.
        """
        if self.index is None or self.index.ntotal == 0:
            return []
        
        query = query_embedding.reshape(1, -1).astype(np.float32)
        distances, indices = self.index.search(query, k)
        
        results = []
        for dist, idx in zip(distances[0], indices[0]):
            if idx != -1 and dist <= threshold:
                user_id = self.id_map[idx]
                results.append((user_id, float(dist)))
        return results
    
    def remove_user(self, user_id: str):
        """
        Elimina todos los embeddings de un usuario (requiere reconstruir índice).
        FAISS no soporta eliminación directa, por lo que se recrea el índice.
        """
        if user_id not in self.id_map:
            return
        
        # Obtener todos los vectores excepto los del usuario
        if self.use_gpu and faiss.get_num_gpus() > 0:
            # Mover a CPU para reconstruir
            cpu_index = faiss.index_gpu_to_cpu(self.index)
            vectors = np.array([cpu_index.reconstruct(i) for i in range(cpu_index.ntotal)])
        else:
            vectors = np.array([self.index.reconstruct(i) for i in range(self.index.ntotal)])
        
        mask = np.array([uid != user_id for uid in self.id_map])
        new_vectors = vectors[mask]
        new_id_map = [uid for i, uid in enumerate(self.id_map) if mask[i]]
        
        # Crear nuevo índice
        self._create_new_index()
        if len(new_vectors) > 0:
            self.index.add(new_vectors.astype(np.float32))
            self.id_map = new_id_map
        
        logger.info(f"Usuario {user_id} eliminado del índice. Total vectores: {self.index.ntotal}")
    
    def save(self):
        """Guarda el índice FAISS y el mapeo de IDs en disco."""
        os.makedirs(os.path.dirname(self.index_path), exist_ok=True)
        
        # Si está en GPU, mover a CPU para guardar
        if self.use_gpu and faiss.get_num_gpus() > 0:
            cpu_index = faiss.index_gpu_to_cpu(self.index)
            faiss.write_index(cpu_index, self.index_path)
        else:
            faiss.write_index(self.index, self.index_path)
        
        # Guardar id_map
        map_path = self.index_path.replace('.faiss', '_map.pkl')
        with open(map_path, 'wb') as f:
            pickle.dump(self.id_map, f)
        
        logger.info(f"Índice guardado en {self.index_path} con {self.index.ntotal} vectores")
    
    def load(self):
        """Carga el índice FAISS y el mapeo de IDs desde disco."""
        self.index = faiss.read_index(self.index_path)
        if self.use_gpu and faiss.get_num_gpus() > 0:
            self.index = faiss.index_cpu_to_gpu(faiss.StandardGpuResources(), 0, self.index)
        
        map_path = self.index_path.replace('.faiss', '_map.pkl')
        if os.path.exists(map_path):
            with open(map_path, 'rb') as f:
                self.id_map = pickle.load(f)
        else:
            self.id_map = []
        
        logger.info(f"Índice cargado desde {self.index_path}. Vectores: {self.index.ntotal}")
```

---

### 2.3. `weather.py` – Cliente para Open-Meteo

```python
"""
Cliente para la API gratuita de Open-Meteo (datos meteorológicos).
"""
import httpx
from typing import Optional, Dict, Any
from loguru import logger

class WeatherClient:
    BASE_URL = "https://api.open-meteo.com/v1/forecast"
    
    def __init__(self, latitude: float = 19.4326, longitude: float = -99.1332):
        """
        Args:
            latitude: Latitud por defecto (CDMX).
            longitude: Longitud por defecto.
        """
        self.latitude = latitude
        self.longitude = longitude
    
    async def get_current_weather(self, lat: Optional[float] = None, lon: Optional[float] = None) -> Dict[str, Any]:
        """
        Obtiene el clima actual para una ubicación.
        Retorna diccionario con temperatura, código de clima, etc.
        """
        lat = lat or self.latitude
        lon = lon or self.longitude
        
        params = {
            "latitude": lat,
            "longitude": lon,
            "current_weather": True,
            "timezone": "America/Mexico_City"
        }
        
        async with httpx.AsyncClient(timeout=10.0) as client:
            try:
                resp = await client.get(self.BASE_URL, params=params)
                resp.raise_for_status()
                data = resp.json()
                current = data.get("current_weather", {})
                return {
                    "temperature": current.get("temperature"),
                    "windspeed": current.get("windspeed"),
                    "weathercode": current.get("weathercode"),
                    "time": current.get("time")
                }
            except Exception as e:
                logger.error(f"Error obteniendo clima: {e}")
                return {}
```

---

### 2.4. `events.py` – Cliente para GDELT

```python
"""
Cliente para GDELT Project (eventos geopolíticos).
"""
import httpx
from typing import List, Dict, Any
from datetime import datetime, timedelta
from loguru import logger

class GDELTClient:
    BASE_URL = "https://api.gdeltproject.org/api/v2/doc/doc"
    
    async def get_recent_events(self, country_code: str = "MX", hours_back: int = 24) -> List[Dict[str, Any]]:
        """
        Obtiene eventos recientes para un país.
        
        Args:
            country_code: Código ISO de país (ej. 'MX', 'US').
            hours_back: Horas hacia atrás para buscar eventos.
        """
        # Formato de tiempo para GDELT
        start_time = (datetime.utcnow() - timedelta(hours=hours_back)).strftime("%Y%m%d%H%M%S")
        
        params = {
            "query": f"sourcecountry:{country_code}",
            "mode": "artlist",
            "format": "json",
            "maxrecords": 5,
            "timespan": f"{start_time}",
            "sort": "datedesc"
        }
        
        async with httpx.AsyncClient(timeout=15.0) as client:
            try:
                resp = await client.get(self.BASE_URL, params=params)
                resp.raise_for_status()
                data = resp.json()
                articles = data.get("articles", [])
                events = []
                for art in articles[:3]:
                    events.append({
                        "title": art.get("title"),
                        "url": art.get("url"),
                        "seendate": art.get("seendate"),
                        "sourcecountry": art.get("sourcecountry")
                    })
                return events
            except Exception as e:
                logger.error(f"Error obteniendo eventos GDELT: {e}")
                return []
```

---

## 🔗 3. Integración en Endpoints FastAPI

Crea el archivo `backend/app/api/v1/endpoints/enroll.py`:

```python
from fastapi import APIRouter, UploadFile, File, Form, HTTPException
from typing import List
import cv2
import numpy as np
from app.core.face_engine import FaceEngine
from app.core.vector_store import VectorStore

router = APIRouter()
face_engine = FaceEngine()
vector_store = VectorStore()

@router.post("/enroll")
async def enroll_user(
    user_id: str = Form(...),
    files: List[UploadFile] = File(...)
):
    """
    Registra un nuevo usuario subiendo varias imágenes.
    Se extraen embeddings de cada rostro y se almacenan en FAISS.
    """
    if len(files) < 6:
        raise HTTPException(400, "Se requieren al menos 6 imágenes para el registro.")
    
    all_embeddings = []
    for file in files:
        contents = await file.read()
        nparr = np.frombuffer(contents, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        if img is None:
            continue
        
        embeddings_faces = face_engine.extract_embeddings_from_image(img)
        if embeddings_faces:
            # Tomamos el embedding del rostro más grande (mayor área de bbox)
            main_face = max(embeddings_faces, key=lambda x: (x[1]['bbox'][2]-x[1]['bbox'][0])*(x[1]['bbox'][3]-x[1]['bbox'][1]))
            all_embeddings.append(main_face[0])
    
    if len(all_embeddings) < 6:
        raise HTTPException(400, f"No se detectaron rostros en suficientes imágenes. Se encontraron {len(all_embeddings)}.")
    
    # Agregar al índice
    vector_store.add_embeddings(user_id, all_embeddings)
    vector_store.save()
    
    return {"status": "success", "user_id": user_id, "embeddings_stored": len(all_embeddings)}
```

Crea `backend/app/api/v1/endpoints/recognize.py`:

```python
from fastapi import APIRouter, UploadFile, File, HTTPException
import cv2
import numpy as np
from app.core.face_engine import FaceEngine
from app.core.vector_store import VectorStore
from app.core.weather import WeatherClient
from app.core.events import GDELTClient
from pydantic import BaseModel

router = APIRouter()
face_engine = FaceEngine()
vector_store = VectorStore()
weather_client = WeatherClient()
gdelt_client = GDELTClient()

class RecognitionResponse(BaseModel):
    user_id: str = None
    distance: float = None
    weather: dict = {}
    events: list = []

@router.post("/recognize", response_model=RecognitionResponse)
async def recognize_face(file: UploadFile = File(...)):
    """
    Reconoce un rostro en la imagen subida.
    Retorna el user_id si coincide, junto con contexto.
    """
    contents = await file.read()
    nparr = np.frombuffer(contents, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    if img is None:
        raise HTTPException(400, "No se pudo decodificar la imagen.")
    
    embeddings_faces = face_engine.extract_embeddings_from_image(img)
    if not embeddings_faces:
        raise HTTPException(404, "No se detectó ningún rostro.")
    
    # Usar el rostro principal (el de mayor área)
    main_emb, face_info = max(embeddings_faces, key=lambda x: (x[1]['bbox'][2]-x[1]['bbox'][0])*(x[1]['bbox'][3]-x[1]['bbox'][1]))
    
    # Buscar en FAISS
    matches = vector_store.search(main_emb, k=1, threshold=0.8)
    
    result = RecognitionResponse()
    if matches:
        result.user_id = matches[0][0]
        result.distance = matches[0][1]
    else:
        result.user_id = None
        result.distance = None
    
    # Obtener contexto (asíncrono)
    result.weather = await weather_client.get_current_weather()
    result.events = await gdelt_client.get_recent_events("MX")
    
    return result
```

---

## 🧪 4. Prueba Local del Motor

Crea un script de prueba `backend/test_engine.py`:

```python
import cv2
from app.core.face_engine import FaceEngine

def test_face_engine():
    engine = FaceEngine()
    
    # Cargar una imagen de prueba
    img_path = "ruta/a/tu/imagen.jpg"
    img = cv2.imread(img_path)
    
    # Detectar y extraer embeddings
    results = engine.extract_embeddings_from_image(img)
    print(f"Rostros detectados: {len(results)}")
    for emb, face_info in results:
        print(f"Embedding shape: {emb.shape}, norm: {np.linalg.norm(emb):.4f}")
        bbox = face_info['bbox']
        print(f"BBox: {bbox}")

if __name__ == "__main__":
    test_face_engine()
```

Ejecuta con el entorno activado:

```powershell
cd C:\Users\fcoca\VIVA_FACE\backend
python test_engine.py
```

---

## ⚙️ 5. Ajustes Recomendados para tu GPU

- **Memoria GPU limitada (4 GB)**: El modelo `buffalo_l` usa ~500 MB. Si tienes problemas, puedes cambiar a `buffalo_s` (más ligero) en `FaceEngine`:
  ```python
  self.app = FaceAnalysis(name="buffalo_s", ...)
  ```

- **Umbral de reconocimiento**: El valor `threshold=0.8` en `vector_store.search` es un buen punto de partida. Ajusta según falsos positivos/negativos.

- **Normalización L2**: InsightFace ya devuelve embeddings normalizados. FAISS con `IndexFlatL2` usa distancia euclidiana, equivalente a similitud coseno cuando los vectores están normalizados.

---

## 📦 6. Instalación de Dependencias Adicionales

Asegúrate de haber instalado:

```powershell
pip install opencv-python-headless numpy insightface onnxruntime-gpu faiss-gpu loguru httpx
```

Recuerda que `faiss-gpu` se instala mejor con Conda.

---

## 🚀 Siguientes Pasos

1. **Completa los endpoints** de `enroll` y `recognize` con conexión a PostgreSQL para almacenar perfiles de usuario.
2. **Implementa el frontend** en React para subir imágenes y mostrar resultados.
3. **Configura CORS** en FastAPI para permitir peticiones desde el frontend.

