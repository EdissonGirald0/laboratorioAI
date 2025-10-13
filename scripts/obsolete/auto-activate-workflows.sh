#!/bin/bash

# Script para activar workflows y asignar credenciales automáticamente en n8n
# Usa la API REST de n8n

set +e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                           ║${NC}"
echo -e "${BLUE}║   ⚡ ACTIVACIÓN AUTOMÁTICA DE WORKFLOWS EN n8n ⚡        ║${NC}"
echo -e "${BLUE}║                                                           ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Configuración
N8N_URL="http://localhost:5678"
N8N_API_BASE="$N8N_URL/api/v1"
API_KEY_FILE="./config/.n8n_api_key"

# Función para verificar si n8n está listo
check_n8n() {
    echo -e "${YELLOW}Verificando que n8n esté disponible...${NC}"
    if curl -s "$N8N_URL/healthz" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ n8n está disponible${NC}"
        return 0
    else
        echo -e "${RED}❌ Error: n8n no está disponible${NC}"
        return 1
    fi
}

# Función para obtener API Key
get_api_key() {
    if [ -f "$API_KEY_FILE" ]; then
        API_KEY=$(cat "$API_KEY_FILE")
        echo -e "${GREEN}✅ Usando API Key guardada${NC}"
        return 0
    else
        echo -e "${RED}❌ Error: No se encontró la API Key${NC}"
        echo -e "${YELLOW}Ejecuta primero: ./scripts/auto-import-n8n-workflows.sh${NC}"
        return 1
    fi
}

# Función para obtener ID de credencial por nombre
get_credential_id() {
    local cred_name="$1"
    local response=$(curl -s -H "X-N8N-API-KEY: $API_KEY" "$N8N_API_BASE/credentials")
    local cred_id=$(echo "$response" | jq -r ".data[] | select(.name == \"$cred_name\") | .id" 2>/dev/null | head -1)
    echo "$cred_id"
}

# Función para listar todos los workflows
list_workflows() {
    local response=$(curl -s -H "X-N8N-API-KEY: $API_KEY" "$N8N_API_BASE/workflows")
    echo "$response" | jq -r '.data[] | "\(.id)|\(.name)|\(.active)"' 2>/dev/null
}

# Función para obtener workflow por nombre
get_workflow_by_name() {
    local workflow_name="$1"
    local response=$(curl -s -H "X-N8N-API-KEY: $API_KEY" "$N8N_API_BASE/workflows")
    echo "$response" | jq -r ".data[] | select(.name == \"$workflow_name\")" 2>/dev/null
}

# Función para actualizar y activar workflow con credenciales
activate_workflow_with_credentials() {
    local workflow_name="$1"
    local postgres_cred_name="$2"
    
    echo -e "${YELLOW}Procesando: $workflow_name${NC}"
    
    # Obtener el workflow completo
    local workflow=$(get_workflow_by_name "$workflow_name")
    
    if [ -z "$workflow" ]; then
        echo -e "${RED}  ❌ Workflow no encontrado${NC}"
        return 1
    fi
    
    local workflow_id=$(echo "$workflow" | jq -r '.id')
    local is_active=$(echo "$workflow" | jq -r '.active')
    
    # Obtener ID de credencial PostgreSQL
    local postgres_cred_id=$(get_credential_id "$postgres_cred_name")
    
    if [ -z "$postgres_cred_id" ] || [ "$postgres_cred_id" = "null" ]; then
        echo -e "${YELLOW}  ⚠️  Credencial PostgreSQL no encontrada, activando sin credenciales${NC}"
        postgres_cred_id=""
    else
        echo -e "${GREEN}  ✓ Credencial PostgreSQL encontrada: $postgres_cred_id${NC}"
    fi
    
    # Actualizar nodos con credenciales
    local updated_workflow=$(echo "$workflow" | jq --arg cred_id "$postgres_cred_id" '
        .nodes |= map(
            if .type == "n8n-nodes-base.postgres" and $cred_id != "" then
                .credentials = {"postgres": {"id": $cred_id, "name": "PostgreSQL Main"}}
            else
                .
            end
        )
    ')
    
    # Activar el workflow
    local final_workflow=$(echo "$updated_workflow" | jq '.active = true')
    
    # Enviar actualización
    local response=$(curl -s -X PUT \
        -H "Content-Type: application/json" \
        -H "X-N8N-API-KEY: $API_KEY" \
        -d "$final_workflow" \
        "$N8N_API_BASE/workflows/$workflow_id" 2>&1)
    
    if echo "$response" | grep -q '"id"'; then
        if [ "$is_active" = "true" ]; then
            echo -e "${GREEN}  ✅ Workflow actualizado (ya estaba activo)${NC}"
        else
            echo -e "${GREEN}  ✅ Workflow activado y actualizado${NC}"
        fi
        return 0
    else
        echo -e "${RED}  ❌ Error al actualizar workflow${NC}"
        echo -e "${RED}     $(echo "$response" | head -c 200)${NC}"
        return 1
    fi
}

# Función principal
main() {
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Verificar que n8n esté disponible
    if ! check_n8n; then
        exit 1
    fi
    
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Obtener API Key
    if ! get_api_key; then
        exit 1
    fi
    
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}⚡ Activando workflows de desarrollo...${NC}"
    echo ""
    
    local activated_count=0
    local error_count=0
    
    # Lista de workflows de desarrollo a activar
    local dev_workflows=(
        "Code Review Assistant"
        "Git Commit Message Generator"
        "Bug Report Analyzer"
        "API Documentation Generator"
        "Test Case Generator"
    )
    
    for workflow_name in "${dev_workflows[@]}"; do
        if activate_workflow_with_credentials "$workflow_name" "PostgreSQL Main"; then
            activated_count=$((activated_count + 1))
        else
            error_count=$((error_count + 1))
        fi
    done
    
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}📊 RESUMEN DE ACTIVACIÓN:${NC}"
    echo ""
    echo -e "  ${GREEN}✅ Workflows activados: $activated_count${NC}"
    if [ $error_count -gt 0 ]; then
        echo -e "  ${RED}❌ Con errores: $error_count${NC}"
    fi
    echo ""
    
    if [ $activated_count -gt 0 ]; then
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BLUE}✅ WORKFLOWS LISTOS PARA USAR${NC}"
        echo ""
        echo -e "${GREEN}Webhooks disponibles:${NC}"
        echo -e "  📝 Code Review:     ${BLUE}$N8N_URL/webhook/code-review${NC}"
        echo -e "  📝 Git Commit:      ${BLUE}$N8N_URL/webhook/git-commit${NC}"
        echo -e "  📝 Bug Report:      ${BLUE}$N8N_URL/webhook/bug-report${NC}"
        echo -e "  📝 API Docs:        ${BLUE}$N8N_URL/webhook/generate-api-docs${NC}"
        echo -e "  📝 Tests:           ${BLUE}$N8N_URL/webhook/generate-tests${NC}"
        echo ""
        echo -e "${GREEN}Prueba los scripts CLI:${NC}"
        echo -e "  ${BLUE}./scripts/dev-tools/code-review.sh README.md${NC}"
        echo -e "  ${BLUE}./scripts/dev-tools/generate-commit.sh${NC}"
        echo ""
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    fi
    
    if [ $error_count -eq 0 ]; then
        echo -e "${GREEN}✅ Todos los workflows activados exitosamente${NC}"
        exit 0
    else
        echo -e "${RED}⚠️  Algunos workflows no se pudieron activar${NC}"
        exit 1
    fi
}

# Ejecutar función principal
main
