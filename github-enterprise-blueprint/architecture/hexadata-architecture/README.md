# HEXADATA Architecture

Repositorio central de arquitectura y gobierno tecnico del ecosistema HEXADATA Cloud.

## Vision
HEXA-DATA CLOUD es un ecosistema modular de inteligencia distribuida.

## Alcance
- arquitectura global
- estandares de desarrollo
- lineamientos de seguridad
- contratos de integracion
- diagramas tecnicos (C4)

## Estructura
- /docs
- /architecture
- /diagrams
- /standards
- /security
- /data-models

## Capas del ecosistema
- EXPERIENCE: Dashboards, BI, interfaces
- INTELLIGENCE: OSINT, AI, analytics
- SECURITY: Auth, firewall, monitoring
- CORE: Orquestacion, procesamiento
- INFRASTRUCTURE: Storage, backup, cloud

## Reglas de integracion entre repos
1. Los contratos viven en hexadata-api-contracts.
2. Los SDK viven en hexadata-sdk.
3. Ningun modulo publica cambios breaking sin versionado semantico.
4. Todo servicio debe tener owner tecnico.

## Prioridad de implementacion
1. CORE
2. SECURITY
3. OSINT
4. Modulos satelite

## Governance minima
- RFC para cambios de arquitectura
- ADR por decision critica
- revisión de seguridad para nuevos servicios
- control de dependencia y licencias
