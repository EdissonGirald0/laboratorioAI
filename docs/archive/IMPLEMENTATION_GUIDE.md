# 🎯 Guía de Implementación Completa

Esta guía te llevará paso a paso para tener todos los workflows funcionando al 100%.

## ✅ Estado Actual

### Completado ✓
- [x] Base de datos inicializada (5 tablas, 3 vistas)
- [x] Workflows importados a n8n (5 workflows)
- [x] CodeLlama descargado en Ollama
- [x] Scripts CLI creados y funcionales
- [x] Todos los servicios Docker corriendo

### Pendiente 🔄
- [ ] Activar workflows en n8n
- [ ] Configurar credenciales de PostgreSQL en n8n
- [ ] Probar endpoints de los workflows

---

## 📋 Pasos para Completar la Implementación

### Paso 1: Acceder a n8n

```bash
# Abrir n8n en el navegador
xdg-open http://localhost:5678
# o
open http://localhost:5678
```

**URL**: http://localhost:5678

---

### Paso 2: Configurar Credenciales de PostgreSQL

1. En n8n, haz clic en **Settings** (⚙️) → **Credentials**
2. Haz clic en **Add Credential**
3. Busca y selecciona **Postgres**
4. Completa los campos:

```
Name: PostgreSQL Main
Host: postgres
Port: 5432
Database: ailab
User: aiadmin
Password: [ver archivo .env - variable POSTGRES_PASSWORD]
SSL: Disabled
```

5. Haz clic en **Create**

**Nota**: Para obtener la contraseña:
```bash
grep POSTGRES_PASSWORD .env
```

---

### Paso 3: Activar los Workflows

En n8n, ve a **Workflows** y activa cada uno:

1. **code-review-assistant**
   - Webhook: `/webhook/code-review`
   - Método: POST

2. **git-commit-generator**
   - Webhook: `/webhook/git-commit`
   - Método: POST

3. **bug-report-analyzer**
   - Webhook: `/webhook/bug-report`
   - Método: POST

4. **api-documentation-generator**
   - Webhook: `/webhook/generate-api-docs`
   - Método: POST

5. **test-case-generator**
   - Webhook: `/webhook/generate-tests`
   - Método: POST

**Para activar cada workflow:**
1. Abre el workflow
2. Haz clic en el toggle **Active/Inactive** en la esquina superior derecha
3. Verifica que muestre **Active** (verde)

---

### Paso 4: Configurar las Credenciales en los Workflows

Para cada workflow:

1. Abre el workflow en n8n
2. Busca el nodo **PostgreSQL** (Save to Database)
3. Haz clic en el nodo
4. En **Credentials**, selecciona **PostgreSQL Main**
5. Guarda el workflow

Repite para los 5 workflows.

---

### Paso 5: Probar los Workflows

Una vez activados, prueba cada workflow:

#### 🔍 Code Review
```bash
./scripts/dev-tools/code-review.sh README.md
```

#### 📝 Git Commit
```bash
git add .
./scripts/dev-tools/generate-commit.sh
```

#### 🐛 Bug Analyzer
```bash
./scripts/dev-tools/analyze-bug.sh
# Sigue las instrucciones interactivas
```

#### 🧪 Test Generator
```bash
./scripts/dev-tools/generate-tests.sh scripts/init-env.sh
```

---

## 🔧 Troubleshooting

### Error: "webhook is not registered"

**Causa**: El workflow no está activado

**Solución**:
1. Ve a n8n → Workflows
2. Abre el workflow
3. Activa el toggle Active/Inactive

---

### Error: "Could not connect to database"

**Causa**: Credenciales de PostgreSQL no configuradas

**Solución**:
1. Sigue el **Paso 2** arriba
2. Verifica que el contenedor de postgres esté corriendo:
   ```bash
   docker compose ps postgres
   ```

---

### Error: "Model not found: codellama"

**Causa**: CodeLlama no está descargado

**Solución**:
```bash
docker compose exec ollama ollama pull codellama
```

---

### Los workflows tardan mucho

**Causa**: El modelo CodeLlama es grande y requiere tiempo

**Soluciones**:
- Primera ejecución: 20-30 segundos (carga del modelo)
- Ejecuciones posteriores: 5-15 segundos
- Para mejorar: Usar GPU si está disponible
- Alternativa: Usar modelo más pequeño (phi, tinyllama)

---

## 📊 Verificar que Todo Funcione

### 1. Verificar servicios
```bash
docker compose ps
```

Todos deben mostrar **healthy** o **Up**.

### 2. Verificar base de datos
```bash
docker compose exec postgres psql -U aiadmin -d ailab -c "\dt"
```

Debe mostrar las 5 tablas.

### 3. Verificar workflows en n8n
```bash
docker compose exec n8n ls -la /home/node/.n8n/workflows/
```

Debe listar los 5 archivos JSON.

### 4. Verificar CodeLlama
```bash
docker compose exec ollama ollama list
```

Debe mostrar `codellama:latest`.

---

## 🎯 Test Completo

Una vez todo configurado, ejecuta este test:

```bash
# Test 1: Code Review
echo "function sum(a, b) { return a + b; }" > test.js
./scripts/dev-tools/code-review.sh test.js

# Test 2: Generate Tests
./scripts/dev-tools/generate-tests.sh test.js

# Test 3: Verificar base de datos
docker compose exec postgres psql -U aiadmin -d ailab -c "SELECT COUNT(*) FROM code_reviews;"
docker compose exec postgres psql -U aiadmin -d ailab -c "SELECT COUNT(*) FROM generated_tests;"

# Cleanup
rm test.js tests/test.test.js
```

**Resultado esperado**:
- Code review completo con sugerencias
- Tests generados automáticamente
- Registros en la base de datos

---

## 📚 Documentación Adicional

- [DEV_WORKFLOWS.md](./DEV_WORKFLOWS.md) - Documentación completa de workflows
- [scripts/dev-tools/README.md](../scripts/dev-tools/README.md) - Guía de scripts CLI
- [n8n Documentation](https://docs.n8n.io/)
- [Ollama Documentation](https://ollama.ai/)

---

## 🎉 ¡Listo!

Una vez completados todos los pasos, tendrás:

✅ 5 workflows de IA funcionando  
✅ Base de datos persistiendo todos los datos  
✅ Scripts CLI para uso fácil  
✅ Integración completa con Ollama (CodeLlama)  
✅ Sistema completamente funcional  

---

**Última actualización**: 12 de octubre de 2025  
**Versión**: 1.0.0
