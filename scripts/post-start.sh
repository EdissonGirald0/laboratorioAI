#!/bin/bash

# Script para ejecutar automáticamente después de docker-compose up
# Se puede llamar manualmente o desde un hook

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║    🚀 POST-START: Configuración Automática Sistema 🚀   ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar si ya fue ejecutado
if [ -f "./config/.initialized" ]; then
    echo -e "${GREEN}✅ Sistema ya configurado${NC}"
    echo -e "${YELLOW}   Archivo de marca: ./config/.initialized${NC}"
    echo -e "${YELLOW}   Fecha: $(cat ./config/.initialized)${NC}"
    echo ""
    echo -e "${YELLOW}Para reinicializar:${NC}"
    echo -e "${BLUE}  1. rm ./config/.initialized${NC}"
    echo -e "${BLUE}  2. ./scripts/docker-init-automation.sh${NC}"
    exit 0
fi

# Verificar si hay marca de pendiente
if [ -f "./config/.init-pending" ]; then
    echo -e "${YELLOW}⏳ Inicialización pendiente detectada${NC}"
    rm -f ./config/.init-pending
fi

# Ejecutar script de inicialización
if [ -f "./scripts/docker-init-automation.sh" ]; then
    echo -e "${BLUE}📋 Ejecutando configuración automática...${NC}"
    echo ""
    ./scripts/docker-init-automation.sh
else
    echo -e "${RED}❌ Error: Script de inicialización no encontrado${NC}"
    exit 1
fi
