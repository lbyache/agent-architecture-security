# Agent Architecture & Security Skills

Skills para asistentes de código AI especializados en arquitectura de agentes y seguridad OWASP.

Implementa una arquitectura de dos agentes para auditoría de seguridad integrada en el flujo de generación de código:

- **Architect Agent** (orquestador): coordina las 5 fases del proceso
- **Security Analyst Agent** (subagente): ejecuta el Security Deep Dive y emite un Security Readiness Score de 0-30

---

## Compatibilidad

Estos skills están escritos como archivos Markdown con YAML frontmatter y son compatibles con herramientas de desarrollo AI que soporten este formato de skills/agentes, incluyendo:

- [opencode](https://opencode.ai) — skills en `~/.config/opencode/skills/`
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — agentes y skills como plugins
- Otras herramientas que soporten el formato `.md` con frontmatter para agentes

> **Nota:** El modelo de lenguaje a utilizar depende de la herramienta. El campo `model: inherit` en los skills indica que se use el modelo configurado en la herramienta (puede ser un modelo local vía Ollama, o un modelo cloud como Claude, GPT, etc.).

---

## Flujo de 5 Fases

```
Usuario: "quiero construir una API REST con login y subida de archivos"
         │
         ▼
┌─────────────────────────────────────────────────────────┐
│              ARCHITECT AGENT (orquestador)               │
│                                                         │
│  FASE 1 ── Quick Check de Seguridad                      │
│            Detecta vectores de riesgo en la solicitud   │
│            Path Traversal, SQLi, XSS, Secrets,          │
│            IDOR, Rate Limiting                           │
│                    │                                     │
│                    ▼                                     │
│  FASE 2 ── Selección de Stack Tecnológico               │
│            Propone 2-3 opciones con perfil de seguridad  │
│                    │                                     │
│                    ▼                                     │
│  FASE 3 ── Matriz de Evaluación Comparativa             │
│            Tabla de criterios + recomendación final      │
│                    │                                     │
│                    ▼                                     │
│  FASE 4 ── Security Deep Dive ──────────────────────┐   │
│            Delega al subagente                       │   │
│                    │              ┌───────────────┐  │   │
│                    └─────────────►│ SECURITY      │  │   │
│                                  │ ANALYST AGENT │  │   │
│                                  │               │  │   │
│                                  │ Score 0-30    │  │   │
│                                  │ 6 categorías  │  │   │
│                                  └──────┬────────┘  │   │
│                    ┌─────────────────────┘           │   │
│                    ▼                                 │   │
│  FASE 5 ── Offer BUILD                               │   │
│            score < 15  → ❌ BLOQUEADO                │   │
│            score 15-22 → ⚠️  APROBADO CON CONDICIONES│   │
│            score > 22  → ✅ APROBADO                 │   │
└─────────────────────────────────────────────────────────┘
         │
         ▼
  "¿Procedemos con la construcción?"
```

---

## Skills incluidos

| Skill | Rol | Fase |
|---|---|---|
| `orchestrator-architect` | Agente orquestador, coordina las 5 fases | Todas |
| `owasp-quick-check` | Triage rápido de riesgos en 6 categorías | Fase 1 |
| `security-analyst` | Score de seguridad 0-30, auditoría de diseño y código | Fase 4 |
| `owasp-top-10` | Referencia completa OWASP Top 10 2021 | Referencia |

---

## Sobre el Security Readiness Score

El Security Readiness Score de 0-30 evalúa **6 categorías clave** derivadas de OWASP Top 10, seleccionadas por su alta incidencia en proyectos nuevos:

| # | Categoría | OWASP relacionado |
|---|---|---|
| C1 | Path Traversal / File Access | A01 Broken Access Control |
| C2 | Injection (SQL/NoSQL/Command) | A03 Injection |
| C3 | XSS / Output Encoding | A03 Injection / A07 |
| C4 | Secrets & Credentials | A02 Cryptographic Failures |
| C5 | Access Control / IDOR | A01 Broken Access Control |
| C6 | Rate Limiting & DoS | A05 Security Misconfiguration |

> **Importante:** Este score es una evaluación heurística basada en análisis de texto por un LLM, no una auditoría formal de seguridad. Los resultados pueden variar entre ejecuciones y modelos. Para auditorías formales, utilizar herramientas SAST/DAST profesionales.

---

## Instalación

### 1. Copiar los skills

```bash
# Clonar el repositorio
git clone https://github.com/LauYache/agent-architecture-security
cd agent-architecture-security

# Copiar skills al directorio de tu herramienta
# Para opencode:
cp -r skills/* ~/.config/opencode/skills/

# Para Claude Code (como plugin):
# Consultar la documentación de plugins de Claude Code
```

### 2. Verificar instalación

```bash
# Iniciar tu herramienta y verificar que los skills aparezcan disponibles
# Para opencode:
opencode
/skills
```

---

## Ejemplo de Uso Completo

**Solicitud del usuario:**
> "Quiero construir un sistema de gestión de documentos donde los usuarios puedan subir PDFs, buscarlos por nombre, y compartirlos con otros usuarios mediante un link."

**Respuesta del Architect Agent:**

```
━━━ FASE 1: QUICK CHECK DE SEGURIDAD ━━━━━━━━━━━━━

C1 Path Traversal:    🔴 Alto  — upload/download de archivos sin validación de rutas
C2 SQL Injection:     🟡 Medio — búsqueda por nombre puede construir queries dinámicas
C3 XSS:               🟡 Medio — nombres de archivo renderizados en UI
C4 Hardcoded Secrets: 🟢 Bajo  — no mencionado aún, vigilar en config
C5 IDOR:              🔴 Alto  — links de compartir pueden exponer docs de otros usuarios
C6 Rate Limiting:     🟡 Medio — endpoint de upload sin límites mencionados

━━━ FASE 2: STACK TECNOLÓGICO ━━━━━━━━━━━━━━━━━

Opción A: FastAPI + PostgreSQL + S3-compatible (MinIO local)
Opción B: Express.js + MongoDB + sistema de archivos local
Opción C: Django + PostgreSQL + almacenamiento en disco

━━━ FASE 3: MATRIZ COMPARATIVA ━━━━━━━━━━━━━━━━

| Criterio              | FastAPI+PG | Express+Mongo | Django+PG |
|-----------------------|-----------|---------------|-----------| 
| Seguridad por defecto | Alta      | Media         | Alta      |
| Path traversal nativo | Sí (S3)   | No            | Parcial   |
| ORM con prepared stmts| SQLAlchemy| Mongoose      | Django ORM|
| Riesgo OWASP residual | Bajo      | Medio         | Bajo      |

Recomendación: FastAPI + PostgreSQL + MinIO

━━━ FASE 4: SECURITY DEEP DIVE ━━━━━━━━━━━━━━━

[Security Analyst evalúa el diseño y emite score]

C1 Path Traversal:    4 — S3/MinIO elimina traversal; validar extensiones
C2 Injection:         5 — SQLAlchemy ORM + prepared statements
C3 XSS/Output:        3 — Sanitizar nombres de archivo en frontend
C4 Secrets:           4 — .env para credenciales MinIO/DB
C5 Access Control:    3 — Implementar ownership check en links compartidos
C6 Rate Limiting:     3 — Agregar throttling en endpoint /upload

SCORE TOTAL: 22 / 30

DECISIÓN: ⚠️ APROBADO CON CONDICIONES

━━━ FASE 5: OFFER BUILD ━━━━━━━━━━━━━━━━━━━━━━

Stack seleccionado: FastAPI + PostgreSQL + MinIO
Security Readiness Score: 22/30 ⚠️

Condiciones obligatorias antes de construir:
1. Implementar validación de ownership en endpoints de compartir
2. Sanitizar nombres de archivo en la capa de presentación
3. Configurar rate limiting en /upload (ej: 10 req/min por usuario)

¿Procedemos con la construcción aplicando estas condiciones?
```

---

## Auditoría de Código Generado

El Security Analyst también puede auditar código ya escrito, de forma agnóstica al lenguaje:

```
# En tu herramienta AI, pegar el código y escribir:
"Audita la seguridad de este código con score OWASP"

# El Security Analyst detecta patrones vulnerables en el texto
# sin necesitar compilación ni ejecución
```

Ejemplo de uso directo:

```python
# Código a auditar
def get_document(user_id, doc_id):
    query = f"SELECT * FROM docs WHERE id = {doc_id}"  # SQLi
    path = f"/files/{doc_id}.pdf"                      # Path traversal
    return open(path).read()
```

El Security Analyst identificará:
- C2 Injection: score 0 — concatenación directa de `doc_id` en query SQL
- C1 Path Traversal: score 1 — ruta construida con input sin validar
- C5 IDOR: score 0 — no verifica que `doc_id` pertenece a `user_id`

---

## Limitaciones

- El score de seguridad es heurístico y depende del LLM utilizado — no reemplaza una auditoría profesional
- Las 6 categorías cubren los riesgos más frecuentes pero no la totalidad del OWASP Top 10
- La delegación entre agentes depende de que la herramienta soporte invocación de subagentes
- Los resultados pueden variar entre ejecuciones y entre modelos

## Referencias

- [Artículo de diseño del sistema](https://lauyache.github.io/portfolio/buencommit/orquestador-arquitectura-seguridad/)
- [OWASP Top 10 2021](https://owasp.org/Top10/)

## Licencia

[MIT](LICENSE)
