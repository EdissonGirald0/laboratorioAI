#!/bin/bash

# Script de verificación rápida del estado del sistema
# Ejecuta todas las pruebas principales y muestra un resumen

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}║     🔍 VERIFICACIÓN DEL SISTEMA LABORATORIOAI 🔍          ║${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Función para verificar servicio
check_service() {
    local service=$1
    local port=$2
    local name=$3
    
    if docker compose ps $service 2>/dev/null | grep -q "Up"; then
        echo -e "${GREEN}✅${NC} $name (puerto $port)"
        return 0
    else
        echo -e "${RED}❌${NC} $name (puerto $port)"
        return 1
    fi
}

# Función para verificar API
check_api() {
    local url=$1
    local name=$2
    
    if curl -s -f -o /dev/null "$url" 2>/dev/null; then
        echo -e "${GREEN}✅${NC} $name API"
        return 0
    else
        echo -e "${RED}❌${NC} $name API"
        return 1
    fi
}

# 1. Verificar contenedores Docker
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🐳 Estado de Contenedores Docker${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

services_ok=0
services_total=8

check_service "n8n" "5678" "n8n Automation" && ((services_ok++)) || true
check_service "postgres" "5432" "PostgreSQL" && ((services_ok++)) || true
check_service "redis" "6379" "Redis" && ((services_ok++)) || true
check_service "ollama" "11434" "Ollama AI" && ((services_ok++)) || true
check_service "openwebui" "8080" "OpenWebUI" && ((services_ok++)) || true
check_service "qdrant" "6333" "Qdrant Vector DB" && ((services_ok++)) || true
check_service "floowise" "3000" "Flowise" && ((services_ok++)) || true
check_service "dev" "-" "Dev Container" && ((services_ok++)) || true

echo ""
echo -e "${BLUE}Servicios operacionales: ${GREEN}$services_ok/$services_total${NC}"
echo ""

# 2. Verificar APIs
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🌐 Estado de APIs${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

apis_ok=0
apis_total=5

check_api "http://localhost:5678" "n8n" && ((apis_ok++)) || true
check_api "http://localhost:11434/api/tags" "Ollama" && ((apis_ok++)) || true
check_api "http://localhost:8080" "OpenWebUI" && ((apis_ok++)) || true
check_api "http://localhost:6333/collections" "Qdrant" && ((apis_ok++)) || true
check_api "http://localhost:3000" "Flowise" && ((apis_ok++)) || true

echo ""
echo -e "${BLUE}APIs funcionales: ${GREEN}$apis_ok/$apis_total${NC}"
echo ""

# 3. Verificar workflows n8n
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🔄 Workflows de n8n${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ -f ./config/.n8n_api_key ]; then
    API_KEY=$(cat ./config/.n8n_api_key)
    workflows_total=$(curl -s -H "X-N8N-API-KEY: $API_KEY" "http://localhost:5678/api/v1/workflows?limit=100" | jq -r '.data | length' 2>/dev/null || echo "0")
    workflows_active=$(curl -s -H "X-N8N-API-KEY: $API_KEY" "http://localhost:5678/api/v1/workflows?limit=100" | jq -r '.data[] | select(.active == true) | .name' 2>/dev/null | wc -l)
    
    echo -e "${BLUE}Total de workflows: ${GREEN}$workflows_total${NC}"
    echo -e "${BLUE}Workflows activos: ${GREEN}$workflows_active${NC}"
    echo ""
    
    echo -e "${BLUE}Workflows activos:${NC}"
    curl -s -H "X-N8N-API-KEY: $API_KEY" "http://localhost:5678/api/v1/workflows?limit=100" | \
        jq -r '.data[] | select(.active == true) | "  ✅ \(.name)"' 2>/dev/null || echo "  Error al listar workflows"
else
    echo -e "${RED}❌ API Key de n8n no encontrada${NC}"
fi

echo ""

# 4. Verificar modelos de Ollama
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🤖 Modelos de IA (Ollama)${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

models_count=$(curl -s http://localhost:11434/api/tags | jq -r '.models | length' 2>/dev/null || echo "0")
echo -e "${BLUE}Modelos instalados: ${GREEN}$models_count${NC}"
echo ""

if [ "$models_count" -gt 0 ]; then
    curl -s http://localhost:11434/api/tags | jq -r '.models[] | "  🧠 \(.name) (\(.details.parameter_size))"' 2>/dev/null
fi

echo ""

# 5. Test rápido de generación con Ollama
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🧪 Prueba de Generación de IA${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${BLUE}Probando generación con Ollama...${NC}"
response=$(curl -s http://localhost:11434/api/generate -d '{
  "model": "codellama:latest",
  "prompt": "Write just the word Hello in one line",
  "stream": false
}' 2>/dev/null | jq -r '.response' 2>/dev/null || echo "Error")

if [ "$response" != "Error" ] && [ -n "$response" ]; then
    echo -e "${GREEN}✅ Ollama respondió correctamente${NC}"
    echo -e "${BLUE}Respuesta: ${NC}$response"
else
    echo -e "${RED}❌ Error en la generación${NC}"
fi

echo ""

# 6. Resumen final
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📊 RESUMEN FINAL${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

total_checks=$((services_ok + apis_ok))
max_checks=$((services_total + apis_total))
percentage=$((total_checks * 100 / max_checks))

echo -e "${BLUE}Servicios Docker:${NC} ${GREEN}$services_ok/$services_total${NC}"
echo -e "${BLUE}APIs funcionales:${NC} ${GREEN}$apis_ok/$apis_total${NC}"
echo -e "${BLUE}Workflows totales:${NC} ${GREEN}$workflows_total${NC}"
echo -e "${BLUE}Workflows activos:${NC} ${GREEN}$workflows_active${NC}"
echo -e "${BLUE}Modelos de IA:${NC} ${GREEN}$models_count${NC}"
echo ""

if [ $percentage -ge 90 ]; then
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}║   ✅ SISTEMA OPERACIONAL - Estado: EXCELENTE (${percentage}%)     ║${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
elif [ $percentage -ge 70 ]; then
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║                                                           ║${NC}"
    echo -e "${YELLOW}║   ⚠️  SISTEMA OPERACIONAL - Estado: ACEPTABLE (${percentage}%)    ║${NC}"
    echo -e "${YELLOW}║                                                           ║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════╝${NC}"
else
    echo -e "${RED}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                                                           ║${NC}"
    echo -e "${RED}║   ❌ SISTEMA CON PROBLEMAS - Estado: CRÍTICO (${percentage}%)     ║${NC}"
    echo -e "${RED}║                                                           ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════════╝${NC}"
fi

echo ""
echo -e "${BLUE}📄 Para más detalles, consulta:${NC}"
echo -e "   ${GREEN}./docs/REPORTE_PRUEBAS_AUTOMATIZACION.md${NC}"
echo ""
echo -e "${BLUE}🔗 Servicios disponibles:${NC}"
echo -e "   • n8n: ${GREEN}http://localhost:5678${NC}"
echo -e "   • OpenWebUI: ${GREEN}http://localhost:8080${NC}"
echo -e "   • Flowise: ${GREEN}http://localhost:3000${NC}"
echo -e "   • Qdrant: ${GREEN}http://localhost:6333${NC}"
echo ""

# Salir con código apropiado
if [ $percentage -ge 70 ]; then
    exit 0
else
    exit 1
fi
