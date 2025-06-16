FROM ollama/ollama:latest

# Exponer el puerto de Ollama
EXPOSE 11434

# Configurar el directorio de datos
VOLUME ["/root/.ollama"]

# Instalar modelos adicionales
RUN ollama pull devstral:24b && \
    ollama pull phi4-reasoning && \
    ollama pull nomic-embed-text

# Comando para iniciar Ollama
CMD ["serve"] 