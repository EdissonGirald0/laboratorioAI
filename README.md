# Laboratorio AI Local

[![GitHub Actions](https://github.com/EdissonGirald0/laboratorioAI/actions/workflows/main.yml/badge.svg)](https://github.com/EdissonGirald0/laboratorioAI/actions/workflows/main.yml)
[![Licencia MIT](https://img.shields.io/badge/Licencia-MIT-green.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)](https://docker.com)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?logo=postgresql&logoColor=white)](https://postgresql.org)
[![Redis](https://img.shields.io/badge/Redis-Alpine-DC382D?logo=redis&logoColor=white)](https://redis.io)
[![Qdrant](https://img.shields.io/badge/Qdrant-Vector_DB-DC382D?logo=qdrant&logoColor=white)](https://qdrant.tech)
[![Ollama](https://img.shields.io/badge/Ollama-LLM-000000?logo=ollama&logoColor=white)](https://ollama.com)
[![n8n](https://img.shields.io/badge/n8n-Automation-EA4B71?logo=n8n&logoColor=white)](https://n8n.io)
[![Flowise](https://img.shields.io/badge/Flowise-AI_Flows-5B21B6?logo=flowise&logoColor=white)](https://flowiseai.com)
[![OpenWebUI](https://img.shields.io/badge/OpenWebUI-Interface-3B82F6?logo=openwebui&logoColor=white)](https://openwebui.com)

## Que es

Laboratorio de Inteligencia Artificial local basado en Docker. Proporciona un entorno completo y aislado para experimentar con modelos de IA, automatizacion y procesamiento de datos.

## Inicio Rapido

```bash
# 1. Generar .env
chmod +x scripts/init-env.sh
./scripts/init-env.sh

# 2. Iniciar servicios
docker compose up -d

# 3. (Opcional) Automatizar n8n
./scripts/setup-n8n-complete.sh
```

## Servicios

| Servicio | Puerto | Descripcion |
|----------|--------|-------------|
| **Ollama** | 11434 | Modelos LLM locales |
| **OpenWebUI** | 8080 | Interfaz web para Ollama |
| **n8n** | 5678 | Automatizacion de workflows |
| **Flowise** | 3000 | Construccion visual de flujos AI |
| **Qdrant** | 6333 | Base de datos vectorial |
| **PostgreSQL** | 5432 | Base de datos relacional |
| **Redis** | 6380 | Cache y sesiones |

> **Nota**: Redis usa puerto 6380 en el host para evitar conflictos. Internamente usa 6379.
> Las bases de datos `n8n_db` y `ailab` se crean/recuperan automaticamente al iniciar.

## Comandos Utiles

```bash
docker compose up -d              # Iniciar todo
docker compose down               # Detener todo
docker compose restart <servicio> # Reiniciar un servicio
docker compose logs -f <servicio> # Ver logs
./scripts/verify-system.sh        # Verificar salud
./scripts/backup-data.sh          # Respaldar datos
```

### Makefile

```bash
make up       # Iniciar servicios
make down     # Detener servicios
make restart  # Reiniciar todo
make ps       # Estado de contenedores
make status   # Health check + URLs
make clean    # Detener y borrar volumenes
make init     # Setup completo
```

## Estructura

```
laboratorioAI/
├── docker-compose.yml       # Orquestacion de servicios
├── .env                     # Variables de entorno (no commit)
├── Makefile                 # Atajos de comandos
├── scripts/                 # Scripts de automatizacion
│   ├── init-env.sh          # Genera .env
│   ├── backup-data.sh       # Backup de datos
│   ├── restore-data.sh      # Restaurar datos
│   └── verify-system.sh     # Verificar salud
├── postgres/                # PostgreSQL
│   └── init-scripts/        # Scripts de inicializacion
├── n8n/                     # Workflows y credenciales n8n
├── floowise/                # Configuracion Flowise
├── ollama/                  # Configuracion Ollama
├── openwebui/               # Configuracion OpenWebUI
├── redis/                   # Datos Redis
├── qdrant/                  # Datos Qdrant
└── docs/                    # Documentacion
```

## Automatizacion de BD

Las bases de datos se gestionan automaticamente:

- **Primer despliegue**: `postgres/init-scripts/` crea todo desde cero
- **Reinicios**: Postgres verifica y recrea `n8n_db` si no existe
- **Recuperacion**: Si se borra `n8n_db`, se recrea al reiniciar postgres

## Backup y Restauracion

```bash
# Crear backup
./scripts/backup-data.sh

# Restaurar desde backup
./scripts/restore-data.sh ./backups/backup_YYYYMMDD_HHMMSS
```

> Los modelos de Ollama se omiten del backup por tamano.

## Automatizacion n8n

```bash
# Importar workflows y credenciales automaticamente
./scripts/setup-n8n-complete.sh
```

Workflows incluidos: chatbot con memoria, procesamiento de documentos, sistema de consultas inteligente, analisis de sentimientos, monitoreo de sistema.

## Requisitos

- Docker y Docker Compose
- Linux (Ubuntu 22.04+ recomendado)
- Minimo 16GB RAM
- 50GB espacio en disco

## Documentacion

- [ARQUITECTURA.md](docs/ARQUITECTURA.md) - Diagramas Mermaid del sistema
- [QUICKSTART.md](docs/QUICKSTART.md) - Guia rapida
- [PROJECT_STRUCTURE.md](docs/PROJECT_STRUCTURE.md) - Estructura detallada
- [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) - Solucion de problemas
- [INTEGRACIONES.md](docs/INTEGRACIONES.md) - Conexiones entre servicios
- [docs/](docs/) - Documentacion completa

## Licencia

MIT - [LICENSE](LICENSE)