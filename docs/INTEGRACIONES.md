# Integraciones entre Servicios

## Arquitectura

Ver [ARQUITECTURA.md](./ARQUITECTURA.md) para diagramas Mermaid completos del sistema.

## Conexiones

| Origen | Destino | Protocolo | Puerto | Proposito |
|--------|---------|-----------|--------|-----------|
| OpenWebUI | Ollama | HTTP REST | 11434 | Consulta de modelos LLM |
| OpenWebUI | Redis | TCP | 6379 | Cache de sesiones |
| n8n | PostgreSQL | TCP | 5432 | BD de workflows y ejecuciones |
| n8n | Redis | TCP | 6379 | Bull queue para jobs |
| n8n | Ollama | HTTP REST | 11434 | Consulta de modelos en workflows |
| n8n | Qdrant | HTTP REST | 6333 | Almacenamiento y busqueda vectorial |
| Flowise | PostgreSQL | TCP | 5432 | Configuracion de flows |
| Flowise | Redis | TCP | 6379 | Cache |
| Flowise | Ollama | HTTP REST | 11434 | Generacion de respuestas |
| Flowise | Qdrant | HTTP REST | 6333 | RAG y busqueda semantica |

## Variables de Entorno Clave

### PostgreSQL
```
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=postgres
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n_db
```

### Redis
```
REDIS_URL=redis://redis:6379/0?password=${REDIS_PASSWORD}
QUEUE_BULL_REDIS_HOST=redis
QUEUE_BULL_REDIS_PORT=6379
```

### Ollama
```
OLLAMA_API_BASE_URL=http://ollama:11434
```

### Qdrant
```
QDRANT_URL=http://qdrant:6333
QDRANT_API_KEY=${QDRANT_API_KEY}
```

## Red Docker

Todos los servicios comparten la red `laboratorio_ai` (bridge). Los nombres de contenedor funcionan como DNS:
- `postgres` → PostgreSQL
- `redis` → Redis
- `qdrant` → Qdrant
- `ollama` → Ollama

Para acceso desde el host se usa `host.docker.internal`.

## Flujo de Chat

1. Usuario envia mensaje a OpenWebUI (puerto 8080)
2. OpenWebUI recupera contexto de sesion de Redis
3. OpenWebUI envia prompt a Ollama (puerto 11434)
4. Ollama genera respuesta con el modelo cargado
5. OpenWebUI guarda contexto en Redis
6. OpenWebUI muestra respuesta al usuario

## Flujo RAG (Flowise)

1. Usuario envia consulta a Flowise (puerto 3000)
2. Flowise carga configuracion del flow desde PostgreSQL
3. Flowise busca documentos relevantes en Qdrant (vectores)
4. Flowise envia prompt + contexto a Ollama
5. Ollama genera respuesta basada en los documentos
6. Flowise devuelve resultado con fuentes

## Flujo de Automatizacion (n8n)

1. Webhook recibe datos en n8n (puerto 5678)
2. n8n ejecuta nodos del workflow
3. Si necesita IA: consulta a Ollama
4. Si necesita vectores: consulta a Qdrant
5. Si necesita cache: usa Redis Bull Queue
6. n8n persiste estado en PostgreSQL
7. n8n devuelve respuesta al webhook