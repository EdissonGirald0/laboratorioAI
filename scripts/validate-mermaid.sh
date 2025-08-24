#!/bin/bash

# Script para validar la sintaxis de diagramas Mermaid en README.md
# Autor: Edisson Giraldo
# Fecha: Julio 2025

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 Validando diagramas Mermaid en README.md..."

# Verificar que README.md existe
if [ ! -f "README.md" ]; then
    echo -e "${RED}❌ Error: README.md no encontrado${NC}"
    exit 1
fi

# Contar diagramas Mermaid
total=$(grep -c "\`\`\`mermaid" README.md)
echo -e "\n� Total de diagramas Mermaid encontrados: ${GREEN}$total${NC}"

if [ "$total" -eq 0 ]; then
    echo -e "${RED}❌ Error: No se encontraron diagramas Mermaid${NC}"
    exit 1
fi

# Verificar tipos de diagramas
echo -e "\n📊 Verificando tipos de diagramas..."
graph_count=$(grep -A1 "\`\`\`mermaid" README.md | grep -c "^graph")
sequence_count=$(grep -A1 "\`\`\`mermaid" README.md | grep -c "^sequenceDiagram")
class_count=$(grep -A1 "\`\`\`mermaid" README.md | grep -c "^classDiagram")
flowchart_count=$(grep -A1 "\`\`\`mermaid" README.md | grep -c "^flowchart")

echo -e "  - Diagramas de grafos: ${GREEN}$graph_count${NC}"
echo -e "  - Diagramas de secuencia: ${GREEN}$sequence_count${NC}"
echo -e "  - Diagramas de clases: ${GREEN}$class_count${NC}"
echo -e "  - Diagramas de flujo: ${GREEN}$flowchart_count${NC}"

# Verificar errores comunes
echo -e "\n� Verificando errores comunes..."

# Verificar referencias a Flowise incorrectas
if grep -q "Floowise\|floowise" README.md; then
    echo -e "${RED}❌ Error: Referencias incorrectas a 'Floowise' encontradas${NC}"
    exit 1
else
    echo -e "${GREEN}✅ No se encontraron referencias incorrectas a Flowise${NC}"
fi

# Verificar balance de bloques de código
mermaid_start=$(grep -c "\`\`\`mermaid" README.md)
all_code_blocks=$(grep -c "\`\`\`" README.md)

# Cada bloque mermaid tiene un inicio y un fin, así que debe haber el doble de bloques
if [ "$all_code_blocks" -ge $((mermaid_start * 2)) ]; then
    echo -e "${GREEN}✅ Bloques de código Mermaid balanceados${NC}"
else
    echo -e "${RED}❌ Error: Bloques de código Mermaid desbalanceados${NC}"
    echo -e "  - Bloques Mermaid: $mermaid_start"
    echo -e "  - Total bloques código: $all_code_blocks"
    exit 1
fi

# Verificar sintaxis básica
echo -e "\n� Verificando sintaxis básica..."

# Extraer y verificar subgrafos
subgraph_errors=0
temp_file="/tmp/mermaid_check.txt"
awk '/```mermaid/,/```/' README.md > "$temp_file"

subgraph_start=$(grep -c "subgraph" "$temp_file")
subgraph_end=$(grep -c "end" "$temp_file")

if [ "$subgraph_start" -ne "$subgraph_end" ]; then
    echo -e "${RED}❌ Error: Subgrafos desbalanceados (start: $subgraph_start, end: $subgraph_end)${NC}"
    subgraph_errors=1
else
    echo -e "${GREEN}✅ Subgrafos balanceados correctamente${NC}"
fi

# Verificar estilos CSS
echo -e "\n🎨 Verificando estilos CSS..."
classDef_count=$(grep -c "classDef" "$temp_file")
class_usage=$(grep -c "class " "$temp_file")

if [ "$classDef_count" -gt 0 ]; then
    echo -e "${GREEN}✅ Estilos CSS definidos: $classDef_count${NC}"
    if [ "$class_usage" -gt 0 ]; then
        echo -e "${GREEN}✅ Estilos CSS utilizados: $class_usage${NC}"
    else
        echo -e "${YELLOW}⚠️  Estilos CSS definidos pero no utilizados${NC}"
    fi
else
    echo -e "${GREEN}✅ No se utilizan estilos CSS (válido)${NC}"
fi

# Limpieza
rm -f "$temp_file"

echo -e "\n🏁 Validación completada"

if [ "$subgraph_errors" -eq 0 ]; then
    echo -e "${GREEN}✅ Todos los diagramas Mermaid pasaron la validación${NC}"
    exit 0
else
    echo -e "${RED}❌ Se encontraron errores en los diagramas${NC}"
    exit 1
fi
