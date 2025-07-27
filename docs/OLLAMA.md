# Ollama - Servicio de Modelos de IA

## Descripción
Ollama es el servicio principal para la ejecución de modelos de lenguaje de forma local.

## Modelos Disponibles

| Modelo | Descripción | Uso Recomendado |
|--------|-------------|-----------------|
| devstral:24b | Optimizado para desarrollo | Generación de código y asistencia técnica |
| phi4-reasoning | Especializado en razonamiento | Análisis lógico y resolución de problemas |
| nomic-embed-text | Generación de embeddings | Procesamiento de texto y búsqueda semántica |
| codellama | Especializado en código | Desarrollo y análisis de código |
| mistral | Propósito general | Tareas generales de IA |

## Configuración

### Variables de Entorno
- `OLLAMA_HOST`: Host donde se ejecuta el servicio (default: 0.0.0.0)
- `OLLAMA_PORT`: Puerto de escucha (default: 11434)

### Volúmenes
- `/root/.ollama`: Almacenamiento persistente de modelos

### Healthcheck
El servicio incluye un healthcheck que verifica:
- Disponibilidad del servicio cada 30 segundos
- Tiempo de espera de 10 segundos
- 3 reintentos antes de marcar como no saludable

## Uso

### API Endpoints

1. **Listar Modelos**
```bash
curl http://localhost:11434/api/tags
```

2. **Generar Texto**
```bash
curl -X POST http://localhost:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{"model": "mistral", "prompt": "Tu pregunta aquí"}'
```

3. **Embeddings**
```bash
curl -X POST http://localhost:11434/api/embeddings \
  -H "Content-Type: application/json" \
  -d '{"model": "nomic-embed-text", "prompt": "Texto para embedding"}'
```

## Integración con Otros Servicios

### Con Floowise
- Usar el endpoint de generación para procesamiento de texto
- Usar embeddings para análisis semántico

### Con OpenWebUI
- Interfaz gráfica principal para interacción con modelos
- Configuración a través de variables de entorno

## Mantenimiento

### Actualización de Modelos
```bash
docker exec -it ollama ollama pull modelo:versión
```

### Limpieza de Cache
```bash
docker exec -it ollama rm -rf /root/.ollama/cache/*
```

## Troubleshooting

### Problemas Comunes

1. **Servicio No Responde**
   - Verificar logs: `docker logs ollama`
   - Comprobar memoria disponible
   - Verificar puerto 11434 está libre

2. **Modelo No Carga**
   - Verificar espacio en disco
   - Comprobar conectividad a Internet
   - Revisar logs específicos del modelo

3. **Rendimiento Lento**
   - Monitorear uso de GPU/CPU
   - Verificar memoria disponible
   - Comprobar carga del sistema
