# Instrucciones de Importación para n8n

## 📋 Credenciales Disponibles

Las siguientes credenciales están configuradas en `./n8n/credentials/`:

1. **postgres-main.json** - Conexión a PostgreSQL (base de datos n8n_db)
2. **redis-main.json** - Conexión a Redis con autenticación
3. **ollama-api.json** - API de Ollama para modelos de IA
4. **flowise-api.json** - API de Flowise con autenticación
5. **qdrant-api.json** - Base de datos vectorial Qdrant

## 🔄 Workflows Disponibles

Los siguientes workflows están listos en `./n8n/workflows/`:

1. **chatbot.json** - Bot de chat con IA
2. **document-processing-automation.json** - Procesamiento automático de documentos
3. **document-processing.json** - Procesamiento de documentos
4. **intelligent-query-system-es.json** - Sistema de consultas inteligentes (español)
5. **intelligent-query-system.json** - Sistema de consultas inteligentes
6. **sentiment-analysis-pipeline.json** - Pipeline de análisis de sentimientos
7. **system-health-monitoring.json** - Monitoreo de salud del sistema

## 📖 Cómo Importar

### Paso 1: Acceder a n8n
```
http://localhost:5678
```

### Paso 2: Crear cuenta (primera vez)
- Crea tu cuenta de administrador
- Configura tu email y contraseña

### Paso 3: Importar Credenciales

1. Ve a **Settings** → **Credentials**
2. Click en **"Add Credential"**
3. Selecciona el tipo según la credencial:
   - **PostgreSQL** para postgres-main.json
   - **Redis** para redis-main.json
   - **HTTP Request** para ollama-api.json, flowise-api.json, qdrant-api.json
4. Copia los valores desde los archivos JSON
5. Guarda cada credencial

### Paso 4: Importar Workflows

1. Ve a **Workflows**
2. Click en el menú (⋮) → **"Import from File"**
3. Selecciona uno o más archivos .json desde `./n8n/workflows/`
4. Los workflows se importarán con las referencias a las credenciales

### Paso 5: Activar Workflows

1. Abre cada workflow importado
2. Verifica que las credenciales estén correctamente asignadas
3. Activa el workflow con el toggle en la esquina superior derecha

## ⚠️ Notas Importantes

- Las credenciales contienen las contraseñas actuales del sistema
- Si cambias las contraseñas en `.env`, actualiza también los archivos de credenciales
- Los workflows pueden requerir ajustes según tu configuración específica
- Algunos workflows necesitan que los modelos de Ollama estén descargados

## 🔐 Seguridad

- No compartas los archivos de credenciales públicamente
- Las credenciales están en `.gitignore` para evitar commits accidentales
- Usa contraseñas fuertes en producción

## 🆘 Solución de Problemas

**Error de conexión a PostgreSQL:**
- Verifica que la base de datos `n8n_db` existe
- Comprueba usuario y contraseña en `.env`

**Error de conexión a Redis:**
- Verifica que Redis esté corriendo: `docker compose ps redis`
- Comprueba la contraseña en `.env` → `REDIS_PASSWORD`

**Workflows no funcionan:**
- Verifica que todas las credenciales estén configuradas
- Comprueba que los servicios externos (Ollama, Flowise, Qdrant) estén activos
- Revisa los logs de n8n: `docker logs laboratorioai-n8n-1 --tail=50`
