#!/bin/bash

# Verificar si el archivo .env existe
if [ ! -f .env ]; then
    echo "Error: El archivo .env no existe"
    exit 1
fi

# Crear backup antes de modificar
./backup-env.sh

echo "Generando nuevas claves de seguridad..."

# Generar nuevas claves de encriptación
NEW_ENCRYPTION_KEY=$(openssl rand -base64 32)
NEW_WEBUI_SECRET=$(openssl rand -base64 32)

# Generar nueva contraseña para PostgreSQL
NEW_POSTGRES_PASSWORD=$(openssl rand -base64 16 | tr -dc 'a-zA-Z0-9' | head -c 16)

# Actualizar el archivo .env
sed -i "s/N8N_ENCRYPTION_KEY=.*/N8N_ENCRYPTION_KEY=$NEW_ENCRYPTION_KEY/" .env
sed -i "s/WEBUI_SECRET_KEY=.*/WEBUI_SECRET_KEY=$NEW_WEBUI_SECRET/" .env
sed -i "s/POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$NEW_POSTGRES_PASSWORD/" .env

echo "Variables actualizadas correctamente"
echo "Nueva contraseña de PostgreSQL: $NEW_POSTGRES_PASSWORD"
echo "Por favor, guarda estas credenciales en un lugar seguro" 