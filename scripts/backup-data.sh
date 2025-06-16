#!/bin/bash

# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar si se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Este script debe ejecutarse como root para manejar los permisos correctamente${NC}"
    echo "Por favor, ejecuta: sudo $0"
    exit 1
fi

# Directorio base para backups
BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_PATH="$BACKUP_DIR/backup_$TIMESTAMP"

# Crear directorio de backup si no existe
mkdir -p "$BACKUP_PATH"

echo -e "${YELLOW}Iniciando backup de datos...${NC}"
echo -e "${YELLOW}Nota: Los datos de Ollama se omiten del backup debido a su tamaño. Los modelos pueden ser descargados nuevamente.${NC}"

# Función para realizar backup de un directorio
backup_directory() {
    local source=$1
    local name=$2
    
    if [ -d "$source" ]; then
        echo -e "${YELLOW}Realizando backup de $name...${NC}"
        
        # Verificar permisos del directorio
        if [ ! -r "$source" ]; then
            echo -e "${YELLOW}Ajustando permisos de $source...${NC}"
            chmod -R u+r "$source"
        fi
        
        # Realizar backup con sudo
        tar -czf "$BACKUP_PATH/${name}_${TIMESTAMP}.tar.gz" -C "$(dirname "$source")" "$(basename "$source")" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Backup de $name completado${NC}"
        else
            echo -e "${RED}✗ Error al realizar backup de $name${NC}"
            echo -e "${YELLOW}Intentando con permisos elevados...${NC}"
            
            # Intentar con permisos elevados
            cd "$(dirname "$source")"
            sudo tar -czf "$BACKUP_PATH/${name}_${TIMESTAMP}.tar.gz" "$(basename "$source")" 2>/dev/null
            cd - > /dev/null
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓ Backup de $name completado con permisos elevados${NC}"
            else
                echo -e "${RED}✗ Error al realizar backup de $name incluso con permisos elevados${NC}"
            fi
        fi
    else
        echo -e "${RED}✗ Directorio $source no encontrado${NC}"
    fi
}

# Backup de PostgreSQL
backup_directory "./postgres/data" "postgres"

# Backup de Qdrant
backup_directory "./qdrant/data" "qdrant"

# Backup de n8n
backup_directory "./n8n/data" "n8n"

# Backup de Floowise
backup_directory "./floowise/data" "floowise"

# Backup de OpenWebUI
backup_directory "./openwebui/data" "openwebui"

# Backup de archivos de configuración
echo -e "${YELLOW}Realizando backup de archivos de configuración...${NC}"
cp .env "$BACKUP_PATH/env_$TIMESTAMP"
cp docker-compose.yml "$BACKUP_PATH/docker-compose_$TIMESTAMP.yml"

# Crear archivo de metadatos
echo "Backup realizado el $(date)" > "$BACKUP_PATH/metadata.txt"
echo "Contenido del backup:" >> "$BACKUP_PATH/metadata.txt"
ls -lh "$BACKUP_PATH" >> "$BACKUP_PATH/metadata.txt"
echo "Nota: Los datos de Ollama se omiten del backup debido a su tamaño. Los modelos pueden ser descargados nuevamente." >> "$BACKUP_PATH/metadata.txt"

# Ajustar permisos del directorio de backup
chown -R $(whoami):$(whoami) "$BACKUP_PATH"
chmod -R 755 "$BACKUP_PATH"

echo -e "${GREEN}Backup completado en: $BACKUP_PATH${NC}"

# Mantener solo los últimos 5 backups
echo -e "${YELLOW}Limpiando backups antiguos...${NC}"
ls -t "$BACKUP_DIR"/backup_* | tail -n +4 | xargs -r rm -rf

echo -e "${GREEN}Proceso de backup finalizado${NC}"
