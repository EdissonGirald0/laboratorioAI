#!/bin/bash

# Script para automatizar la carga de workflows en n8n
# Usa la API REST de n8n para importar workflows automáticamente

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                           ║${NC}"
echo -e "${BLUE}║     🤖 CARGA AUTOMÁTICA DE WORKFLOWS EN n8n 🤖          ║${NC}"
echo -e "${BLUE}║                                                           ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Configuración
N8N_URL="http://localhost:5678"
N8N_API_BASE="$N8N_URL/api/v1"
WORKFLOW_DIR="./n8n/workflows"
CREDENTIALS_DIR="./n8n/credentials"

# Función para verificar si n8n está listo
check_n8n() {
    echo -e "${YELLOW}Verificando que n8n esté disponible...${NC}"
    local max_retries=30
    local retry_count=0
    
    while [ $retry_count -lt $max_retries ]; do
        if curl -s "$N8N_URL/healthz" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ n8n está disponible${NC}"
            return 0
        fi
        retry_count=$((retry_count + 1))
        echo -e "${YELLOW}Esperando n8n... ($retry_count/$max_retries)${NC}"
        sleep 2
    done
    
    echo -e "${RED}❌ Error: n8n no está disponible después de $max_retries intentos${NC}"
    return 1
}

# Función para verificar si el usuario está autenticado
check_auth() {
    echo -e "${YELLOW}Verificando autenticación...${NC}"
    
    # Intentar acceder a la API sin autenticación (n8n permite acceso local sin auth por defecto)
    if curl -s "$N8N_API_BASE/workflows" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Acceso a API confirmado${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}⚠️  n8n requiere autenticación${NC}"
    echo -e "${YELLOW}Por favor, primero:${NC}"
    echo -e "  1. Accede a $N8N_URL"
    echo -e "  2. Crea tu cuenta de administrador"
    echo -e "  3. Ejecuta este script nuevamente"
    echo ""
    return 1
}

# Función para importar un workflow
import_workflow() {
    local workflow_file="$1"
    local workflow_name=$(basename "$workflow_file" .json)
    
    echo -e "${YELLOW}Importando: ${workflow_name}${NC}"
    
    # Leer el contenido del workflow
    local workflow_content=$(cat "$workflow_file")
    
    # Intentar importar el workflow
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "$workflow_content" \
        "$N8N_API_BASE/workflows" 2>&1)
    
    # Verificar si la importación fue exitosa
    if echo "$response" | grep -q '"id"'; then
        echo -e "${GREEN}  ✅ Importado exitosamente: ${workflow_name}${NC}"
        return 0
    else
        # Verificar si el workflow ya existe
        if echo "$response" | grep -q "already exists"; then
            echo -e "${YELLOW}  ⚠️  Ya existe: ${workflow_name}${NC}"
            return 0
        else
            echo -e "${RED}  ❌ Error al importar: ${workflow_name}${NC}"
            echo -e "${RED}     ${response}${NC}"
            return 1
        fi
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
    
    # Verificar autenticación
    if ! check_auth; then
        exit 1
    fi
    
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}📋 Importando workflows...${NC}"
    echo ""
    
    # Contar workflows
    local total_workflows=$(ls -1 "$WORKFLOW_DIR"/*.json 2>/dev/null | wc -l)
    local imported_count=0
    local skipped_count=0
    local error_count=0
    
    if [ $total_workflows -eq 0 ]; then
        echo -e "${RED}❌ No se encontraron workflows en $WORKFLOW_DIR${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}Total de workflows encontrados: $total_workflows${NC}"
    echo ""
    
    # Importar cada workflow
    for workflow_file in "$WORKFLOW_DIR"/*.json; do
        if [ -f "$workflow_file" ]; then
            if import_workflow "$workflow_file"; then
                imported_count=$((imported_count + 1))
            else
                error_count=$((error_count + 1))
            fi
        fi
    done
    
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}📊 RESUMEN DE IMPORTACIÓN:${NC}"
    echo ""
    echo -e "  ${GREEN}✅ Importados exitosamente: $imported_count${NC}"
    if [ $skipped_count -gt 0 ]; then
        echo -e "  ${YELLOW}⚠️  Ya existían: $skipped_count${NC}"
    fi
    if [ $error_count -gt 0 ]; then
        echo -e "  ${RED}❌ Con errores: $error_count${NC}"
    fi
    echo ""
    
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}📝 NOTA IMPORTANTE:${NC}"
    echo ""
    echo -e "${YELLOW}Los workflows han sido importados, pero necesitan:${NC}"
    echo -e "  1. ${YELLOW}Configurar credenciales manualmente en n8n${NC}"
    echo -e "     Settings → Credentials → Add Credential"
    echo -e "     Usa los valores de: $CREDENTIALS_DIR/"
    echo ""
    echo -e "  2. ${YELLOW}Abrir cada workflow y asignar las credenciales${NC}"
    echo -e "     a los nodos que las requieran"
    echo ""
    echo -e "  3. ${YELLOW}Activar los workflows que desees usar${NC}"
    echo ""
    echo -e "${GREEN}Accede a n8n: $N8N_URL${NC}"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [ $error_count -eq 0 ]; then
        echo -e "${GREEN}✅ Importación completada exitosamente${NC}"
        exit 0
    else
        echo -e "${RED}⚠️  Importación completada con algunos errores${NC}"
        exit 1
    fi
}

# Ejecutar función principal
main
