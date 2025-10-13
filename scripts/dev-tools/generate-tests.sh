#!/bin/bash

# Script para generar tests usando el workflow de n8n
# Uso: ./generate-tests.sh <archivo> [framework]

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Configuración
N8N_URL="${N8N_URL:-http://localhost:5678}"
WEBHOOK_PATH="/webhook/generate-tests"

# Función de ayuda
show_help() {
    cat << EOF
${BLUE}Test Case Generator${NC}

Genera tests unitarios completos a partir de código fuente.

${YELLOW}Uso:${NC}
    $0 <archivo> [framework]

${YELLOW}Argumentos:${NC}
    archivo     - Ruta al archivo de código
    framework   - Framework de testing (opcional, auto-detectado)

${YELLOW}Frameworks soportados:${NC}
    - Jest (JavaScript/TypeScript)
    - Vitest (JavaScript/TypeScript)
    - Mocha (JavaScript)
    - Pytest (Python)
    - JUnit (Java)
    - RSpec (Ruby)

${YELLOW}Ejemplos:${NC}
    $0 src/utils/validator.js
    $0 main.py pytest
    $0 Calculator.java junit

${YELLOW}Variables de entorno:${NC}
    N8N_URL     - URL del servidor n8n (default: http://localhost:5678)
    OUTPUT_DIR  - Directorio de salida para tests (default: ./tests)

${YELLOW}Características:${NC}
    - Tests unitarios completos
    - Casos edge y error handling
    - Mocks necesarios
    - Setup y teardown
    - Estimación de cobertura

EOF
    exit 0
}

# Detectar framework por extensión y configuración del proyecto
detect_framework() {
    local file="$1"
    
    # Por extensión
    case "$file" in
        *.js|*.ts)
            # Buscar configuración de Jest o Vitest
            if [[ -f "jest.config.js" ]] || [[ -f "jest.config.ts" ]] || grep -q '"jest"' package.json 2>/dev/null; then
                echo "Jest"
            elif [[ -f "vitest.config.js" ]] || [[ -f "vitest.config.ts" ]] || grep -q '"vitest"' package.json 2>/dev/null; then
                echo "Vitest"
            else
                echo "Jest"  # Default para JS/TS
            fi
            ;;
        *.py)       echo "pytest" ;;
        *.java)     echo "JUnit" ;;
        *.rb)       echo "RSpec" ;;
        *)          echo "Jest" ;;  # Default
    esac
}

# Detectar lenguaje
detect_language() {
    local file="$1"
    case "$file" in
        *.js)       echo "javascript" ;;
        *.ts)       echo "typescript" ;;
        *.py)       echo "python" ;;
        *.java)     echo "java" ;;
        *.rb)       echo "ruby" ;;
        *)          echo "unknown" ;;
    esac
}

# Generar nombre de archivo de test
generate_test_filename() {
    local source_file="$1"
    local framework="$2"
    local basename=$(basename "$source_file")
    local dirname=$(dirname "$source_file")
    local name="${basename%.*}"
    local ext="${basename##*.}"
    
    case "$framework" in
        Jest|Vitest|Mocha)
            echo "${name}.test.${ext}"
            ;;
        pytest)
            echo "test_${name}.py"
            ;;
        JUnit)
            echo "${name}Test.java"
            ;;
        RSpec)
            echo "${name}_spec.rb"
            ;;
        *)
            echo "${name}.test.${ext}"
            ;;
    esac
}

# Validar argumentos
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_help
fi

if [[ -z "$1" ]]; then
    echo -e "${RED}❌ Error: Debe especificar un archivo${NC}"
    echo "Uso: $0 <archivo> [framework]"
    exit 1
fi

FILE="$1"
if [[ ! -f "$FILE" ]]; then
    echo -e "${RED}❌ Error: Archivo no encontrado: $FILE${NC}"
    exit 1
fi

# Detectar lenguaje y framework
LANGUAGE=$(detect_language "$FILE")
FRAMEWORK="${2:-$(detect_framework "$FILE")}"

