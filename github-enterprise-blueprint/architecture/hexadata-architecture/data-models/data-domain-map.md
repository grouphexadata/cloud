# Data Domain Map

## Dominios
- identity: usuarios, cuentas, roles
- security: alertas, eventos, evidencias
- intelligence: señales, fuentes, correlaciones
- operations: ejecuciones, jobs, estados
- finance: costos, billing, presupuestos

## Reglas
1. Cada dominio tiene owner claro.
2. Contratos de datos versionados en hexadata-api-contracts.
3. Campos sensibles etiquetados y protegidos.
4. No acoplar modelos internos con APIs externas sin mapeo.
