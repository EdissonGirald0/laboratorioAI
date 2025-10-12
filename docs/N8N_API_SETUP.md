# 🔑 Configuración de API Key en n8n

## Resumen

Para automatizar la importación de workflows en n8n necesitas una **API Key**. Este documento explica cómo generarla y usarla.

---

## 📋 Pasos para Generar API Key

### 1. Accede a n8n

```bash
# Abre tu navegador y ve a:
http://localhost:5678
```

### 2. Crea tu Usuario Administrador

Si es la primera vez que accedes:

- **Email**: Usa tu email (ej: edisson.giraldo.dev@gmail.com)
- **Password**: Crea una contraseña segura
- **First Name**: Tu nombre
- **Last Name**: Tu apellido

Completa el formulario de registro.

### 3. Accede a la Configuración de API

1. Una vez dentro de n8n, haz clic en tu avatar (esquina superior derecha)
2. Selecciona **"Settings"**
3. En el menú lateral, busca **"API"**

### 4. Genera una API Key

1. En la sección **"API Keys"**, haz clic en **"Create an API Key"**
2. Dale un nombre descriptivo (ej: "Importación Automática de Workflows")
3. Copia la API Key generada (solo se muestra una vez)

> ⚠️ **IMPORTANTE**: Guarda esta API Key en un lugar seguro. No se volverá a mostrar.

---

## 🚀 Uso de la API Key

### Opción 1: Ejecutar script con la API Key

```bash
# Ejecuta el script proporcionando la API Key como argumento
./scripts/auto-import-n8n-workflows.sh "tu-api-key-aqui"
```

El script guardará automáticamente la API Key en `.n8n_api_key` para futuros usos.

### Opción 2: Guardar API Key manualmente

```bash
# Guarda tu API Key en un archivo
echo "tu-api-key-aqui" > .n8n_api_key
chmod 600 .n8n_api_key

# Luego ejecuta el script sin argumentos
./scripts/auto-import-n8n-workflows.sh
```

---

## 🔄 Importación Automática de Workflows

Una vez configurada la API Key:

```bash
# Ejecuta el script de importación automática
./scripts/auto-import-n8n-workflows.sh
```

El script:
- ✅ Verifica que n8n esté disponible
- ✅ Usa la API Key guardada
- ✅ Importa todos los workflows de `./n8n/workflows/`
- ✅ Muestra resumen de la importación

### Workflows que se Importarán

1. **chatbot.json** - AI Chatbot con memoria usando Qdrant
2. **document-processing-automation.json** - Procesamiento automático de documentos
3. **document-processing.json** - Pipeline de procesamiento de documentos
4. **intelligent-query-system-es.json** - Sistema inteligente de consultas (español)
5. **intelligent-query-system.json** - Sistema inteligente de consultas (inglés)
6. **sentiment-analysis-pipeline.json** - Análisis de sentimientos
7. **system-health-monitoring.json** - Monitoreo del sistema

---

## 🔐 Seguridad

### Protección de la API Key

- El archivo `.n8n_api_key` está en `.gitignore` (no se sube al repositorio)
- Permisos restrictivos: `chmod 600` (solo el usuario puede leer/escribir)
- La API Key nunca se muestra en logs o salidas del script

### Renovación de API Key

Si necesitas renovar la API Key:

```bash
# 1. Elimina la API Key guardada
rm .n8n_api_key

# 2. Genera una nueva API Key en n8n (Settings → API)

# 3. Ejecuta el script con la nueva API Key
./scripts/auto-import-n8n-workflows.sh "nueva-api-key"
```

---

## 📝 Siguientes Pasos Después de la Importación

### 1. Configurar Credenciales

Las credenciales deben configurarse manualmente por seguridad:

```bash
# Ver guía rápida de credenciales
cat ./n8n/QUICK_IMPORT_GUIDE.md
```

Credenciales requeridas:
- **PostgreSQL** (`postgres-main.json`)
- **Redis** (`redis-main.json`)
- **Ollama API** (`ollama-api.json`)
- **Flowise API** (`flowise-api.json`)
- **Qdrant** (`qdrant-api.json`)

### 2. Asignar Credenciales a Workflows

1. Abre cada workflow en n8n
2. Para cada nodo que requiera credenciales:
   - Haz clic en el nodo
   - Selecciona "Credentials"
   - Elige la credencial correspondiente

### 3. Activar Workflows

1. Ve a **Workflows** en el menú lateral
2. Para cada workflow:
   - Abre el workflow
   - Activa el toggle en la esquina superior derecha

---

## 🐛 Troubleshooting

### Error: "API Key inválida"

```bash
# Elimina la API Key guardada
rm .n8n_api_key

# Genera una nueva en n8n y vuelve a intentar
./scripts/auto-import-n8n-workflows.sh "nueva-api-key"
```

### Error: "n8n no está disponible"

```bash
# Verifica que n8n esté corriendo
docker compose ps n8n

# Si no está corriendo, inícialo
docker compose up -d n8n

# Verifica los logs
docker compose logs n8n
```

### Workflows ya existen

El script detecta automáticamente workflows duplicados y los omite:

```
⚠️  Ya existe: chatbot
```

Si quieres reimportar, elimina el workflow existente en n8n primero.

---

## 📚 Referencias

- [Documentación de n8n API](https://docs.n8n.io/api/)
- [Guía de Credenciales](./n8n/QUICK_IMPORT_GUIDE.md)
- [Instrucciones de Despliegue](./DEPLOYMENT_SUCCESS.md)
- [Guía de Credenciales Completa](./CREDENTIALS.md)

---

## 🎯 Resumen Rápido

```bash
# 1. Genera API Key en n8n (http://localhost:5678)
#    Settings → API → Create an API Key

# 2. Importa workflows automáticamente
./scripts/auto-import-n8n-workflows.sh "tu-api-key"

# 3. Configura credenciales manualmente
#    Ver: ./n8n/QUICK_IMPORT_GUIDE.md

# 4. Asigna credenciales a workflows y actívalos
```

---

**¡Listo!** Ahora puedes automatizar la importación de workflows en n8n. 🚀
