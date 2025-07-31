#!/bin/bash

# Script de inicialización automática para N8N
# Configura workflows, credenciales y esquemas de base de datos

set -e

echo "🚀 Iniciando configuración automática de N8N..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Esperar a que PostgreSQL esté disponible
wait_for_postgres() {
    log_info "Esperando a que PostgreSQL esté disponible..."
    
    for i in {1..30}; do
        if docker exec laboratorioai-postgres-1 pg_isready -U postgres > /dev/null 2>&1; then
            log_success "PostgreSQL está disponible"
            return 0
        fi
        echo -n "."
        sleep 2
    done
    
    log_error "PostgreSQL no está disponible después de 60 segundos"
    return 1
}

# Esperar a que Redis esté disponible
wait_for_redis() {
    log_info "Esperando a que Redis esté disponible..."
    
    for i in {1..15}; do
        if docker exec laboratorioai-redis-1 redis-cli -a redis_secure_password_2024 ping > /dev/null 2>&1; then
            log_success "Redis está disponible"
            return 0
        fi
        echo -n "."
        sleep 2
    done
    
    log_error "Redis no está disponible después de 30 segundos"
    return 1
}

# Crear esquemas de base de datos para N8N workflows
create_database_schemas() {
    log_info "Creando esquemas de base de datos para N8N workflows..."
    
    # Tabla para logs de queries inteligentes
    docker exec laboratorioai-postgres-1 psql -U postgres -d laboratorio_ai -c "
    CREATE TABLE IF NOT EXISTS query_logs (
        id SERIAL PRIMARY KEY,
        query_id VARCHAR(255) UNIQUE NOT NULL,
        original_query TEXT NOT NULL,
        documents_found INTEGER DEFAULT 0,
        response_generated TEXT,
        timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
        processing_time_ms INTEGER DEFAULT 0,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );
    
    CREATE INDEX IF NOT EXISTS idx_query_logs_timestamp ON query_logs(timestamp);
    CREATE INDEX IF NOT EXISTS idx_query_logs_query_id ON query_logs(query_id);
    " && log_success "Tabla query_logs creada"
    
    # Tabla para análisis de sentimientos
    docker exec laboratorioai-postgres-1 psql -U postgres -d laboratorio_ai -c "
    CREATE TABLE IF NOT EXISTS sentiment_analysis (
        id SERIAL PRIMARY KEY,
        analysis_id VARCHAR(255) UNIQUE NOT NULL,
        original_text TEXT NOT NULL,
        overall_sentiment VARCHAR(20) NOT NULL,
        sentiment_score DECIMAL(5,3) DEFAULT 0.0,
        confidence_score DECIMAL(5,3) DEFAULT 0.0,
        emotional_indicators JSONB DEFAULT '[]'::jsonb,
        key_phrases JSONB DEFAULT '[]'::jsonb,
        sentiment_breakdown JSONB DEFAULT '{}'::jsonb,
        reasoning TEXT,
        word_count INTEGER DEFAULT 0,
        sentence_count INTEGER DEFAULT 0,
        language VARCHAR(50) DEFAULT 'unknown',
        source VARCHAR(100) DEFAULT 'api',
        user_id VARCHAR(255) DEFAULT 'anonymous',
        created_at TIMESTAMP WITH TIME ZONE NOT NULL,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );
    
    CREATE INDEX IF NOT EXISTS idx_sentiment_analysis_timestamp ON sentiment_analysis(created_at);
    CREATE INDEX IF NOT EXISTS idx_sentiment_analysis_sentiment ON sentiment_analysis(overall_sentiment);
    CREATE INDEX IF NOT EXISTS idx_sentiment_analysis_user ON sentiment_analysis(user_id);
    " && log_success "Tabla sentiment_analysis creada"
    
    # Tabla para documentos procesados
    docker exec laboratorioai-postgres-1 psql -U postgres -d laboratorio_ai -c "
    CREATE TABLE IF NOT EXISTS processed_documents (
        id SERIAL PRIMARY KEY,
        document_id VARCHAR(255) UNIQUE NOT NULL,
        filename VARCHAR(255) NOT NULL,
        content_type VARCHAR(100) NOT NULL,
        file_size INTEGER DEFAULT 0,
        content_preview TEXT,
        embedding_status VARCHAR(50) DEFAULT 'pending',
        qdrant_point_id VARCHAR(255),
        processing_metadata JSONB DEFAULT '{}'::jsonb,
        error_message TEXT,
        processed_at TIMESTAMP WITH TIME ZONE,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );
    
    CREATE INDEX IF NOT EXISTS idx_processed_documents_status ON processed_documents(embedding_status);
    CREATE INDEX IF NOT EXISTS idx_processed_documents_type ON processed_documents(content_type);
    " && log_success "Tabla processed_documents creada"
    
    log_success "Todos los esquemas de base de datos han sido creados"
}

