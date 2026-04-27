#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

N8N_URL="http://localhost:5678"
API_KEY_FILE="./config/.n8n_api_key"

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   🤖 SETUP COMPLETO n8n — WORKFLOWS + CREDENCIALES 🤖  ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Fase 0: API Key (si no existe, guiar al usuario)
if [ ! -f "$API_KEY_FILE" ]; then
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}  ⚠️  PRIMER USO: NECESITAS CREAR UNA API KEY EN n8n      ${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "  Sigue estos pasos (solo la primera vez):"
    echo ""
    echo -e "  ${BLUE}1.${NC} Abre ${GREEN}http://localhost:5678${NC}"
    echo -e "  ${BLUE}2.${NC} Crea tu cuenta de administrador"
    echo -e "  ${BLUE}3.${NC} Ve a Settings → API → Create API Key"
    echo -e "  ${BLUE}4.${NC} Copia la API Key generada"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    read -rp "$(echo -e ${GREEN}Pega tu API Key: ${NC})" API_KEY_INPUT
    
    if [ -z "$API_KEY_INPUT" ]; then
        echo -e "${RED}No se ingresó API Key. Abortando.${NC}"
        echo ""
        echo "Ejecuta este script de nuevo cuando tengas la API Key:"
        echo -e "  ${GREEN}./scripts/setup-n8n-complete.sh${NC}"
        exit 1
    fi
    
    mkdir -p ./config
    echo "$API_KEY_INPUT" > "$API_KEY_FILE"
    chmod 600 "$API_KEY_FILE"
    echo -e "${GREEN}✓ API Key guardada en $API_KEY_FILE${NC}"
    echo ""
else
    echo -e "${GREEN}✓ API Key encontrada${NC}"
fi

API_KEY=$(cat "$API_KEY_FILE")
FAILED=0

# Fase 1: Esperar n8n
echo ""
echo -e "${YELLOW}[1/5] Verificando conexión con n8n...${NC}"
for i in $(seq 1 60); do
    if curl -s "$N8N_URL/healthz" > /dev/null 2>&1; then
        echo -e "${GREEN}  ✓ n8n respondiendo${NC}"
        break
    fi
    [ $i -eq 60 ] && echo -e "${RED}  ✗ n8n no disponible${NC}" && exit 1
    sleep 2
done

# Fase 2: Corregir URLs
echo ""
echo -e "${YELLOW}[2/5] Verificando URLs en workflows...${NC}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/fix-ollama-url.sh" ]; then
    "$SCRIPT_DIR/fix-ollama-url.sh" 2>/dev/null && echo -e "${GREEN}  ✓ URLs verificadas${NC}" || echo -e "${YELLOW}  ⚠ Sin cambios${NC}"
fi

# Fase 3: Importar workflows
echo ""
echo -e "${YELLOW}[3/5] Importando workflows a n8n...${NC}"
if [ -f "$SCRIPT_DIR/auto-import-n8n-workflows.sh" ]; then
    "$SCRIPT_DIR/auto-import-n8n-workflows.sh" 2>&1 | tail -8
    RET=${PIPESTATUS[0]}
    if [ $RET -ne 0 ] && [ $RET -ne 1 ]; then
        echo -e "${RED}  ✗ Error importando workflows${NC}"
        FAILED=1
    fi
else
    echo -e "${RED}  ✗ Script auto-import-n8n-workflows.sh no encontrado${NC}"
    FAILED=1
fi

# Fase 4: Crear credenciales
echo ""
echo -e "${YELLOW}[4/5] Creando credenciales en n8n...${NC}"
if [ -f "$SCRIPT_DIR/auto-import-n8n-credentials.sh" ]; then
    "$SCRIPT_DIR/auto-import-n8n-credentials.sh" 2>&1 | tail -8
    RET=${PIPESTATUS[0]}
    if [ $RET -ne 0 ] && [ $RET -ne 1 ]; then
        echo -e "${RED}  ✗ Error creando credenciales${NC}"
        FAILED=1
    fi
else
    echo -e "${RED}  ✗ Script auto-import-n8n-credentials.sh no encontrado${NC}"
    FAILED=1
fi

# Fase 5: Activar workflows
echo ""
echo -e "${YELLOW}[5/5] Activando workflows de desarrollo...${NC}"
if [ -f "$SCRIPT_DIR/activate-dev-workflows.sh" ]; then
    "$SCRIPT_DIR/activate-dev-workflows.sh" 2>&1 | tail -5
fi

# Resumen
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ SETUP n8n COMPLETADO EXITOSAMENTE${NC}"
else
    echo -e "${YELLOW}⚠️  SETUP COMPLETADO CON ADVERTENCIAS${NC}"
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}🌐 Accesos:${NC}"
echo -e "   n8n:     ${GREEN}http://localhost:5678${NC}"
echo -e "   Flowise: ${GREEN}http://localhost:3000${NC}"
echo -e "   Ollama:  ${GREEN}http://localhost:11434${NC}"
echo ""
echo -e "${BLUE}🔗 Webhooks activos:${NC}"
echo -e "   ${GREEN}http://localhost:5678/webhook/code-review${NC}"
echo -e "   ${GREEN}http://localhost:5678/webhook/git-commit${NC}"
echo -e "   ${GREEN}http://localhost:5678/webhook/bug-report${NC}"

exit $FAILED
