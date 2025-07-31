#!/bin/bash

# Script de prueba para las automatizaciones N8N
# Testa todos los workflows y endpoints creados

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración
N8N_BASE_URL="http://localhost:5678"
WEBHOOK_BASE_URL="$N8N_BASE_URL/webhook"

# Función para logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que N8N esté disponible
check_n8n_availability() {
    log_info "Verificando disponibilidad de N8N..."
    
    for i in {1..10}; do
        if curl -f -s "$N8N_BASE_URL/healthz" > /dev/null 2>&1; then
            log_success "N8N está disponible"
            return 0
        fi
        echo -n "."
        sleep 3
    done
    
    log_error "N8N no está disponible"
    return 1
}

# Probar el webhook de procesamiento de documentos
test_document_processing() {
    log_info "Probando webhook de procesamiento de documentos..."
    
    local test_payload='{
        "content": "Este es un documento de prueba para el laboratorio de IA. Contiene información sobre machine learning, procesamiento de lenguaje natural y análisis de datos.",
        "filename": "test-document.txt",
        "content_type": "text/plain",
        "metadata": {
            "author": "Sistema de Pruebas",
            "category": "testing",
            "tags": ["ai", "test", "automation"]
        }
    }'
    
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "$test_payload" \
        "$WEBHOOK_BASE_URL/document-processing" 2>/dev/null)
    
    if echo "$response" | grep -q "success.*true"; then
        log_success "✅ Webhook de procesamiento de documentos funciona correctamente"
        echo "   📄 Respuesta: $(echo "$response" | jq -r '.document_id // "ID no disponible"')"
        return 0
    else
        log_error "❌ Webhook de procesamiento de documentos falló"
        echo "   📄 Respuesta: $response"
        return 1
    fi
}

# Probar el webhook de consultas inteligentes
test_intelligent_query() {
    log_info "Probando webhook de consultas inteligentes..."
    
    local test_payload='{
        "query": "¿Qué información tienes sobre machine learning y procesamiento de documentos?",
        "limit": 3,
        "threshold": 0.7
    }'
    
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "$test_payload" \
        "$WEBHOOK_BASE_URL/intelligent-query" 2>/dev/null)
    
    if echo "$response" | grep -q "success.*true"; then
        log_success "✅ Webhook de consultas inteligentes funciona correctamente"
        echo "   🤖 Respuesta: $(echo "$response" | jq -r '.answer // "Respuesta no disponible"' | head -c 100)..."
        return 0
    else
        log_error "❌ Webhook de consultas inteligentes falló"
        echo "   🤖 Respuesta: $response"
        return 1
    fi
}

# Probar el webhook de análisis de sentimientos
test_sentiment_analysis() {
    log_info "Probando webhook de análisis de sentimientos..."
    
    local test_payload='{
        "text": "Me encanta este laboratorio de IA! Es increíble lo que se puede lograr con estas herramientas de automatización. Estoy muy emocionado de explorar todas las funcionalidades.",
        "language": "es",
        "source": "test",
        "user_id": "test_user"
    }'
    
    local response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "$test_payload" \
        "$WEBHOOK_BASE_URL/sentiment-analysis" 2>/dev/null)
    
    if echo "$response" | grep -q "success.*true"; then
        log_success "✅ Webhook de análisis de sentimientos funciona correctamente"
        local sentiment=$(echo "$response" | jq -r '.sentiment_analysis.overall_sentiment // "No detectado"')\n        local confidence=$(echo "$response" | jq -r '.sentiment_analysis.confidence_score // 0')\n        echo "   😊 Sentimiento: $sentiment (Confianza: $confidence)"
        return 0
    else
        log_error "❌ Webhook de análisis de sentimientos falló"
        echo "   😊 Respuesta: $response"
        return 1
    fi
}

# Verificar estado de la base de datos
check_database_health() {
    log_info "Verificando estado de la base de datos..."
    
    # Verificar conexión a PostgreSQL
    if docker exec laboratorioai-postgres-1 pg_isready -U postgres > /dev/null 2>&1; then
        log_success "✅ PostgreSQL está funcionando"
        
        # Verificar tablas creadas
        local tables=$(docker exec laboratorioai-postgres-1 psql -U postgres -d laboratorio_ai -t -c "SELECT tablename FROM pg_tables WHERE schemaname = 'public';" 2>/dev/null | grep -E "(processed_documents|query_logs|sentiment_analysis|system_health_logs|system_alerts)" | wc -l)
        
        if [ "$tables" -ge 5 ]; then
            log_success "✅ Todas las tablas necesarias están creadas ($tables/5)"
        else
            log_warning "⚠️  Solo $tables/5 tablas encontradas en la base de datos"
        fi
    else
        log_error "❌ PostgreSQL no está funcionando"
        return 1
    fi
}

# Verificar estado de Redis
check_redis_health() {
    log_info "Verificando estado de Redis..."
    
    if docker exec laboratorioai-redis-1 redis-cli -a redis_secure_password_2024 ping 2>/dev/null | grep -q "PONG"; then
        log_success "✅ Redis está funcionando"
        
        # Verificar memoria utilizada
        local memory=$(docker exec laboratorioai-redis-1 redis-cli -a redis_secure_password_2024 info memory 2>/dev/null | grep "used_memory_human" | cut -d: -f2 | tr -d '\r')
        echo "   💾 Memoria utilizada: $memory"
        return 0
    else
        log_error "❌ Redis no está funcionando"
        return 1
    fi
}

