#!/bin/bash

# Crear directorio de backups si no existe
mkdir -p backups

# Generar nombre del archivo de backup con timestamp
BACKUP_FILE="backups/.env.backup.$(date +%Y%m%d_%H%M%S)"

# Copiar el archivo .env actual al backup
if [ -f .env ]; then
    cp .env "$BACKUP_FILE"
    echo "Backup creado en: $BACKUP_FILE"
else
    echo "No existe archivo .env para hacer backup"
fi 