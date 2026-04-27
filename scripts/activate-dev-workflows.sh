#!/bin/bash
set +e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      ⚡ ACTIVACIÓN DE WORKFLOWS — n8n ⚡                 ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

N8N_URL="http://localhost:5678"
N8N_API_BASE="$N8N_URL/api/v1"
API_KEY=$(cat ./config/.n8n_api_key 2>/dev/null)

if [ -z "$API_KEY" ]; then
    echo -e "${RED}❌ No se encontró API Key${NC}"
    echo "Ejecuta primero: ./scripts/setup-n8n-complete.sh"
    exit 1
fi

activate_workflow() {
    local workflow_id="$1"
    local workflow_name="$2"
    echo -e "${YELLOW}Activando: $workflow_name${NC}"
    local response=$(curl -s -X POST \
        -H "X-N8N-API-KEY: $API_KEY" \
        "$N8N_API_BASE/workflows/$workflow_id/activate" 2>&1)
    if echo "$response" | grep -q '"active":true'; then
        echo -e "${GREEN}  ✅ Activado${NC}"
        return 0
    else
        echo -e "${RED}  ❌ Error${NC}"
        return 1
    fi
}

workflows=$(curl -s -H "X-N8N-API-KEY: $API_KEY" "$N8N_API_BASE/workflows")

dev_workflow_names=(
    "Revisor de Código"
    "Generador de Commits Git"
    "Analizador de Bugs"
    "Generador de Documentación API"
    "Generador de Pruebas"
    "Chatbot con Memoria"
    "Procesador de Documentos"
    "Automatización de Documentos"
    "Sistema de Consultas Inteligentes"
    "Análisis de Sentimientos"
    "Monitoreo de Salud del Sistema"
)

activados=0
errores=0

for name in "${dev_workflow_names[@]}"; do
    id=$(echo "$workflows" | jq -r ".data[] | select(.name == \"$name\") | .id" 2>/dev/null | head -1)
    if [ -n "$id" ] && [ "$id" != "null" ]; then
        if activate_workflow "$id" "$name"; then
            activados=$((activados + 1))
        else
            errores=$((errores + 1))
        fi
    else
        echo -e "${YELLOW}⚠️  No encontrado: $name${NC}"
        errores=$((errores + 1))
    fi
done

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Activados: $activados  ❌ Errores: $errores${NC}"
echo ""
echo -e "${BLUE}🔗 Webhooks disponibles:${NC}"
echo -e "  ${GREEN}http://localhost:5678/webhook/code-review${NC}       → Revisor de Código"
echo -e "  ${GREEN}http://localhost:5678/webhook/git-commit${NC}        → Generador de Commits"
echo -e "  ${GREEN}http://localhost:5678/webhook/bug-report${NC}        → Analizador de Bugs"
echo -e "  ${GREEN}http://localhost:5678/webhook/generate-api-docs${NC} → Documentación API"
echo -e "  ${GREEN}http://localhost:5678/webhook/generate-tests${NC}    → Generador de Pruebas"
echo -e "  ${GREEN}http://localhost:5678/webhook/chat${NC}              → Chatbot con Memoria"
echo -e "  ${GREEN}http://localhost:5678/webhook/process-document${NC}  → Procesador de Docs"
echo -e "  ${GREEN}http://localhost:5678/webhook/sentiment${NC}         → Análisis de Sentimientos"
echo -e "  ${GREEN}http://localhost:5678/webhook/query${NC}             → Consultas Inteligentes"
echo -e "  ${GREEN}http://localhost:5678/webhook/health-check${NC}      → Salud del Sistema"

exit $errores
