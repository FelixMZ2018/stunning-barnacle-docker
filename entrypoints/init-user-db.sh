#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER user;
    CREATE DATABASE rails;
    GRANT ALL PRIVILEGES ON DATABASE rails TO user;
EOSQL