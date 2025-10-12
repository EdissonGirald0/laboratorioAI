#!/bin/bash

# Script para automatizar la carga de credenciales en n8n
# Usa la API REST de n8n para crear credenciales

# No usar set -e porque necesitamos manejar códigos de retorno manualmente
set +e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                           ║${NC}"
echo -e "${BLUE}║    🔐 CARGA AUTOMÁTICA DE CREDENCIALES EN n8n 🔐        ║${NC}"
echo -e "${BLUE}║                                                           ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Configuración
N8N_URL="http://localhost:5678"
N8N_API_BASE="$N8N_URL/api/v1"
CREDENTIALS_DIR="./n8n/credentials"
API_KEY_FILE="./config/.n8n_api_key"

# Cargar variables de entorno
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
else
    echo -e "${RED}❌ Error: Archivo .env no encontrado${NC}"
    exit 1
fi

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

# Función para crear credencial de PostgreSQL
create_postgres_credential() {
    local cred_name="$1"
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "X-N8N-API-KEY: $API_KEY" \
        -d "{
            \"name\": \"$cred_name\",
            \"type\": \"postgres\",
            \"data\": {
                \"host\": \"postgres\",
                \"port\": 5432,
                \"database\": \"${DB_POSTGRESDB_DATABASE}\",
                \"user\": \"${DB_POSTGRESDB_USER}\",
                \"password\": \"${DB_POSTGRESDB_PASSWORD}\",
                \"ssl\": \"disable\",
                \"sshTunnel\": false
            }
        }" \
        "$N8N_API_BASE/credentials" 2>&1)
    
    if echo "$response" | grep -q '"id"'; then
        local cred_id=$(echo "$response" | jq -r '.id' 2>/dev/null || echo "unknown")
        echo -e "${GREEN}  ✅ Credencial creada: $cred_name (ID: $cred_id)${NC}"
        return 0
    else
        echo -e "${RED}  ❌ Error al crear: $cred_name${NC}"
        echo -e "${RED}     $(echo "$response" | head -c 200)${NC}"
        return 1
    fi
}

# Función para crear credencial de Redis
create_redis_credential() {
    local cred_name="$1"
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "X-N8N-API-KEY: $API_KEY" \
        -d "{
            \"name\": \"$cred_name\",
            \"type\": \"redis\",
            \"data\": {
                \"host\": \"redis\",
                \"port\": 6379,
                \"password\": \"${REDIS_PASSWORD}\",
                \"database\": 0,
                \"ssl\": false
            }
        }" \
        "$N8N_API_BASE/credentials" 2>&1)
    
    if echo "$response" | grep -q '"id"'; then
        local cred_id=$(echo "$response" | jq -r '.id' 2>/dev/null || echo "unknown")
        echo -e "${GREEN}  ✅ Credencial creada: $cred_name (ID: $cred_id)${NC}"
        return 0
    else
        echo -e "${RED}  ❌ Error al crear: $cred_name${NC}"
        echo -e "${RED}     $(echo "$response" | head -c 200)${NC}"
        return 1
    fi
}

# Función para crear credencial HTTP para Ollama
create_ollama_credential() {
    local cred_name="$1"
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "X-N8N-API-KEY: $API_KEY" \
        -d "{
            \"name\": \"$cred_name\",
            \"type\": \"httpBasicAuth\",
            \"data\": {
                \"user\": \"\",
                \"password\": \"\"
            }
        }" \
        "$N8N_API_BASE/credentials" 2>&1)
    
    if echo "$response" | grep -q '"id"'; then
        local cred_id=$(echo "$response" | jq -r '.id' 2>/dev/null || echo "unknown")
        echo -e "${GREEN}  ✅ Credencial creada: $cred_name (ID: $cred_id)${NC}"
        echo -e "${YELLOW}     ⚠️  Ollama no requiere autenticación, credencial vacía creada${NC}"
        return 0
    else
        echo -e "${YELLOW}  ⚠️  Ollama no requiere credencial HTTP (sin autenticación)${NC}"
        return 2
    fi
}

# Función para crear credencial HTTP para Flowise
create_flowise_credential() {
    local cred_name="$1"
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "X-N8N-API-KEY: $API_KEY" \
        -d "{
            \"name\": \"$cred_name\",
            \"type\": \"httpHeaderAuth\",
            \"data\": {
                \"name\": \"Authorization\",
                \"value\": \"Bearer ${FLOWISE_SECRETKEY_OVERWRITE}\"
            }
        }" \
        "$N8N_API_BASE/credentials" 2>&1)
    
    if echo "$response" | grep -q '"id"'; then
        local cred_id=$(echo "$response" | jq -r '.id' 2>/dev/null || echo "unknown")
        echo -e "${GREEN}  ✅ Credencial creada: $cred_name (ID: $cred_id)${NC}"
        return 0
    else
        echo -e "${RED}  ❌ Error al crear: $cred_name${NC}"
        echo -e "${RED}     $(echo "$response" | head -c 200)${NC}"
        return 1
    fi
}

