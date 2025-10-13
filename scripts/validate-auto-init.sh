#!/bin/bash

# Script de validación de la implementación de inicialización automática

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                           ║${NC}"
echo -e "${BLUE}║    🧪 VALIDACIÓN DE INICIALIZACIÓN AUTOMÁTICA 🧪        ║${NC}"
echo -e "${BLUE}║                                                           ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

ERRORS=0
WARNINGS=0

# Función de verificación
check() {
    local name="$1"
    local command="$2"
    local expected="$3"
    
    echo -e "${YELLOW}Verificando: $name${NC}"
    
    if eval "$command" > /dev/null 2>&1; then
        echo -e "${GREEN}  ✅ OK${NC}"
    else
        echo -e "${RED}  ❌ FALLO${NC}"
        ERRORS=$((ERRORS + 1))
    fi
}

# Función de verificación con contenido
check_content() {
    local name="$1"
    local file="$2"
    
    echo -e "${YELLOW}Verificando: $name${NC}"
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}  ✅ Existe${NC}"
    else
        echo -e "${RED}  ❌ No existe: $file${NC}"
        ERRORS=$((ERRORS + 1))
    fi
}

# Función de verificación de ejecutable
check_executable() {
    local name="$1"
    local file="$2"
    
    echo -e "${YELLOW}Verificando: $name${NC}"
    
    if [ -x "$file" ]; then
        echo -e "${GREEN}  ✅ Ejecutable${NC}"
    else
        echo -e "${RED}  ❌ No ejecutable: $file${NC}"
        ERRORS=$((ERRORS + 1))
    fi
}

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}FASE 1: Verificación de archivos${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

check_content "Makefile" "./Makefile"
check_content "QUICKSTART.md" "./QUICKSTART.md"
check_content "AUTO_INIT_SUMMARY.md" "./AUTO_INIT_SUMMARY.md"
check_content "docker-init-automation.sh" "./scripts/docker-init-automation.sh"
check_content "post-start.sh" "./scripts/post-start.sh"
check_content "AUTO_INITIALIZATION.md" "./docs/AUTO_INITIALIZATION.md"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}FASE 2: Verificación de permisos${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

check_executable "docker-init-automation.sh" "./scripts/docker-init-automation.sh"
check_executable "post-start.sh" "./scripts/post-start.sh"
check_executable "auto-import-n8n-workflows.sh" "./scripts/auto-import-n8n-workflows.sh"
check_executable "auto-import-n8n-credentials.sh" "./scripts/auto-import-n8n-credentials.sh"
check_executable "activate-dev-workflows.sh" "./scripts/activate-dev-workflows.sh"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}FASE 3: Verificación de docker-compose.yml${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${YELLOW}Verificando: Servicio init-automation${NC}"
if grep -q "init-automation:" docker-compose.yml; then
    echo -e "${GREEN}  ✅ Servicio definido${NC}"
else
    echo -e "${RED}  ❌ Servicio no encontrado${NC}"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}FASE 4: Verificación de comandos Makefile${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

MAKE_COMMANDS=(
    "help"
    "start"
    "stop"
    "restart"
    "status"
    "init"
    "reset"
    "logs"
    "health"
)

for cmd in "${MAKE_COMMANDS[@]}"; do
    echo -e "${YELLOW}Verificando: make $cmd${NC}"
    if grep -q "^$cmd:" Makefile; then
        echo -e "${GREEN}  ✅ Definido${NC}"
    else
        echo -e "${RED}  ❌ No definido${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
done

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}FASE 5: Verificación de scripts existentes${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

check_content "auto-import-n8n-workflows.sh" "./scripts/auto-import-n8n-workflows.sh"
check_content "auto-import-n8n-credentials.sh" "./scripts/auto-import-n8n-credentials.sh"
check_content "activate-dev-workflows.sh" "./scripts/activate-dev-workflows.sh"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}FASE 6: Verificación de workflows${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

WORKFLOW_COUNT=$(find ./n8n/workflows -name "*.json" -type f | wc -l)
echo -e "${YELLOW}Workflows encontrados: $WORKFLOW_COUNT${NC}"

if [ "$WORKFLOW_COUNT" -ge 10 ]; then
    echo -e "${GREEN}  ✅ Suficientes workflows${NC}"
else
    echo -e "${YELLOW}  ⚠️  Pocos workflows (esperado: 10+)${NC}"
    WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}FASE 7: Verificación de documentación${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

DOCS=(
    "QUICKSTART.md"
    "AUTO_INIT_SUMMARY.md"
    "docs/AUTO_INITIALIZATION.md"
    "FINAL_IMPLEMENTATION_STATUS.md"
    "OLLAMA_URL_FIX.md"
)

for doc in "${DOCS[@]}"; do
    check_content "Documentación: $doc" "./$doc"
done

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📊 RESUMEN DE VALIDACIÓN${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ VALIDACIÓN EXITOSA - Todo OK${NC}"
    echo -e "${GREEN}   0 errores, 0 advertencias${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  VALIDACIÓN CON ADVERTENCIAS${NC}"
    echo -e "${YELLOW}   0 errores, $WARNINGS advertencias${NC}"
    exit 0
else
    echo -e "${RED}❌ VALIDACIÓN FALLIDA${NC}"
    echo -e "${RED}   $ERRORS errores, $WARNINGS advertencias${NC}"
    exit 1
fi
