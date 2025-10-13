.PHONY: help start stop restart logs status clean init reset

# Variables
COMPOSE_FILE := docker-compose.yml
PROJECT_NAME := laboratorioai

help: ## Mostrar esta ayuda
	@echo "╔═══════════════════════════════════════════════════════════╗"
	@echo "║          🤖 LaboratorioAI - Comandos Disponibles 🤖      ║"
	@echo "╚═══════════════════════════════════════════════════════════╝"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

start: ## Iniciar todos los servicios y configurar automáticamente
	@echo "🚀 Iniciando LaboratorioAI..."
	@docker compose -f $(COMPOSE_FILE) up -d
	@echo "⏳ Esperando a que los servicios estén listos (30 segundos)..."
	@sleep 30
	@echo "🔧 Ejecutando configuración automática..."
	@./scripts/post-start.sh
	@echo ""
	@echo "✅ Sistema iniciado y configurado"
	@make status

start-no-init: ## Iniciar servicios sin configuración automática
	@echo "🚀 Iniciando LaboratorioAI (sin auto-configuración)..."
	@docker compose -f $(COMPOSE_FILE) up -d
	@echo ""
	@echo "✅ Servicios iniciados"
	@echo "⚠️  Ejecuta 'make init' para configurar el sistema"

stop: ## Detener todos los servicios
	@echo "🛑 Deteniendo LaboratorioAI..."
	@docker compose -f $(COMPOSE_FILE) down
	@echo "✅ Servicios detenidos"

restart: ## Reiniciar todos los servicios
	@make stop
	@sleep 5
	@make start

logs: ## Ver logs de todos los servicios
	@docker compose -f $(COMPOSE_FILE) logs -f

logs-n8n: ## Ver logs de n8n
	@docker compose -f $(COMPOSE_FILE) logs -f n8n

logs-ollama: ## Ver logs de Ollama
	@docker compose -f $(COMPOSE_FILE) logs -f ollama

logs-flowise: ## Ver logs de Flowise
	@docker compose -f $(COMPOSE_FILE) logs -f floowise

status: ## Mostrar estado de los servicios
	@echo "📊 Estado de los servicios:"
	@docker compose -f $(COMPOSE_FILE) ps
	@echo ""
	@echo "🌐 URLs de acceso:"
	@echo "  • n8n:         http://localhost:5678"
	@echo "  • Flowise:     http://localhost:3000"
	@echo "  • OpenWebUI:   http://localhost:8080"
	@echo "  • Ollama API:  http://localhost:11434"
	@echo "  • Qdrant:      http://localhost:6333"

init: ## Ejecutar configuración automática manualmente
	@echo "🔧 Ejecutando configuración automática..."
	@./scripts/docker-init-automation.sh

reset: ## Reinicializar el sistema (borra marca de inicialización)
	@echo "🔄 Reinicializando sistema..."
	@rm -f ./config/.initialized ./config/.init-pending
	@echo "✅ Marcas de inicialización eliminadas"
	@echo "   Ejecuta 'make init' para reconfigurar"

clean: ## Limpiar contenedores, volúmenes y datos (PELIGROSO)
	@echo "⚠️  ADVERTENCIA: Esto eliminará TODOS los datos"
	@read -p "¿Estás seguro? (escribe 'yes' para confirmar): " confirm && [ "$$confirm" = "yes" ] || exit 1
	@echo "🧹 Limpiando sistema..."
	@docker compose -f $(COMPOSE_FILE) down -v
	@rm -rf ./*/data ./config/.initialized ./config/.init-pending
	@echo "✅ Sistema limpio"

build: ## Reconstruir imágenes Docker
	@echo "🔨 Reconstruyendo imágenes..."
	@docker compose -f $(COMPOSE_FILE) build
	@echo "✅ Imágenes reconstruidas"

pull: ## Actualizar imágenes Docker
	@echo "⬇️  Actualizando imágenes..."
	@docker compose -f $(COMPOSE_FILE) pull
	@echo "✅ Imágenes actualizadas"

backup: ## Crear backup de datos
	@echo "💾 Creando backup..."
	@./scripts/backup-data.sh
	@echo "✅ Backup completado"

dev-tools: ## Mostrar información de herramientas de desarrollo
	@echo "🛠️  Herramientas de desarrollo disponibles:"
	@echo ""
	@echo "Scripts CLI:"
	@echo "  ./scripts/dev-tools/code-review.sh <archivo>"
	@echo "  ./scripts/dev-tools/generate-commit.sh"
	@echo "  ./scripts/dev-tools/analyze-bug.sh"
	@echo "  ./scripts/dev-tools/generate-tests.sh <archivo>"
	@echo ""
	@echo "Webhooks activos:"
	@echo "  • Code Review: http://localhost:5678/webhook/code-review"
	@echo "  • Git Commit:  http://localhost:5678/webhook/git-commit"
	@echo "  • Bug Report:  http://localhost:5678/webhook/bug-report"
	@echo "  • API Docs:    http://localhost:5678/webhook/generate-api-docs"
	@echo "  • Tests:       http://localhost:5678/webhook/generate-tests"

test: ## Ejecutar tests de integración
	@echo "🧪 Ejecutando tests..."
	@./scripts/test-lab.sh
	@echo "✅ Tests completados"

health: ## Verificar salud de los servicios
	@echo "🏥 Verificando salud de los servicios..."
	@curl -s http://localhost:5678/healthz > /dev/null && echo "✅ n8n: OK" || echo "❌ n8n: ERROR"
	@curl -s http://localhost:11434/api/tags > /dev/null && echo "✅ Ollama: OK" || echo "❌ Ollama: ERROR"
	@curl -s http://localhost:3000 > /dev/null && echo "✅ Flowise: OK" || echo "❌ Flowise: ERROR"
	@curl -s http://localhost:6333 > /dev/null && echo "✅ Qdrant: OK" || echo "❌ Qdrant: ERROR"
