#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Función para imprimir mensajes
log() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

success() {
    echo -e "${GREEN}[SUCCESS] $1${NC}"
}

# Probar workflow de procesamiento de documentos
test_document_processing() {
    log "Probando workflow de procesamiento de documentos..."
    
    response=$(curl -s -X POST http://localhost:5678/webhook/process-document \
        -H 'Content-Type: application/json' \
        -d '{
            "text": "Este es un documento de prueba que necesita ser procesado y analizado.",
            "metadata": {
                "type": "test",
                "language": "es",
                "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"
            }
        }')
    
    if [ $? -eq 0 ] && [ "$(echo $response | jq -r '.success')" == "true" ]; then
        success "Workflow de procesamiento de documentos funcionando correctamente"
        echo "Respuesta:"
        echo $response | jq '.'
        return 0
    else
        error "Error en workflow de procesamiento de documentos"
        echo "Respuesta de error:"
        echo $response | jq '.'
        return 1
    fi
}

# Probar workflow de chatbot
test_chatbot() {
    log "Probando workflow de chatbot..."
    
    # Primera interacción
    response1=$(curl -s -X POST http://localhost:5678/webhook/chat \
        -H 'Content-Type: application/json' \
        -d '{
            "session_id": "test-session-123",
            "question": "¿Cuál es la capital de Francia?"
        }')
    
    if [ $? -ne 0 ]; then
        error "Error en primera interacción del chatbot"
        return 1
    fi
    
    # Segunda interacción (con contexto)
    response2=$(curl -s -X POST http://localhost:5678/webhook/chat \
        -H 'Content-Type: application/json' \
        -d '{
            "session_id": "test-session-123",
            "question": "¿Cuál es su población?"
        }')
    
    if [ $? -eq 0 ]; then
        success "Workflow de chatbot funcionando correctamente"
        echo "Primera respuesta:"
        echo $response1 | jq '.'
        echo "Segunda respuesta (con contexto):"
        echo $response2 | jq '.'
        return 0
    else
        error "Error en segunda interacción del chatbot"
        return 1
    fi
}

# Probar nodo personalizado de Ollama
test_ollama_node() {
    log "Probando nodo personalizado de Ollama..."
    
    response=$(curl -s -X POST http://localhost:5678/webhook/test-ollama \
        -H 'Content-Type: application/json' \
        -d '{
            "operation": "generate",
            "model": "mistral",
            "text": "Escribe un breve resumen sobre la inteligencia artificial.",
            "temperature": 0.7,
            "max_tokens": 200
        }')
    
    if [ $? -eq 0 ] && [ "$(echo $response | jq -r '.success')" == "true" ]; then
        success "Nodo personalizado de Ollama funcionando correctamente"
        echo "Respuesta:"
        echo $response | jq '.'
        return 0
    else
        error "Error en nodo personalizado de Ollama"
        echo "Respuesta de error:"
        echo $response | jq '.'
        return 1
    fi
}

# Función principal
main() {
    log "Iniciando pruebas de workflows..."
    
    # Verificar que n8n está funcionando
    if ! curl -s http://localhost:5678/healthz > /dev/null; then
        error "n8n no está respondiendo"
        exit 1
    fi
    
    # Ejecutar pruebas
    test_document_processing || exit 1
    test_chatbot || exit 1
    test_ollama_node || exit 1
    
    success "Todas las pruebas de workflows completadas exitosamente"
}

# Ejecutar script
main
