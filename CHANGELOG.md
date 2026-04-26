# Changelog

## [3.0.0] - Abril 2026

### Refactorizacion Completa
- **Eliminados** 31 archivos obsoletos (scripts, docs, configs)
- **Eliminado** servicio `dev` y `init-automation` del docker-compose
- **Simplificada** documentacion: 12 docs activos (antes 31)
- **Unificados** scripts en `scripts/`

### Automatizacion de BD
- PostgreSQL crea/recupera `n8n_db` y `ailab` automaticamente
- Init scripts para primer despliegue (`postgres/init-scripts/`)
- Comando inline en docker-compose para recuperacion en reinicios

### Correcciones
- Redis mapeado a puerto 6380 para evitar conflictos
- PostgreSQL pinneado a `16-alpine` para estabilidad
- Volumen de postgres en `/var/lib/postgresql` (compatible con versiones futuras)
- OpenWebUI apuntando al Redis interno correcto

### Docs
- 12 documentos activos (antes 21)
- README.md raiz actualizado
- AGENTS.md actualizado con datos reales del proyecto

---

## [2.0.0] - Octubre 2025

### Reorganizacion
- Documentacion movida a `docs/` (17 archivos)
- Archivos sensibles en `config/`
- Backups organizados en `backups/`

### Automatizacion 96%
- Auto-importacion de workflows n8n
- Auto-creacion de credenciales
- Script maestro `setup-n8n-complete.sh`

### Correcciones
- Fix autenticacion Redis en OpenWebUI
- Scripts actualizados con nuevas rutas
- `.gitignore` optimizado