# 🗺️ Mapa de Navegación del Proyecto

Guía rápida para encontrar cualquier cosa en el proyecto LaboratorioAI.

---

## 🚀 Empezar Aquí

```
¿Primera vez?          → docs/QUICKSTART.md
¿Problemas?            → docs/TROUBLESHOOTING.md
¿Ver documentación?    → docs/README.md
¿Ejecutar el sistema?  → make start
```

---

## 📚 Documentación por Categoría

### Inicio y Configuración
- **docs/QUICKSTART.md** - Guía de inicio rápido (5 minutos)
- **docs/AUTO_INITIALIZATION.md** - Cómo funciona la auto-inicialización
- **docs/AUTO_INIT_SUMMARY.md** - Resumen ejecutivo de auto-init
- **docs/FINAL_IMPLEMENTATION_STATUS.md** - Estado actual del sistema

### Configuración de Servicios
- **docs/N8N_API_SETUP.md** - Configurar API de n8n
- **docs/OLLAMA.md** - Configurar Ollama y modelos
- **docs/FLOOWISE.md** - Configurar Flowise
- **docs/INTEGRACIONES.md** - Integraciones entre servicios

### Solución de Problemas
- **docs/TROUBLESHOOTING.md** - Guía completa de troubleshooting
- **docs/OLLAMA_URL_FIX.md** - Fix de URLs de Ollama
- **docs/REDIS_FIX.md** - Fix de problemas con Redis

### Proyecto
- **docs/PROJECT_STRUCTURE.md** - Estructura del proyecto
- **docs/ORGANIZATION_SUMMARY.md** - Resumen de organización
- **docs/CONTRIBUTING.md** - Cómo contribuir
- **README.md** - Documentación principal (raíz)
- **CHANGELOG.md** - Histórico de cambios

---

## 🔧 Scripts por Función

### Inicialización (Automática)
```bash
make start                           # ⭐ Inicia y configura TODO automáticamente
./scripts/docker-init-automation.sh  # Script principal de inicialización
./scripts/post-start.sh              # Wrapper de ejecución
```

### Importación y Configuración (Manual)
```bash
./scripts/auto-import-n8n-workflows.sh    # Importa workflows
./scripts/auto-import-n8n-credentials.sh  # Crea credenciales
./scripts/activate-dev-workflows.sh       # Activa workflows
```

### Ambiente y Variables
```bash
./scripts/init-env.sh        # Inicializa variables de entorno
./scripts/validate-env.sh    # Valida configuración
./scripts/reset-env.sh       # Resetea configuración
```

### Mantenimiento
```bash
./scripts/backup-data.sh     # Backup de datos
./scripts/restore-data.sh    # Restaurar backup
./scripts/cleanup.sh         # Limpiar sistema
./scripts/monitor-services.sh # Monitorear servicios
```

### Utilidades
```bash
./scripts/fix-ollama-url.sh       # Fix URLs de Ollama
./scripts/validate-auto-init.sh   # Validar inicialización
./scripts/test-lab.sh             # Tests del laboratorio
```

### Herramientas CLI
```bash
./scripts/dev-tools/code-review.sh <archivo>    # Revisar código
./scripts/dev-tools/generate-commit.sh          # Generar commit
./scripts/dev-tools/analyze-bug.sh              # Analizar bug
./scripts/dev-tools/generate-tests.sh <archivo> # Generar tests
```

---

## ⚙️ Comandos Make

```bash
make help          # Ver todos los comandos disponibles
make start         # ⭐ Iniciar con auto-configuración
make stop          # Detener servicios
make restart       # Reiniciar servicios
make status        # Ver estado de servicios
make logs          # Ver logs en tiempo real
make logs-n8n      # Logs de n8n
make logs-ollama   # Logs de Ollama
make logs-flowise  # Logs de Flowise
make init          # Reconfigurar manualmente
make reset         # Reinicializar sistema
make health        # Verificar salud de servicios
make dev-tools     # Ver herramientas disponibles
make backup        # Crear backup
make clean         # Limpiar todo (PELIGROSO)
make build         # Reconstruir imágenes
make pull          # Actualizar imágenes
```

---

