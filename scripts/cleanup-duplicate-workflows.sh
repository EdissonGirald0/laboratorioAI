#!/bin/bash

# Script para limpiar workflows duplicados en n8n
# Elimina duplicados y deja solo una instancia de cada workflow

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                           ║${NC}"
echo -e "${BLUE}║    🧹 LIMPIEZA DE WORKFLOWS DUPLICADOS EN n8n 🧹        ║${NC}"
echo -e "${BLUE}║                                                           ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Configuración
N8N_URL="http://localhost:5678"
N8N_API_BASE="$N8N_URL/api/v1"
API_KEY_FILE="./config/.n8n_api_key"

# Verificar API Key
if [ ! -f "$API_KEY_FILE" ]; then
    echo -e "${RED}❌ Error: No se encontró API Key en $API_KEY_FILE${NC}"
    exit 1
fi

API_KEY=$(cat "$API_KEY_FILE")
echo -e "${GREEN}✅ API Key encontrada${NC}"
echo ""

# Función para obtener workflows por nombre
get_workflows_by_name() {
    local name="$1"
    curl -s -H "X-N8N-API-KEY: $API_KEY" "$N8N_API_BASE/workflows" | \
        jq -r ".data[] | select(.name == \"$name\") | \"\(.id)|\(.active)\""
}

# Función para desactivar workflow
deactivate_workflow() {
    local workflow_id="$1"
    curl -s -X PATCH \
        -H "Content-Type: application/json" \
        -H "X-N8N-API-KEY: $API_KEY" \
        -d '{"active": false}' \
        "$N8N_API_BASE/workflows/$workflow_id" > /dev/null 2>&1
}

# Función para eliminar workflow
delete_workflow() {
    local workflow_id="$1"
    curl -s -X DELETE \
        -H "X-N8N-API-KEY: $API_KEY" \
        "$N8N_API_BASE/workflows/$workflow_id" > /dev/null 2>&1
}

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📊 Analizando workflows...${NC}"
echo ""

# Obtener todos los workflows
ALL_WORKFLOWS=$(curl -s -H "X-N8N-API-KEY: $API_KEY" "$N8N_API_BASE/workflows" | \
    jq -r '.data[] | "\(.name)"' | sort | uniq)

# Contar duplicados
echo -e "${YELLOW}Workflows únicos encontrados:${NC}"
TOTAL_UNIQUE=0
TOTAL_DUPLICATES=0

while IFS= read -r workflow_name; do
    COUNT=$(curl -s -H "X-N8N-API-KEY: $API_KEY" "$N8N_API_BASE/workflows" | \
        jq -r ".data[] | select(.name == \"$workflow_name\") | .id" | wc -l)
    
    if [ "$COUNT" -gt 1 ]; then
        echo -e "  ${RED}❌ $workflow_name: $COUNT copias${NC}"
        TOTAL_DUPLICATES=$((TOTAL_DUPLICATES + COUNT - 1))
    else
        echo -e "  ${GREEN}✅ $workflow_name: 1 copia${NC}"
    fi
    TOTAL_UNIQUE=$((TOTAL_UNIQUE + 1))
done <<< "$ALL_WORKFLOWS"

echo ""
echo -e "${YELLOW}Total workflows únicos:${NC} $TOTAL_UNIQUE"
echo -e "${YELLOW}Total duplicados a eliminar:${NC} $TOTAL_DUPLICATES"
echo ""

if [ "$TOTAL_DUPLICATES" -eq 0 ]; then
    echo -e "${GREEN}✅ No hay duplicados para eliminar${NC}"
    exit 0
fi

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -p "$(echo -e ${BLUE}¿Deseas continuar con la limpieza? [y/N]: ${NC})" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Limpieza cancelada${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}🧹 Limpiando workflows duplicados...${NC}"
echo ""

DELETED=0
KEPT=0

# Procesar cada workflow único
while IFS= read -r workflow_name; do
    echo -e "${YELLOW}Procesando: $workflow_name${NC}"
    
    # Obtener todos los IDs de este workflow
    WORKFLOW_IDS=$(curl -s -H "X-N8N-API-KEY: $API_KEY" "$N8N_API_BASE/workflows" | \
        jq -r ".data[] | select(.name == \"$workflow_name\") | .id")
    
    # Contar cuántos hay
    COUNT=$(echo "$WORKFLOW_IDS" | wc -l)
    
    if [ "$COUNT" -gt 1 ]; then
        # Mantener solo el primero, eliminar el resto
        FIRST=true
        while IFS= read -r workflow_id; do
            if [ "$FIRST" = true ]; then
                echo -e "  ${GREEN}✓ Manteniendo: $workflow_id${NC}"
                KEPT=$((KEPT + 1))
                FIRST=false
            else
                echo -e "  ${RED}✗ Eliminando: $workflow_id${NC}"
                # Primero desactivar
                deactivate_workflow "$workflow_id"
                # Luego eliminar
                if delete_workflow "$workflow_id"; then
                    DELETED=$((DELETED + 1))
                else
                    echo -e "    ${RED}⚠️  Error al eliminar${NC}"
                fi
            fi
        done <<< "$WORKFLOW_IDS"
    else
        echo -e "  ${GREEN}✓ Sin duplicados${NC}"
        KEPT=$((KEPT + 1))
    fi
done <<< "$ALL_WORKFLOWS"

echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}📊 RESUMEN DE LIMPIEZA:${NC}"
echo ""
echo -e "  ${GREEN}✅ Workflows mantenidos: $KEPT${NC}"
echo -e "  ${RED}🗑️  Workflows eliminados: $DELETED${NC}"
echo ""

if [ $DELETED -gt 0 ]; then
    echo -e "${GREEN}✅ Limpieza completada exitosamente${NC}"
    echo ""
    echo -e "${BLUE}💡 Próximos pasos:${NC}"
    echo -e "  1. Verificar workflows en n8n: ${YELLOW}http://localhost:5678${NC}"
    echo -e "  2. Activar los workflows necesarios"
    echo -e "  3. Asignar credenciales si es necesario"
else
    echo -e "${YELLOW}⚠️  No se pudo eliminar ningún workflow${NC}"
fi

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
