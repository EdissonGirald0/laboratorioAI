# 🛠️ Dev Tools Scripts

Scripts CLI para interactuar con los workflows de automatización de desarrollo.

## 📋 Scripts Disponibles

### 1. 🔍 code-review.sh

Analiza código y proporciona revisiones detalladas.

```bash
# Uso básico
./code-review.sh src/utils/validator.js

# Especificar lenguaje
./code-review.sh script.sh bash

# Desde stdin
cat file.py | ./code-review.sh - python

# Ver ayuda
./code-review.sh --help
```

**Características**:
- Auto-detección de lenguaje por extensión
- Análisis de calidad, bugs, optimizaciones
- Clasificación por severidad (high/medium/low)
- Output colorizado

---

### 2. 📝 generate-commit.sh

Genera mensajes de commit convencionales automáticamente.

```bash
# Todos los cambios staged
./generate-commit.sh

# Archivos específicos
./generate-commit.sh src/api/users.js

# Múltiples archivos
./generate-commit.sh src/*.js

# Ver ayuda
./generate-commit.sh --help
```

**Características**:
- Formato Conventional Commits
- Detección automática de tipo (feat, fix, docs, etc.)
- Scope automático
- Detección de breaking changes
- Opción de commit automático

---

### 3. 🐛 analyze-bug.sh

Analiza reportes de bugs con priorización automática.

```bash
# Modo interactivo
./analyze-bug.sh

# Desde archivo JSON
./analyze-bug.sh -i bug-report.json

# Ver ayuda
./analyze-bug.sh --help
```

**Formato JSON**:
```json
{
  "title": "Login button not working",
  "description": "Users cannot login...",
  "steps": "1. Go to login\n2. Click button",
  "expected": "User logs in",
  "actual": "Nothing happens",
  "stackTrace": "Error: ..."
}
```

**Características**:
- Clasificación de severidad (crítico/alto/medio/bajo)
- Categorización automática
- Estimación de tiempo
- Análisis de causa raíz
- Alertas para bugs críticos

---

### 4. 🧪 generate-tests.sh

Genera tests unitarios completos automáticamente.

```bash
# Uso básico (auto-detecta framework)
./generate-tests.sh src/utils/calculator.js

# Especificar framework
./generate-tests.sh main.py pytest

# Con directorio de salida personalizado
OUTPUT_DIR=./src/__tests__ ./generate-tests.sh utils.js

# Ver ayuda
./generate-tests.sh --help
```

**Frameworks soportados**:
- Jest (JavaScript/TypeScript)
- Vitest (JavaScript/TypeScript)
- Mocha (JavaScript)
- Pytest (Python)
- JUnit (Java)
- RSpec (Ruby)

**Características**:
- Auto-detección de framework
- Tests unitarios + edge cases
- Mocks automáticos
- Setup y teardown
- Estimación de cobertura

---

## 🚀 Instalación

### 1. Dar permisos de ejecución

```bash
chmod +x scripts/dev-tools/*.sh
```

### 2. Añadir al PATH (opcional)

```bash
# Añadir a ~/.bashrc o ~/.zshrc
export PATH="$PATH:$PWD/scripts/dev-tools"

# Recargar configuración
source ~/.bashrc  # o source ~/.zshrc
```

Ahora puedes ejecutar los scripts desde cualquier directorio:

```bash
code-review.sh file.js
generate-commit.sh
analyze-bug.sh
generate-tests.sh function.py
```

### 3. Crear aliases (opcional)

```bash
# Añadir a ~/.bashrc o ~/.zshrc
alias review='code-review.sh'
alias genmsg='generate-commit.sh'
alias bugfix='analyze-bug.sh'
alias gentests='generate-tests.sh'
```

Ahora:
```bash
review file.js
genmsg
bugfix -i bug.json
gentests calculator.py
```

---

## ⚙️ Configuración

### Variables de Entorno

Todas disponibles para todos los scripts:

```bash
# URL del servidor n8n
export N8N_URL="http://localhost:5678"

# Directorio de salida para tests
export OUTPUT_DIR="./tests"
```

### Archivo de Configuración

Crear `.devtools.conf` en el directorio del proyecto:

```bash
# .devtools.conf
N8N_URL=http://localhost:5678
OUTPUT_DIR=./src/__tests__
AUTO_COMMIT=false
AUTO_STAGE=true
```

Cargar configuración:
```bash
source .devtools.conf
```

---

## 🔗 Integración con Git Hooks

### Pre-commit Hook (code review)

