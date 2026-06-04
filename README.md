# Agent Architecture & Security Skills

Skills para asistentes de código AI especializados en arquitectura de agentes y seguridad OWASP.

Implementa una arquitectura de dos agentes para auditoría de seguridad integrada en el flujo de generación de código:

- **Architect Agent** (orquestador): coordina las 5 fases del proceso
- **Security Analyst Agent** (subagente): ejecuta el Security Deep Dive y emite un Security Readiness Score de 0-50
 
 ---
 
 
 │                                  │ Score 0-50    │  │   │
 │                                  │ 10 categorías │  │   │
 │                                  └──────┬────────┘  │   │
 │                    ┌─────────────────────┘           │   │
 │  FASE 5 ── Offer BUILD                               │
-│            score < 25  → [BLOQUEADO]                │   │
-│            score 25-37 → [ADVERTENCIA] APROBADO CON CONDICIONES│   │
-│            score > 37  → [OK] APROBADO                 │   │
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
| `owasp-quick-check` | Triage rápido de riesgos en 6 categorías de alta incidencia | Fase 1 |
| `security-analyst` | Score de seguridad 0-50, auditoría de diseño y código (10 categorías OWASP) | Fase 4 |
| `owasp-top-10` | Referencia completa OWASP Top 10 2021 | Referencia |

---

## Sobre el Security Readiness Score

El Security Readiness Score de 0-50 evalúa **10 categorías** que cubren el OWASP Top 10 2021 completo, con 5 puntos por categoría:

| # | Categoría | OWASP Top 10 2021 |
|---|---|---|
| C1 | Access Control | A01 Broken Access Control |
| C2 | Cryptography | A02 Cryptographic Failures |
| C3 | Injection | A03 Injection |
| C4 | Secure Design | A04 Insecure Design |
| C5 | Configuration | A05 Security Misconfiguration |
| C6 | Dependencies | A06 Vulnerable and Outdated Components |
| C7 | Authentication | A07 Identification and Authentication Failures |
| C8 | Integrity | A08 Software and Data Integrity Failures |
| C9 | Logging | A09 Security Logging and Monitoring Failures |
| C10 | SSRF | A10 Server-Side Request Forgery |

**Umbrales de decisión:**

| Score | Decisión |
|---|---|
| < 25 | [BLOQUEADO] — no proceder a construcción |
| 25-37 | [ADVERTENCIA] APROBADO CON CONDICIONES — remediar hallazgos antes de construir |
| > 37 | [OK] APROBADO — proceder a construcción |

> **Importante:** Este score es una evaluación heurística basada en análisis de texto por un LLM, no una auditoría formal de seguridad. Los resultados pueden variar entre ejecuciones y modelos. Para auditorías formales, utilizar herramientas SAST/DAST profesionales.

---

## Instalación

### opencode

```bash
cp -r skills/* ~/.config/opencode/skills/
# o para uso en proyecto:
cp -r skills/* .opencode/skills/
```

Los skills se cargan bajo demanda — el agente los descubre y los invoca cuando el contexto lo requiere.

### Claude Code

```bash
cp -r skills/* ~/.claude/skills/
# o para uso en proyecto:
cp -r skills/* .claude/skills/
```

### Codex / GitHub Copilot

Estas herramientas no soportan SKILL.md — usan `AGENTS.md` como archivo de instrucciones. Copiá el contenido del skill que querés activar en tu `AGENTS.md`:

```bash
# Ejemplo: activar el orquestador
cat skills/orchestrator-architect/SKILL.md >> AGENTS.md
```

Para activar todos los skills de una vez:

```bash
for skill in skills/*/SKILL.md; do
  echo "" >> AGENTS.md
  cat "$skill" >> AGENTS.md
done
```

### Cursor / Windsurf / otros editores

Copiá el contenido de los skills relevantes en el archivo de instrucciones de tu editor (`.cursorrules`, `.windsurfrules`, o equivalente). El formato Markdown es compatible con cualquier herramienta que acepte instrucciones en texto plano.

### Verificar instalación

Pedile al agente: _"quiero construir una API REST con login"_ — debería ejecutar las 5 fases del orquestador automáticamente.

---

## Ejemplo de Uso Completo

**Solicitud del usuario:**
> "Quiero construir un sistema de gestión de documentos donde los usuarios puedan subir PDFs, buscarlos por nombre, y compartirlos con otros usuarios mediante un link."

