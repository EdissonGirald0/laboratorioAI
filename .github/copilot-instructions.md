# Instrucciones para Agentes de IA - LaboratorioAI

## Arquitectura y estructura

- **Ecosistema Docker**: Todo el proyecto está basado en Docker. El `docker-compose.yml` es el archivo central que define todos los servicios y sus interconexiones.
- **Patrón de comunicación**: Servicios interconectados a través de la red interna `laboratorio_ai`. Usa `host.docker.internal` como patrón para referencias entre contenedores.
- **Estructura de datos**: Todos los volúmenes persistentes están mapeados a directorios `<servicio>/data` en el host.

## Flujos de trabajo críticos

### Inicialización y despliegue
1. Inicializa el entorno usando `./scripts/init-env.sh` (genera variables de entorno)
2. Verifica la configuración con `./scripts/validate-env.sh`
3. Despliega con `docker-compose up -d` (o `docker compose up -d` en sistemas más nuevos)

### Mantenimiento
- Backups: `./scripts/backup-data.sh` (excluye los modelos de Ollama por su tamaño)
- Restauración: `./scripts/restore-data.sh ./backups/backup_YYYYMMDD_HHMMSS`
- Limpieza: `./scripts/cleanup.sh` (elimina logs antiguos y datos temporales)

## Servicios y comunicaciones

- **Ollama** → **OpenWebUI**: Modelos de IA accesibles vía REST API en puerto 11434
- **n8n** → **Floowise**: Automatizaciones que invocan flujos de IA
- **Floowise** → **Ollama+Qdrant**: Procesamiento de datos y almacenamiento vectorial
- **Todos los servicios** → **PostgreSQL**: Almacenamiento persistente de datos

## Convenciones importantes

- Scripts de shell siempre incluyen validaciones y códigos de colores para output
- Variables de entorno generadas automáticamente y almacenadas en `.env` 
- Los servicios utilizan healthchecks para garantizar disponibilidad
- Cada directorio de servicio puede contener un `healthcheck.sh` personalizado

## Puntos críticos al modificar el proyecto

- Conserva los patrones de host en `host.docker.internal` al agregar nuevos servicios
- Mantén la estructura de volúmenes persistentes en `./*/data`
- Actualiza `validate-env.sh` cuando añadas nuevas variables de entorno requeridas
- Los servicios de IA tienen dependencias específicas de hardware (CPU/RAM/GPU)

## Errores comunes y soluciones

- **Docker Compose sintaxis**: Usa `docker compose` (sin guión) en sistemas modernos
- **Variables de entorno**: Siempre ejecuta `./scripts/init-env.sh` antes del primer despliegue
- **Dockerfiles multilínea**: Usa `\` al final de cada línea en comandos RUN y ENV
- **JSON en .env**: Mantén el JSON en una sola línea (ej: CREDENTIAL_JSON)
- **Imagen de Ollama**: Construye localmente con `docker compose build ollama`

## Archivos clave
- `docker-compose.yml`: Definición de todos los servicios
- `scripts/init-env.sh`: Generación de variables de entorno
- `floowise/Dockerfile`: Construcción de imagen personalizada de Flowise
- `Dockerfile.ollama`: Construcción de imagen de Ollama
- `docs/TROUBLESHOOTING.md`: Guía completa de solución de problemas
- `docs/*.md`: Documentación de cada componente del sistema
- `n8n/workflows/*.json`: Flujos de trabajo automatizados predefinidos