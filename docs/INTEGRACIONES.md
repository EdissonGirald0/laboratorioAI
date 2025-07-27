# Guía de Integraciones

## Integración Floowise con Ollama

1. En Floowise, crear un nuevo flujo
2. Añadir el nodo "LLM Chain"
3. Configurar el modelo de Ollama:
   - URL: http://ollama:11434
   - Modelo: devstral:24b (u otro modelo disponible)

## Integración n8n con Floowise

1. En n8n, crear un nuevo workflow
2. Usar el nodo HTTP Request para conectar con Floowise:
   - URL: http://floowise:3000/api
   - Autenticación: Bearer Token

## Ejemplos de Flujos de Trabajo

### Procesamiento de Documentos
1. n8n recibe documento
2. Extrae texto
3. Floowise procesa con LLM
4. Almacena embeddings en Qdrant
5. Guarda metadatos en PostgreSQL

### Chatbot Automatizado
1. OpenWebUI recibe pregunta
2. Consulta embeddings en Qdrant
3. Procesa respuesta con Ollama
4. Almacena conversación en PostgreSQL
