# Solucion de Problemas - LaboratorioAI

## Errores Comunes

### 1. Puerto en uso (6379 o 5432)

**Problema**: Redis o PostgreSQL no inician porque otros contenedores usan esos puertos.

**Solucion**:
```bash
# Ver que ocupa el puerto
sudo lsof -i :6379
sudo lsof -i :5432

# Redis del proyecto usa puerto 6380 en el host
# Si aun hay conflicto, cambia el puerto en docker-compose.yml:
#   ports:
#     - "6381:6379"
```

### 2. Postgres no arranca (version incompatible)

**Problema**: Datos de una version anterior de PostgreSQL son incompatibles.

**Solucion**:
```bash
docker compose down -v
rm -rf postgres/data/*
docker compose up -d
```

> La BD se recrea automaticamente con los init-scripts.

### 3. n8n no inicia: "database n8n_db does not exist"

**Problema**: La base de datos `n8n_db` no se creo.

**Solucion**: Se resuelve automaticamente. Reinicia postgres:
```bash
docker compose restart postgres
```

El comando de inicio verifica y crea `n8n_db` si no existe.

### 4. Servicios no responden

**Verificacion**:
```bash
# Estado de contenedores
docker compose ps

# Logs
docker compose logs <servicio>
```

### 5. OpenWebUI error de Redis

**Problema**: OpenWebUI no puede autenticarse con Redis.

**Solucion**: Ya corregido en la configuracion actual. OpenWebUI usa la red interna Docker (`redis://redis:6379`). Si persiste:
```bash
docker compose up -d openwebui
```

### 6. Permisos en directorios de datos

```bash
mkdir -p postgres/data qdrant/data ollama/data n8n/data floowise/data openwebui/data redis/data
chmod -R 777 */data
```

## Diagnostico

```bash
# Estado general
docker compose ps

# Logs en tiempo real
docker compose logs -f

# Logs de un servicio
docker compose logs -f n8n

# Recursos
docker stats
```

## Reinicio Completo

```bash
# Sin borrar datos
docker compose down
docker compose up -d

# Borrando todo (empezar de cero)
docker compose down -v
rm -rf */data/*
docker compose up -d
```

## Verificacion

```bash
# Health checks
curl http://localhost:5678/healthz  # n8n
curl http://localhost:3000          # Flowise
curl http://localhost:8080          # OpenWebUI
curl http://localhost:11434         # Ollama
curl http://localhost:6333          # Qdrant

# Bases de datos
make status
```

## Soporte

- Revisa logs: `docker compose logs`
- Valida .env: `./scripts/validate-env.sh`
- Abre issue en GitHub con logs y descripcion del error