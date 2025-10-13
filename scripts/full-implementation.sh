#!/bin/bash

# Script maestro para implementación completa de LaboratorioAI Dev Workflows

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                           ║${NC}"
echo -e "${BLUE}║   🚀 IMPLEMENTACIÓN COMPLETA - LABORATORIO AI 🚀        ║${NC}"
echo -e "${BLUE}║                                                           ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}Este script va a:${NC}"
echo -e "  1. Importar workflows automáticamente vía API"
echo -e "  2. Crear credenciales en n8n"
echo -e "  3. Activar workflows de desarrollo"
echo -e "  4. Verificar que todo funcione"
echo ""

read -p "$(echo -e ${BLUE}¿Continuar? [y/N]: ${NC})" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Implementación cancelada${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}[1/4] Importando workflows...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

./scripts/auto-import-n8n-workflows.sh

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}[2/4] Creando credenciales...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

./scripts/auto-import-n8n-credentials.sh

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}[3/4] Activando workflows de desarrollo...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

./scripts/activate-dev-workflows.sh

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}[4/4] Verificando implementación...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${YELLOW}Verificando servicios...${NC}"
docker compose ps | grep -E "postgres|n8n|ollama" | grep -E "healthy|Up"

echo ""
echo -e "${YELLOW}Verificando workflows activos...${NC}"
API_KEY=$(cat ./config/.n8n_api_key)
ACTIVE_COUNT=$(curl -s -H "X-N8N-API-KEY: $API_KEY" "http://localhost:5678/api/v1/workflows" | jq '[.data[] | select(.active == true)] | length')
echo -e "Workflows activos: ${GREEN}$ACTIVE_COUNT${NC}"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}   ✅ IMPLEMENTACIÓN COMPLETADA AL 100%${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${BLUE}🎯 Todo listo para usar:${NC}"
echo ""
echo -e "${YELLOW}Webhooks disponibles:${NC}"
echo -e "  📝 ${BLUE}http://localhost:5678/webhook/code-review${NC}"
echo -e "  📝 ${BLUE}http://localhost:5678/webhook/git-commit${NC}"
echo -e "  📝 ${BLUE}http://localhost:5678/webhook/bug-report${NC}"
echo -e "  📝 ${BLUE}http://localhost:5678/webhook/generate-api-docs${NC}"
echo -e "  📝 ${BLUE}http://localhost:5678/webhook/generate-tests${NC}"
echo ""

echo -e "${YELLOW}Scripts CLI:${NC}"
echo -e "  🔧 ${BLUE}./scripts/dev-tools/code-review.sh <archivo>${NC}"
echo -e "  🔧 ${BLUE}./scripts/dev-tools/generate-commit.sh${NC}"
echo -e "  🔧 ${BLUE}./scripts/dev-tools/analyze-bug.sh${NC}"
echo -e "  🔧 ${BLUE}./scripts/dev-tools/generate-tests.sh <archivo>${NC}"
echo ""

echo -e "${GREEN}¡Comienza a automatizar tu desarrollo! 🎉${NC}"
