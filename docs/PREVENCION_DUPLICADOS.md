# Prevención de Duplicados en n8n

## 📋 Resumen

Este documento describe el sistema de prevención de duplicados implementado en los scripts de importación automática para workflows y credenciales en n8n.

## 🎯 Problema Identificado

Durante la operación del laboratorio, se detectó un problema crítico:

- **55 workflows totales** (46 duplicados)
- **Conflictos de webhook paths**: Múltiples workflows con la misma ruta webhook
- **Causa**: Los scripts de importación no verificaban la existencia de recursos antes de crearlos

### Impacto

- ❌ Conflictos en rutas de webhooks
- ❌ Confusión en la gestión de workflows
- ❌ Dificultad para identificar el workflow activo correcto
- ❌ Uso innecesario de recursos

## ✅ Solución Implementada

### 1. Script de Limpieza de Duplicados

**Archivo**: `scripts/clean-duplicate-workflows.sh`

Funciones principales:
- `get_all_workflows()`: Lista todos los workflows vía API
- `deactivate_workflow($id)`: Desactiva un workflow por ID
- `delete_workflow($id)`: Elimina un workflow por ID
- Lógica de procesamiento: Agrupa por nombre, mantiene el primero, elimina los demás

**Resultado de la limpieza**:
```
Workflows antes: 55 (46 duplicados)
Workflows después: 9 (únicos)
```

### 2. Detección de Duplicados en Workflows

**Archivo**: `scripts/auto-import-n8n-workflows.sh`

#### Función de detección

```bash
workflow_exists() {
    local workflow_name="$1"
    
    # Obtener todos los workflows
    local response=$(curl -s -H "X-N8N-API-KEY: $API_KEY" \
        "$N8N_API_BASE/workflows?limit=1000")
    
    # Contar workflows con el mismo nombre
    local count=$(echo "$response" | jq -r \
        "[.data[] | select(.name == \"$workflow_name\")] | length" 2>/dev/null)
    
    if [ -z "$count" ] || [ "$count" = "null" ]; then
        echo "0"
        return 1
    fi
    
    echo "$count"
    return 0
}
```

#### Implementación en la importación

```bash
import_workflow() {
    local file_path="$1"
    local workflow_name=$(jq -r '.name' "$file_path" 2>/dev/null)
    
    # Verificar si ya existe
    local existing_count=$(workflow_exists "$workflow_name")
    
    if [ "$existing_count" -gt 0 ]; then
        echo "  ℹ️  Ya existe: $workflow_name ($existing_count instancia(s))"
        echo "  ⏭️  Omitiendo importación para evitar duplicados"
        return 4  # Código para "ya existe"
    fi
    
    # Importar workflow...
}
```

#### Códigos de retorno

- `0`: Importación exitosa
- `2`: Error de autenticación
- `3`: Archivo inválido o vacío
- `4`: **Workflow ya existe (duplicado detectado)**

### 3. Detección de Duplicados en Credenciales

**Archivo**: `scripts/auto-import-n8n-credentials.sh`

#### Limitación de la API de n8n

⚠️ **IMPORTANTE**: La API de credenciales de n8n tiene restricciones de seguridad:
- No permite listar todas las credenciales existentes
- El método GET en `/api/v1/credentials` retorna "GET method not allowed"
- Esto es por diseño para proteger información sensible

#### Solución alternativa implementada

```bash
credential_exists() {
    local cred_name="$1"
    
    # Intentar obtener credenciales (puede no funcionar por seguridad)
    local response=$(curl -s -H "X-N8N-API-KEY: $API_KEY" \
        "$N8N_API_BASE/credentials")
    
    # Verificar si la credencial ya existe
    local count=$(echo "$response" | jq -r \
        "[.data[] | select(.name == \"$cred_name\")] | length" 2>/dev/null)
    
    # Si count está vacío o es null, retornar 0
    if [ -z "$count" ] || [ "$count" = "null" ]; then
        echo "0"
        return 1
    fi
    
    echo "$count"
    return 0
}
```

#### Implementación en cada función de creación

Patrón aplicado a todas las funciones `create_*_credential()`:

```bash
create_postgres_credential() {
    local cred_name="$1"
    
    # Verificar si la credencial ya existe
    local existing_count=$(credential_exists "$cred_name")
    if [ "$existing_count" -gt 0 ]; then
        echo "  ℹ️  Ya existe: $cred_name (${existing_count} instancia(s))"
        echo "  ⏭️  Omitiendo creación para evitar duplicados"
        return 2  # Código para "ya existe"
    fi
    
    # Crear credencial...
}
```

Funciones modificadas:
- ✅ `create_postgres_credential()`
- ✅ `create_redis_credential()`
- ✅ `create_ollama_credential()`
- ✅ `create_flowise_credential()`
- ✅ `create_qdrant_credential()`

#### Códigos de retorno

- `0`: Creación exitosa
- `1`: Error en la creación
- `2`: **Credencial ya existe (duplicado detectado)**

## 📊 Resultados

### Workflows

```
Prueba de detección de duplicados:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total de workflows encontrados: 12

✅ Importados exitosamente: 0
ℹ️  Ya existían (omitidos): 10
⚠️  Omitidos (vacíos/inválidos): 2
```

### Credenciales

