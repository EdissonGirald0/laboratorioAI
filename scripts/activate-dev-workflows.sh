#!/bin/bash

# Script simple para activar workflows en n8n vía API

set +e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      ⚡ ACTIVACIÓN DE WORKFLOWS - MÉTODO SIMPLE ⚡       ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

N8N_URL="http://localhost:5678"
N8N_API_BASE="$N8N_URL/api/v1"
API_KEY=$(cat ./config/.n8n_api_key 2>/dev/null)

if [ -z "$API_KEY" ]; then
    echo -e "${RED}❌ No se encontró API Key${NC}"
    exit 1
fi

echo -e "${GREEN}✅ API Key encontrada${NC}"
echo ""

# Activar workflow por ID usando el endpoint correcto
activate_workflow() {
    local workflow_id="$1"
    local workflow_name="$2"
    
    echo -e "${YELLOW}Activando: $workflow_name${NC}"
    
    # Usar el endpoint específico de activación: POST /workflows/{id}/activate
    local response=$(curl -s -X POST \
        -H "X-N8N-API-KEY: $API_KEY" \
        "$N8N_API_BASE/workflows/$workflow_id/activate" 2>&1)
    
    if echo "$response" | jq -e '.active == true' > /dev/null 2>&1; then
        echo -e "${GREEN}  ✅ Activado exitosamente${NC}"
        return 0
    else
        local error_msg=$(echo "$response" | jq -r '.message' 2>/dev/null || echo "Unknown")
        echo -e "${RED}  ❌ Error: $error_msg${NC}"
        return 1
    fi
}

echo -e "${BLUE}📋 Obteniendo workflows...${NC}"
echo ""

# Obtener todos los workflows
workflows=$(curl -s -H "X-N8N-API-KEY: $API_KEY" "$N8N_API_BASE/workflows")

# Workflows de desarrollo
dev_workflow_names=(
    "Code Review Assistant"
    "Git Commit Message Generator"
    "Bug Report Analyzer"
    "API Documentation Generator"
    "Test Case Generator"
)

activated=0
errors=0

for name in "${dev_workflow_names[@]}"; do
    # Buscar el ID del workflow
    id=$(echo "$workflows" | jq -r ".data[] | select(.name == \"$name\") | .id" | head -1)
    
    if [ -n "$id" ] && [ "$id" != "null" ]; then
        if activate_workflow "$id" "$name"; then
            activated=$((activated + 1))
        else
            errors=$((errors + 1))
        fi
    else
        echo -e "${YELLOW}⚠️  No encontrado: $name${NC}"
        errors=$((errors + 1))
    fi
done

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}📊 RESUMEN:${NC}"
echo -e "  ✅ Activados: $activated"
echo -e "  ❌ Errores: $errors"
echo ""

if [ $activated -gt 0 ]; then
    echo -e "${GREEN}✅ Webhooks disponibles en:${NC}"
    echo -e "  ${BLUE}http://localhost:5678/webhook/code-review${NC}"
    echo -e "  ${BLUE}http://localhost:5678/webhook/git-commit${NC}"
    echo -e "  ${BLUE}http://localhost:5678/webhook/bug-report${NC}"
    echo -e "  ${BLUE}http://localhost:5678/webhook/generate-api-docs${NC}"
    echo -e "  ${BLUE}http://localhost:5678/webhook/generate-tests${NC}"
    echo ""
    echo -e "${YELLOW}Prueba con:${NC}"
    echo -e "  ${BLUE}./scripts/dev-tools/code-review.sh README.md${NC}"
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

exit $errors