## 🌐 URLs de Acceso

```
n8n:         http://localhost:5678
Flowise:     http://localhost:3000
OpenWebUI:   http://localhost:8080
Ollama API:  http://localhost:11434
Qdrant:      http://localhost:6333
PostgreSQL:  localhost:5432
Redis:       localhost:6379
```

---

## 🔌 Webhooks Activos

```bash
# Code Review
curl -X POST http://localhost:5678/webhook/code-review \
  -H "Content-Type: application/json" \
  -d '{"code": "...", "language": "javascript"}'

# Git Commit
curl -X POST http://localhost:5678/webhook/git-commit \
  -H "Content-Type: application/json" \
  -d '{"diff": "..."}'

# Bug Report
curl -X POST http://localhost:5678/webhook/bug-report \
  -H "Content-Type: application/json" \
  -d '{"title": "...", "description": "..."}'

# API Documentation
curl -X POST http://localhost:5678/webhook/generate-api-docs \
  -H "Content-Type: application/json" \
  -d '{"code": "..."}'

# Test Generator
curl -X POST http://localhost:5678/webhook/generate-tests \
  -H "Content-Type: application/json" \
  -d '{"code": "..."}'
```

---

## 📁 Ubicaciones Importantes

```
Variables de entorno:      .env
Configuración:             ./config/
Workflows n8n:             ./n8n/workflows/
Scripts:                   ./scripts/
Documentación:             ./docs/
Backups:                   ./backups/
Datos PostgreSQL:          ./postgres/data/
Datos Ollama:              ./ollama/data/
Datos n8n:                 ./n8n/data/
API Key de n8n:            ./config/.n8n_api_key
Marca de inicialización:   ./config/.initialized
```

---

## 🔍 Buscar por Problema

| Problema | Ver |
|----------|-----|
| Sistema no inicia | docs/TROUBLESHOOTING.md |
| Workflows no cargan | docs/N8N_API_SETUP.md |
| Ollama no responde | docs/OLLAMA.md |
| Error 404 en webhooks | docs/OLLAMA_URL_FIX.md |
| Redis falla | docs/REDIS_FIX.md |
| Primera instalación | docs/QUICKSTART.md |
| Entender auto-init | docs/AUTO_INITIALIZATION.md |
| Ver estructura | docs/PROJECT_STRUCTURE.md |

---

## 📦 Archivos Archivados

### Scripts obsoletos: `scripts/obsolete/`
- activate-workflows.sh
- auto-activate-workflows.sh
- import-n8n-data.sh
- import-workflows-n8n.sh
- deploy-dev-workflows.sh
- setup-n8n-automation.sh
- setup-n8n-complete.sh

### Docs históricos: `docs/archive/`
- OLD_README.md
- AUTOMATION_SUCCESS.md
- COMPLETE_AUTOMATION.md
- DEPLOYMENT_SUCCESS.md
- IMPLEMENTATION_STATUS.md
- WORKFLOW_IMPORT_SUCCESS.md
- FINAL_REPORT.md
- PROJECT_SUMMARY.md
- IMPLEMENTATION_GUIDE.md
- DEV_WORKFLOWS.md
- CREDENTIALS.md

---

## 🎯 Flujos de Trabajo Comunes

### Iniciar el sistema por primera vez
```bash
git clone https://github.com/EdissonGirald0/laboratorioAI.git
cd laboratorioAI
./scripts/init-env.sh
make start
# Esperar 5-10 minutos
make status
```

### Reinicializar el sistema
```bash
make reset
make init
```

### Hacer backup
```bash
make backup
```

### Ver logs de un servicio
```bash
make logs-n8n
# o
docker logs -f n8n
```

### Detener y limpiar todo
```bash
make stop
make clean  # CUIDADO: Borra todos los datos
```

---

## 🆘 Ayuda Rápida

```bash
# ¿Qué comandos hay disponibles?
make help

# ¿Cómo está el sistema?
make status
make health

# ¿Qué está pasando?
make logs

# ¿Cómo reinicio?
make restart

# ¿Cómo configuro de nuevo?
make reset
make init
```

---

**Última actualización**: 13 de octubre de 2025  
**Versión**: 2.0.0
