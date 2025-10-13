#!/bin/bash

# Script para realizar code review usando el workflow de n8n
# Uso: ./code-review.sh <archivo> [lenguaje]

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Configuración
N8N_URL="${N8N_URL:-http://localhost:5678}"
WEBHOOK_PATH="/webhook/code-review"

# Función de ayuda
show_help() {
    cat << EOF
${BLUE}Code Review Assistant${NC}

Analiza código fuente y proporciona revisiones detalladas con sugerencias.

${YELLOW}Uso:${NC}
    $0 <archivo> [lenguaje]

${YELLOW}Argumentos:${NC}
    archivo     - Ruta al archivo de código a revisar
    lenguaje    - Lenguaje del código (opcional, auto-detectado si no se especifica)

${YELLOW}Ejemplos:${NC}
    $0 src/utils/validator.js
    $0 main.py python
    $0 - javascript  # Leer desde stdin

${YELLOW}Variables de entorno:${NC}
    N8N_URL     - URL del servidor n8n (default: http://localhost:5678)

EOF
    exit 0
}

# Detectar lenguaje por extensión
detect_language() {
    local file="$1"
    case "$file" in
        *.js)       echo "javascript" ;;
        *.ts)       echo "typescript" ;;
        *.py)       echo "python" ;;
        *.java)     echo "java" ;;
        *.go)       echo "go" ;;
        *.rb)       echo "ruby" ;;
        *.php)      echo "php" ;;
        *.cs)       echo "csharp" ;;
        *.cpp|*.cc) echo "cpp" ;;
        *.rs)       echo "rust" ;;
        *.sh)       echo "bash" ;;
        *)          echo "unknown" ;;
    esac
}

# Validar argumentos
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_help
fi

if [[ -z "$1" ]]; then
    echo -e "${RED}❌ Error: Debe especificar un archivo${NC}"
    echo "Uso: $0 <archivo> [lenguaje]"
    exit 1
fi

# Leer código
FILE="$1"
if [[ "$FILE" == "-" ]]; then
    CODE=$(cat)
    LANGUAGE="${2:-unknown}"
else
    if [[ ! -f "$FILE" ]]; then
        echo -e "${RED}❌ Error: Archivo no encontrado: $FILE${NC}"
        exit 1
    fi
    CODE=$(cat "$FILE")
    LANGUAGE="${2:-$(detect_language "$FILE")}"
fi

echo -e "${BLUE}🔍 Analizando código...${NC}"
echo -e "${YELLOW}Archivo:${NC} $FILE"
echo -e "${YELLOW}Lenguaje:${NC} $LANGUAGE"
echo -e "${YELLOW}Líneas:${NC} $(echo "$CODE" | wc -l)"
echo ""

# Escapar JSON
CODE_JSON=$(echo "$CODE" | jq -Rs .)

# Crear payload
PAYLOAD=$(cat <<EOF
{
  "language": "$LANGUAGE",
  "code": $CODE_JSON
}
EOF
)

# Enviar request
RESPONSE=$(curl -s -X POST "$N8N_URL$WEBHOOK_PATH" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD")

# Verificar respuesta
if [[ -z "$RESPONSE" ]]; then
    echo -e "${RED}❌ Error: No se recibió respuesta del servidor${NC}"
    exit 1
fi

# Parsear respuesta
STATUS=$(echo "$RESPONSE" | jq -r '.status // "error"')

if [[ "$STATUS" != "success" ]]; then
    echo -e "${RED}❌ Error en el análisis${NC}"
    echo "$RESPONSE" | jq .
    exit 1
fi

# Mostrar resultados
REVIEW=$(echo "$RESPONSE" | jq -r '.review // "No review available"')
SEVERITY=$(echo "$RESPONSE" | jq -r '.severity // "unknown"')
TIMESTAMP=$(echo "$RESPONSE" | jq -r '.timestamp // ""')

echo -e "${GREEN}✅ Análisis completado${NC}"
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Color según severidad
case "$SEVERITY" in
    high)     SEVERITY_COLOR="$RED" ;;
    medium)   SEVERITY_COLOR="$YELLOW" ;;
    low)      SEVERITY_COLOR="$GREEN" ;;
    *)        SEVERITY_COLOR="$NC" ;;
esac

echo -e "${YELLOW}Severidad:${NC} ${SEVERITY_COLOR}${SEVERITY}${NC}"
echo -e "${YELLOW}Fecha:${NC} $TIMESTAMP"
echo ""
echo -e "${BLUE}📋 Review:${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "$REVIEW"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
