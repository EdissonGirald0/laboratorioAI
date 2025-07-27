FROM ollama/ollama:latest

# Exponer el puerto de Ollama
EXPOSE 11434

# Configurar el directorio de datos
VOLUME ["/root/.ollama"]

# Documentación de los modelos
LABEL modelo.devstral="Modelo de lenguaje de 24B parámetros optimizado para desarrollo" \
      modelo.phi4="Modelo especializado en razonamiento y lógica" \
      modelo.nomic="Modelo para generación de embeddings de texto" \
      modelo.codellama="Modelo especializado en código" \
      modelo.mistral="Modelo de propósito general de alto rendimiento"

# Instalar modelos adicionales
RUN ollama pull devstral:24b && \
    ollama pull phi4-reasoning && \
    ollama pull nomic-embed-text && \
    ollama pull codellama && \
    ollama pull mistral

# Script de healthcheck
COPY healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD [ "/usr/local/bin/healthcheck.sh" ]

# Comando para iniciar Ollama
CMD ["serve"] 