FROM postgres:15

# Exponer el puerto de PostgreSQL
EXPOSE 5432

# Configurar el directorio de datos
VOLUME ["/var/lib/postgresql/data"]

# Scripts de inicialización
COPY ./init-scripts/ /docker-entrypoint-initdb.d/

# Comando para iniciar PostgreSQL
CMD ["postgres"] 