#!/bin/bash

# Script maestro para automatizar completamente la configuración de n8n
# Importa workflows y credenciales automáticamente

set +e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                                               ║${NC}"
echo -e "${CYAN}║      🚀 SETUP AUTOMÁTICO COMPLETO DE n8n 🚀                 ║${NC}"
echo -e "${CYAN}║                                                               ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar que la API Key esté configurada
API_KEY_FILE="./config/.n8n_api_key"

if [ ! -f "$API_KEY_FILE" ]; then
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}⚠️  API KEY NO ENCONTRADA${NC}"
    echo ""
    echo -e "${YELLOW}Para usar este script, primero necesitas:${NC}"
    echo ""
    echo -e "${BLUE}1. Acceder a n8n:${NC} ${GREEN}http://localhost:5678${NC}"
    echo -e "${BLUE}2. Ir a:${NC} Settings → API"
    echo -e "${BLUE}3. Crear una API Key${NC}"
    echo -e "${BLUE}4. Ejecutar:${NC} ${GREEN}./scripts/auto-import-n8n-workflows.sh \"tu-api-key\"${NC}"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    exit 1
fi

echo -e "${GREEN}✅ API Key encontrada${NC}"
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Paso 1: Importar Workflows
echo -e "${BLUE}📋 PASO 1/2: Importando workflows...${NC}"
echo ""
./scripts/auto-import-n8n-workflows.sh
WORKFLOWS_STATUS=$?
echo ""

# Paso 2: Crear Credenciales
echo -e "${BLUE}🔐 PASO 2/2: Creando credenciales...${NC}"
echo ""
./scripts/auto-import-n8n-credentials.sh
CREDENTIALS_STATUS=$?
echo ""

# Resumen Final
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                                               ║${NC}"
echo -e "${CYAN}║                   📊 RESUMEN FINAL                           ║${NC}"
echo -e "${CYAN}║                                                               ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

if [ $WORKFLOWS_STATUS -eq 0 ]; then
    echo -e "  ${GREEN}✅ Workflows importados exitosamente${NC}"
else
    echo -e "  ${YELLOW}⚠️  Workflows importados con advertencias${NC}"
fi

if [ $CREDENTIALS_STATUS -eq 0 ]; then
    echo -e "  ${GREEN}✅ Credenciales creadas exitosamente${NC}"
else
    echo -e "  ${YELLOW}⚠️  Credenciales creadas con advertencias${NC}"
fi

echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📝 PRÓXIMOS PASOS MANUALES:${NC}"
echo ""
echo -e "${YELLOW}1. Verificar en n8n (${GREEN}http://localhost:5678${YELLOW}):${NC}"
echo -e "   • Settings → Credentials (verificar las 5 credenciales)"
echo -e "   • Workflows (verificar los 5 workflows)"
echo ""
echo -e "${YELLOW}2. Asignar credenciales a workflows:${NC}"
echo -e "   • Abre cada workflow"
echo -e "   • Para cada nodo con ⚠️, asigna la credencial"
echo -e "   • Guarda el workflow"
echo ""
echo -e "${YELLOW}3. Activar workflows:${NC}"
echo -e "   • Usa el toggle de activación en cada workflow"
echo -e "   • Verifica que no haya errores"
echo ""
echo -e "${YELLOW}4. (Opcional) Descargar modelos de Ollama:${NC}"
echo -e "   ${GREEN}docker exec -it ollama ollama pull llama2${NC}"
echo -e "   ${GREEN}docker exec -it ollama ollama pull mistral${NC}"
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ $WORKFLOWS_STATUS -eq 0 ] && [ $CREDENTIALS_STATUS -eq 0 ]; then
    echo -e "${GREEN}✅ ¡CONFIGURACIÓN AUTOMÁTICA COMPLETADA EXITOSAMENTE!${NC}"
    echo ""
    exit 0
else
    echo -e "${YELLOW}⚠️  Configuración completada con algunas advertencias${NC}"
    echo -e "${YELLOW}Revisa los mensajes anteriores para más detalles${NC}"
    echo ""
    exit 1
fi
