# 🔧 Implementación de Inicialización Automática

## 📋 Resumen

Se ha implementado un sistema completo de inicialización automática que configura todos los componentes del LaboratorioAI al iniciar Docker Compose.

---

## 🏗️ Arquitectura de Inicialización

### Componentes Creados

1. **`docker-init-automation.sh`** - Script principal de inicialización
2. **`post-start.sh`** - Wrapper para ejecución post-inicio
3. **`Makefile`** - Comandos simplificados
4. **Servicio Docker `init-automation`** - Contenedor de señalización
5. **Marca de inicialización** - `./config/.initialized`

---

## 📁 Archivos Modificados/Creados

### Nuevos Scripts

```
scripts/
├── docker-init-automation.sh    # Script principal ⭐
├── post-start.sh                # Wrapper de ejecución
└── (existentes)
    ├── auto-import-n8n-workflows.sh
    ├── auto-import-n8n-credentials.sh
    └── activate-dev-workflows.sh
```

### Docker Compose

**Agregado**: Servicio `init-automation`
- Contenedor efímero de señalización
- Se ejecuta una vez y termina
- Crea marca temporal en `./config/.init-pending`

### Makefile

**Nuevo**: Comandos de orquestación
- `make start` - Inicio con auto-configuración
- `make init` - Configuración manual
- `make reset` - Reinicialización
- Y 15 comandos más...

---

## 🔄 Flujo de Ejecución

### 1. Usuario ejecuta `make start`

```bash
make start
```

**Acciones**:
1. Ejecuta `docker compose up -d`
2. Espera 30 segundos
3. Ejecuta `./scripts/post-start.sh`

### 2. Post-start verifica inicialización

```bash
./scripts/post-start.sh
```

**Verifica**:
- ¿Existe `./config/.initialized`?
  - **SÍ** → Sale con mensaje
  - **NO** → Ejecuta `docker-init-automation.sh`

### 3. Docker-init-automation configura todo

```bash
./scripts/docker-init-automation.sh
```

**Fases**:

#### FASE 1: Verificación
- Verifica si ya fue inicializado
- Pregunta confirmación si existe marca
- Crea directorio `./config/`

#### FASE 2: Espera de servicios
```bash
wait_for_n8n()      # Máximo 60 intentos (2min)
wait_for_ollama()   # Máximo 30 intentos (1min)
```

#### FASE 3: Ollama
```bash
setup_ollama_model()
```
- Verifica si `codellama` existe
- Lo descarga si no está presente (~4GB)

#### FASE 4: Workflows
```bash
./scripts/auto-import-n8n-workflows.sh
```
- Lee `./n8n/workflows/*.json`
- Limpia campos inválidos
- POST a `/api/v1/workflows`
- Importa 10 workflows

#### FASE 5: Credenciales
```bash
./scripts/auto-import-n8n-credentials.sh
```
- Lee variables de `.env`
- POST a `/api/v1/credentials`
- Crea 5 credenciales:
  - PostgreSQL Main
  - Redis Main
  - Ollama API
  - Flowise API
  - Qdrant

#### FASE 6: Activación
```bash
./scripts/activate-dev-workflows.sh
```
- Busca workflows por nombre
- POST a `/api/v1/workflows/{id}/activate`
- Activa 5 workflows de desarrollo

#### FASE 7: Marca final
```bash
date > ./config/.initialized
```
- Crea archivo de marca
- Contiene fecha de inicialización

---

## 🎯 Resultados Esperados

### Al finalizar exitosamente:

```
✅ 10 Workflows importados
✅ 5 Credenciales creadas
✅ 5 Workflows activos
✅ 5 Webhooks funcionando
✅ Modelo CodeLlama descargado
✅ Sistema 100% operativo
```

### URLs activas:

```
http://localhost:5678        → n8n
http://localhost:3000        → Flowise
http://localhost:8080        → OpenWebUI
http://localhost:11434       → Ollama API
http://localhost:6333        → Qdrant
```

### Webhooks activos:

```
POST /webhook/code-review
POST /webhook/git-commit
POST /webhook/bug-report
POST /webhook/generate-api-docs
POST /webhook/generate-tests
```

---

## 🔐 Sistema de Marcas

### Archivo `.initialized`

**Ubicación**: `./config/.initialized`

**Contenido**: Fecha de inicialización
```
Sun Oct 13 14:30:45 UTC 2025
```

**Propósito**:
- Evitar re-inicialización accidental
- Registro de cuándo fue configurado
- Bandera para scripts

### Archivo `.init-pending`

**Ubicación**: `./config/.init-pending`

**Contenido**: Fecha de creación
```
Sun Oct 13 14:28:12 UTC 2025
```

