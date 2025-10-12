# 📋 Guía Rápida: Importar Credenciales en n8n

## ⚠️ Importante
Las credenciales en `./n8n/credentials/*.json` son archivos de referencia. n8n almacena credenciales encriptadas en su base de datos, por lo que **deben importarse manualmente** a través de la interfaz web.

## 🚀 Pasos Rápidos

### 1. Acceder a n8n
```
http://localhost:5678
```

### 2. Crear tu cuenta de administrador (primera vez)

### 3. Importar cada credencial

#### a) PostgreSQL (postgres-main.json)
1. Settings → Credentials → Add Credential
2. Buscar "Postgres"
3. Configurar:
   ```
   Name: PostgreSQL Main Database
   Host: postgres
   Port: 5432
   Database: n8n_db
   User: aiadmin
   Password: EafLYt91EsTtPC7S
   SSL: disable
   ```

#### b) Redis (redis-main.json)
1. Settings → Credentials → Add Credential
2. Buscar "Redis"
3. Configurar:
   ```
   Name: Redis Main Cache
   Host: redis
   Port: 6379
   Password: d5863c011152954059ed17067bb14020
   Database: 0
   ```

#### c) Ollama (ollama-api.json)
1. Settings → Credentials → Add Credential
2. Buscar "HTTP Request"
3. Configurar:
   ```
   Name: Ollama API
   Authentication: None
   Base URL: http://ollama:11434
   ```

#### d) Flowise (flowise-api.json)
1. Settings → Credentials → Add Credential
2. Buscar "HTTP Request" o "Generic Credential Type"
3. Configurar:
   ```
   Name: Flowise API
   Base URL: http://floowise:3000
   Authentication: Header Auth
   Header Name: Authorization
   Header Value: Bearer ZEStTOBhipXJDhzmIq5jUpKLX8gDX3k5
   ```

#### e) Qdrant (qdrant-api.json)
1. Settings → Credentials → Add Credential
2. Buscar "HTTP Request"
3. Configurar:
   ```
   Name: Qdrant Vector Database
   Base URL: http://qdrant:6333
   Authentication: Header Auth
   Header Name: api-key
   Header Value: zkxkrh3kRoqApX5p6Zov1f5Xz9ad64mf
   ```

## 🔄 Importar Workflows

1. Ve a Workflows
2. Click en el botón de menú (⋮) → "Import from File"
3. Selecciona los archivos desde `./n8n/workflows/`:
   - chatbot.json
   - document-processing-automation.json
   - document-processing.json
   - intelligent-query-system-es.json
   - intelligent-query-system.json
   - sentiment-analysis-pipeline.json
   - system-health-monitoring.json

## ✅ Verificar

Después de importar:
1. Abre cada workflow
2. Verifica que los nodos tengan las credenciales asignadas
3. Activa los workflows que necesites

## 💡 Tip: Copiar y Pegar

Para facilitar la importación, puedes copiar directamente los valores desde los archivos JSON:

```bash
# Ver PostgreSQL
cat ./n8n/credentials/postgres-main.json

# Ver Redis
cat ./n8n/credentials/redis-main.json

# Ver todas las credenciales
ls -la ./n8n/credentials/
```

## 🔐 Seguridad

- Las credenciales se almacenan encriptadas en la base de datos de n8n
- n8n usa la variable `N8N_ENCRYPTION_KEY` del `.env` para encriptar
- No compartas tu archivo `.env` ni las credenciales públicamente
