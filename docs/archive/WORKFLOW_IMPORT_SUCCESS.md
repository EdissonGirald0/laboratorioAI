# ✅ Importación Automática de Workflows Completada

## 🎯 Resumen

Se ha completado exitosamente la **automatización de importación de workflows en n8n** usando la API REST.

---

## 📊 Resultados

### Workflows Importados: **5 de 7**

| Estado | Workflow | Descripción |
|--------|----------|-------------|
| ✅ | `chatbot.json` | AI Chatbot con memoria usando Qdrant |
| ✅ | `document-processing-automation.json` | Automatización de procesamiento de documentos |
| ✅ | `document-processing.json` | Pipeline de procesamiento de documentos |
| ✅ | `intelligent-query-system-es.json` | Sistema inteligente de consultas (español) |
| ✅ | `intelligent-query-system.json` | Sistema inteligente de consultas (inglés) |
| ⚠️ | `sentiment-analysis-pipeline.json` | **Archivo vacío - Omitido** |
| ⚠️ | `system-health-monitoring.json` | **Archivo vacío - Omitido** |

---

## 🚀 Script de Importación Automática

### Ubicación
```bash
./scripts/auto-import-n8n-workflows.sh
```

### Características

1. **Verificación de disponibilidad de n8n**
   - Comprueba que n8n esté activo y responda

2. **Gestión de API Key**
   - Guarda la API Key de forma segura (`.n8n_api_key`)
   - Permisos restrictivos (`chmod 600`)
   - Reutiliza la API Key en ejecuciones futuras

3. **Validación de archivos**
   - Detecta archivos vacíos
   - Valida formato JSON
   - Omite automáticamente archivos problemáticos

4. **Filtrado inteligente de datos**
   - Elimina campos no aceptados por la API de n8n
   - Preserva: `name`, `nodes`, `connections`, `staticData`
   - Elimina: `id`, `active`, `tags`, `triggerCount`, `settings` personalizados

5. **Manejo robusto de errores**
   - Detecta errores de autenticación
   - Identifica workflows duplicados
   - Continúa con el siguiente workflow en caso de error

6. **Reporte detallado**
   - Resumen de importación
   - Workflows importados, omitidos y con errores
   - Siguientes pasos claros

---

## 💻 Uso del Script

### Primera vez (con API Key)

```bash
# Genera tu API Key en n8n: http://localhost:5678
# Settings → API → Create an API Key

# Ejecuta el script con la API Key
./scripts/auto-import-n8n-workflows.sh "tu-api-key-generada"
```

### Siguientes ejecuciones

```bash
# La API Key ya está guardada
./scripts/auto-import-n8n-workflows.sh
```

### Renovar API Key

```bash
# Elimina la API Key guardada
rm .n8n_api_key

# Genera una nueva en n8n y ejecuta
./scripts/auto-import-n8n-workflows.sh "nueva-api-key"
```

---

## 📝 Próximos Pasos

### 1. Configurar Credenciales en n8n

Las credenciales deben importarse manualmente por razones de seguridad:

```bash
# Ver guía rápida
cat ./n8n/QUICK_IMPORT_GUIDE.md
```

**Credenciales requeridas:**
- PostgreSQL (`postgres-main.json`)
- Redis (`redis-main.json`)
- Ollama API (`ollama-api.json`)
- Flowise API (`flowise-api.json`)
- Qdrant (`qdrant-api.json`)

**Ubicación de archivos de referencia:**
```bash
./n8n/credentials/
```

### 2. Asignar Credenciales a Workflows

1. Accede a n8n: http://localhost:5678
2. Abre cada workflow
3. Para cada nodo que requiera credenciales:
   - Haz clic en el nodo
   - Selecciona "Credentials"
   - Elige la credencial correspondiente
   - Guarda los cambios

### 3. Activar Workflows

1. Ve a **Workflows** en el menú lateral
2. Para cada workflow:
   - Abre el workflow
   - Activa el toggle en la esquina superior derecha
   - Verifica que no haya errores de configuración

---

## 🔧 Detalles Técnicos

### API de n8n

- **Endpoint**: `http://localhost:5678/api/v1/workflows`
- **Método**: `POST`
- **Headers requeridos**:
  ```
  Content-Type: application/json
  X-N8N-API-KEY: <tu-api-key>
  ```

### Estructura de Datos

#### Formato de Entrada (Workflow Exportado)

```json
{
  "name": "Workflow Name",
  "nodes": [...],
  "connections": {...},
  "settings": {
    "saveDataErrorExecution": "all",
    "saveDataSuccessExecution": "all",
    "saveManualExecutions": true,
    "callerPolicy": "workflowsFromSameOwner"
  },
  "active": false,
  "tags": [],
  "triggerCount": 0,
  "staticData": null
}
```

#### Formato de Salida (Para API)

```json
{
  "name": "Workflow Name",
  "nodes": [...],
  "connections": {...},
  "settings": {},
  "staticData": null
}
```

**Campos eliminados**: `id`, `active`, `createdAt`, `updatedAt`, `tags`, `triggerCount`, propiedades de `settings`

### Transformación con jq

```bash
jq -c '{
  name: .name,
  nodes: .nodes,
  connections: .connections,
  settings: {},
  staticData: (.staticData // null)
}'
```

---

## 🐛 Solución de Problemas

### Error: "API Key inválida"

```bash
# Elimina la API Key guardada
rm .n8n_api_key

# Genera una nueva en n8n y vuelve a intentar
./scripts/auto-import-n8n-workflows.sh "nueva-api-key"
```

### Error: "n8n no está disponible"

```bash
# Verifica el estado de n8n
docker compose ps n8n

# Si no está corriendo, inícialo
docker compose up -d n8n

# Verifica los logs
docker compose logs n8n
```

### Workflows duplicados

El script detecta automáticamente workflows duplicados. Si necesitas reimportar:

1. Elimina el workflow existente en n8n (interfaz web)
2. Ejecuta el script de nuevo

### Archivo JSON inválido

El script omite automáticamente archivos vacíos o con JSON inválido. Verifica el contenido:

```bash
cat ./n8n/workflows/nombre-workflow.json | jq .
```

---

## 📚 Referencias

- [Documentación de n8n API](https://docs.n8n.io/api/)
- [Guía de API Key](./N8N_API_SETUP.md)
- [Guía de Credenciales](./n8n/QUICK_IMPORT_GUIDE.md)
- [Instrucciones de Despliegue](./DEPLOYMENT_SUCCESS.md)

---

## 🎉 Logros

- ✅ Script de importación completamente funcional
- ✅ Gestión segura de API Key
- ✅ Validación y filtrado de datos
- ✅ Manejo robusto de errores
- ✅ 5 workflows importados exitosamente
- ✅ Documentación completa
- ✅ Proceso repetible y automatizado

---

**Fecha de completación**: 12 de octubre de 2025  
**Estado**: ✅ Completado exitosamente  
**Workflows importados**: 5/7 (2 archivos vacíos omitidos)