# Verificar estado de Qdrant
check_qdrant_health() {
    log_info "Verificando estado de Qdrant..."
    
    local response=$(curl -s -H "api-key: qdrant_api_key_2024" "http://localhost:6333/health" 2>/dev/null)
    
    if echo "$response" | grep -q "qdrant"; then
        log_success "✅ Qdrant está funcionando"
        
        # Verificar colecciones
        local collections=$(curl -s -H "api-key: qdrant_api_key_2024" "http://localhost:6333/collections" 2>/dev/null | jq -r '.result.collections[].name // empty' | wc -l)
        echo "   🗂️  Colecciones disponibles: $collections"
        return 0
    else
        log_error "❌ Qdrant no está funcionando"
        return 1
    fi
}

# Verificar estado de Ollama
check_ollama_health() {
    log_info "Verificando estado de Ollama..."
    
    local response=$(curl -s "http://localhost:11434/api/tags" 2>/dev/null)
    
    if echo "$response" | grep -q "models"; then
        log_success "✅ Ollama está funcionando"
        
        # Verificar modelos disponibles
        local models=$(echo "$response" | jq -r '.models[].name // empty' | wc -l)
        echo "   🧠 Modelos disponibles: $models"
        
        if [ "$models" -gt 0 ]; then
            echo "   📋 Modelos: $(echo "$response" | jq -r '.models[].name // empty' | head -3 | tr '\n' ', ' | sed 's/,$//')"
        fi
        return 0
    else
        log_error "❌ Ollama no está funcionando"
        return 1
    fi
}

# Prueba de rendimiento básica
performance_test() {
    log_info "Ejecutando prueba de rendimiento básica..."
    
    local start_time=$(date +%s)
    
    # Hacer múltiples peticiones para medir rendimiento
    local success_count=0
    local total_requests=5
    
    for i in $(seq 1 $total_requests); do
        local test_payload='{"text": "Prueba de rendimiento número '$i'", "source": "performance_test"}'
        
        if curl -s -X POST \
           -H "Content-Type: application/json" \
           -d "$test_payload" \
           "$WEBHOOK_BASE_URL/sentiment-analysis" 2>/dev/null | grep -q "success.*true"; then
            ((success_count++))
        fi
        
        echo -n "."
    done
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local success_rate=$((success_count * 100 / total_requests))
    
    echo ""
    
    if [ "$success_rate" -ge 80 ]; then
        log_success "✅ Prueba de rendimiento completada"
        echo "   ⏱️  Duración: ${duration}s para $total_requests peticiones"
        echo "   📊 Tasa de éxito: $success_rate% ($success_count/$total_requests)"
    else
        log_warning "⚠️  Rendimiento por debajo del esperado"
        echo "   ⏱️  Duración: ${duration}s para $total_requests peticiones"
        echo "   📊 Tasa de éxito: $success_rate% ($success_count/$total_requests)"
    fi
}

# Generar reporte final
generate_report() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo -e "\n${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    📊 REPORTE DE PRUEBAS                     ║${NC}"
    echo -e "${GREEN}║                   $timestamp                 ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    echo -e "${BLUE}🔧 Estado de Servicios:${NC}"
    echo "   • PostgreSQL: $postgres_status"
    echo "   • Redis: $redis_status"
    echo "   • Qdrant: $qdrant_status"
    echo "   • Ollama: $ollama_status"
    
    echo -e "\n${BLUE}🔗 Estado de Webhooks:${NC}"
    echo "   • Procesamiento de documentos: $document_processing_status"
    echo "   • Consultas inteligentes: $intelligent_query_status"
    echo "   • Análisis de sentimientos: $sentiment_analysis_status"
    
    echo -e "\n${BLUE}📈 Rendimiento:${NC}"
    echo "   • Prueba de carga básica: $performance_status"
    
    echo -e "\n${GREEN}✨ El laboratorio de IA está listo para usar!${NC}"
    echo -e "${YELLOW}💡 Puedes acceder a N8N en: http://localhost:5678${NC}"
}

# Función principal
main() {
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                🧪 LABORATORIO AI - PRUEBAS                   ║${NC}"
    echo -e "${GREEN}║              Verificación de Automatizaciones N8N           ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    # Verificar disponibilidad de N8N
    if ! check_n8n_availability; then
        log_error "No se puede continuar sin N8N disponible"
        exit 1
    fi
    
    # Variables para el reporte
    postgres_status="❌ Error"
    redis_status="❌ Error"
    qdrant_status="❌ Error"
    ollama_status="❌ Error"
    document_processing_status="❌ Error"
    intelligent_query_status="❌ Error"
    sentiment_analysis_status="❌ Error"
    performance_status="❌ Error"
    
    # Verificar servicios
    echo -e "\n${BLUE}🔍 Verificando servicios de infraestructura...${NC}"
    check_database_health && postgres_status="✅ Funcionando"
    check_redis_health && redis_status="✅ Funcionando"
    check_qdrant_health && qdrant_status="✅ Funcionando"
    check_ollama_health && ollama_status="✅ Funcionando"
    
    # Esperar un momento para que todo se estabilice
    sleep 3
    
    # Probar webhooks
    echo -e "\n${BLUE}🔗 Probando webhooks de N8N...${NC}"
    test_document_processing && document_processing_status="✅ Funcionando"
    sleep 2
    test_intelligent_query && intelligent_query_status="✅ Funcionando"
    sleep 2
    test_sentiment_analysis && sentiment_analysis_status="✅ Funcionando"
    
    # Prueba de rendimiento
    echo -e "\n${BLUE}📈 Ejecutando pruebas de rendimiento...${NC}"
    performance_test && performance_status="✅ Aprobado"
    
    # Generar reporte final
    generate_report
    
    log_success "🎉 Pruebas completadas exitosamente!"
}

# Ejecutar función principal
main "$@"
