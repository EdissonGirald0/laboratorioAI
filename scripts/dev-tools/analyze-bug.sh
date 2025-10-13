#!/bin/bash

# Script para analizar reportes de bugs usando el workflow de n8n
# Uso: ./analyze-bug.sh

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Configuración
N8N_URL="${N8N_URL:-http://localhost:5678}"
WEBHOOK_PATH="/webhook/bug-report"

# Función de ayuda
show_help() {
    cat << EOF
${BLUE}Bug Report Analyzer${NC}

Analiza reportes de bugs y proporciona análisis detallado con priorización.

${YELLOW}Uso:${NC}
    $0 [opciones]

${YELLOW}Opciones:${NC}
    -h, --help      Mostrar ayuda
    -i, --input     Archivo JSON con el reporte (opcional)

${YELLOW}Ejemplo:${NC}
    $0                      # Modo interactivo
    $0 -i bug-report.json   # Desde archivo

${YELLOW}Variables de entorno:${NC}
    N8N_URL     - URL del servidor n8n (default: http://localhost:5678)

${YELLOW}Formato JSON:${NC}
{
  "title": "Título del bug",
  "description": "Descripción detallada",
  "steps": "Pasos para reproducir",
  "expected": "Comportamiento esperado",
  "actual": "Comportamiento actual",
  "stackTrace": "Stack trace (opcional)"
}

EOF
    exit 0
}

# Función para modo interactivo
interactive_mode() {
    echo -e "${BLUE}🐛 Bug Report Analyzer - Modo Interactivo${NC}"
    echo ""
    
    # Título
    echo -e "${YELLOW}Título del bug:${NC}"
    read -r TITLE
    
    # Descripción
    echo -e "${YELLOW}Descripción (Ctrl+D para terminar):${NC}"
    DESCRIPTION=$(cat)
    
    # Pasos para reproducir
    echo -e "${YELLOW}Pasos para reproducir (Ctrl+D para terminar):${NC}"
    STEPS=$(cat)
    
    # Comportamiento esperado
    echo -e "${YELLOW}Comportamiento esperado:${NC}"
    read -r EXPECTED
    
    # Comportamiento actual
    echo -e "${YELLOW}Comportamiento actual:${NC}"
    read -r ACTUAL
    
    # Stack trace (opcional)
    echo -e "${YELLOW}Stack trace (opcional, Enter para omitir):${NC}"
    read -r STACK_TRACE
    
    # Crear JSON
    cat <<EOF
{
  "title": $(echo "$TITLE" | jq -Rs .),
  "description": $(echo "$DESCRIPTION" | jq -Rs .),
  "steps": $(echo "$STEPS" | jq -Rs .),
  "expected": $(echo "$EXPECTED" | jq -Rs .),
  "actual": $(echo "$ACTUAL" | jq -Rs .),
  "stackTrace": $(echo "$STACK_TRACE" | jq -Rs .)
}
EOF
}

# Parsear argumentos
INPUT_FILE=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            ;;
        -i|--input)
            INPUT_FILE="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}❌ Error: Opción desconocida: $1${NC}"
            exit 1
            ;;
    esac
done

# Obtener payload
if [[ -n "$INPUT_FILE" ]]; then
    if [[ ! -f "$INPUT_FILE" ]]; then
        echo -e "${RED}❌ Error: Archivo no encontrado: $INPUT_FILE${NC}"
        exit 1
    fi
    PAYLOAD=$(cat "$INPUT_FILE")
else
    PAYLOAD=$(interactive_mode)
fi

echo ""
echo -e "${BLUE}🔍 Analizando bug...${NC}"

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
TITLE=$(echo "$RESPONSE" | jq -r '.title // ""')
ANALYSIS=$(echo "$RESPONSE" | jq -r '.analysis // ""')
SEVERITY=$(echo "$RESPONSE" | jq -r '.severity // ""')
CATEGORY=$(echo "$RESPONSE" | jq -r '.category // ""')
ESTIMATED_HOURS=$(echo "$RESPONSE" | jq -r '.estimatedHours // 0')
PRIORITY=$(echo "$RESPONSE" | jq -r '.priority // ""')
SCORE=$(echo "$RESPONSE" | jq -r '.score // 0')

if [[ -z "$ANALYSIS" ]]; then
    echo -e "${RED}❌ Error en el análisis${NC}"
    echo "$RESPONSE" | jq .
    exit 1
fi

# Color según severidad
case "$SEVERITY" in
    crítico)  SEVERITY_COLOR="$RED" ;;
    alto)     SEVERITY_COLOR="$YELLOW" ;;
    medio)    SEVERITY_COLOR="$BLUE" ;;
    bajo)     SEVERITY_COLOR="$GREEN" ;;
    *)        SEVERITY_COLOR="$NC" ;;
esac

# Mostrar resultados
echo -e "${GREEN}✅ Análisis completado${NC}"
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Título:${NC} $TITLE"
echo -e "${BLUE}Severidad:${NC} ${SEVERITY_COLOR}${SEVERITY}${NC} (Score: $SCORE)"
echo -e "${BLUE}Categoría:${NC} $CATEGORY"
echo -e "${BLUE}Prioridad:${NC} $PRIORITY"
echo -e "${BLUE}Tiempo estimado:${NC} $ESTIMATED_HOURS horas"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}📋 Análisis Detallado:${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "$ANALYSIS"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Alerta para bugs críticos
if [[ "$SEVERITY" == "crítico" ]] || [[ "$SEVERITY" == "alto" ]]; then
    echo ""
    echo -e "${RED}⚠️  ALERTA: Bug de prioridad ${SEVERITY}${NC}"
    echo -e "${RED}Este bug requiere atención inmediata${NC}"
fi
