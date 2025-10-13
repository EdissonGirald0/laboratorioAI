#!/bin/bash

# Script mejorado para automatizar la carga de workflows en n8n
# Requiere que el usuario cree una API Key primero

# No usar set -e porque necesitamos manejar códigos de retorno manualmente
set +e

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

# Función para obtener o solicitar API Key
get_api_key() {
    # Verificar si ya tenemos una API Key guardada
    if [ -f "$API_KEY_FILE" ]; then
        API_KEY=$(cat "$API_KEY_FILE")
        echo -e "${GREEN}✅ Usando API Key guardada${NC}"
        return 0
    fi
    
    # Si no hay API Key, mostrar instrucciones
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}⚠️  NO SE ENCONTRÓ UNA API KEY${NC}"
    echo ""
    echo -e "${YELLOW}Para usar este script, necesitas generar una API Key en n8n:${NC}"
    echo ""
    echo -e "${BLUE}PASOS:${NC}"
    echo -e "  1. Accede a n8n: ${GREEN}$N8N_URL${NC}"
    echo -e "  2. Crea tu cuenta de administrador (si no la tienes)"
    echo -e "  3. Ve a: ${BLUE}Settings → API${NC}"
    echo -e "  4. Click en ${BLUE}'Create an API Key'${NC}"
    echo -e "  5. Copia la API Key generada"
    echo -e "  6. Ejecuta este script con la API Key:"
    echo ""
    echo -e "     ${GREEN}./scripts/import-workflows-n8n.sh YOUR_API_KEY${NC}"
    echo ""
    echo -e "${YELLOW}La API Key se guardará para futuros usos.${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    return 1
}

# Función para verificar si un workflow ya existe
workflow_exists() {
    local workflow_name="$1"
    
    # Obtener todos los workflows y buscar por nombre
    local response=$(curl -s -H "X-N8N-API-KEY: $API_KEY" "$N8N_API_BASE/workflows")
    
    # Verificar si el workflow ya existe (cualquier cantidad de veces)
    local count=$(echo "$response" | jq -r "[.data[] | select(.name == \"$workflow_name\")] | length" 2>/dev/null)
    
    if [ "$count" -gt 0 ]; then
        echo "$count"
        return 0
    else
        echo "0"
        return 1
    fi
}

