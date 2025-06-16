#!/bin/bash

# Verificar si el archivo .env existe
if [ ! -f .env ]; then
    echo "Error: El archivo .env no existe"
    exit 1
fi

# Función para verificar si una variable está definida
check_var() {
    if ! grep -q "^$1=" .env; then
        echo "Error: Falta la variable $1"
        return 1
    fi
}

# Verificar variables requeridas
required_vars=(
    "POSTGRES_USER"
    "POSTGRES_PASSWORD"
    "POSTGRES_DB"
    "POSTGRES_HOST"
    "POSTGRES_PORT"
    "QDRANT_HOST"
    "QDRANT_PORT"
    "QDRANT_GRPC_PORT"
    "OLLAMA_HOST"
    "OLLAMA_PORT"
    "OLLAMA_API_BASE_URL"
    "WEBUI_SECRET_KEY"
    "WEBUI_HOST"
    "WEBUI_PORT"
    "NODE_ENV"
    "N8N_PROTOCOL"
    "N8N_HOST"
    "N8N_PORT"
    "N8N_ENCRYPTION_KEY"
    "DB_TYPE"
    "DB_POSTGRESDB_HOST"
    "DB_POSTGRESDB_PORT"
    "DB_POSTGRESDB_DATABASE"
    "DB_POSTGRESDB_USER"
    "DB_POSTGRESDB_PASSWORD"
    "FLOOWISE_HOST"
    "FLOOWISE_PORT"
    "DATABASE_URL"
    "QDRANT_URL"
)

# Verificar cada variable requerida
errors=0
for var in "${required_vars[@]}"; do
    if ! check_var "$var"; then
        errors=$((errors + 1))
    fi
done

# Verificar puertos
check_port() {
    local port=$1
    if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        echo "Error: Puerto inválido para $2: $port"
        return 1
    fi
}

# Verificar puertos específicos
check_port "$(grep "^POSTGRES_PORT=" .env | cut -d'=' -f2)" "PostgreSQL"
check_port "$(grep "^QDRANT_PORT=" .env | cut -d'=' -f2)" "Qdrant"
check_port "$(grep "^OLLAMA_PORT=" .env | cut -d'=' -f2)" "Ollama"
check_port "$(grep "^WEBUI_PORT=" .env | cut -d'=' -f2)" "OpenWebUI"
check_port "$(grep "^N8N_PORT=" .env | cut -d'=' -f2)" "n8n"
check_port "$(grep "^FLOOWISE_PORT=" .env | cut -d'=' -f2)" "Floowise"

if [ $errors -eq 0 ]; then
    echo "Validación exitosa: Todas las variables requeridas están presentes"
    exit 0
else
    echo "Validación fallida: Se encontraron $errors errores"
    exit 1
fi 