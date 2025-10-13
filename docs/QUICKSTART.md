# 🚀 INICIO RÁPIDO - Configuración Automática

## ✨ Nuevo: Inicialización Automática al 100%

El sistema ahora se configura automáticamente al iniciar. **No requiere pasos manuales**.

---

## 📦 Instalación y Primer Inicio

### 1️⃣ Clonar el repositorio
```bash
git clone https://github.com/EdissonGirald0/laboratorioAI.git
cd laboratorioAI
```

### 2️⃣ Inicializar variables de entorno
```bash
./scripts/init-env.sh
```

### 3️⃣ Iniciar el sistema (UN SOLO COMANDO)
```bash
make start
```

Este comando hará **AUTOMÁTICAMENTE**:
- ✅ Inicia todos los contenedores Docker
- ✅ Espera a que los servicios estén listos
- ✅ Descarga el modelo CodeLlama en Ollama
- ✅ Importa workflows en n8n
- ✅ Crea credenciales en n8n
- ✅ Activa workflows
- ✅ Configura webhooks

**¡Todo listo en ~5 minutos!** ⏱️

---

## 🎯 Comandos Disponibles (Makefile)

```bash
make help          # Ver todos los comandos
make start         # Iniciar con configuración automática ⭐
make stop          # Detener servicios
make restart       # Reiniciar servicios
make status        # Ver estado de servicios
make logs          # Ver logs en tiempo real
make init          # Reconfigurar manualmente
make reset         # Reinicializar sistema
make health        # Verificar salud de servicios
make dev-tools     # Ver herramientas de desarrollo
```

---

## 🌐 URLs de Acceso

Una vez iniciado el sistema:

| Servicio | URL | Descripción |
|----------|-----|-------------|
| **n8n** | http://localhost:5678 | Automatización de workflows |
| **Flowise** | http://localhost:3000 | Flujos de IA visual |
| **OpenWebUI** | http://localhost:8080 | Chat con Ollama |
| **Ollama API** | http://localhost:11434 | API de modelos de IA |
| **Qdrant** | http://localhost:6333 | Base de datos vectorial |

---

## 🔧 Webhooks Activos

El sistema incluye 5 webhooks listos para usar:

```bash
# Code Review
curl -X POST http://localhost:5678/webhook/code-review \
  -H "Content-Type: application/json" \
  -d '{"code": "tu código", "language": "javascript"}'

# Git Commit Message
curl -X POST http://localhost:5678/webhook/git-commit \
  -H "Content-Type: application/json" \
  -d '{"diff": "git diff output"}'

# Bug Report Analyzer
curl -X POST http://localhost:5678/webhook/bug-report \
  -H "Content-Type: application/json" \
  -d '{"title": "Bug", "description": "Descripción"}'

# API Documentation
curl -X POST http://localhost:5678/webhook/generate-api-docs \
  -H "Content-Type: application/json" \
  -d '{"code": "código de API"}'

# Test Generator
curl -X POST http://localhost:5678/webhook/generate-tests \
  -H "Content-Type: application/json" \
  -d '{"code": "código a testear"}'
```

---

## 🛠️ Scripts CLI

También puedes usar los scripts de línea de comandos:

```bash
./scripts/dev-tools/code-review.sh README.md
./scripts/dev-tools/generate-commit.sh
./scripts/dev-tools/analyze-bug.sh
./scripts/dev-tools/generate-tests.sh archivo.js
```

---

## 🔄 Flujo de Inicialización

```
┌─────────────────────────────────────────────┐
│  1. make start                              │
│     └─> docker compose up -d                │
└─────────────────┬───────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────┐
│  2. Espera servicios (30s)                  │
│     ✓ PostgreSQL                            │
│     ✓ Redis                                 │
│     ✓ n8n                                   │
│     ✓ Ollama                                │
└─────────────────┬───────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────┐
│  3. ./scripts/post-start.sh                 │
│     └─> ./scripts/docker-init-automation.sh │
└─────────────────┬───────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────┐
│  4. Configuración Automática                │
│     ✓ Descarga CodeLlama                    │
│     ✓ Importa 10 workflows                  │
│     ✓ Crea 5 credenciales                   │
│     ✓ Activa workflows                      │
└─────────────────┬───────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────┐
│  ✅ SISTEMA LISTO                           │
│     Todos los webhooks activos              │
└─────────────────────────────────────────────┘
```

---

## 📝 Notas Importantes

### Primera Vez
- El primer inicio descargará el modelo **CodeLlama** (~4GB)
- Tiempo estimado: **5-10 minutos** dependiendo de tu conexión
- Una vez descargado, inicios posteriores son **instantáneos**

### Marca de Inicialización
El sistema crea un archivo `./config/.initialized` para evitar reconfiguración:

```bash
# Ver si ya fue inicializado
cat ./config/.initialized

# Forzar reinicialización
rm ./config/.initialized
make init
```

### Sin Inicialización Automática
Si prefieres configurar manualmente:

```bash
make start-no-init    # Inicia servicios sin configurar
# ... configuración manual ...
make init             # Configura cuando estés listo
```

---

## 🆘 Solución de Problemas

### El sistema no se inicia
```bash
# Verificar estado
make status

# Ver logs
make logs

# Verificar salud
make health
```

### Workflows no importados
```bash
# Reinicializar
make reset
make init
```

### Servicios caídos
```bash
# Reiniciar todo
make restart
```

### Limpiar y empezar de cero
```bash
# ⚠️ PELIGRO: Borra todos los datos
make clean
make start
```

---

## 📚 Documentación Adicional

- **Guía Completa**: [README.md](../README.md)
- **Troubleshooting**: [docs/TROUBLESHOOTING.md](../docs/TROUBLESHOOTING.md)
- **n8n Workflows**: [docs/N8N_WORKFLOWS.md](../docs/N8N_WORKFLOWS.md)
- **Ollama**: [docs/OLLAMA.md](../docs/OLLAMA.md)
- **Flowise**: [docs/FLOWISE.md](../docs/FLOWISE.md)

---

**🎉 ¡Todo configurado automáticamente con un solo comando!**

```bash
make start
```
