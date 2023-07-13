#!/bin/bash

set -e
set -u

function create_user_and_database() {
    local dbinfo=$1
    IFS=":" read -r database user password <<< "$dbinfo"

    echo "Creating database '$database' with user '$user' and password '$password'"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" <<-EOSQL
      CREATE USER $user IF NOT EXISTS;
      ALTER USER $user WITH ENCRYPTED PASSWORD '$password';
      CREATE DATABASE $database ENCODING "UTF8 LC_COLLATE = "en_US.UTF-8" LC_CTYPE = "en_US.UTF-8" TEMPLATE="template0";
      GRANT ALL PRIVILEGES ON DATABASE $database TO $user;
}

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
    echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
    for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
        create_user_and_database $db
    done
    echo "Multiple databases created"
fi
