# Floowise - Servicio de Procesamiento de Datos

## Descripción
Floowise es el servicio de procesamiento y orquestación de flujos de datos, integrando diferentes servicios del laboratorio.

## Componentes Principales

### API REST
- Endpoints para procesamiento de datos
- Integración con Ollama y Qdrant
- Gestión de flujos de trabajo

### Base de Datos
- PostgreSQL para almacenamiento persistente
- Esquemas separados para diferentes funcionalidades

## Configuración

### Variables de Entorno Requeridas
```env
FLOOWISE_HOST=0.0.0.0
FLOOWISE_PORT=3000
DATABASE_URL=postgresql://user:password@postgres:5432/dbname
QDRANT_URL=http://qdrant:6333
```

### Dependencias
- PostgreSQL: Base de datos principal
- Qdrant: Base de datos vectorial
- Ollama: Modelos de IA

## API Endpoints

### Health Checks
```bash
# Verificar estado general
GET /health

# Verificar conexión PostgreSQL
GET /health/postgres

# Verificar conexión Qdrant
GET /health/qdrant
```

### Procesamiento de Datos
```bash
# Procesar texto con IA
POST /api/process
Content-Type: application/json
{
    "text": "Texto a procesar",
    "model": "mistral",
    "options": {}
}

# Búsqueda semántica
POST /api/search
Content-Type: application/json
{
    "query": "Consulta de búsqueda",
    "collection": "nombre_colección",
    "limit": 10
}
```

## Integración con Otros Servicios

### Con Ollama
- Procesamiento de texto
- Generación de embeddings

### Con Qdrant
- Almacenamiento de vectores
- Búsqueda semántica

### Con n8n
- Automatización de flujos
- Webhooks para procesamiento

## Desarrollo

### Requisitos
- Node.js 20 o superior
- npm o yarn
- PostgreSQL 16
- Docker y Docker Compose

### Instalación Local
```bash
# Instalar dependencias
npm install

# Ejecutar en modo desarrollo
npm run dev

# Ejecutar en producción
npm start
```

## Mantenimiento

### Logs
Los logs se encuentran en:
- Docker: `docker logs floowise`
- Aplicación: `/app/data/logs/`

### Backup de Datos
```bash
# Backup de configuración
./scripts/backup-data.sh

# Restaurar configuración
./scripts/restore-data.sh ./backups/backup_name
```

## Troubleshooting

### Problemas Comunes

1. **Conexión a Base de Datos**
   - Verificar credenciales
   - Comprobar que PostgreSQL esté corriendo
   - Verificar network de Docker

2. **Problemas de Memoria**
   - Revisar logs de Node.js
   - Monitorear uso de memoria
   - Ajustar límites de contenedor

3. **Errores de API**
   - Verificar logs de aplicación
   - Comprobar conexiones a servicios
   - Validar formato de requests
