# 🤖 Automatizaciones para Desarrollo de Software

## 📋 Descripción

Este documento describe los workflows de n8n diseñados para automatizar tareas comunes en el desarrollo de software. Cada workflow utiliza modelos de IA (Ollama) para proporcionar asistencia inteligente.

---

## 📚 Workflows Disponibles

### 1. 🔍 Code Review Assistant

**Archivo**: `code-review-assistant.json`

**Descripción**: Analiza código fuente y proporciona revisiones detalladas con sugerencias de mejora.

**Endpoint**: `POST /webhook/code-review`

**Entrada**:
```json
{
  "language": "javascript",
  "code": "function example() { ... }"
}
```

**Salida**:
```json
{
  "status": "success",
  "review": "Análisis completo del código...",
  "severity": "medium",
  "timestamp": "2025-10-12T10:00:00Z"
}
```

**Características**:
- ✅ Análisis de calidad de código
- ✅ Detección de bugs potenciales
- ✅ Sugerencias de optimización
- ✅ Revisión de seguridad
- ✅ Recomendaciones de documentación
- ✅ Sugerencias de tests
- ✅ Clasificación por severidad

**Modelo IA**: CodeLlama

**Base de datos**: Almacena en `code_reviews` table

---

### 2. 📝 Git Commit Message Generator

**Archivo**: `git-commit-generator.json`

**Descripción**: Genera mensajes de commit convencionales a partir de diffs de git.

**Endpoint**: `POST /webhook/git-commit`

**Entrada**:
```json
{
  "diff": "diff --git a/file.js..."
}
```

**Salida**:
```json
{
  "commitMessage": "feat(api): add user authentication\n\n- Implement JWT tokens\n- Add login endpoint",
  "type": "feat",
  "scope": "api",
  "description": "add user authentication",
  "body": "- Implement JWT tokens\n- Add login endpoint",
  "hasBreakingChanges": false,
  "timestamp": "2025-10-12T10:00:00Z"
}
```

**Características**:
- ✅ Formato de commits convencional
- ✅ Detección automática de tipo (feat, fix, docs, etc.)
- ✅ Extracción de alcance
- ✅ Generación de cuerpo del mensaje
- ✅ Detección de breaking changes
- ✅ Historial de commits

**Tipos de commit soportados**:
- `feat` - Nueva funcionalidad
- `fix` - Corrección de bugs
- `docs` - Cambios en documentación
- `style` - Formato de código
- `refactor` - Refactorización
- `perf` - Mejoras de rendimiento
- `test` - Añadir tests
- `chore` - Tareas de mantenimiento
- `ci` - Cambios en CI/CD
- `build` - Cambios en build

**Modelo IA**: CodeLlama

**Base de datos**: Almacena en `git_commits` table

---

### 3. 🐛 Bug Report Analyzer

**Archivo**: `bug-report-analyzer.json`

**Descripción**: Analiza reportes de bugs y proporciona análisis detallado con priorización automática.

**Endpoint**: `POST /webhook/bug-report`

**Entrada**:
```json
{
  "title": "Login button not working",
  "description": "When clicking login...",
  "steps": "1. Navigate to login\n2. Enter credentials\n3. Click button",
  "expected": "User should login",
  "actual": "Nothing happens",
  "stackTrace": "Error: Cannot read property..."
}
```

**Salida**:
```json
{
  "title": "Login button not working",
  "analysis": "Análisis completo...",
  "severity": "alto",
  "category": "frontend",
  "estimatedHours": 4,
  "priority": "alta",
  "score": 7,
  "timestamp": "2025-10-12T10:00:00Z",
  "status": "open"
}
```

**Características**:
- ✅ Clasificación automática de severidad
- ✅ Categorización por tipo
- ✅ Estimación de tiempo de resolución
- ✅ Priorización automática
- ✅ Análisis de causa raíz
- ✅ Sugerencias de solución
- ✅ Tests recomendados
- ✅ Alertas para bugs críticos

**Severidades**:
- `crítico` - Afecta funcionalidad principal
- `alto` - Bug importante pero no bloqueante
- `medio` - Bug menor con workaround
- `bajo` - Mejora o bug cosmético

**Categorías**:
- `frontend` - UI/UX
- `backend` - Lógica de servidor
- `database` - Base de datos
- `api` - APIs externas/internas
- `security` - Seguridad
- `performance` - Rendimiento

**Modelo IA**: CodeLlama

