# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es/1.1.0/).

## [0.3.0] - 2026-06-02

### Cambiado

- Idioma unificado a español en todos los skills (términos técnicos en inglés)
- Score renombrado de "OWASP Score" a "Security Readiness Score"
- Security Analyst ampliado a 10 categorías (50 puntos) cubriendo OWASP Top 10 completo
- Umbrales de decisión actualizados para nuevo score de 50 puntos
- `owasp-quick-check` clarificado como triage standalone o Fase 1 del orquestador

### Agregado

- Rúbricas de calibración con ejemplos concretos para cada nivel de score (0-5)
- Sección de limitaciones en `security-analyst` y `owasp-quick-check`
- Mapeo explícito de categorías propias a OWASP Top 10 2021
- CI con GitHub Actions para validar estructura de SKILL.md
- CHANGELOG
- Guía de compatibilidad y testing

## [0.2.0] - 2026-06-02

### Eliminado

- `owasp-security-review/` — skill roto (sin frontmatter, redundante)
- `agent-development/` — fuera de scope (meta-skill de Claude Code)
- Archivos `.DS_Store` del tracking de git

### Agregado

- `.gitignore` para macOS y editores
- `LICENSE` MIT
- Sección de compatibilidad en README (plataforma agnóstica)
- Disclaimer de score heurístico en README
- Sección de limitaciones en README

### Cambiado

- README reescrito: clarifica plataforma, honesto sobre alcance del score

## [0.1.0] - 2026-05-26

### Agregado

- Skills iniciales: orchestrator-architect, owasp-quick-check, security-analyst, owasp-top-10, owasp-security-review, agent-development
- README con diagrama de flujo de 5 fases
- Ejemplo de uso completo
- Referencias OWASP Top 10 2021 (12 archivos)
