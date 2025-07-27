#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Iniciando limpieza del sistema...${NC}"

# Limpiar logs antiguos
find ./*/data -name "*.log" -type f -mtime +7 -exec rm {} \;
echo -e "${GREEN}✓ Logs antiguos eliminados${NC}"

# Limpiar backups antiguos (mantener últimos 5)
cd backups
ls -t | tail -n +6 | xargs -I {} rm -- {}
cd ..
echo -e "${GREEN}✓ Backups antiguos eliminados${NC}"

# Limpiar datos temporales de Docker
docker system prune -f
echo -e "${GREEN}✓ Datos temporales de Docker eliminados${NC}"

# Limpiar cache de npm en Floowise
docker-compose exec floowise npm cache clean --force
echo -e "${GREEN}✓ Cache de npm limpiado${NC}"

# Verificar espacio liberado
df -h /
echo -e "${GREEN}✓ Limpieza completada${NC}"
