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

# Función para verificar si un servicio está respondiendo
check_service() {
    local service=$1
    local port=$2
    local max_retries=30
    local retry=0

    log "Verificando servicio $service en puerto $port..."
    
    while ! nc -z localhost $port; do
        if [ $retry -eq $max_retries ]; then
            error "El servicio $service no respondió después de $max_retries intentos"
            return 1
        fi
        retry=$((retry + 1))
        echo -n "."
        sleep 2
    done
    success "Servicio $service está respondiendo en puerto $port"
    return 0
}

# Función para probar Ollama
test_ollama() {
    log "Probando Ollama..."
    
    # Verificar que el servicio está corriendo
    check_service "ollama" "11434" || return 1
    
    # Probar API de Ollama
    response=$(curl -s -X POST http://localhost:11434/api/generate \
        -H 'Content-Type: application/json' \
        -d '{"model": "mistral", "prompt": "Hello, how are you?"}')
    
    if [ $? -eq 0 ] && [ "$(echo $response | jq -r '.response')" != "" ]; then
        success "Ollama está funcionando correctamente"
        return 0
    else
        error "Error al probar Ollama API"
        return 1
    fi
}

# Función para probar Floowise
test_floowise() {
    log "Probando Floowise..."
    
    # Verificar que el servicio está corriendo
    check_service "floowise" "3000" || return 1
    
    # Probar API de Floowise
    response=$(curl -s -X GET http://localhost:3000/api/v1/health)
    
    if [ $? -eq 0 ] && [ "$(echo $response | jq -r '.status')" == "ok" ]; then
        success "Floowise está funcionando correctamente"
        return 0
    else
        error "Error al probar Floowise API"
        return 1
    fi
}

# Función para probar n8n
test_n8n() {
    log "Probando n8n..."
    
    # Verificar que el servicio está corriendo
    check_service "n8n" "5678" || return 1
    
    # Probar API de n8n
    response=$(curl -s -X GET http://localhost:5678/healthz)
    
    if [ $? -eq 0 ]; then
        success "n8n está funcionando correctamente"
        return 0
    else
        error "Error al probar n8n API"
        return 1
    fi
}

# Función para probar Qdrant
test_qdrant() {
    log "Probando Qdrant..."
    
    # Verificar que el servicio está corriendo
    check_service "qdrant" "6333" || return 1
    
    # Probar API de Qdrant
    response=$(curl -s -X GET http://localhost:6333/health)
    
    if [ $? -eq 0 ] && [ "$(echo $response | jq -r '.status')" == "ok" ]; then
        success "Qdrant está funcionando correctamente"
        return 0
    else
        error "Error al probar Qdrant API"
        return 1
    fi
}

# Función para probar la integración completa
test_integration() {
    log "Probando integración completa..."
    
    # Crear una colección de prueba en Qdrant
    curl -X PUT http://localhost:6333/collections/test \
        -H 'Content-Type: application/json' \
        -d '{
            "vectors": {
                "size": 384,
                "distance": "Cosine"
            }
        }'
    
    # Enviar un documento de prueba a través del workflow de n8n
    response=$(curl -s -X POST http://localhost:5678/webhook/process-document \
        -H 'Content-Type: application/json' \
        -d '{
            "text": "This is a test document",
            "metadata": {
                "type": "test",
                "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"
            }
        }')
    
    if [ $? -eq 0 ] && [ "$(echo $response | jq -r '.success')" == "true" ]; then
        success "Integración completa funcionando correctamente"
        return 0
    else
        error "Error en la prueba de integración"
        return 1
    fi
}

# Función para probar el rendimiento
test_performance() {
    log "Iniciando pruebas de rendimiento..."
    
    # Variables para estadísticas
    total_requests=10
    successful_requests=0
    failed_requests=0
    total_time=0
    
    for i in $(seq 1 $total_requests); do
        start_time=$(date +%s.%N)
        
        # Realizar una solicitud de prueba
        response=$(curl -s -X POST http://localhost:11434/api/generate \
            -H 'Content-Type: application/json' \
            -d '{
                "model": "mistral",
                "prompt": "Generate a short response for testing purposes"
            }')
        
        end_time=$(date +%s.%N)
        duration=$(echo "$end_time - $start_time" | bc)
        total_time=$(echo "$total_time + $duration" | bc)
        
        if [ $? -eq 0 ] && [ "$(echo $response | jq -r '.response')" != "" ]; then
            successful_requests=$((successful_requests + 1))
        else
            failed_requests=$((failed_requests + 1))
        fi
        
        echo -n "."
        sleep 1
    done
    
    # Calcular estadísticas
    avg_time=$(echo "scale=3; $total_time / $total_requests" | bc)
    success_rate=$(echo "scale=2; ($successful_requests * 100) / $total_requests" | bc)
    
    echo
    log "Resultados de la prueba de rendimiento:"
    echo "Total de solicitudes: $total_requests"
    echo "Solicitudes exitosas: $successful_requests"
    echo "Solicitudes fallidas: $failed_requests"
    echo "Tiempo promedio de respuesta: ${avg_time}s"
    echo "Tasa de éxito: ${success_rate}%"
}

# Función principal
main() {
    log "Iniciando pruebas del sistema..."
    
    # Verificar dependencias
    command -v jq >/dev/null 2>&1 || { error "jq es requerido pero no está instalado."; exit 1; }
    command -v bc >/dev/null 2>&1 || { error "bc es requerido pero no está instalado."; exit 1; }
    command -v nc >/dev/null 2>&1 || { error "netcat es requerido pero no está instalado."; exit 1; }
    
    # Ejecutar pruebas
    test_ollama || exit 1
    test_floowise || exit 1
    test_n8n || exit 1
    test_qdrant || exit 1
    test_integration || exit 1
    test_performance
    
    success "Todas las pruebas completadas exitosamente"
}

# Ejecutar script
main