**Respuesta del Architect Agent:**

```
━━━ FASE 1: QUICK CHECK DE SEGURIDAD ━━━━━━━━━━━━━

C1 Path Traversal:    [ALTO] — upload/download de archivos sin validación de rutas
C2 SQL Injection:     [MEDIO] — búsqueda por nombre puede construir queries dinámicas
C3 XSS:               [MEDIO] — nombres de archivo renderizados en UI
C4 Hardcoded Secrets: [BAJO]  — no mencionado aún, vigilar en config
C5 IDOR:              [ALTO]  — links de compartir pueden exponer docs de otros usuarios
C6 Rate Limiting:     [MEDIO] — endpoint de upload sin límites mencionados

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

C1  Access Control:   4 — S3/MinIO elimina traversal; UUID keys para archivos
C2  Cryptography:     4 — .env para credenciales MinIO/DB; bcrypt para passwords
C3  Injection:        5 — SQLAlchemy ORM + prepared statements; sin concatenación
C4  Secure Design:    3 — Diseño razonable pero sin threat model documentado
C5  Configuration:    3 — Agregar throttling en /upload y headers de seguridad
C6  Dependencies:     3 — Información insuficiente para evaluar completamente
C7  Authentication:   3 — Implementar ownership check en links compartidos
C8  Integrity:        3 — Información insuficiente para evaluar completamente
C9  Logging:          3 — Información insuficiente para evaluar completamente
C10 SSRF:             3 — No aplica directamente; sin fetch a URLs externas

SECURITY READINESS SCORE: 34 / 50

DECISIÓN: [ADVERTENCIA] APROBADO CON CONDICIONES
 
 ━━━ FASE 5: OFFER BUILD ━━━━━━━━━━━━━━━━━━━━━━
 
 Stack seleccionado: FastAPI + PostgreSQL + MinIO
 Security Readiness Score: 34/50 [ADVERTENCIA]

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
- C1 Access Control: score 0 — no verifica que `doc_id` pertenece a `user_id`; path construido con input sin validar
- C2 Cryptography: score 3 — no evaluable desde este fragmento
- C3 Injection: score 0 — concatenación directa de `doc_id` en query SQL

---

## Testing

El repo incluye un script de validación que verifica la integridad de los skills:

```bash
bash scripts/test-skills.sh
```

Corre desde la raíz del repo. El script ejecuta 5 bloques de validación:

**Bloque 1 — Frontmatter**: cada SKILL.md abre y cierra con `---`, tiene los campos `name` y `description`, y el valor de `name` coincide con el nombre del directorio que lo contiene. Esto garantiza que cualquier herramienta que consuma el frontmatter lo pueda parsear correctamente.

**Bloque 2 — Contenido mínimo**: el body de cada skill tiene al menos 100 palabras. Detecta skills vacíos o truncados.

**Bloque 3 — Referencias de owasp-top-10**: los 12 archivos de referencia declarados en el SKILL.md de `owasp-top-10` existen físicamente en `references/`. Detecta referencias rotas si alguien renombra o elimina un archivo.

**Bloque 4 — Consistencia del score**: busca patrones del modelo viejo (`0-30`, umbrales `< 15 / 15-22 / > 22`) en todos los archivos `.md`. Detecta documentación desincronizada si se actualiza el scoring en los skills pero no en el README u otros docs.

**Bloque 5 — .DS_Store**: verifica que no haya archivos `.DS_Store` trackeados en git.

Salida esperada cuando todo está bien:

```
[OK] Todos los tests pasaron
```
 
 Si algo falla, cada [ERROR] indica el archivo y el problema exacto.

Para que corra automáticamente antes de cada commit:

```bash
cp scripts/test-skills.sh .git/hooks/pre-commit
```

El CI en GitHub Actions corre el mismo script en cada push y pull request a `main`.

---

## Limitaciones

- El score de seguridad es heurístico y depende del LLM utilizado — no reemplaza una auditoría profesional
- Las 10 categorías cubren el OWASP Top 10 2021 completo, pero el análisis es textual y no equivale a herramientas SAST/DAST
- La delegación entre agentes depende de que la herramienta soporte invocación de subagentes
- Los resultados pueden variar entre ejecuciones y entre modelos

## Referencias

- [OWASP Top 10 2021](https://owasp.org/Top10/)

## Licencia

[MIT](LICENSE)
