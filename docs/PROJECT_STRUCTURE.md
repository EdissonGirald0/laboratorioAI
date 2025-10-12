# 📁 Estructura del Proyecto

```
laboratorioAI/
│
├── 📄 docker-compose.yml          # Orquestación de 7 servicios
├── 📄 .env                         # Variables de entorno (generado)
├── 📄 .gitignore                   # Archivos ignorados por Git
├── 📄 LICENSE                      # Licencia MIT
│
├── 📚 Documentación Principal
│   ├── README.md                   # Guía completa del proyecto
│   ├── PROJECT_SUMMARY.md          # Resumen ejecutivo
│   ├── AUTOMATION_SUCCESS.md       # Logros de automatización
│   ├── CREDENTIALS.md              # Credenciales del sistema
│   ├── DEPLOYMENT_SUCCESS.md       # Estado del despliegue
│   └── CHANGELOG.md                # Historial de cambios
│
├── 📂 docs/                        # Documentación detallada
│   ├── COMPLETE_AUTOMATION.md      # Guía de automatización completa
│   ├── N8N_API_SETUP.md            # Configuración de API Key
│   ├── WORKFLOW_IMPORT_SUCCESS.md  # Detalles de workflows
│   ├── TROUBLESHOOTING.md          # Solución de problemas
│   ├── CONTRIBUTING.md             # Guía de contribución
│   ├── OLLAMA.md                   # Documentación de Ollama
│   ├── FLOOWISE.md                 # Documentación de Flowise
│   ├── INTEGRACIONES.md            # Integraciones entre servicios
│   └── imagenes/                   # Diagramas y capturas
│       ├── laboratorio_ai_network.png
│       ├── ai_document_workflow.png
│       └── document_query_pipeline.png
│
├── 🤖 scripts/                     # Scripts de automatización
│   ├── 🚀 Automatización
│   │   ├── setup-n8n-complete.sh           # Setup completo (maestro)
│   │   ├── auto-import-n8n-workflows.sh    # Importar workflows
│   │   └── auto-import-n8n-credentials.sh  # Crear credenciales
│   │
│   ├── 🔧 Mantenimiento
│   │   ├── init-env.sh                     # Inicializar variables
│   │   ├── validate-env.sh                 # Validar configuración
│   │   ├── backup-data.sh                  # Backup de datos
│   │   ├── restore-data.sh                 # Restaurar backup
│   │   └── cleanup.sh                      # Limpieza de logs
│   │
│   └── 🧪 Testing
│       ├── test-lab.sh                     # Test del sistema
│       ├── test-n8n-automations.sh         # Test de n8n
│       └── monitor-services.sh             # Monitoreo de servicios
│
├── 🔄 n8n/                         # Configuración de n8n
│   ├── workflows/                  # Workflows pre-configurados
│   │   ├── chatbot.json                    # AI Chatbot con memoria
│   │   ├── document-processing.json        # Procesamiento de docs
│   │   ├── document-processing-automation.json
│   │   ├── intelligent-query-system.json   # Consultas inteligentes (EN)
│   │   ├── intelligent-query-system-es.json # Consultas inteligentes (ES)
│   │   ├── sentiment-analysis-pipeline.json # (vacío - por completar)
│   │   └── system-health-monitoring.json    # (vacío - por completar)
│   │
│   ├── credentials/                # Plantillas de credenciales
│   │   ├── postgres-main.json              # PostgreSQL
│   │   ├── redis-main.json                 # Redis
│   │   ├── ollama-api.json                 # Ollama
│   │   ├── flowise-api.json                # Flowise
│   │   └── qdrant-api.json                 # Qdrant
│   │
│   └── custom/                     # Nodos y credenciales custom
│       ├── tsconfig.json
│       ├── credentials/
│       │   └── OllamaApi.credentials.ts
│       └── nodes/
│           └── Ollama/
│               └── Ollama.node.ts
│
├── 🐳 Servicios Docker/            # Configuración de servicios
│   ├── ollama/
│   │   ├── Dockerfile
│   │   └── healthcheck.sh
│   │
│   ├── floowise/
│   │   ├── Dockerfile
│   │   ├── healthcheck.sh
│   │   ├── package.json
│   │   ├── index.js
│   │   ├── config.json
│   │   └── components/
│   │       ├── OllamaNode.js
│   │       └── QdrantNode.js
│   │
│   ├── postgres/
│   │   ├── Dockerfile
│   │   └── init-scripts/
│   │       ├── 00-init-users.sh
│   │       ├── 01-init.sql
│   │       └── 02-monitoring-schema.sql
│   │
│   ├── openwebui/
│   ├── redis/
│   └── qdrant/
│
├── 🧪 tests/                       # Tests de integración
│   ├── integration_test.sh         # Tests de integración
│   ├── load_test.sh                # Tests de carga
│   └── workflow_test.sh            # Tests de workflows
│
├── 🔐 .github/                     # GitHub configuration
│   ├── copilot-instructions.md     # Instrucciones para IA
│   └── workflows/
│       └── main.yml                # CI/CD (por configurar)
│
├── 🐋 .devcontainer/               # Dev Container para VS Code
│   ├── devcontainer.json
│   └── post-create.sh
│
└── 💾 Datos (gitignored)/          # Datos persistentes
    ├── postgres/                   # Bases de datos PostgreSQL
    │   └── data/                   # (ailab, n8n_db)
    ├── redis/                      # Datos de Redis
    ├── qdrant/                     # Vectores de Qdrant
    ├── ollama/                     # Modelos de Ollama
    ├── n8n/                        # Datos de n8n
    ├── floowise/                   # Datos de Flowise
    └── openwebui/                  # Datos de OpenWebUI
```

## 📊 Estadísticas del Proyecto

| Categoría | Cantidad |
|-----------|----------|
| **Archivos de configuración** | 8 |
| **Scripts bash** | 11 |
| **Workflows n8n** | 7 (5 completos) |
| **Credenciales** | 5 |
| **Servicios Docker** | 7 |
| **Archivos de documentación** | 14 |
| **Tests** | 3 |
| **Componentes custom** | 2 (Ollama, Qdrant) |

## 🎨 Convenciones de Nombres

### Archivos
- **Configuración**: `kebab-case.yml`, `kebab-case.json`
- **Scripts**: `kebab-case.sh`
- **Documentación**: `SCREAMING_SNAKE_CASE.md`
- **Código**: `camelCase.js`, `camelCase.ts`

### Directorios
- **Lowercase**: `scripts/`, `docs/`, `tests/`
- **Servicios**: Nombre del servicio (`ollama/`, `n8n/`)

### Variables de Entorno
- **SCREAMING_SNAKE_CASE**: `DB_POSTGRESDB_DATABASE`
- **Prefijo por servicio**: `N8N_*`, `FLOWISE_*`, `REDIS_*`

## 🔗 Enlaces Rápidos

- **Repositorio**: https://github.com/EdissonGirald0/laboratorioAI
- **Issues**: https://github.com/EdissonGirald0/laboratorioAI/issues
- **Wiki**: (por crear)
- **Releases**: https://github.com/EdissonGirald0/laboratorioAI/releases

## 📝 Notas

- ✅ Todos los datos persistentes están en `.gitignore`
- ✅ Credenciales generadas automáticamente
- ✅ Estructura modular y escalable
- ✅ Documentación completa en español
- ✅ Scripts con validación y error handling

---

*Última actualización: 12 de octubre de 2025*