**Propósito**:
- Señal del contenedor `init-automation`
- Indica que el sistema necesita configuración
- Se elimina al ejecutar `post-start.sh`

---

## 🛠️ Comandos de Mantenimiento

### Verificar estado de inicialización
```bash
if [ -f ./config/.initialized ]; then
  echo "Inicializado el: $(cat ./config/.initialized)"
else
  echo "No inicializado"
fi
```

### Forzar reinicialización
```bash
rm ./config/.initialized
make init
```

### Ver logs de última inicialización
```bash
# Buscar en logs del script
grep -r "INICIALIZACIÓN" ./logs/ 2>/dev/null
```

### Reiniciar sin configurar
```bash
make start-no-init
```

---

## 🐛 Troubleshooting

### Error: "n8n no está disponible"
**Causa**: n8n no responde en healthcheck

**Solución**:
```bash
# Ver logs de n8n
make logs-n8n

# Verificar salud
curl http://localhost:5678/healthz

# Reiniciar n8n
docker restart n8n
sleep 30
make init
```

### Error: "Workflows no importados"
**Causa**: API Key no generada o inválida

**Solución**:
```bash
# Verificar API Key
cat ./config/.n8n_api_key

# Regenerar si no existe
docker exec n8n n8n generate-api-key > ./config/.n8n_api_key

# Reintentar
make init
```

### Error: "Modelo CodeLlama no descargado"
**Causa**: Timeout o falta de espacio

**Solución**:
```bash
# Descargar manualmente
docker exec ollama ollama pull codellama:latest

# Verificar
docker exec ollama ollama list
```

### Sistema ya inicializado pero no funciona
**Solución**:
```bash
# Reinicializar forzado
make reset
make init
```

---

## 🔄 Ciclo de Vida

```
┌─────────────────┐
│  make start     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐      ┌──────────────────┐
│ Docker Compose  │─────▶│ init-automation  │
│ up -d           │      │ (contenedor)     │
└────────┬────────┘      └──────────────────┘
         │                        │
         │                        ▼
         │               ┌──────────────────┐
         │               │ .init-pending    │
         │               │ (marca temporal) │
         │               └──────────────────┘
         ▼
┌─────────────────┐
│ Sleep 30s       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ post-start.sh   │
└────────┬────────┘
         │
         ▼
    ┌────────────┐
    │¿Initialized?│
    └──┬──────┬──┘
       │NO    │SI
       ▼      └──────▶ EXIT
┌────────────────────┐
│docker-init-        │
│automation.sh       │
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│ Configuración      │
│ completa           │
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│ .initialized       │
│ (marca permanente) │
└────────────────────┘
```

---

## 📊 Métricas de Rendimiento

### Tiempo de Inicialización

| Fase | Tiempo Estimado |
|------|-----------------|
| Docker Compose up | 20-30s |
| Espera inicial | 30s |
| Verificación servicios | 10-20s |
| Descarga CodeLlama (primera vez) | 3-10min |
| Importar workflows | 5-10s |
| Crear credenciales | 3-5s |
| Activar workflows | 2-3s |
| **TOTAL (primera vez)** | **5-12 minutos** |
| **TOTAL (subsecuentes)** | **1-2 minutos** |

### Recursos

| Fase | CPU | RAM | Disco |
|------|-----|-----|-------|
| Descarga Ollama | 10% | 500MB | +4GB |
| Importación n8n | 30% | 200MB | +50MB |
| Operación normal | 5% | 100MB | - |

---

## 🎓 Lecciones Aprendidas

### ✅ Lo que funciona bien

1. **Idempotencia**: El sistema detecta si ya fue inicializado
2. **Reintentos**: Wait loops con timeouts razonables
3. **Feedback**: Mensajes claros de progreso
4. **Marcas**: Archivos de estado simples y efectivos
5. **Makefile**: Abstracción de comandos complejos

### ⚠️ Puntos de mejora futura

1. **Logging estructurado**: Implementar logs en JSON
2. **Rollback automático**: Deshacer cambios si falla
3. **Validación post-init**: Tests de integración automáticos
4. **Notificaciones**: Webhook/email al completar
5. **Dashboard**: UI web de estado de inicialización

---

## 📚 Referencias

- [n8n API Documentation](https://docs.n8n.io/api/)
- [Ollama API Reference](https://github.com/ollama/ollama/blob/main/docs/api.md)
- [Docker Compose Healthchecks](https://docs.docker.com/compose/compose-file/compose-file-v3/#healthcheck)
- [Make Manual](https://www.gnu.org/software/make/manual/)

---

**Fecha de implementación**: 13 de octubre de 2025  
**Versión**: 1.0.0  
**Mantenedor**: Edisson Giraldo
