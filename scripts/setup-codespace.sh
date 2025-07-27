#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Configurando entorno de desarrollo en Codespaces...${NC}"

# Verificar Docker
echo -e "\n${YELLOW}Verificando Docker...${NC}"
if ! docker --version; then
    echo -e "${RED}Docker no está instalado${NC}"
    exit 1
fi
echo -e "${GREEN}Docker está instalado correctamente${NC}"

# Verificar Docker Compose
echo -e "\n${YELLOW}Verificando Docker Compose...${NC}"
if ! docker-compose --version; then
    echo -e "${RED}Docker Compose no está instalado${NC}"
    exit 1
fi
echo -e "${GREEN}Docker Compose está instalado correctamente${NC}"

# Verificar espacio en disco
echo -e "\n${YELLOW}Verificando espacio en disco...${NC}"
df -h /
echo -e "${GREEN}Verificación de espacio completada${NC}"

# Verificar memoria disponible
echo -e "\n${YELLOW}Verificando memoria disponible...${NC}"
free -h
echo -e "${GREEN}Verificación de memoria completada${NC}"

# Instalar dependencias adicionales
echo -e "\n${YELLOW}Instalando dependencias adicionales...${NC}"
sudo apt-get update
sudo apt-get install -y \
    jq \
    curl \
    wget \
    netcat \
    bc \
    postgresql-client

# Crear directorios necesarios
echo -e "\n${YELLOW}Creando directorios de datos...${NC}"
mkdir -p postgres/data
mkdir -p qdrant/data
mkdir -p ollama/data
mkdir -p n8n/data
mkdir -p floowise/data
mkdir -p openwebui/data
mkdir -p redis/data

# Configurar permisos
echo -e "\n${YELLOW}Configurando permisos...${NC}"
chmod -R 777 */data

# Generar archivo de entorno si no existe
if [ ! -f .env ]; then
    echo -e "\n${YELLOW}Generando archivo .env...${NC}"
    ./scripts/init-env.sh
fi

# Verificar configuración
echo -e "\n${YELLOW}Verificando configuración...${NC}"
./scripts/validate-env.sh

echo -e "\n${GREEN}¡Configuración del entorno completada!${NC}"
echo -e "${YELLOW}Puedes iniciar el sistema con:${NC} docker-compose up -d"