**Base de datos**: Almacena en `bug_reports` table

---

### 4. 📖 API Documentation Generator

**Archivo**: `api-documentation-generator.json`

**Descripción**: Genera documentación OpenAPI 3.0 automáticamente a partir de código de endpoints.

**Endpoint**: `POST /webhook/generate-api-docs`

**Entrada**:
```json
{
  "method": "POST",
  "path": "/api/users",
  "description": "Create a new user",
  "code": "router.post('/users', async (req, res) => { ... })"
}
```

**Salida**:
```json
{
  "method": "POST",
  "path": "/api/users",
  "documentation": "Especificación completa...",
  "openApiSpec": {
    "openapi": "3.0.0",
    "paths": { ... }
  },
  "version": "3.0.0",
  "timestamp": "2025-10-12T10:00:00Z"
}
```

**Características**:
- ✅ Especificación OpenAPI 3.0
- ✅ Descripción detallada
- ✅ Parámetros de entrada
- ✅ Respuestas posibles
- ✅ Ejemplos de request/response
- ✅ Esquemas de datos
- ✅ Autenticación
- ✅ Rate limiting
- ✅ Deprecation warnings

**Modelo IA**: CodeLlama

**Base de datos**: Almacena en `api_documentation` table

---

### 5. 🧪 Test Case Generator

**Archivo**: `test-case-generator.json`

**Descripción**: Genera tests unitarios completos a partir de código fuente.

**Endpoint**: `POST /webhook/generate-tests`

**Entrada**:
```json
{
  "language": "javascript",
  "testFramework": "Jest",
  "code": "function sum(a, b) { return a + b; }"
}
```

**Salida**:
```json
{
  "language": "javascript",
  "testFramework": "Jest",
  "testCode": "describe('sum', () => { ... })",
  "testCount": 8,
  "hasUnitTests": true,
  "hasIntegrationTests": false,
  "hasMocks": true,
  "estimatedCoverage": 90,
  "timestamp": "2025-10-12T10:00:00Z"
}
```

**Características**:
- ✅ Tests unitarios completos
- ✅ Tests de casos edge
- ✅ Tests de errores
- ✅ Mocks necesarios
- ✅ Setup y teardown
- ✅ Tests de integración
- ✅ Estimación de cobertura
- ✅ Comentarios explicativos

**Frameworks soportados**:
- Jest (JavaScript/TypeScript)
- Mocha (JavaScript)
- Vitest (JavaScript/TypeScript)
- Pytest (Python)
- JUnit (Java)
- RSpec (Ruby)

**Cobertura**:
- Happy path
- Error handling
- Boundary conditions
- Edge cases
- Null/undefined handling

**Modelo IA**: CodeLlama

**Base de datos**: Almacena en `generated_tests` table

---

## 🗄️ Base de Datos

### Tablas Creadas

El script `03-dev-workflows-schema.sql` crea las siguientes tablas:

1. **code_reviews** - Revisiones de código
2. **git_commits** - Mensajes de commit
3. **bug_reports** - Reportes de bugs
4. **api_documentation** - Documentación de API
5. **generated_tests** - Tests generados

### Vistas Creadas

1. **bug_summary** - Resumen de bugs por severidad/categoría
2. **commit_stats** - Estadísticas de commits
3. **test_coverage_stats** - Estadísticas de cobertura

---

## 🚀 Uso

### 1. Configurar Base de Datos

```bash
# Ejecutar script de inicialización
docker compose exec postgres psql -U aiadmin -d ailab -f /docker-entrypoint-initdb.d/03-dev-workflows-schema.sql
```

### 2. Importar Workflows

```bash
# Importar todos los workflows de desarrollo
./scripts/setup-n8n-complete.sh
```

O importar individualmente:

```bash
# Copiar workflows a n8n
docker compose exec n8n cp /data/workflows/*.json /home/node/.n8n/workflows/
```

### 3. Activar Workflows

1. Acceder a n8n: `http://localhost:5678`
2. Ir a Workflows
3. Activar cada workflow

### 4. Obtener URLs de Webhooks

Cada workflow genera una URL única de webhook:

```
http://localhost:5678/webhook/code-review
http://localhost:5678/webhook/git-commit
http://localhost:5678/webhook/bug-report
http://localhost:5678/webhook/generate-api-docs
http://localhost:5678/webhook/generate-tests
```

---

## 📊 Ejemplos de Uso

### Code Review

