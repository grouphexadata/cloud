# policies/prompt_constraints.rego
# Validación de políticas de seguridad para HEXA-DATA PROMPT
# Garantiza que los prompts cumplan con restricciones de temperatura, seed, etc.
# Actualizado: Abril 2026 — modelos sincronizados con hexadata_prompt.html v2.0

package hexa_data.prompts

# Política por defecto: DENEGAR acceso
default allow = false

# Permitir solo si se cumplen todas las restricciones
allow {
    # Validar rango de temperatura (0.1 - 0.5 para mayor consistencia predictiva)
    input.temperature >= 0.1
    input.temperature <= 0.5
    
    # Garantizar que seed está definido para reproducibilidad
    input.seed != null
    
    # Permitir solo modelos autorizados (sincronizado con aiProfiles en hexadata_prompt.html)
    input.model in ["gpt-5.3-codex", "claude-3.7-sonnet", "gemini-2.5-pro", "llama-3.2-70b", "local-phi3"]
    
    # Validar presencia de metadata de auditoría
    input.audit_id != null
    
    # Garantizar max_tokens dentro de límites (32 tokens mínimo, 32768 máximo — modelos 2026)
    input.max_tokens <= 32768
    input.max_tokens >= 32
}

# Regla de negación explícita para prompts sin temperatura válida
deny[msg] {
    input.temperature > 0.5
    msg := "VIOLACIÓN: Temperatura superior a 0.5 (riesgo de alucinaciones)"
}

deny[msg] {
    input.temperature < 0.1
    msg := "VIOLACIÓN: Temperatura inferior a 0.1 (respuestas demasiado determinísticas)"
}

deny[msg] {
    input.seed == null
    msg := "VIOLACIÓN: Seed no definido (imposible reproducibilidad)"
}

deny[msg] {
    not (input.model in ["gpt-5.3-codex", "claude-3.7-sonnet", "gemini-2.5-pro", "llama-3.2-70b", "local-phi3"])
    msg := sprintf("VIOLACIÓN: Modelo '%v' no autorizado", [input.model])
}

deny[msg] {
    input.max_tokens > 32768
    msg := "VIOLACIÓN: max_tokens excede 32768"
}

# Validar alineación (opcional)
warn[msg] {
    input.temperature > 0.3
    msg := "ADVERTENCIA: Temperatura > 0.3 puede reducir fidelidad predictiva"
}

# Métrica de confianza (0-100)
confidence_score = score {
    score := 100 - (abs(input.temperature - 0.3) * 100)
}