⚠️ **Limitación**: La detección de duplicados en credenciales está limitada por la API de n8n.

**Recomendación**: Ejecutar el script de credenciales solo una vez durante la inicialización del sistema, o gestionar las credenciales manualmente desde la interfaz de n8n.

## 🔧 Uso de los Scripts

### Script de limpieza de workflows duplicados

```bash
# Limpiar workflows duplicados existentes
./scripts/clean-duplicate-workflows.sh
```

### Importación segura de workflows

```bash
# Importar workflows (omite duplicados automáticamente)
./scripts/auto-import-n8n-workflows.sh
```

### Importación de credenciales

```bash
# Importar credenciales (ejecutar solo una vez)
./scripts/auto-import-n8n-credentials.sh
```

## 🎯 Buenas Prácticas

### Para Workflows

1. ✅ **Ejecuta el script de importación libremente** - Los duplicados se omiten automáticamente
2. ✅ **Usa el script de limpieza** - Si detectas duplicados manualmente
3. ✅ **Verifica workflows activos** - Asegúrate de que solo hay una instancia activa

### Para Credenciales

1. ⚠️ **Ejecuta el script solo una vez** - Durante la inicialización
2. ⚠️ **Gestiona credenciales manualmente** - Usa la interfaz de n8n para actualizaciones
3. ⚠️ **Documenta credenciales creadas** - Mantén un registro de las credenciales existentes

## 🔍 Verificación

### Verificar workflows únicos

```bash
# Contar workflows totales
curl -s -H "X-N8N-API-KEY: $(cat ./config/.n8n_api_key)" \
    "http://localhost:5678/api/v1/workflows?limit=1000" | \
    jq '.data | length'

# Listar workflows con nombres
curl -s -H "X-N8N-API-KEY: $(cat ./config/.n8n_api_key)" \
    "http://localhost:5678/api/v1/workflows?limit=1000" | \
    jq -r '.data[] | "\(.id) - \(.name)"'
```

### Verificar credenciales

⚠️ No es posible listar credenciales vía API por motivos de seguridad.

**Alternativa**: Accede a la interfaz web de n8n:
1. Navega a `http://localhost:5678`
2. Ve a `Settings → Credentials`
3. Verifica manualmente las credenciales existentes

## 📝 Códigos de Retorno

### auto-import-n8n-workflows.sh

| Código | Significado | Acción |
|--------|-------------|--------|
| 0 | Importación exitosa | Workflow creado |
| 2 | Error de autenticación | Verificar API Key |
| 3 | Archivo inválido | Revisar JSON del workflow |
| 4 | Ya existe | Duplicado omitido |

### auto-import-n8n-credentials.sh

| Código | Significado | Acción |
|--------|-------------|--------|
| 0 | Creación exitosa | Credencial creada |
| 1 | Error en creación | Revisar logs |
| 2 | Ya existe* | Duplicado omitido* |

\* **Nota**: La detección puede no funcionar por limitaciones de la API.

## 🚀 Integración con CI/CD

Los scripts de importación son **idempotentes** para workflows, lo que permite:

```yaml
# .github/workflows/deploy.yml
- name: Import workflows
  run: ./scripts/auto-import-n8n-workflows.sh
  # ✅ Seguro ejecutar múltiples veces
  # ✅ Omite duplicados automáticamente
```

Para credenciales, se recomienda:

```yaml
# .github/workflows/deploy.yml
- name: Import credentials (only on first deployment)
  run: |
    if [ ! -f .credentials-imported ]; then
      ./scripts/auto-import-n8n-credentials.sh
      touch .credentials-imported
    fi
  # ⚠️ Solo en la primera ejecución
```

## 📚 Referencias

- [API de n8n - Workflows](https://docs.n8n.io/api/v1/workflows/)
- [API de n8n - Credentials](https://docs.n8n.io/api/v1/credentials/)
- [Conventional Commits](https://www.conventionalcommits.org/)

## 🐛 Problemas Conocidos

### 1. Credenciales no verificables

**Problema**: La API de n8n no permite listar credenciales por seguridad.

**Impacto**: La detección de duplicados en credenciales puede no funcionar.

**Solución temporal**: Ejecutar el script de credenciales solo una vez y gestionar manualmente.

**Solución futura**: Implementar un registro local de credenciales creadas.

### 2. Workflows con nombres idénticos

**Problema**: Si manualmente se crean workflows con nombres duplicados.

**Impacto**: El script detectará múltiples instancias.

**Solución**: Usar el script de limpieza `clean-duplicate-workflows.sh`.

## 🔮 Mejoras Futuras

1. **Registro local de credenciales**
   - Mantener un archivo JSON con las credenciales creadas
   - Verificar contra este registro antes de crear nuevas

2. **Validación avanzada de workflows**
   - Verificar no solo el nombre, sino también la estructura
   - Detectar workflows con nombres diferentes pero contenido similar

3. **Dashboard de estado**
   - Mostrar workflows activos/inactivos
   - Alertar sobre posibles duplicados
   - Estadísticas de uso

4. **Automatización de limpieza**
   - Ejecución programada del script de limpieza
   - Notificaciones cuando se detectan duplicados

---

**Última actualización**: 2024-01-XX
**Mantenedor**: @EdissonGirald0
**Estado**: ✅ Implementado y probado