# Leer código
CODE=$(cat "$FILE")

echo -e "${BLUE}🧪 Generando tests...${NC}"
echo -e "${YELLOW}Archivo:${NC} $FILE"
echo -e "${YELLOW}Lenguaje:${NC} $LANGUAGE"
echo -e "${YELLOW}Framework:${NC} $FRAMEWORK"
echo -e "${YELLOW}Líneas:${NC} $(echo "$CODE" | wc -l)"
echo ""

# Escapar JSON
CODE_JSON=$(echo "$CODE" | jq -Rs .)

# Crear payload
PAYLOAD=$(cat <<EOF
{
  "language": "$LANGUAGE",
  "testFramework": "$FRAMEWORK",
  "code": $CODE_JSON
}
EOF
)

# Enviar request
RESPONSE=$(curl -s -X POST "$N8N_URL$WEBHOOK_PATH" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD")

# Verificar respuesta
if [[ -z "$RESPONSE" ]]; then
    echo -e "${RED}❌ Error: No se recibió respuesta del servidor${NC}"
    exit 1
fi

# Parsear respuesta
TEST_CODE=$(echo "$RESPONSE" | jq -r '.testCode // ""')

if [[ -z "$TEST_CODE" ]]; then
    echo -e "${RED}❌ Error al generar tests${NC}"
    echo "$RESPONSE" | jq .
    exit 1
fi

# Extraer métricas
TEST_COUNT=$(echo "$RESPONSE" | jq -r '.testCount // 0')
HAS_UNIT=$(echo "$RESPONSE" | jq -r '.hasUnitTests // false')
HAS_INTEGRATION=$(echo "$RESPONSE" | jq -r '.hasIntegrationTests // false')
HAS_MOCKS=$(echo "$RESPONSE" | jq -r '.hasMocks // false')
COVERAGE=$(echo "$RESPONSE" | jq -r '.estimatedCoverage // 0')

echo -e "${GREEN}✅ Tests generados${NC}"
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Tests generados:${NC} $TEST_COUNT"
echo -e "${BLUE}Tests unitarios:${NC} $([ "$HAS_UNIT" == "true" ] && echo "✅" || echo "❌")"
echo -e "${BLUE}Tests de integración:${NC} $([ "$HAS_INTEGRATION" == "true" ] && echo "✅" || echo "❌")"
echo -e "${BLUE}Usa mocks:${NC} $([ "$HAS_MOCKS" == "true" ] && echo "✅" || echo "❌")"
echo -e "${BLUE}Cobertura estimada:${NC} ${COVERAGE}%"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Generar nombre de archivo de test
TEST_FILENAME=$(generate_test_filename "$FILE" "$FRAMEWORK")
OUTPUT_DIR="${OUTPUT_DIR:-./tests}"
OUTPUT_FILE="$OUTPUT_DIR/$TEST_FILENAME"

# Preguntar si desea guardar
echo -e "${BLUE}Archivo de test sugerido:${NC} $OUTPUT_FILE"
read -p "$(echo -e "${BLUE}¿Deseas guardar los tests? [y/N]:${NC} ")" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Crear directorio si no existe
    mkdir -p "$OUTPUT_DIR"
    
    # Guardar tests
    echo "$TEST_CODE" > "$OUTPUT_FILE"
    echo -e "${GREEN}✅ Tests guardados en: $OUTPUT_FILE${NC}"
    
    # Mostrar preview
    echo ""
    echo -e "${BLUE}📄 Preview (primeras 20 líneas):${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    head -n 20 "$OUTPUT_FILE"
    if [[ $(wc -l < "$OUTPUT_FILE") -gt 20 ]]; then
        echo "..."
        echo -e "${BLUE}($(wc -l < "$OUTPUT_FILE") líneas totales)${NC}"
    fi
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
else
    echo -e "${YELLOW}ℹ️  Tests no guardados${NC}"
    echo ""
    echo -e "${BLUE}📋 Código de tests:${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "$TEST_CODE"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
fi