# Esperar a que N8N esté disponible
wait_for_n8n() {
    log_info "Esperando a que N8N esté disponible..."
    
    for i in {1..60}; do
        if curl -f http://localhost:5678/healthz > /dev/null 2>&1; then
            log_success "N8N está disponible"
            return 0
        fi
        echo -n "."
        sleep 3
    done
    
    log_error "N8N no está disponible después de 180 segundos"
    return 1
}

# Configurar variables de entorno para N8N API
setup_n8n_env() {
    export N8N_API_URL="http://localhost:5678/api/v1"
    export N8N_USER_EMAIL="admin@laboratorio.ai"
    export N8N_USER_PASSWORD="admin_secure_password_2024"
}

# Importar credenciales a N8N
import_credentials() {
    log_info "Importando credenciales a N8N..."
    
    local credentials_dir="/home/dev1/Escritorio/proyectos/AGI/laboratorioAI/n8n/credentials"
    
    # Importar credenciales de PostgreSQL
    if [ -f "$credentials_dir/postgres-main.json" ]; then
        docker exec laboratorioai-n8n-1 n8n import:credentials --input=/home/node/.n8n/credentials/postgres-main.json 2>/dev/null || log_warning "Credenciales PostgreSQL ya existen o falló la importación"
    fi
    
    # Importar credenciales de Redis
    if [ -f "$credentials_dir/redis-main.json" ]; then
        docker exec laboratorioai-n8n-1 n8n import:credentials --input=/home/node/.n8n/credentials/redis-main.json 2>/dev/null || log_warning "Credenciales Redis ya existen o falló la importación"
    fi
    
    log_success "Importación de credenciales completada"
}

# Importar workflows a N8N
import_workflows() {
    log_info "Importando workflows a N8N..."
    
    local workflows_dir="/home/dev1/Escritorio/proyectos/AGI/laboratorioAI/n8n/workflows"
    
    # Importar workflow de procesamiento de documentos
    if [ -f "$workflows_dir/document-processing-automation.json" ]; then
        docker exec laboratorioai-n8n-1 n8n import:workflow --input=/home/node/.n8n/workflows/document-processing-automation.json 2>/dev/null || log_warning "Workflow de procesamiento de documentos ya existe o falló la importación"
        log_success "Workflow de procesamiento de documentos importado"
    fi
    
    # Importar workflow de consultas inteligentes
    if [ -f "$workflows_dir/intelligent-query-system.json" ]; then
        docker exec laboratorioai-n8n-1 n8n import:workflow --input=/home/node/.n8n/workflows/intelligent-query-system.json 2>/dev/null || log_warning "Workflow de consultas inteligentes ya existe o falló la importación"
        log_success "Workflow de consultas inteligentes importado"
    fi
    
    # Importar workflow de análisis de sentimientos
    if [ -f "$workflows_dir/sentiment-analysis-pipeline.json" ]; then
        docker exec laboratorioai-n8n-1 n8n import:workflow --input=/home/node/.n8n/workflows/sentiment-analysis-pipeline.json 2>/dev/null || log_warning "Workflow de análisis de sentimientos ya existe o falló la importación"
        log_success "Workflow de análisis de sentimientos importado"
    fi
    
    log_success "Todos los workflows han sido importados"
}

