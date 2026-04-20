param(
    [Parameter(Mandatory = $true)]
    [string]$RepoPath,

    [Parameter(Mandatory = $false)]
    [string]$ModuleName = "hexadata-module",

    [Parameter(Mandatory = $false)]
    [string]$ModuleDescription = "Modulo HEXADATA",

    [switch]$Force = $false
)

$ErrorActionPreference = "Stop"

function New-DirectoryIfMissing {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
        Write-Host "Created directory: $Path" -ForegroundColor Green
    }
}

function Write-FileIfMissing {
    param(
        [string]$Path,
        [string]$Content
    )

    if ((Test-Path $Path) -and -not $Force) {
        Write-Host "Skipped existing file: $Path" -ForegroundColor DarkYellow
        return
    }

    Set-Content -Path $Path -Value $Content -Encoding UTF8
    Write-Host "Written file: $Path" -ForegroundColor Green
}

$repoFullPath = Resolve-Path -Path $RepoPath -ErrorAction SilentlyContinue
if (-not $repoFullPath) {
    New-Item -ItemType Directory -Path $RepoPath -Force | Out-Null
    $repoFullPath = Resolve-Path -Path $RepoPath
}

$repo = $repoFullPath.Path

# Standard structure
$dirs = @(
    "src",
    "tests",
    "docs",
    "examples",
    ".github",
    ".github/workflows"
)

foreach ($d in $dirs) {
    New-DirectoryIfMissing -Path (Join-Path $repo $d)
}

$readme = @"
# HEXADATA $ModuleName

> $ModuleDescription

---

## Descripcion

[Que hace el modulo, por que existe, que problema resuelve]

---

## Capacidades

- Feature 1
- Feature 2
- Feature 3

---

## Arquitectura

[Diagrama o explicacion simple]

---

## Instalacion

```bash
git clone https://github.com/hexadata-cloud/$ModuleName
cd $ModuleName
```

---

## Uso

```python
# ejemplo
```

---

## Seguridad

[Notas relevantes si aplica]

---

## Integracion con Ecosistema

Este modulo forma parte de:
- HEXADATA CORE
- HEXADATA SECURITY
- HEXADATA OSINT

---

## Filosofia

Este modulo sigue los principios de:
- precision
- modularidad
- escalabilidad

---

## Autor

Francisco Caballero  
Arquitecto de Sistemas

---

## Licencia

MIT
"@

$contributing = @"
# Contributing

## Branching
- main
- feature/*
- fix/*
- chore/*

## Commit format
- feat:
- fix:
- docs:
- refactor:
- test:
- chore:

## Pull request checklist
- objetivo claro
- pruebas ejecutadas
- sin secretos
- documentacion actualizada
"@

$changelog = @"
# Changelog

## [Unreleased]
### Added
- 

### Changed
- 

### Fixed
- 

## [0.1.0] - 2026-04-20
### Added
- Initial scaffolding.
"@

$license = @"
MIT License

Copyright (c) 2026 Francisco Caballero

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"@

$codeowners = @"
* @hexadata-cloud/architecture
/src/ @hexadata-cloud/core-team
/tests/ @hexadata-cloud/qa-team
/.github/ @hexadata-cloud/devops-team
/docs/ @hexadata-cloud/architecture
"@

$workflow = @"
name: ci

on:
  pull_request:
    branches: [\"main\"]
  push:
    branches: [\"main\"]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: \"3.11\"
      - run: python -m compileall -q .
"@

Write-FileIfMissing -Path (Join-Path $repo "README.md") -Content $readme
Write-FileIfMissing -Path (Join-Path $repo "CONTRIBUTING.md") -Content $contributing
Write-FileIfMissing -Path (Join-Path $repo "CHANGELOG.md") -Content $changelog
Write-FileIfMissing -Path (Join-Path $repo "LICENSE") -Content $license
Write-FileIfMissing -Path (Join-Path $repo "CODEOWNERS") -Content $codeowners
Write-FileIfMissing -Path (Join-Path $repo ".github/workflows/ci.yml") -Content $workflow

Write-Host "" 
Write-Host "Repository scaffold completed for: $repo" -ForegroundColor Cyan
Write-Host "Next:" -ForegroundColor Cyan
Write-Host "1) revisar owners reales en CODEOWNERS" -ForegroundColor Cyan
Write-Host "2) agregar codigo en /src y tests en /tests" -ForegroundColor Cyan
Write-Host "3) hacer primer commit" -ForegroundColor Cyan
