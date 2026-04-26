# AGENTS.md

## Repo Type
Docker-based AI lab. Edits: config, scripts, docker-compose.yml.

## Setup
```bash
# 1. Generate .env (required)
chmod +x scripts/init-env.sh
./scripts/init-env.sh

# 2. Start services
docker compose up -d

# 3. Optional: n8n automation
./scripts/setup-n8n-complete.sh
```

## Commands
```bash
docker compose up -d      # start
docker compose down    # stop
docker compose restart <svc>
docker compose logs -f <svc>
./scripts/verify-system.sh
./scripts/backup-data.sh
```

## Ports
| Service   | Port |
|----------|------|
| Ollama    | 11434 |
| OpenWebUI | 8080 |
| n8n      | 5678 |
| Flowise   | 3000 |
| Qdrant   | 6333 |
| PostgreSQL| 5432 |
| Redis    | 6380 |

## Makefile
```bash
make up       # docker compose up -d
make down     # docker compose down
make restart # restart all
make ps      # container status
make status  # health check
make clean   # stop + remove volumes
make init    # full setup
```

## Important Files
- `.env` - **Never commit** (.gitignore)
- `docker-compose.yml`
- `scripts/setup-n8n-complete.sh`
- `scripts/init-env.sh`

## CI
`.github/workflows/main.yml` validates:
- Script syntax (`bash -n`)
- docker-compose config
- .gitignore

## Services
- **PostgreSQL**: n8n (n8n_db) + Flowise (ailab) - auto-created/recovered on start
- **Redis**: shared cache (mapped to host port 6380 to avoid conflicts)
- **Qdrant**: vector DB
- **Ollama**: LLM models
- **n8n**: automation
- **Flowise**: visual AI flows
- **OpenWebUI**: web UI for Ollama

## Docs
- `docs/QUICKSTART.md`
- `docs/PROJECT_STRUCTURE.md`
- `docs/TROUBLESHOOTING.md`