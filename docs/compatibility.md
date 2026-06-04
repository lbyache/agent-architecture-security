# Compatibilidad y Testing

> **Nota:** La compatibilidad con herramientas específicas está basada en la correspondencia de formato (YAML frontmatter + Markdown), no en pruebas de integración automatizadas. Si verificás el funcionamiento en tu herramienta, abrí un issue o PR para actualizar esta tabla.

## Herramientas Compatibles

| Herramienta | Mecanismo nativo | Directorio de instalación | Estado |
|---|---|---|---|
| opencode | SKILL.md con frontmatter | `~/.config/opencode/skills/` o `.opencode/skills/` | Compatible — no verificado en producción |
| Claude Code | SKILL.md con frontmatter | `~/.claude/skills/` o `.claude/skills/` | Compatible — no verificado en producción |
| Codex / GitHub Copilot | AGENTS.md (no soporta SKILL.md) | Raíz del repo o directorio de trabajo | Requiere conversión manual a AGENTS.md |
| Cursor / Windsurf | `.cursorrules` / reglas de proyecto | Raíz del repo | Requiere copiar contenido manualmente |
| Otras | Instrucciones en texto plano | Varía | Copiar contenido de SKILL.md al archivo de instrucciones |

## Uso en herramientas sin soporte SKILL.md

Para Codex, Copilot, Cursor y similares, copiá el contenido del skill al archivo de instrucciones de tu herramienta:

```bash
# Activar un skill específico en AGENTS.md (Codex / Copilot)
cat skills/orchestrator-architect/SKILL.md >> AGENTS.md

# Activar todos los skills
for skill in skills/*/SKILL.md; do
  echo "" >> AGENTS.md
  cat "$skill" >> AGENTS.md
done
```

El contenido Markdown es compatible con cualquier herramienta que acepte instrucciones en texto plano.


## Modelos de Lenguaje

Todos los skills usan `model: inherit`, lo que significa que funcionan con cualquier modelo que la herramienta tenga configurado. No se fuerza un modelo específico.

**Capacidad mínima recomendada:** modelos con buen seguimiento de instrucciones (7B+ parámetros para modelos locales, o cualquier modelo cloud de proveedor principal).

Para obtener scoring consistente, modelos más grandes (>14B local o modelos cloud como Claude, GPT-4) producen resultados más calibrados.

### Compatibilidad Testeada/Esperada

| Modelo | Tipo | Resultado |
|---|---|---|
| qwen2.5-coder | Local (Ollama) | Funcional, scores pueden variar |
| Claude Sonnet/Opus | Cloud | Recomendado, scoring consistente |
| GPT-4/4o | Cloud | Compatible, buen seguimiento de instrucciones |
| Modelos <7B | Local | No recomendado, pueden ignorar rúbricas de calibración |

## Cómo Verificar la Instalación

1. **Copiar skills al directorio correspondiente** de tu herramienta (e.g., `~/.config/opencode/skills/` para opencode)
2. **Iniciar la herramienta** (e.g., `opencode`)
3. **Verificar que los 4 skills aparecen disponibles:**
   - `orchestrator-architect`
   - `owasp-quick-check`
   - `security-analyst`
   - `owasp-top-10`
4. **Test rápido:** pedirle al agente _"quiero construir una API REST con login"_ y verificar que ejecuta las 5 fases del orquestador

## Cómo Testear Consistencia del Scoring

Para verificar que tu modelo produce scores calibrados, usa esta prueba simple:

1. Usar el mismo prompt de prueba con diferentes modelos
2. **Prompt sugerido:**
   ```
   Audita este código: def login(user, pwd): query = f"SELECT * FROM users WHERE user='{user}'"
   ```
3. Un modelo consistente debería dar:
   - **C2 Injection: 0** (SQL injection evidente, sin protección)
   - **C5 Access Control: 0-1** (sin control de acceso visible)
4. Si un modelo da **C2 > 2** para ese código, no es confiable para scoring

## Limitaciones Conocidas

- El scoring es heurístico y no determinístico — el mismo input puede producir scores ligeramente diferentes entre ejecuciones
- Modelos pequeños pueden no seguir las rúbricas de calibración, produciendo scores inconsistentes
- La delegación entre agentes (orquestador → analista) depende del soporte de la herramienta para invocación de skills
- No reemplaza herramientas profesionales SAST/DAST (e.g., SonarQube, Snyk, Burp Suite)
- Las referencias OWASP Top 10 son de la versión 2021
