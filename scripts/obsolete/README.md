# Scripts Obsoletos

Esta carpeta contiene scripts que han sido reemplazados por la nueva implementación de inicialización automática.

## ⚠️ No usar estos scripts

Los siguientes scripts están **obsoletos** y han sido reemplazados:

### Scripts de Activación (Duplicados)
- `activate-workflows.sh` → **Usar**: `activate-dev-workflows.sh`
- `auto-activate-workflows.sh` → **Usar**: `activate-dev-workflows.sh`

### Scripts de Importación (Duplicados)
- `import-n8n-data.sh` → **Usar**: `auto-import-n8n-workflows.sh`
- `import-workflows-n8n.sh` → **Usar**: `auto-import-n8n-workflows.sh`

### Scripts de Deployment (Obsoletos)
- `deploy-dev-workflows.sh` → **Usar**: `docker-init-automation.sh`
- `setup-n8n-automation.sh` → **Usar**: `docker-init-automation.sh`
- `setup-n8n-complete.sh` → **Usar**: `docker-init-automation.sh`

---

## ✅ Scripts Actuales (en /scripts/)

### Inicialización Automática
- `docker-init-automation.sh` - Script principal de configuración
- `post-start.sh` - Wrapper de ejecución post-inicio

### Importación y Configuración
- `auto-import-n8n-workflows.sh` - Importa workflows vía API
- `auto-import-n8n-credentials.sh` - Crea credenciales vía API
- `activate-dev-workflows.sh` - Activa workflows vía API

### Utilidades
- `init-env.sh` - Inicializa variables de entorno
- `validate-env.sh` - Valida configuración
- `backup-data.sh` - Backup de datos
- `cleanup.sh` - Limpieza del sistema
- `fix-ollama-url.sh` - Corrección de URLs de Ollama
- `validate-auto-init.sh` - Validación de inicialización

---

## 🗑️ Para eliminar estos archivos

Si estás seguro de que no los necesitas:

```bash
cd /home/edissondev1/proyectos/laboratorioAI/scripts
rm -rf obsolete/
```

**Recomendación**: Mantener esta carpeta por un tiempo antes de eliminar definitivamente.