# Función para crear credencial HTTP para Qdrant
create_qdrant_credential() {
    local cred_name="$1"
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "X-N8N-API-KEY: $API_KEY" \
        -d "{
            \"name\": \"$cred_name\",
            \"type\": \"httpHeaderAuth\",
            \"data\": {
                \"name\": \"api-key\",
                \"value\": \"${N8N_QDRANT_API_KEY}\"
            }
        }" \
        "$N8N_API_BASE/credentials" 2>&1)
    
    if echo "$response" | grep -q '"id"'; then
        local cred_id=$(echo "$response" | jq -r '.id' 2>/dev/null || echo "unknown")
        echo -e "${GREEN}  ✅ Credencial creada: $cred_name (ID: $cred_id)${NC}"
        return 0
    else
        echo -e "${RED}  ❌ Error al crear: $cred_name${NC}"
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
    echo -e "${BLUE}🔐 Creando credenciales...${NC}"
    echo ""
    
    local created_count=0
    local skipped_count=0
    local error_count=0
    
    # 1. PostgreSQL
    echo -e "${YELLOW}Creando: PostgreSQL Main${NC}"
    create_postgres_credential "PostgreSQL Main"
    local result=$?
    if [ $result -eq 0 ]; then
        created_count=$((created_count + 1))
    elif [ $result -eq 2 ]; then
        skipped_count=$((skipped_count + 1))
    else
        error_count=$((error_count + 1))
    fi
    
    # 2. Redis
    echo -e "${YELLOW}Creando: Redis Main${NC}"
    create_redis_credential "Redis Main"
    result=$?
    if [ $result -eq 0 ]; then
        created_count=$((created_count + 1))
    elif [ $result -eq 2 ]; then
        skipped_count=$((skipped_count + 1))
    else
        error_count=$((error_count + 1))
    fi
    
    # 3. Ollama (nota: Ollama no requiere autenticación real)
    echo -e "${YELLOW}Creando: Ollama API${NC}"
    create_ollama_credential "Ollama API"
    result=$?
    if [ $result -eq 0 ]; then
        created_count=$((created_count + 1))
    elif [ $result -eq 2 ]; then
        skipped_count=$((skipped_count + 1))
    else
        error_count=$((error_count + 1))
    fi
    
    # 4. Flowise
    echo -e "${YELLOW}Creando: Flowise API${NC}"
    create_flowise_credential "Flowise API"
    result=$?
    if [ $result -eq 0 ]; then
        created_count=$((created_count + 1))
    elif [ $result -eq 2 ]; then
        skipped_count=$((skipped_count + 1))
    else
        error_count=$((error_count + 1))
    fi
    
    # 5. Qdrant
    echo -e "${YELLOW}Creando: Qdrant${NC}"
    create_qdrant_credential "Qdrant"
    result=$?
    if [ $result -eq 0 ]; then
        created_count=$((created_count + 1))
    elif [ $result -eq 2 ]; then
        skipped_count=$((skipped_count + 1))
    else
        error_count=$((error_count + 1))
    fi
    
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}📊 RESUMEN DE CREDENCIALES:${NC}"
    echo ""
    echo -e "  ${GREEN}✅ Creadas exitosamente: $created_count${NC}"
    if [ $skipped_count -gt 0 ]; then
        echo -e "  ${YELLOW}⚠️  Omitidas (no requieren auth): $skipped_count${NC}"
    fi
    if [ $error_count -gt 0 ]; then
        echo -e "  ${RED}❌ Con errores: $error_count${NC}"
    fi
    echo ""
    
    if [ $created_count -gt 0 ]; then
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BLUE}📝 SIGUIENTES PASOS:${NC}"
        echo ""
        echo -e "${YELLOW}1. Verificar credenciales en n8n:${NC}"
        echo -e "   Settings → Credentials"
        echo -e "   Verifica que todas las credenciales estén creadas"
        echo ""
        echo -e "${YELLOW}2. Asignar credenciales a workflows:${NC}"
        echo -e "   Abre cada workflow y asigna las credenciales"
        echo -e "   a los nodos que las requieran"
        echo ""
        echo -e "${YELLOW}3. Activar workflows:${NC}"
        echo -e "   Usa el toggle en cada workflow para activarlo"
        echo ""
        echo -e "${GREEN}Accede a n8n: $N8N_URL${NC}"
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    fi
    
    if [ $error_count -eq 0 ]; then
        echo -e "${GREEN}✅ Credenciales creadas exitosamente${NC}"
        exit 0
    else
        echo -e "${RED}⚠️  Algunas credenciales no se pudieron crear${NC}"
        echo -e "${YELLOW}Puedes crearlas manualmente siguiendo: ./n8n/QUICK_IMPORT_GUIDE.md${NC}"
        exit 1
    fi
}

# Ejecutar función principal
main
