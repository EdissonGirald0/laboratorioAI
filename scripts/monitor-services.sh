#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Función para verificar servicio
check_service() {
    local service=$1
    local port=$2
    local endpoint=$3

    echo -e "${YELLOW}Verificando $service...${NC}"
    
    # Verificar si el contenedor está corriendo
    if docker-compose ps | grep -q "$service.*Up"; then
        echo -e "${GREEN}✓ Contenedor $service está corriendo${NC}"
    else
        echo -e "${RED}✗ Contenedor $service no está corriendo${NC}"
        return 1
    fi

    # Verificar el puerto
    if nc -z localhost $port; then
        echo -e "${GREEN}✓ Puerto $port está abierto${NC}"
    else
        echo -e "${RED}✗ Puerto $port no está respondiendo${NC}"
        return 1
    fi

    # Verificar endpoint si se proporciona
    if [ ! -z "$endpoint" ]; then
        if curl -s -f "http://localhost:$port$endpoint" > /dev/null; then
            echo -e "${GREEN}✓ Endpoint $endpoint está respondiendo${NC}"
        else
            echo -e "${RED}✗ Endpoint $endpoint no está respondiendo${NC}"
            return 1
        fi
    fi

    return 0
}

# Verificar espacio en disco
check_disk_space() {
    local threshold=80
    local usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    
    echo -e "${YELLOW}Verificando espacio en disco...${NC}"
    if [ $usage -gt $threshold ]; then
        echo -e "${RED}✗ Espacio en disco crítico: $usage%${NC}"
        return 1
    else
        echo -e "${GREEN}✓ Espacio en disco OK: $usage%${NC}"
        return 0
    fi
}

# Verificar uso de memoria
check_memory() {
    echo -e "${YELLOW}Verificando uso de memoria por servicio...${NC}"
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
}

# Verificar servicios
check_service "postgres" "5432"
check_service "qdrant" "6333" "/health"
check_service "ollama" "11434"
check_service "openwebui" "8080"
check_service "n8n" "5678"
check_service "floowise" "3000"

# Verificar espacio y memoria
check_disk_space
check_memory
