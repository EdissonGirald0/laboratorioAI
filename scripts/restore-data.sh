#!/bin/bash

# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar si se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Este script debe ejecutarse como root para manejar los permisos correctamente${NC}"
    echo "Por favor, ejecuta: sudo $0 <directorio_de_backup>"
    exit 1
fi

# Verificar si se proporcionó un directorio de backup
if [ -z "$1" ]; then
    echo -e "${RED}Error: Debes especificar el directorio de backup${NC}"
    echo "Uso: sudo $0 <directorio_de_backup>"
    echo "Ejemplo: sudo $0 ./backups/backup_20240315_123456"
    exit 1
fi

BACKUP_PATH="$1"

# Verificar si el directorio de backup existe
if [ ! -d "$BACKUP_PATH" ]; then
    echo -e "${RED}Error: El directorio de backup no existe${NC}"
    exit 1
fi

echo -e "${YELLOW}Iniciando restauración desde: $BACKUP_PATH${NC}"
echo -e "${YELLOW}Nota: Los datos de Ollama no se restauran del backup. Los modelos deberán ser descargados nuevamente.${NC}"

# Función para restaurar un backup
restore_backup() {
    local backup_file=$1
    local target_dir=$2
    local name=$3
    
    if [ -f "$backup_file" ]; then
        echo -e "${YELLOW}Restaurando $name...${NC}"
        # Crear directorio de destino si no existe
        mkdir -p "$target_dir"
        
        # Asegurar permisos del directorio de destino
        chmod 755 "$target_dir"
        
        # Extraer el backup
        tar -xzf "$backup_file" -C "$(dirname "$target_dir")"
        
        if [ $? -eq 0 ]; then
            # Ajustar permisos después de la restauración
            chown -R 999:999 "$target_dir"  # 999 es el UID común para servicios en contenedores
            chmod -R 755 "$target_dir"
            echo -e "${GREEN}✓ Restauración de $name completada${NC}"
        else
            echo -e "${RED}✗ Error al restaurar $name${NC}"
        fi
    else
        echo -e "${RED}✗ Archivo de backup $backup_file no encontrado${NC}"
    fi
}

# Detener los contenedores antes de restaurar
echo -e "${YELLOW}Deteniendo contenedores...${NC}"
docker-compose down

# Restaurar cada servicio
restore_backup "$BACKUP_PATH/postgres_*.tar.gz" "./postgres/data" "PostgreSQL"
restore_backup "$BACKUP_PATH/qdrant_*.tar.gz" "./qdrant/data" "Qdrant"
restore_backup "$BACKUP_PATH/n8n_*.tar.gz" "./n8n/data" "n8n"
restore_backup "$BACKUP_PATH/floowise_*.tar.gz" "./floowise/data" "Floowise"
restore_backup "$BACKUP_PATH/openwebui_*.tar.gz" "./openwebui/data" "OpenWebUI"

# Restaurar archivos de configuración si existen
if [ -f "$BACKUP_PATH/env_"* ]; then
    echo -e "${YELLOW}Restaurando archivo .env...${NC}"
    cp "$BACKUP_PATH/env_"* .env
    chmod 644 .env
fi

if [ -f "$BACKUP_PATH/docker-compose_"*".yml" ]; then
    echo -e "${YELLOW}Restaurando docker-compose.yml...${NC}"
    cp "$BACKUP_PATH/docker-compose_"*".yml" docker-compose.yml
    chmod 644 docker-compose.yml
fi

# Reiniciar los contenedores
echo -e "${YELLOW}Reiniciando contenedores...${NC}"
docker-compose up -d

echo -e "${GREEN}Restauración completada${NC}"
echo -e "${YELLOW}Verificando estado de los servicios...${NC}"
docker-compose ps

echo -e "${YELLOW}Nota: Después de la restauración, deberás descargar nuevamente los modelos de Ollama que necesites.${NC}" 