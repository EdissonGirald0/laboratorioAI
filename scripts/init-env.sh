#!/bin/bash

# Colores para mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Iniciando configuración del entorno...${NC}"

# Generar claves de seguridad
N8N_ENCRYPTION_KEY=$(openssl rand -base64 32)
WEBUI_SECRET_KEY=$(openssl rand -base64 32)
QDRANT_API_KEY=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32)

# Generar contraseñas
POSTGRES_PASSWORD=$(openssl rand -base64 16 | tr -dc 'a-zA-Z0-9' | head -c 16)
POSTGRES_NON_ROOT_PASSWORD=$(openssl rand -base64 16 | tr -dc 'a-zA-Z0-9' | head -c 16)
REDIS_PASSWORD=$(openssl rand -base64 16 | tr -dc 'a-zA-Z0-9' | head -c 16)
FLOWISE_PASSWORD=$(openssl rand -base64 16 | tr -dc 'a-zA-Z0-9' | head -c 16)

# Crear el archivo .env
cat > .env << EOL
# PostgreSQL
POSTGRES_USER=postgres
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
POSTGRES_DB=ailab
POSTGRES_NON_ROOT_USER=aiadmin
POSTGRES_NON_ROOT_PASSWORD=${POSTGRES_NON_ROOT_PASSWORD}
POSTGRES_HOST=host.docker.internal
POSTGRES_PORT=5432

# Redis
REDIS_HOST=host.docker.internal
REDIS_PORT=6379
REDIS_PASSWORD=${REDIS_PASSWORD}

# Qdrant
QDRANT_HOST=host.docker.internal
QDRANT_PORT=6333
QDRANT_GRPC_PORT=6334
QDRANT_API_KEY=$QDRANT_API_KEY

# Ollama
OLLAMA_HOST=host.docker.internal
OLLAMA_PORT=11434

# OpenWebUI
OLLAMA_API_BASE_URL=http://host.docker.internal:11434/api
WEBUI_SECRET_KEY=${WEBUI_SECRET_KEY}
WEBUI_HOST=0.0.0.0
WEBUI_PORT=8080

# n8n
NODE_ENV=development
N8N_PROTOCOL=http
N8N_HOST=localhost
N8N_PORT=5678
N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=postgres
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=ailab
DB_POSTGRESDB_USER=aiadmin
DB_POSTGRESDB_PASSWORD=${POSTGRES_NON_ROOT_PASSWORD}
N8N_USER_MANAGEMENT_DISABLED=true
N8N_DIAGNOSTICS_ENABLED=false
N8N_DIAGNOSTICS_CONFIG_ENABLED=false
N8N_METRICS=false
QUEUE_BULL_REDIS_HOST=redis
QUEUE_BULL_REDIS_PORT=6379
QUEUE_BULL_REDIS_PASSWORD=${REDIS_PASSWORD}

# Floowise
FLOOWISE_HOST=0.0.0.0
FLOOWISE_PORT=3000
DATABASE_URL=postgresql://aiadmin:${POSTGRES_NON_ROOT_PASSWORD}@host.docker.internal:5432/ailab
QDRANT_URL=http://host.docker.internal:6333

# Flowise
FLOWISE_USERNAME=admin
FLOWISE_PASSWORD=${FLOWISE_PASSWORD}
FLOWISE_HOST=0.0.0.0
FLOWISE_PORT=3000
EOL

# Establecer permisos correctos
chmod 600 .env

echo -e "${GREEN}Archivo .env creado exitosamente${NC}"
echo -e "${YELLOW}Nota: Las contraseñas y claves se han generado automáticamente.${NC}"
echo -e "${YELLOW}Guarda estas credenciales en un lugar seguro:${NC}"
echo -e "POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}"
echo -e "POSTGRES_NON_ROOT_PASSWORD: ${POSTGRES_NON_ROOT_PASSWORD}"
echo -e "REDIS_PASSWORD: ${REDIS_PASSWORD}"
echo -e "FLOWISE_PASSWORD: ${FLOWISE_PASSWORD}"
echo -e "N8N_ENCRYPTION_KEY: ${N8N_ENCRYPTION_KEY}"
echo -e "WEBUI_SECRET_KEY: ${WEBUI_SECRET_KEY}"
echo -e "QDRANT_API_KEY: ${QDRANT_API_KEY}" 