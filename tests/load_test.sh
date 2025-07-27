#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuración de la prueba
CONCURRENT_USERS=5
REQUESTS_PER_USER=20
TEST_DURATION=300  # 5 minutos

# Función para imprimir mensajes
log() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

# Función para generar carga en Ollama
load_test_ollama() {
    local user=$1
    local requests=$2
    local results_file="results_ollama_user_${user}.txt"
    
    for ((i=1; i<=requests; i++)); do
        start_time=$(date +%s.%N)
        
        response=$(curl -s -w "%{time_total}\n" -X POST http://localhost:11434/api/generate \
            -H 'Content-Type: application/json' \
            -d '{
                "model": "mistral",
                "prompt": "Generate a response for load testing"
            }')
        
        end_time=$(date +%s.%N)
        duration=$(echo "$end_time - $start_time" | bc)
        
        echo "$duration" >> $results_file
        
        # Esperar un tiempo aleatorio entre solicitudes (0-2 segundos)
        sleep $(echo "scale=4; $RANDOM/16384" | bc)
    done
}

# Función para generar carga en Floowise
load_test_floowise() {
    local user=$1
    local requests=$2
    local results_file="results_floowise_user_${user}.txt"
    
    for ((i=1; i<=requests; i++)); do
        start_time=$(date +%s.%N)
        
        response=$(curl -s -w "%{time_total}\n" -X POST http://localhost:3000/api/v1/prediction/test-workflow \
            -H 'Content-Type: application/json' \
            -d '{
                "input": "Test input for load testing",
                "sessionId": "loadtest-'$user'-'$i'"
            }')
        
        end_time=$(date +%s.%N)
        duration=$(echo "$end_time - $start_time" | bc)
        
        echo "$duration" >> $results_file
        
        sleep $(echo "scale=4; $RANDOM/16384" | bc)
    done
}

# Función para monitorear recursos
monitor_resources() {
    log "Iniciando monitoreo de recursos..."
    
    while true; do
        # Obtener uso de CPU y memoria para cada servicio
        docker stats --no-stream --format \
            "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}" \
            >> resource_usage.log
        
        sleep 5
    done
}

# Función para analizar resultados
analyze_results() {
    log "Analizando resultados..."
    
    # Analizar tiempos de respuesta
    echo "Resultados de Ollama:"
    for f in results_ollama_user_*.txt; do
        echo "Archivo: $f"
        awk '
            BEGIN { min=999999; max=0; sum=0; count=0 }
            {
                if ($1 < min) min=$1
                if ($1 > max) max=$1
                sum += $1
                count += 1
            }
            END {
                printf "Min: %.3fs\nMax: %.3fs\nPromedio: %.3fs\nTotal requests: %d\n",
                    min, max, sum/count, count
            }' $f
    done
    
    echo -e "\nResultados de Floowise:"
    for f in results_floowise_user_*.txt; do
        echo "Archivo: $f"
        awk '
            BEGIN { min=999999; max=0; sum=0; count=0 }
            {
                if ($1 < min) min=$1
                if ($1 > max) max=$1
                sum += $1
                count += 1
            }
            END {
                printf "Min: %.3fs\nMax: %.3fs\nPromedio: %.3fs\nTotal requests: %d\n",
                    min, max, sum/count, count
            }' $f
    done
    
    # Analizar uso de recursos
    echo -e "\nUso de recursos (promedios):"
    awk '
        /ollama/ { cpu_ollama += $2; mem_ollama += $3; count_ollama++ }
        /floowise/ { cpu_floowise += $2; mem_floowise += $3; count_floowise++ }
        END {
            printf "Ollama - CPU: %.1f%%, Memoria: %.1f%%\n", 
                cpu_ollama/count_ollama, mem_ollama/count_ollama
            printf "Floowise - CPU: %.1f%%, Memoria: %.1f%%\n",
                cpu_floowise/count_floowise, mem_floowise/count_floowise
        }
    ' resource_usage.log
}

# Función principal
main() {
    log "Iniciando prueba de carga..."
    
    # Limpiar archivos anteriores
    rm -f results_*.txt resource_usage.log
    
    # Iniciar monitoreo de recursos en segundo plano
    monitor_resources &
    MONITOR_PID=$!
    
    # Iniciar usuarios concurrentes para Ollama
    for ((u=1; u<=CONCURRENT_USERS; u++)); do
        load_test_ollama $u $REQUESTS_PER_USER &
    done
    
    # Iniciar usuarios concurrentes para Floowise
    for ((u=1; u<=CONCURRENT_USERS; u++)); do
        load_test_floowise $u $REQUESTS_PER_USER &
    done
    
    # Esperar el tiempo de prueba
    log "Prueba en progreso. Esperando $TEST_DURATION segundos..."
    sleep $TEST_DURATION
    
    # Detener monitoreo de recursos
    kill $MONITOR_PID
    
    # Analizar resultados
    analyze_results
    
    log "Prueba de carga completada"
}

# Ejecutar script
main
