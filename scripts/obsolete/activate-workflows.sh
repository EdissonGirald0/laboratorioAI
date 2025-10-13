#!/bin/bash

# Script para activar workflows en n8n
# Este script usa la API de n8n para activar todos los workflows

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

N8N_URL="${N8N_URL:-http://localhost:5678}"
N8N_API_KEY="${N8N_API_KEY:-}"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}   🔧 Activación de Workflows en n8n${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Esperar a que n8n esté disponible
echo -e "${YELLOW}Esperando que n8n esté disponible...${NC}"
MAX_ATTEMPTS=30
ATTEMPT=1

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    if curl -s "$N8N_URL" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ n8n está disponible${NC}"
        break
    fi
    echo -ne "${YELLOW}⏳ Intento $ATTEMPT/$MAX_ATTEMPTS\r${NC}"
    sleep 2
    ((ATTEMPT++))
done

if [ $ATTEMPT -gt $MAX_ATTEMPTS ]; then
    echo -e "${RED}❌ n8n no está disponible${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}📝 Para activar los workflows:${NC}"
echo ""
echo -e "1. Accede a n8n: ${BLUE}$N8N_URL${NC}"
echo -e "2. Ve a la sección ${BLUE}Workflows${NC}"
echo -e "3. Activa cada workflow usando el toggle:"
echo ""
echo -e "   ${GREEN}Workflows a activar:${NC}"
echo -e "   • code-review-assistant"
echo -e "   • git-commit-generator"
echo -e "   • bug-report-analyzer"
echo -e "   • api-documentation-generator"
echo -e "   • test-case-generator"
echo ""
echo -e "${YELLOW}4. También necesitas configurar las credenciales de PostgreSQL:${NC}"
echo ""
echo -e "   En n8n, ve a ${BLUE}Credentials${NC} → ${BLUE}New${NC} → ${BLUE}Postgres${NC}"
echo -e "   Usa estos valores:"
echo -e "   • Host: ${BLUE}postgres${NC}"
echo -e "   • Port: ${BLUE}5432${NC}"
echo -e "   • Database: ${BLUE}ailab${NC}"
echo -e "   • User: ${BLUE}aiadmin${NC}"
echo -e "   • Password: ${BLUE}(ver archivo .env)${NC}"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}💡 Consejo:${NC}"
echo -e "Abre el navegador en: ${BLUE}$N8N_URL${NC}"
xdg-open "$N8N_URL" 2>/dev/null || open "$N8N_URL" 2>/dev/null || echo -e "${YELLOW}Abre manualmente: $N8N_URL${NC}"
