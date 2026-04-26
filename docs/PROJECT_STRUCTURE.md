# Estructura del Proyecto

```
laboratorioAI/
├── docker-compose.yml         # Orquestacion (7 servicios)
├── .env                       # Variables de entorno (generado, no commit)
├── Makefile                   # Atajos de comandos
├── AGENTS.md                  # Instrucciones para agentes AI
├── CHANGELOG.md               # Historial de cambios
├── README.md                  # Documentacion principal
│
├── scripts/                   # Scripts de automatizacion
│   ├── init-env.sh            # Genera .env con claves aleatorias
│   ├── verify-system.sh       # Verifica salud de servicios
│   ├── backup-data.sh         # Backup de datos
│   ├── restore-data.sh        # Restaurar datos
│   ├── auto-import-n8n-workflows.sh    # Importa workflows n8n
│   ├── auto-import-n8n-credentials.sh  # Importa credenciales n8n
│   ├── docker-init-automation.sh       # Configuracion automatica
│   ├── setup-codespace.sh     # Setup para GitHub Codespaces
│   ├── test-lab.sh            # Tests de integracion
│   └── dev-tools/             # Herramientas CLI de desarrollo
│
├── postgres/                  # PostgreSQL
│   └── init-scripts/          # Scripts de inicializacion (primer deploy)
│       └── 00-init-users.sh   # Crea BD, usuarios, extensiones
│
├── n8n/                       # n8n
│   ├── workflows/             # Workflows JSON (8 flujos)
│   ├── credentials/           # Credenciales pre-configuradas
│   └── custom/                # Codigo TypeScript personalizado
│
├── floowise/                  # Flowise
│   ├── Dockerfile             # Imagen personalizada
│   ├── config.json            # Configuracion
│   └── components/            # Componentes personalizados
│
├── ollama/                    # Ollama
│   ├── Dockerfile             # Imagen personalizada
│   └── healthcheck.sh         # Health check
│
├── openwebui/                 # OpenWebUI (datos persistentes)
├── redis/                     # Redis (datos persistentes)
├── qdrant/                    # Qdrant (datos persistentes)
│
├── docs/                      # Documentacion
│   ├── README.md              # Indice de documentacion
│   ├── QUICKSTART.md          # Guia rapida
│   ├── PROJECT_STRUCTURE.md   # Este archivo
│   ├── TROUBLESHOOTING.md     # Solucion de problemas
│   ├── OLLAMA.md              # Configuracion Ollama
│   ├── FLOOWISE.md            # Configuracion Flowise
│   ├── INTEGRACIONES.md       # Integraciones
│   ├── CONTRIBUTING.md        # Guia de contribucion
│   ├── N8N_API_SETUP.md       # API n8n
│   ├── REDIS_FIX.md           # Fix Redis
│   ├── OLLAMA_URL_FIX.md      # Fix URL Ollama
│   └── imagenes/              # Diagramas
│
├── config/                    # Configuraciones sensibles
├── backups/                   # Respaldos de datos
├── tests/                     # Tests de integracion
└── .github/                   # CI/CD y templates
    └── workflows/main.yml     # Validacion CI
```

## Servicios Docker

| Servicio | Imagen | Puerto Host | Dependencias |
|----------|--------|-------------|-------------|
| redis | redis:alpine | 6380 | - |
| postgres | postgres:16-alpine | 5432 | - |
| qdrant | qdrant/qdrant:latest | 6333 | - |
| ollama | ollama/ollama:latest | 11434 | - |
| openwebui | ghcr.io/open-webui/open-webui:latest | 8080 | ollama |
| n8n | docker.n8n.io/n8nio/n8n:latest | 5678 | postgres, redis |
| floowise | laboratorioai-floowise (build) | 3000 | postgres, qdrant, ollama, redis |

## Redes

- `laboratorio_ai` (bridge) - Todos los servicios conectados

## Volumenes

Datos persistentes en directorios locales:
- `postgres/data/` → `/var/lib/postgresql`
- `redis/data/` → `/data`
- `qdrant/data/` → `/qdrant/storage`
- `ollama/data/` → `/root/.ollama`
- `n8n/data/` → `/home/node/.n8n`
- `floowise/data/` → `/root/.flowise`
- `openwebui/data/` → `/app/data`