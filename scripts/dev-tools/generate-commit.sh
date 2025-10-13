#!/bin/bash

# Script para generar mensajes de commit usando el workflow de n8n
# Uso: ./generate-commit.sh [archivo1 archivo2 ...]

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Configuración
N8N_URL="${N8N_URL:-http://localhost:5678}"
WEBHOOK_PATH="/webhook/git-commit"

# Función de ayuda
show_help() {
    cat << EOF
${BLUE}Git Commit Message Generator${NC}

Genera mensajes de commit convencionales a partir de cambios de git.

${YELLOW}Uso:${NC}
    $0 [archivos...]

${YELLOW}Argumentos:${NC}
    archivos    - Archivos específicos para incluir (opcional)
                  Si no se especifica, usa todos los cambios staged

${YELLOW}Ejemplos:${NC}
    $0                          # Todos los cambios staged
    $0 src/api/users.js         # Solo un archivo
    $0 src/*.js                 # Múltiples archivos

${YELLOW}Variables de entorno:${NC}
    N8N_URL     - URL del servidor n8n (default: http://localhost:5678)

${YELLOW}Características:${NC}
    - Formato de Conventional Commits
    - Detección automática de tipo (feat, fix, docs, etc.)
    - Scope automático
    - Detección de breaking changes
    - Cuerpo del mensaje con detalles

EOF
    exit 0
}

# Validar que estamos en un repositorio git
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: No estás en un repositorio git${NC}"
    exit 1
fi

# Validar argumentos
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_help
fi

# Obtener diff
echo -e "${BLUE}📊 Obteniendo cambios...${NC}"

if [[ $# -gt 0 ]]; then
    # Archivos específicos
    DIFF=$(git diff --staged "$@" 2>/dev/null || git diff "$@")
    FILES="$*"
else
    # Todos los cambios staged
    DIFF=$(git diff --staged 2>/dev/null)
    if [[ -z "$DIFF" ]]; then
        # Si no hay cambios staged, usar todos los cambios
        DIFF=$(git diff 2>/dev/null)
        if [[ -z "$DIFF" ]]; then
            echo -e "${RED}❌ Error: No hay cambios para commitear${NC}"
            exit 1
        fi
        echo -e "${YELLOW}⚠️  No hay cambios staged, usando cambios sin stage${NC}"
    fi
    FILES="todos los archivos"
fi

echo -e "${YELLOW}Archivos:${NC} $FILES"
echo -e "${YELLOW}Líneas cambiadas:${NC} $(echo "$DIFF" | wc -l)"
echo ""

# Escapar JSON
DIFF_JSON=$(echo "$DIFF" | jq -Rs .)

# Crear payload
PAYLOAD=$(cat <<EOF
{
  "diff": $DIFF_JSON
}
EOF
)

echo -e "${BLUE}🤖 Generando mensaje de commit...${NC}"

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
COMMIT_MSG=$(echo "$RESPONSE" | jq -r '.commitMessage // ""')

if [[ -z "$COMMIT_MSG" ]]; then
    echo -e "${RED}❌ Error al generar mensaje${NC}"
    echo "$RESPONSE" | jq .
    exit 1
fi

# Extraer componentes
TYPE=$(echo "$RESPONSE" | jq -r '.type // ""')
SCOPE=$(echo "$RESPONSE" | jq -r '.scope // ""')
DESCRIPTION=$(echo "$RESPONSE" | jq -r '.description // ""')
HAS_BREAKING=$(echo "$RESPONSE" | jq -r '.hasBreakingChanges // false')

echo -e "${GREEN}✅ Mensaje generado${NC}"
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Tipo:${NC} $TYPE"
if [[ -n "$SCOPE" && "$SCOPE" != "null" ]]; then
    echo -e "${BLUE}Scope:${NC} $SCOPE"
fi
echo -e "${BLUE}Descripción:${NC} $DESCRIPTION"
echo -e "${BLUE}Breaking Changes:${NC} $([ "$HAS_BREAKING" == "true" ] && echo "${RED}SÍ${NC}" || echo "No")"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}📝 Mensaje completo:${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "$COMMIT_MSG"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Preguntar si desea usar el mensaje
read -p "$(echo -e "${BLUE}¿Deseas usar este mensaje para el commit? [y/N]:${NC} ")" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Guardar mensaje en archivo temporal
    TEMP_FILE=$(mktemp)
    echo "$COMMIT_MSG" > "$TEMP_FILE"
    
    # Hacer commit
    if git commit -F "$TEMP_FILE"; then
        echo -e "${GREEN}✅ Commit realizado exitosamente${NC}"
    else
        echo -e "${RED}❌ Error al realizar commit${NC}"
        rm -f "$TEMP_FILE"
        exit 1
    fi
    
    # Limpiar
    rm -f "$TEMP_FILE"
else
    echo -e "${YELLOW}ℹ️  Commit cancelado${NC}"
    echo -e "Puedes copiar el mensaje manualmente para usarlo después"
fi
