#!/usr/bin/env bash
# test-skills.sh — Smoke test local para validar la integridad de los skills
# Uso: bash scripts/test-skills.sh

set -euo pipefail

EXIT_CODE=0
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

pass() { echo "  Ok $1"; }
fail() { echo "  X $1"; EXIT_CODE=1; }
section() { echo ""; echo "━━━ $1 ━━━"; }

# ─────────────────────────────────────────────
# BLOQUE 1: Estructura de frontmatter
# ─────────────────────────────────────────────
section "BLOQUE 1 — Estructura de frontmatter"

SKILL_FILES=$(find "$REPO_ROOT/skills" -name "SKILL.md" -type f | sort)

if [ -z "$SKILL_FILES" ]; then
  echo " No se encontraron archivos SKILL.md en skills/"
  exit 1
fi

for FILE in $SKILL_FILES; do
  SKILL_NAME=$(basename "$(dirname "$FILE")")
  echo ""
  echo "  → $SKILL_NAME"

  # Abre con ---
  FIRST_LINE=$(awk 'NR==1{print; exit}' "$FILE")
  [ "$FIRST_LINE" = "---" ] && pass "Abre con ---" || fail "No abre con ---"

  # Extrae frontmatter
  FM=$(awk 'BEGIN{f=0} /^---$/{f++; if(f==2) exit; next} f==1{print}' "$FILE")

  # Campos obligatorios
  for FIELD in name description; do
    echo "$FM" | grep -q "^${FIELD}:" && pass "Campo '${FIELD}:' presente" || fail "Campo '${FIELD}:' ausente"
  done

  # Cierra con segundo ---
  CLOSING=$(awk 'BEGIN{f=0} /^---$/{f++; if(f==2){print "ok"; exit}}' "$FILE")
  [ "$CLOSING" = "ok" ] && pass "Cierra frontmatter con ---" || fail "No cierra frontmatter con ---"

  # name en frontmatter coincide con nombre del directorio
  NAME_VAL=$(echo "$FM" | grep "^name:" | awk '{print $2}')
  [ "$NAME_VAL" = "$SKILL_NAME" ] && pass "name '$NAME_VAL' coincide con directorio" || fail "name '$NAME_VAL' no coincide con directorio '$SKILL_NAME'"
done

# ─────────────────────────────────────────────
# BLOQUE 2: Contenido mínimo del body
# ─────────────────────────────────────────────
section "BLOQUE 2 — Contenido mínimo del body"

MIN_WORDS=100

for FILE in $SKILL_FILES; do
  SKILL_NAME=$(basename "$(dirname "$FILE")")
  # Body = todo lo que va después del segundo ---
  BODY=$(awk 'BEGIN{f=0} /^---$/{f++; next} f>=2{print}' "$FILE")
  WORD_COUNT=$(echo "$BODY" | wc -w | tr -d ' ')
  if [ "$WORD_COUNT" -ge "$MIN_WORDS" ]; then
    pass "$SKILL_NAME — body tiene $WORD_COUNT palabras (mín $MIN_WORDS)"
  else
    fail "$SKILL_NAME — body tiene solo $WORD_COUNT palabras (mín $MIN_WORDS)"
  fi
done

# ─────────────────────────────────────────────
# BLOQUE 3: Archivos de referencia de owasp-top-10
# ─────────────────────────────────────────────
section "BLOQUE 3 — Archivos de referencia de owasp-top-10"

REFS_DIR="$REPO_ROOT/skills/owasp-top-10/references"
EXPECTED_REFS=(
  "broken-access-control.md"
  "cryptographic-failures.md"
  "injection.md"
  "insecure-design.md"
  "security-misconfiguration.md"
  "vulnerable-components.md"
  "authentication-failures.md"
  "integrity-failures.md"
  "logging-monitoring.md"
  "ssrf.md"
  "prevention-strategies.md"
  "assessment-workflow.md"
)

for REF in "${EXPECTED_REFS[@]}"; do
  if [ -f "$REFS_DIR/$REF" ]; then
    pass "references/$REF existe"
  else
    fail "references/$REF no encontrado"
  fi
done

# ─────────────────────────────────────────────
# BLOQUE 4: Consistencia del score (sin referencias al modelo viejo)
# ─────────────────────────────────────────────
section "BLOQUE 4 — Consistencia del score (sin referencias al modelo viejo)"

STALE_PATTERNS=(
  "0-30"
  "/ 30"
  "/30"
  "Score de seguridad 0-30"
  "score < 15"
  "score 15-22"
  "score > 22"
)

ALL_MD=$(find "$REPO_ROOT" -name "*.md" -not -path "*/.git/*" | sort)

for PATTERN in "${STALE_PATTERNS[@]}"; do
  MATCHES=$(grep -rl "$PATTERN" $ALL_MD 2>/dev/null || true)
  if [ -z "$MATCHES" ]; then
    pass "Sin referencias a '$PATTERN'"
  else
    fail "Patrón obsoleto '$PATTERN' encontrado en: $MATCHES"
  fi
done

# ─────────────────────────────────────────────
# BLOQUE 5: Sin .DS_Store trackeados en git
# ─────────────────────────────────────────────
section "BLOQUE 5 — Sin .DS_Store trackeados en git"

DS=$(git -C "$REPO_ROOT" ls-files | grep '\.DS_Store' || true)
if [ -z "$DS" ]; then
  pass "No hay archivos .DS_Store trackeados en git"
else
  fail ".DS_Store trackeados en git: $DS"
fi

# ─────────────────────────────────────────────
# Resultado final
# ─────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $EXIT_CODE -eq 0 ]; then
  echo " Todos los tests pasaron"
else
  echo " Algunos tests fallaron — revisar los mensajes arriba"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

exit $EXIT_CODE
