#!/usr/bin/env bash

# This script is used to setup the environment for the project.
docker compose up -d

wait_for_db() {
    echo "Waiting for database to be ready..."
    while ! docker compose exec pg-source psql -U postgres -e -c "\l" > /dev/null 2>&1; do
        sleep 1
    done
    echo "Database is ready!"
}

wait_for_db

docker compose exec pg-source apt update
docker compose exec pg-source apt-get install postgresql-14-pglogical -y
docker compose exec pg-source psql -U postgres -e -c "alter system set shared_preload_libraries = 'pglogical';"
docker compose restart
docker compose exec -T pg-source psql -U postgres -e < setup_source.sql

docker compose exec pg-target apt update
docker compose exec pg-target apt-get install postgresql-14-pglogical -y
docker compose exec pg-target psql -U postgres -e -c "alter system set shared_preload_libraries = 'pglogical';"
docker compose restart
docker compose exec -T pg-target psql -U postgres -e < setup_target.sql


# Compare the dead tuple count
docker compose exec pg-source psql -U postgres -e -c "SELECT dead_tuple_count FROM pgstattuple('testtable');"
docker compose exec pg-target psql -U postgres -e -c "SELECT dead_tuple_count FROM pgstattuple('testtable');"
