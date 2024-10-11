FROM postgres:15.4-alpine

# Copy the custom entrypoint script from the current environment
COPY docker_entrypoint.sh /usr/local/bin/

# Copy the PostgreSQL configuration files from the current environment
COPY ./postgresql.conf /etc/postgresql/
COPY ./pg_hba.conf /etc/postgresql/

# Make sure the entrypoint script is executable
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Use the custom entrypoint script
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]