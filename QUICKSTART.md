# HEXA-DATA PROMPT | Guía Rápida de Comandos PowerShell

> **Actualizado:** Abril 2026 — Incluye HEXA-DATA PROMPT v2.0 con Motor Adaptativo, Directrices Persistentes y soporte multi-modelo.

---

## 0. HEXA-DATA PROMPT (APP WEB)

Abre directamente en el navegador — no requiere instalación:

```powershell
# Abrir desde Live Server (VS Code) → clic derecho en hexadata_prompt.html → Open with Live Server
# O abrir el archivo directamente:
Start-Process "$PWD\hexadata_prompt.html"
```

**Funcionalidades nuevas en v2.0:**

| Sección | Qué hace |
|---------|----------|
| **Motor Adaptativo** | Selecciona modelo IA (GPT-5.3, Claude 3.7, Gemini 2.5, Llama 3.2) y profundidad de salida |
| **Premium + Herramientas** | Activa features de evolución, autocura, stack tecnológico específico del modelo |
| **Directrices Persistentes** | Guarda instrucciones que se añaden automáticamente en cada prompt (localStorage) |
| **Auto-Diagrama SVG** | Genera diagrama visual del proyecto detectado |
| **Detección de Brechas** | Identifica información faltante y genera recomendaciones accionables |
| **Ejemplos JSON/YAML** | Produce ejemplos de formato estructurado según dominio detectado |

Portal público: `https://grouphexadata.github.io/cloud/hexadata_prompt.html`

---

```powershell
cd c:\Users\fcoca\HEXA_DATA_PROMPT
.\venv\Scripts\Activate.ps1
```

**Tip**: Si ves error de ejecución, ejecuta primero:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 1. ACTIVAR ENTORNO VIRTUAL

> **Nota:** Todos los comandos `python` requieren el venv activado (paso 1). Si `python` no responde, usa la ruta absoluta: `.\venv\Scripts\python.exe`

```powershell
# Script de verificación completo
python verify_hexa_setup.py

# Verificar Python
python --version

# Verificar librerías principales
python -c "import torch, pandas, numpy; print('✓ Todas las librerías OK')"

# Verificar CUDA
python -c "import torch; print(f'CUDA: {torch.cuda.is_available()}')"
```

---

## 3. PYTORCH & GPU

```powershell
# Probar PyTorch con configuración automática
python config_pytorch.py

# Verificar memoria GPU en tiempo real
python -c "import torch; print(f'VRAM: {torch.cuda.memory_allocated() / 1024**3:.2f} GB')"

# Entrenar modelo de ejemplo
python example_hexa_usage.py
```

---

## 4. OLLAMA (Modelos Locales)

```powershell
# Verificar instalación
ollama --version

# Descargar modelo Phi-3 (2.4 GB, optimizado para 4GB VRAM)
ollama pull phi3:mini-4k-instruct-q4_K_M

# Probar modelo interactivamente
ollama run phi3:mini-4k-instruct-q4_K_M

# Listar modelos descargados
ollama list

# Ejecutar modelo en background (puerto 11434)
ollama serve
```

---

## 5. DOCKER & OBSERVABILIDAD

```powershell
# Iniciar stack completo (Prometheus, Grafana, AlertManager)
docker-compose up -d

# Ver estado de contenedores
docker-compose ps

# Ver logs de Grafana
docker-compose logs grafana

# Detener todo
docker-compose down

# Limpiar volúmenes (ADVERTENCIA: borra datos)
docker-compose down -v
```

---

## 6. JUPYTER NOTEBOOKS

```powershell
# Iniciar Jupyter
jupyter notebook

# O usar Jupyter Lab (interfaz moderna)
jupyter lab

# Limpiar kernels viejos
jupyter kernelspec list
jupyter kernelspec remove python311
```

---

## 7. GIT & VERSIONADO

```powershell
# Configurar Git (primera vez)
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"

# Inicializar repo
git init

# Agregar todos los archivos
git add .

# Primer commit
git commit -m "Initial commit: HEXA-DATA toolkit setup"

# Ver estado
git status

# Ver historial
git log --oneline
```

---

## 8. DESARROLLO & DEBUGGING

```powershell
# Linting con flake8
flake8 *.py

# Type checking con mypy
mypy config_pytorch.py

# Formateo con Black
black *.py

# Testing con pytest
pytest tests/ -v

# Cobertura de tests
pytest --cov=. tests/
```

---

## 9. MONITOREO DE RECURSOS

```powershell
# Ver uso de CPU/RAM en tiempo real
Get-Process python | Select-Object ProcessName, CPU, @{l="RAM (MB)"; e={$_.WorkingSet / 1MB}}

# Ver procesos por uso de memoria
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 ProcessName, @{l="RAM (MB)"; e={$_.WorkingSet / 1MB}}

# Ver versión de NVIDIA drivers
nvidia-smi

# Monitor de GPU en tiempo real
nvidia-smi -l 1
```

---

## 10. TROUBLESHOOTING

### Python no encuentra módulos
```powershell
# Verificar que estás en el venv correcto
(venv) PS> ...  # Debería haber (venv) al inicio

# Reinstalar dependencias
pip install -r requirements.txt
```

### CUDA no disponible
```powershell
# Actualizar drivers NVIDIA
# Descarga desde: https://www.nvidia.com/Download/driverDetails.aspx

# Verificar instalación CUDA
nvidia-smi
```

### Ollama tarda mucho
```powershell
# Es normal descargar 2-3 GB
# Puedes revisar progreso en: C:\Users\{user}\.ollama

# Preguntar por modelos disponibles
ollama list
```

### Docker no inicia
```powershell
# Habilitar WSL 2 (recomendado para Windows 11)
wsl --install -d Ubuntu

# O verificar que Docker Desktop está corriendo
Get-Process docker
```

---

## 11. ATAJOS ÚTILES

```powershell
# Abrir en VS Code
code .

# Limpiar caché Python
Get-ChildItem -Recurse -Filter __pycache__ | Remove-Item -Recurse
Get-ChildItem -Recurse -Filter *.pyc | Remove-Item

# Crear backup de requirements
pip freeze > requirements_frozen.txt

# Actualizar todas las librerías
pip install --upgrade -r requirements.txt

# Ver espacio en disco
Get-Volume

# Listar puertos activos
netstat -ano | findstr "8000 8888 3000 9090"
```

---

## 12. RECURSOS ÚTILES

| Recurso | Comando / Enlace |
|---------|------------------|
| **Docs PyTorch** | https://pytorch.org/docs |
| **Docs LangGraph** | https://langchain-ai.github.io/langgraph |
| **Docs Ollama** | https://ollama.com |
| **Docs Docker** | https://docs.docker.com |
| **Docs Kubernetes** | https://kubernetes.io/docs |
| **Docs OPA** | https://opa.io/docs |

---

## 13. INFORMACIÓN DEL SISTEMA

```powershell
# Ver especificaciones del sistema
Get-ComputerInfo | Select-Object CsName, OsName, OsVersion, OsSystemDirectory

# GPU
nvidia-smi -q

# RAM
Get-WmiObject Win32_ComputerSystem | Select-Object TotalPhysicalMemory

# Almacenamiento
Get-Volume | Select-Object DriveLetter, Size, SizeRemaining
```

---

**¡Listo para empezar!** 🚀

Si tienes dudas, ejecuta `python verify_hexa_setup.py` para diagnosticar el estado de la instalación.
