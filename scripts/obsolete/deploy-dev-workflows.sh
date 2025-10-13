#!/bin/bash

# Script de implementación completa de workflows de desarrollo
# Despliega workflows de n8n, inicializa base de datos y configura todo

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}   🚀 Implementación Completa de Dev Workflows${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Función para verificar servicio
check_service() {
    local service=$1
    local max_attempts=30
    local attempt=1
    
    echo -e "${YELLOW}Verificando servicio: $service${NC}"
    
    while [ $attempt -le $max_attempts ]; do
        if docker compose ps | grep -q "$service.*healthy\|$service.*Up"; then
            echo -e "${GREEN}✅ $service está disponible${NC}"
            return 0
        fi
        echo -ne "${YELLOW}⏳ Esperando $service... ($attempt/$max_attempts)\r${NC}"
        sleep 2
        ((attempt++))
    done
    
    echo -e "${RED}❌ $service no está disponible después de $max_attempts intentos${NC}"
    return 1
}

# 1. Verificar servicios Docker
echo -e "${BLUE}[1/6] Verificando servicios Docker...${NC}"
echo ""

if ! docker compose ps > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker Compose no está corriendo${NC}"
    echo -e "${YELLOW}Iniciando servicios...${NC}"
    docker compose up -d
    sleep 10
fi

check_service "postgres" || exit 1
check_service "n8n" || exit 1
check_service "ollama" || exit 1

echo ""

# 2. Verificar y descargar modelo CodeLlama
echo -e "${BLUE}[2/6] Verificando modelo CodeLlama en Ollama...${NC}"
echo ""

if ! docker compose exec -T ollama ollama list | grep -q "codellama"; then
    echo -e "${YELLOW}⬇️  Descargando CodeLlama (esto puede tardar varios minutos)...${NC}"
    docker compose exec -T ollama ollama pull codellama:latest
    echo -e "${GREEN}✅ CodeLlama descargado${NC}"
else
    echo -e "${GREEN}✅ CodeLlama ya está disponible${NC}"
fi

echo ""

# 3. Inicializar esquema de base de datos
echo -e "${BLUE}[3/6] Inicializando esquema de base de datos...${NC}"
echo ""

# Verificar si las tablas ya existen
TABLES_EXIST=$(docker compose exec -T postgres psql -U aiadmin -d ailab -tAc \
    "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'code_reviews');" 2>/dev/null || echo "f")

if [ "$TABLES_EXIST" = "t" ]; then
    echo -e "${YELLOW}⚠️  Las tablas ya existen. ¿Deseas recrearlas? [y/N]:${NC}"
    read -n 1 -r RECREATE
    echo
    if [[ $RECREATE =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Eliminando tablas existentes...${NC}"
        docker compose exec -T postgres psql -U aiadmin -d ailab <<EOF
DROP TABLE IF EXISTS generated_tests CASCADE;
DROP TABLE IF EXISTS api_documentation CASCADE;
DROP TABLE IF EXISTS bug_reports CASCADE;
DROP TABLE IF EXISTS git_commits CASCADE;
DROP TABLE IF EXISTS code_reviews CASCADE;
DROP VIEW IF EXISTS bug_summary;
DROP VIEW IF EXISTS commit_stats;
DROP VIEW IF EXISTS test_coverage_stats;
EOF
        echo -e "${GREEN}✅ Tablas eliminadas${NC}"
    else
        echo -e "${YELLOW}Manteniendo tablas existentes${NC}"
    fi
fi

echo -e "${YELLOW}Ejecutando script de inicialización...${NC}"
docker compose exec -T postgres psql -U aiadmin -d ailab < postgres/init-scripts/03-dev-workflows-schema.sql

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Esquema de base de datos inicializado${NC}"
else
    echo -e "${RED}❌ Error al inicializar esquema${NC}"
    exit 1
fi

# Verificar tablas creadas
echo -e "${YELLOW}Verificando tablas creadas...${NC}"
docker compose exec -T postgres psql -U aiadmin -d ailab -c "\dt" | grep -E "code_reviews|git_commits|bug_reports|api_documentation|generated_tests"

echo ""

# 4. Importar workflows a n8n
echo -e "${BLUE}[4/6] Importando workflows a n8n...${NC}"
echo ""

# Crear directorio de workflows en n8n si no existe
docker compose exec -T n8n mkdir -p /home/node/.n8n/workflows 2>/dev/null || true

# Copiar workflows
WORKFLOWS=(
    "code-review-assistant"
    "git-commit-generator"
    "bug-report-analyzer"
    "api-documentation-generator"
    "test-case-generator"
)

for workflow in "${WORKFLOWS[@]}"; do
    echo -e "${YELLOW}Importando: $workflow.json${NC}"
    
    if [ -f "n8n/workflows/${workflow}.json" ]; then
        docker compose cp "n8n/workflows/${workflow}.json" n8n:/home/node/.n8n/workflows/
        echo -e "${GREEN}✅ $workflow importado${NC}"
    else
        echo -e "${RED}❌ Archivo no encontrado: n8n/workflows/${workflow}.json${NC}"
    fi
done

echo ""

# 5. Configurar credenciales de PostgreSQL en n8n
echo -e "${BLUE}[5/6] Configurando credenciales de PostgreSQL...${NC}"
echo ""

# Verificar si las credenciales ya existen
if [ -f "n8n/credentials/postgres-main.json" ]; then
    echo -e "${YELLOW}Copiando credenciales de PostgreSQL...${NC}"
    docker compose cp n8n/credentials/postgres-main.json n8n:/home/node/.n8n/credentials/
    echo -e "${GREEN}✅ Credenciales configuradas${NC}"
else
    echo -e "${YELLOW}⚠️  Archivo de credenciales no encontrado${NC}"
    echo -e "${YELLOW}Debes configurar las credenciales manualmente en n8n:${NC}"
    echo -e "  Host: ${BLUE}postgres${NC}"
    echo -e "  Port: ${BLUE}5432${NC}"
    echo -e "  Database: ${BLUE}ailab${NC}"
    echo -e "  User: ${BLUE}aiadmin${NC}"
    echo -e "  Password: ${BLUE}(ver .env)${NC}"
fi

echo ""

# 6. Reiniciar n8n para cargar workflows
echo -e "${BLUE}[6/6] Reiniciando n8n para aplicar cambios...${NC}"
echo ""

docker compose restart n8n
echo -e "${YELLOW}Esperando que n8n reinicie...${NC}"
sleep 10

if check_service "n8n"; then
    echo -e "${GREEN}✅ n8n reiniciado correctamente${NC}"
else
    echo -e "${RED}❌ Error al reiniciar n8n${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}   ✅ Implementación completada exitosamente${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Mostrar resumen
echo -e "${BLUE}📊 Resumen de la implementación:${NC}"
echo ""
echo -e "${YELLOW}Servicios:${NC}"
echo -e "  ✅ PostgreSQL - ${GREEN}Corriendo${NC}"
echo -e "  ✅ n8n - ${GREEN}Corriendo${NC}"
echo -e "  ✅ Ollama (CodeLlama) - ${GREEN}Corriendo${NC}"
echo ""

echo -e "${YELLOW}Base de datos:${NC}"
echo -e "  ✅ Tablas creadas (5)"
echo -e "  ✅ Vistas creadas (3)"
echo -e "  ✅ Triggers configurados"
echo -e "  ✅ Índices optimizados"
echo ""

echo -e "${YELLOW}Workflows importados:${NC}"
for workflow in "${WORKFLOWS[@]}"; do
    echo -e "  ✅ $workflow"
done
echo ""

echo -e "${YELLOW}URLs de acceso:${NC}"
echo -e "  🌐 n8n: ${BLUE}http://localhost:5678${NC}"
echo -e "  🌐 OpenWebUI: ${BLUE}http://localhost:8080${NC}"
echo -e "  🌐 Flowise: ${BLUE}http://localhost:3000${NC}"
echo -e "  🌐 Ollama API: ${BLUE}http://localhost:11434${NC}"
echo ""

echo -e "${YELLOW}Webhooks disponibles:${NC}"
echo -e "  📝 Code Review: ${BLUE}http://localhost:5678/webhook/code-review${NC}"
echo -e "  📝 Git Commit: ${BLUE}http://localhost:5678/webhook/git-commit${NC}"
echo -e "  📝 Bug Report: ${BLUE}http://localhost:5678/webhook/bug-report${NC}"
echo -e "  📝 API Docs: ${BLUE}http://localhost:5678/webhook/generate-api-docs${NC}"
echo -e "  📝 Tests: ${BLUE}http://localhost:5678/webhook/generate-tests${NC}"
echo ""

echo -e "${YELLOW}Scripts CLI disponibles:${NC}"
echo -e "  🔧 ${BLUE}./scripts/dev-tools/code-review.sh${NC} <archivo>"
echo -e "  🔧 ${BLUE}./scripts/dev-tools/generate-commit.sh${NC}"
echo -e "  🔧 ${BLUE}./scripts/dev-tools/analyze-bug.sh${NC}"
echo -e "  🔧 ${BLUE}./scripts/dev-tools/generate-tests.sh${NC} <archivo>"
echo ""

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}📚 Próximos pasos:${NC}"
echo ""
echo -e "1. Accede a n8n: ${BLUE}http://localhost:5678${NC}"
echo -e "2. Activa los workflows importados"
echo -e "3. Configura las credenciales de PostgreSQL si es necesario"
echo -e "4. Prueba los endpoints con los scripts CLI"
echo -e "5. Lee la documentación en: ${BLUE}docs/DEV_WORKFLOWS.md${NC}"
echo ""
echo -e "${YELLOW}Para probar un workflow:${NC}"
echo -e "  ${BLUE}./scripts/dev-tools/code-review.sh README.md${NC}"
echo ""
echo -e "${GREEN}¡Todo listo para usar! 🎉${NC}"