```bash
curl -X POST http://localhost:5678/webhook/code-review \
  -H "Content-Type: application/json" \
  -d '{
    "language": "javascript",
    "code": "function validateEmail(email) { return email.includes('@'); }"
  }'
```

### Git Commit Message

```bash
curl -X POST http://localhost:5678/webhook/git-commit \
  -H "Content-Type: application/json" \
  -d '{
    "diff": "diff --git a/auth.js b/auth.js\n+function login() { ... }"
  }'
```

### Bug Report

```bash
curl -X POST http://localhost:5678/webhook/bug-report \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Login fails with special characters",
    "description": "Users cannot login when password contains special characters",
    "steps": "1. Use password with @ symbol\n2. Click login",
    "expected": "Login successful",
    "actual": "Error 400",
    "stackTrace": "ValidationError: Invalid password format"
  }'
```

### API Documentation

```bash
curl -X POST http://localhost:5678/webhook/generate-api-docs \
  -H "Content-Type: application/json" \
  -d '{
    "method": "POST",
    "path": "/api/users",
    "description": "Create new user",
    "code": "router.post('/users', async (req, res) => { ... })"
  }'
```

### Test Generation

```bash
curl -X POST http://localhost:5678/webhook/generate-tests \
  -H "Content-Type: application/json" \
  -d '{
    "language": "javascript",
    "testFramework": "Jest",
    "code": "function calculateDiscount(price, percentage) { return price * (1 - percentage / 100); }"
  }'
```

---

## 📈 Métricas y Análisis

### Consultas SQL Útiles

```sql
-- Top 10 bugs por severidad
SELECT * FROM bug_reports 
ORDER BY score DESC, created_at DESC 
LIMIT 10;

-- Estadísticas de commits por tipo
SELECT type, COUNT(*) as total
FROM git_commits
GROUP BY type
ORDER BY total DESC;

-- Cobertura promedio de tests
SELECT 
  language,
  AVG(estimated_coverage) as avg_coverage,
  COUNT(*) as total_tests
FROM generated_tests
GROUP BY language;

-- APIs más documentadas
SELECT method, COUNT(*) as endpoints
FROM api_documentation
GROUP BY method
ORDER BY endpoints DESC;
```

---

## 🔧 Personalización

### Cambiar Modelo de IA

Editar en cada workflow el parámetro `model`:

```json
{
  "name": "model",
  "value": "codellama"  // Cambiar a otro modelo
}
```

Modelos recomendados:
- `codellama` - Código general
- `llama2` - Tareas generales
- `mistral` - Razonamiento avanzado
- `phi` - Modelo ligero

### Ajustar Prompts

Los prompts están en el campo `prompt` de cada nodo Ollama. Personalizar según necesidades.

### Añadir Notificaciones

Agregar nodos adicionales después de guardar en DB:
- Email (SMTP)
- Slack
- Discord
- Telegram
- Webhooks personalizados

---

## 🔐 Seguridad

⚠️ **Importante**: Los webhooks están expuestos públicamente por defecto.

### Recomendaciones:

1. **Añadir Autenticación**:
   - API Keys
   - JWT Tokens
   - Basic Auth

2. **Rate Limiting**:
   - Limitar requests por IP
   - Throttling por usuario

3. **Validación de Entrada**:
   - Sanitizar código
   - Limitar tamaño de payloads
   - Validar tipos de datos

4. **Firewall**:
   - Restringir IPs permitidas
   - Usar VPN o proxy reverso

---

## 📚 Documentación Adicional

- [n8n Documentation](https://docs.n8n.io/)
- [Ollama Models](https://ollama.ai/library)
- [PostgreSQL JSON Functions](https://www.postgresql.org/docs/current/functions-json.html)
- [OpenAPI Specification](https://swagger.io/specification/)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

## 🤝 Contribuir

Para añadir nuevos workflows:

1. Crear archivo JSON en `n8n/workflows/`
2. Actualizar este documento
3. Añadir tabla en SQL si es necesario
4. Crear tests de integración
5. Documentar ejemplos de uso

---

## 📝 Notas

- Los workflows requieren Ollama con el modelo CodeLlama instalado
- Tiempos de respuesta varían según complejidad (2-30 segundos)
- Resultados mejoran con modelos más grandes
- Considerar caché para requests frecuentes

---

**Última actualización**: 12 de octubre de 2025  
**Versión**: 1.0.0  
**Autor**: Edisson Giraldo