# Función para importar un workflow
import_workflow() {
    local workflow_file="$1"
    local workflow_name=$(basename "$workflow_file" .json)
    
    echo -e "${YELLOW}Importando: ${workflow_name}${NC}"
    
    # Verificar que el archivo no esté vacío
    if [ ! -s "$workflow_file" ]; then
        echo -e "${YELLOW}  ⚠️  Omitido: Archivo vacío${NC}"
        return 3
    fi
    
    # Verificar que sea un JSON válido
    if ! jq empty "$workflow_file" 2>/dev/null; then
        echo -e "${YELLOW}  ⚠️  Omitido: JSON inválido${NC}"
        return 3
    fi
    
    # Obtener el nombre del workflow desde el JSON
    local json_workflow_name=$(jq -r '.name // ""' "$workflow_file")
    if [ -z "$json_workflow_name" ]; then
        json_workflow_name="$workflow_name"
    fi
    
    # Verificar si el workflow ya existe
    local existing_count=$(workflow_exists "$json_workflow_name")
    if [ "$existing_count" -gt 0 ]; then
        echo -e "${BLUE}  ℹ️  Ya existe: ${json_workflow_name} (${existing_count} instancia(s))${NC}"
        echo -e "${BLUE}  ⏭️  Omitiendo importación para evitar duplicados${NC}"
        return 4  # Código especial para "ya existe"
    fi
    
    # Leer el contenido del workflow y filtrar solo los campos aceptados por la API
    # La API de n8n solo acepta: name, nodes, connections, settings (vacío), staticData
    # Eliminamos: id, active, createdAt, updatedAt, tags, triggerCount, settings personalizados, etc.
    # IMPORTANTE: settings debe ser un objeto vacío {} al importar
    local workflow_content=$(cat "$workflow_file" | jq -c '{
        name: .name,
        nodes: .nodes,
        connections: .connections,
        settings: {},
        staticData: (.staticData // null)
    }')
    
    # Intentar importar el workflow usando la API
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "X-N8N-API-KEY: $API_KEY" \
        -d "$workflow_content" \
        "$N8N_API_BASE/workflows" 2>&1)
    
    # Verificar si la importación fue exitosa
    if echo "$response" | grep -q '"id"'; then
        local workflow_id=$(echo "$response" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
        echo -e "${GREEN}  ✅ Importado exitosamente: ${workflow_name} (ID: $workflow_id)${NC}"
        return 0
    else
        # Verificar diferentes tipos de errores
        if echo "$response" | grep -qi "unauthorized\|api.key"; then
            echo -e "${RED}  ❌ Error de autenticación: API Key inválida${NC}"
            echo -e "${YELLOW}     Elimina el archivo config/.n8n_api_key y genera una nueva API Key${NC}"
            return 2
        elif echo "$response" | grep -qi "already exists\|duplicate"; then
            echo -e "${YELLOW}  ⚠️  Ya existe: ${workflow_name}${NC}"
            return 0
        else
            echo -e "${RED}  ❌ Error al importar: ${workflow_name}${NC}"
            echo -e "${RED}     $(echo "$response" | head -c 200)${NC}"
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
    
    # Obtener API Key (de argumento, archivo o solicitar)
    if [ -n "$1" ]; then
        API_KEY="$1"
        echo -e "${GREEN}✅ Usando API Key proporcionada${NC}"
        # Guardar para futuros usos
        echo "$API_KEY" > "$API_KEY_FILE"
        chmod 600 "$API_KEY_FILE"
        echo -e "${GREEN}✅ API Key guardada en $API_KEY_FILE${NC}"
    elif ! get_api_key; then
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
    local duplicate_count=0
    local error_count=0
    local auth_error=0
    
    if [ $total_workflows -eq 0 ]; then
        echo -e "${RED}❌ No se encontraron workflows en $WORKFLOW_DIR${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}Total de workflows encontrados: $total_workflows${NC}"
    echo ""
    
    # Importar cada workflow
    for workflow_file in "$WORKFLOW_DIR"/*.json; do
        if [ -f "$workflow_file" ]; then
            import_workflow "$workflow_file"
            local result=$?
            if [ $result -eq 0 ]; then
                imported_count=$((imported_count + 1))
            elif [ $result -eq 2 ]; then
                auth_error=1
                break
            elif [ $result -eq 3 ]; then
                skipped_count=$((skipped_count + 1))
            elif [ $result -eq 4 ]; then
                duplicate_count=$((duplicate_count + 1))
            else
                error_count=$((error_count + 1))
            fi
        fi
    done
    
    # Si hubo error de autenticación, salir
    if [ $auth_error -eq 1 ]; then
        echo ""
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${RED}❌ ERROR DE AUTENTICACIÓN${NC}"
        echo -e "${YELLOW}Elimina el archivo config/.n8n_api_key y genera una nueva API Key${NC}"
        rm -f "$API_KEY_FILE"
        exit 1
    fi
    
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}📊 RESUMEN DE IMPORTACIÓN:${NC}"
    echo ""
    echo -e "  ${GREEN}✅ Importados exitosamente: $imported_count${NC}"
    if [ $duplicate_count -gt 0 ]; then
        echo -e "  ${BLUE}ℹ️  Ya existían (omitidos): $duplicate_count${NC}"
    fi
    if [ $skipped_count -gt 0 ]; then
        echo -e "  ${YELLOW}⚠️  Omitidos (vacíos/inválidos): $skipped_count${NC}"
    fi
    if [ $error_count -gt 0 ]; then
        echo -e "  ${RED}❌ Con errores: $error_count${NC}"
    fi
    echo ""
    
    if [ $imported_count -gt 0 ]; then
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BLUE}📝 SIGUIENTES PASOS:${NC}"
        echo ""
        echo -e "${YELLOW}1. Configurar credenciales en n8n:${NC}"
        echo -e "   Settings → Credentials → Add Credential"
        echo -e "   Usa los valores de: ${BLUE}$CREDENTIALS_DIR/${NC}"
        echo -e "   Ver guía: ${GREEN}cat ./n8n/QUICK_IMPORT_GUIDE.md${NC}"
        echo ""
        echo -e "${YELLOW}2. Asignar credenciales a los workflows:${NC}"
        echo -e "   Abre cada workflow y asigna las credenciales"
        echo -e "   a los nodos que las requieran"
        echo ""
        echo -e "${YELLOW}3. Activar los workflows:${NC}"
        echo -e "   Usa el toggle en cada workflow para activarlo"
        echo ""
        echo -e "${GREEN}Accede a n8n: $N8N_URL${NC}"
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    fi
    
    if [ $imported_count -eq 0 ] && [ $error_count -eq 0 ]; then
        echo -e "${YELLOW}⚠️  No se importó ningún workflow (todos fueron omitidos)${NC}"
        exit 0
    elif [ $error_count -eq 0 ]; then
        echo -e "${GREEN}✅ Importación completada exitosamente${NC}"
        exit 0
    else
        echo -e "${RED}⚠️  Importación completada con algunos errores${NC}"
        exit 1
    fi
}

# Ejecutar función principal con el primer argumento (API Key)
main "$1"
