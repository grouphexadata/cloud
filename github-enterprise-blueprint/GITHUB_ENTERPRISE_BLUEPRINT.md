# HEXADATA Cloud | GitHub Enterprise Blueprint

## Objetivo
Convertir la presencia GitHub en una arquitectura de empresa real: modular, auditable y escalable.

## Decision de Arquitectura
Estrategia recomendada: arquitectura hibrida.
- Multi-repo como base: cada producto evoluciona de forma independiente.
- Repositorio central de gobierno: estandares, contratos, arquitectura y lineamientos de seguridad.

## Organizacion
Nombre recomendado:
- hexadata-cloud

## Repos de producto
- hexadata-core
- hexadata-ident
- hexadata-watson
- hexadata-security
- hexadata-authenticator
- hexadata-bi
- hexadata-lab-diamante
- hexadata-osint
- hexadata-beyond-cloud
- hexadata-backup
- hexadata-pay

## Repos estrategicos
- hexadata-architecture
- hexadata-sdk
- hexadata-api-contracts
- hexadata-infra
- hexadata-devops
- hexadata-design-system

## Convencion de naming
Regla:
- hexadata-[dominio]

Evitar:
- nombres largos con marketing
- sufijos tipo v2, final, new
- espacios o guiones inconsistentes

## Estructura base para todos los repos
- /src
- /tests
- /docs
- /examples
- /.github
- README.md
- LICENSE
- CONTRIBUTING.md
- CHANGELOG.md

## Orden de ejecucion recomendado
Fase 1:
- hexadata-core
- hexadata-security
- hexadata-osint

Fase 2:
- hexadata-api-contracts
- hexadata-sdk
- hexadata-devops

Fase 3:
- hexadata-bi
- hexadata-authenticator
- hexadata-infra
- hexadata-design-system

Fase 4:
- Resto de modulos de negocio

## Posicionamiento recomendado
Mensaje corto de marca:
- HEXA-DATA CLOUD es un ecosistema modular de inteligencia distribuida.

## Entregables incluidos en esta carpeta
- templates/README_MODULE_TEMPLATE.md
- templates/CONTRIBUTING_TEMPLATE.md
- templates/CHANGELOG_TEMPLATE.md
- templates/REPO_STRUCTURE.md
- templates/CODEOWNERS_TEMPLATE
- templates/.github/workflows/ci.yml
- architecture/hexadata-architecture/README.md
- architecture/hexadata-architecture/diagrams/c4-context.mmd
- scripts/bootstrap_hexadata_repos.ps1
- scripts/init_hexadata_repo_structure.ps1

## Uso sugerido
1. Crear la organizacion hexadata-cloud.
2. Ejecutar scripts/bootstrap_hexadata_repos.ps1 con GitHub CLI autenticado.
3. Aplicar templates a cada repositorio.
4. Usar hexadata-architecture como fuente de verdad tecnica.

## Implementacion directa de 1, 2 y 3

### 1) CODEOWNERS base
- Archivo: templates/CODEOWNERS_TEMPLATE
- Accion: copiar a CODEOWNERS en cada repo y ajustar equipos reales.

### 2) Workflows base de CI
- Archivo: templates/.github/workflows/ci.yml
- Incluye:
	- validacion de estructura minima
	- chequeo de sintaxis Python
	- escaneo basico de secretos (gitleaks)

### 3) Script para inicializar estructura estandar
- Archivo: scripts/init_hexadata_repo_structure.ps1
- Uso:

```powershell
./init_hexadata_repo_structure.ps1 -RepoPath "C:\repos\hexadata-core" -ModuleName "hexadata-core" -ModuleDescription "Nucleo de orquestacion"
```

Esto crea:
- /src
- /tests
- /docs
- /examples
- /.github/workflows/ci.yml
- README.md
- CONTRIBUTING.md
- CHANGELOG.md
- LICENSE
- CODEOWNERS
