FROM postgres:15-3.3
COPY create-multiple-postgresql-databases.sh /docker-entrypoint-initdb.d/
