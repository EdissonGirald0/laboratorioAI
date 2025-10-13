#!/bin/bash

# Script para corregir la URL de Ollama en workflows de n8n

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   🔧 CORRECCIÓN URL DE OLLAMA EN WORKFLOWS              ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Buscar y corregir URLs incorrectas en workflows
WORKFLOWS_DIR="./n8n/workflows"
FIXED=0
TOTAL=0

for workflow in "$WORKFLOWS_DIR"/*.json; do
    [ -f "$workflow" ] || continue
    TOTAL=$((TOTAL + 1))
    
    # Verificar si contiene URL incorrecta de Ollama
    if grep -q "host.docker.internal:11434/api" "$workflow" 2>/dev/null; then
        echo -e "${YELLOW}Corrigiendo: $(basename "$workflow")${NC}"
        
        # Hacer backup
        cp "$workflow" "$workflow.bak"
        
        # Corregir la URL (remover /api del final)
        sed -i 's|http://host.docker.internal:11434/api|http://host.docker.internal:11434|g' "$workflow"
        
        echo -e "${GREEN}  ✅ Corregido${NC}"
        FIXED=$((FIXED + 1))
    fi
done

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Archivos revisados: $TOTAL${NC}"
echo -e "${GREEN}✅ Archivos corregidos: $FIXED${NC}"
echo ""

if [ $FIXED -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Ahora debes reimportar los workflows:${NC}"
    echo -e "${BLUE}   ./scripts/auto-import-n8n-workflows.sh${NC}"
fi