```bash
# .git/hooks/pre-commit
#!/bin/bash

echo "🔍 Revisando código..."

# Obtener archivos staged
FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(js|ts|py)$')

if [ -n "$FILES" ]; then
    for FILE in $FILES; do
        ./scripts/dev-tools/code-review.sh "$FILE"
        
        # Opcional: Fallar commit si hay severidad alta
        # if grep -q '"severity": "high"' /tmp/review-result.json; then
        #     echo "❌ Commit bloqueado: problemas de severidad alta"
        #     exit 1
        # fi
    done
fi
```

### Commit-msg Hook (generar mensaje)

```bash
# .git/hooks/prepare-commit-msg
#!/bin/bash

COMMIT_MSG_FILE=$1
COMMIT_SOURCE=$2

# Solo generar para commits normales
if [ -z "$COMMIT_SOURCE" ]; then
    # Generar mensaje
    MSG=$(./scripts/dev-tools/generate-commit.sh --output-only)
    
    # Usar mensaje generado como template
    echo "$MSG" > "$COMMIT_MSG_FILE"
fi
```

### Post-commit Hook (generar tests)

```bash
# .git/hooks/post-commit
#!/bin/bash

echo "🧪 Generando tests para archivos nuevos..."

# Obtener archivos del último commit
FILES=$(git diff-tree --no-commit-id --name-only -r HEAD | grep -E '\.(js|ts|py)$')

for FILE in $FILES; do
    if [ -f "$FILE" ]; then
        # Verificar si ya tiene test
        TEST_FILE=$(./scripts/dev-tools/generate-tests.sh "$FILE" --check-only)
        
        if [ ! -f "$TEST_FILE" ]; then
            echo "Generando test para: $FILE"
            ./scripts/dev-tools/generate-tests.sh "$FILE" --auto-save
        fi
    fi
done
```

---

## 🔧 Ejemplos de Uso Avanzado

### Pipeline de CI/CD

```yaml
# .github/workflows/ai-review.yml
name: AI Code Review

on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Review changed files
        run: |
          for file in $(git diff --name-only origin/main...HEAD | grep -E '\.(js|ts|py)$'); do
            ./scripts/dev-tools/code-review.sh "$file" >> review-report.txt
          done
      
      - name: Comment on PR
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs');
            const report = fs.readFileSync('review-report.txt', 'utf8');
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `## 🤖 AI Code Review\n\n${report}`
            });
```

### Script de Lote para Review Completo

```bash
#!/bin/bash
# review-project.sh

echo "🔍 Revisando todo el proyecto..."

find src -type f -name "*.js" -o -name "*.ts" -o -name "*.py" | while read file; do
    echo "Revisando: $file"
    ./scripts/dev-tools/code-review.sh "$file" >> project-review.txt
done

echo "✅ Review completo guardado en: project-review.txt"
```

### Integración con VS Code Tasks

```json
// .vscode/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "AI Code Review",
      "type": "shell",
      "command": "./scripts/dev-tools/code-review.sh ${file}",
      "problemMatcher": [],
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    },
    {
      "label": "Generate Tests",
      "type": "shell",
      "command": "./scripts/dev-tools/generate-tests.sh ${file}",
      "problemMatcher": [],
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    },
    {
      "label": "Generate Commit Message",
      "type": "shell",
      "command": "./scripts/dev-tools/generate-commit.sh",
      "problemMatcher": [],
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    }
  ]
}
```

Usar: `Ctrl+Shift+P` → `Tasks: Run Task` → Seleccionar tarea

---

## 🐛 Troubleshooting

### Error: "No se recibió respuesta del servidor"

```bash
# Verificar que n8n está corriendo
docker compose ps n8n

# Verificar URL
echo $N8N_URL

# Test manual
curl http://localhost:5678/webhook/code-review
```

### Error: "Workflow not found"

```bash
# Verificar workflows en n8n
docker compose exec n8n ls -la /home/node/.n8n/workflows/

# Reimportar workflows
./scripts/setup-n8n-complete.sh
```

### Respuestas lentas

Los modelos de IA pueden tardar 5-30 segundos. Para mejorar:

1. Usar modelos más pequeños
2. Aumentar recursos de Ollama
3. Usar GPU si está disponible

### jq: command not found

```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq

# Fedora/RHEL
sudo dnf install jq
```

---

## 📚 Documentación Relacionada

- [DEV_WORKFLOWS.md](../docs/DEV_WORKFLOWS.md) - Workflows completos
- [n8n Documentation](https://docs.n8n.io/)
- [Ollama Models](https://ollama.ai/library)

---

**Última actualización**: 12 de octubre de 2025  
**Versión**: 1.0.0