# Activar workflows
activate_workflows() {
    log_info "Activando workflows..."
    
    # Lista de IDs de workflows (basado en los archivos JSON)
    local workflow_ids=("1" "2" "3")
    
    for workflow_id in "${workflow_ids[@]}"; do
        docker exec laboratorioai-n8n-1 n8n workflow:activate --id="$workflow_id" 2>/dev/null || log_warning "No se pudo activar workflow ID: $workflow_id"
    done
    
    log_success "Workflows activados"
}

# Configurar colección en Qdrant
setup_qdrant_collection() {
    log_info "Configurando colección en Qdrant..."
    
    # Crear colección para documentos si no existe
    curl -X PUT "http://localhost:6333/collections/documents" \
         -H "Content-Type: application/json" \
         -H "api-key: qdrant_api_key_2024" \
         -d '{
           "vectors": {
             "size": 768,
             "distance": "Cosine"
           },
           "optimizers_config": {
             "default_segment_number": 2
           },
           "replication_factor": 1
         }' > /dev/null 2>&1 || log_warning "Colección Qdrant ya existe o falló la creación"
    
    log_success "Colección Qdrant configurada"
}

# Verificar estado de servicios
verify_services() {
    log_info "Verificando estado de servicios..."
    
    local services=("postgres" "redis" "qdrant" "ollama" "n8n")
    local all_healthy=true
    
    for service in "${services[@]}"; do
        if docker ps --filter "name=laboratorioai-${service}-1" --filter "status=running" | grep -q "${service}"; then
            log_success "✅ $service está ejecutándose"
        else
            log_error "❌ $service no está ejecutándose"
            all_healthy=false
        fi
    done
    
    if $all_healthy; then
        log_success "Todos los servicios están ejecutándose correctamente"
        return 0
    else
        log_error "Algunos servicios no están funcionando correctamente"
        return 1
    fi
}

# Mostrar información de endpoints
show_endpoints() {
    echo -e "\n${GREEN}🎉 Configuración completada exitosamente!${NC}\n"
    
    echo -e "${BLUE}📋 Endpoints disponibles:${NC}"
    echo -e "   • N8N Dashboard: ${YELLOW}http://localhost:5678${NC}"
    echo -e "   • OpenWebUI: ${YELLOW}http://localhost:3000${NC}"
    echo -e "   • Qdrant Dashboard: ${YELLOW}http://localhost:6333/dashboard${NC}"
    echo -e "   • Ollama API: ${YELLOW}http://localhost:11434${NC}"
    
    echo -e "\n${BLUE}🔗 Webhooks de N8N:${NC}"
    echo -e "   • Procesamiento de documentos: ${YELLOW}http://localhost:5678/webhook/document-processing${NC}"
    echo -e "   • Consultas inteligentes: ${YELLOW}http://localhost:5678/webhook/intelligent-query${NC}"
    echo -e "   • Análisis de sentimientos: ${YELLOW}http://localhost:5678/webhook/sentiment-analysis${NC}"
    
    echo -e "\n${BLUE}🔐 Credenciales por defecto:${NC}"
    echo -e "   • N8N: admin@laboratorio.ai / admin_secure_password_2024"
    echo -e "   • PostgreSQL: postgres / postgres_password_2024"
    echo -e "   • Redis: (password) redis_secure_password_2024"
    
    echo -e "\n${GREEN}🚀 Tu laboratorio de IA está listo para usar!${NC}"
}

# Función principal
main() {
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                  🤖 LABORATORIO AI - N8N SETUP              ║${NC}"
    echo -e "${GREEN}║              Configuración Automática de Workflows          ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    # Configurar entorno
    setup_n8n_env
    
    # Esperar servicios
    wait_for_postgres || exit 1
    wait_for_redis || exit 1
    
    # Configurar base de datos
    create_database_schemas || exit 1
    
    # Configurar Qdrant
    setup_qdrant_collection
    
    # Esperar N8N
    wait_for_n8n || exit 1
    
    # Configurar N8N
    import_credentials
    import_workflows
    activate_workflows
    
    # Verificar servicios
    verify_services || exit 1
    
    # Mostrar información final
    show_endpoints
    
    log_success "¡Configuración automática de N8N completada exitosamente! 🎉"
}

# Ejecutar función principal
main "$@"
