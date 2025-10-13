#!/bin/bash

# Script de inicialización automática para Docker Compose
# Se ejecuta después de que todos los servicios estén listos

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                           ║${NC}"
echo -e "${BLUE}║    🚀 INICIALIZACIÓN AUTOMÁTICA DEL SISTEMA 🚀          ║${NC}"
echo -e "${BLUE}║                                                           ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Función para esperar a que n8n esté listo
wait_for_n8n() {
    echo -e "${YELLOW}⏳ Esperando a que n8n esté disponible...${NC}"
    local max_attempts=60
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -s http://localhost:5678/healthz > /dev/null 2>&1; then
            echo -e "${GREEN}✅ n8n está listo${NC}"
            return 0
        fi
        attempt=$((attempt + 1))
        echo -e "${YELLOW}   Intento $attempt/$max_attempts...${NC}"
        sleep 2
    done
    
    echo -e "${RED}❌ n8n no respondió después de $max_attempts intentos${NC}"
    return 1
}

# Función para esperar a que Ollama esté listo
wait_for_ollama() {
    echo -e "${YELLOW}⏳ Esperando a que Ollama esté disponible...${NC}"
    local max_attempts=30
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Ollama está listo${NC}"
            return 0
        fi
        attempt=$((attempt + 1))
        echo -e "${YELLOW}   Intento $attempt/$max_attempts...${NC}"
        sleep 2
    done
    
    echo -e "${RED}❌ Ollama no respondió después de $max_attempts intentos${NC}"
    return 1
}

# Función para verificar si ya se ejecutó la inicialización
check_initialization_flag() {
    if [ -f "./config/.initialized" ]; then
        echo -e "${YELLOW}⚠️  El sistema ya fue inicializado anteriormente${NC}"
        echo -e "${YELLOW}   Si deseas reinicializar, ejecuta:${NC}"
        echo -e "${BLUE}   rm ./config/.initialized && ./scripts/docker-init-automation.sh${NC}"
        echo ""
        read -p "¿Deseas reinicializar de todos modos? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}⏭️  Saltando inicialización${NC}"
            exit 0
        fi
    fi
}

# Función para descargar modelo de Ollama si no existe
setup_ollama_model() {
    echo -e "${YELLOW}📦 Verificando modelo CodeLlama en Ollama...${NC}"
    
    if docker exec ollama ollama list | grep -q "codellama"; then
        echo -e "${GREEN}✅ Modelo CodeLlama ya está disponible${NC}"
    else
        echo -e "${YELLOW}⬇️  Descargando modelo CodeLlama (puede tardar varios minutos)...${NC}"
        docker exec ollama ollama pull codellama:latest
        echo -e "${GREEN}✅ Modelo CodeLlama descargado${NC}"
    fi
}

# Función principal
main() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}FASE 1: Verificación de requisitos previos${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Verificar si ya fue inicializado
    check_initialization_flag
    
    # Crear directorio de configuración si no existe
    mkdir -p ./config
    
    # Esperar a que los servicios estén listos
    if ! wait_for_n8n; then
        echo -e "${RED}❌ Error: n8n no está disponible${NC}"
        exit 1
    fi
    
    if ! wait_for_ollama; then
        echo -e "${RED}❌ Error: Ollama no está disponible${NC}"
        exit 1
    fi
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}FASE 2: Configuración de Ollama${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    setup_ollama_model
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}FASE 3: Importación de workflows en n8n${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    if [ -f "./scripts/auto-import-n8n-workflows.sh" ]; then
        ./scripts/auto-import-n8n-workflows.sh
    else
        echo -e "${RED}❌ Script de importación de workflows no encontrado${NC}"
        exit 1
    fi
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}FASE 4: Creación de credenciales en n8n${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    if [ -f "./scripts/auto-import-n8n-credentials.sh" ]; then
        ./scripts/auto-import-n8n-credentials.sh
    else
        echo -e "${RED}❌ Script de creación de credenciales no encontrado${NC}"
        exit 1
    fi
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}FASE 5: Activación de workflows${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    if [ -f "./scripts/activate-dev-workflows.sh" ]; then
        ./scripts/activate-dev-workflows.sh
    else
        echo -e "${YELLOW}⚠️  Script de activación de workflows no encontrado${NC}"
    fi
    
    # Marcar como inicializado
    date > ./config/.initialized
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✅ INICIALIZACIÓN COMPLETADA EXITOSAMENTE${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${GREEN}🎉 El sistema está completamente configurado y listo para usar${NC}"
    echo ""
    echo -e "${YELLOW}📋 URLs de acceso:${NC}"
    echo -e "${BLUE}   • n8n:         http://localhost:5678${NC}"
    echo -e "${BLUE}   • Flowise:     http://localhost:3000${NC}"
    echo -e "${BLUE}   • OpenWebUI:   http://localhost:8080${NC}"
    echo -e "${BLUE}   • Ollama API:  http://localhost:11434${NC}"
    echo -e "${BLUE}   • Qdrant:      http://localhost:6333${NC}"
    echo ""
    echo -e "${YELLOW}🔧 Webhooks activos:${NC}"
    echo -e "${BLUE}   • Code Review: http://localhost:5678/webhook/code-review${NC}"
    echo -e "${BLUE}   • Git Commit:  http://localhost:5678/webhook/git-commit${NC}"
    echo -e "${BLUE}   • Bug Report:  http://localhost:5678/webhook/bug-report${NC}"
    echo -e "${BLUE}   • API Docs:    http://localhost:5678/webhook/generate-api-docs${NC}"
    echo -e "${BLUE}   • Tests:       http://localhost:5678/webhook/generate-tests${NC}"
    echo ""
}

# Ejecutar función principal
main
