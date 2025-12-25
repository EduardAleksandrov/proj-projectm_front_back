#!/bin/bash

# $chmod u+x load
# ls -l load

# Create new dotnet 10 project
function construct-up() {
    docker-compose -f docker-compose.construct.yml up --build
}
function construct-copy() {
    docker cp backend_webconstructm_1:/app/OcelotApiGateway .
}
function construct-down() {
    docker-compose -f docker-compose.construct.yml down
}

# Production
function up() {
    docker-compose --env-file .env.prod -f docker-compose.yml up --build
}
function down() {
    docker-compose --env-file .env.prod -f docker-compose.yml down
}

# Development
function devup() {
    docker-compose --env-file .env.dev -f docker-compose.yml up --build
}
function devdown() {
    docker-compose --env-file .env.dev -f docker-compose.yml down
}

function cont() {
    hostname -I
    docker exec -it baseservice_service /bin/sh
}
function postgre-init-dump() {
    docker exec -it baseservice_postgresql bash
    pg_dump -U user -d db-init -f /var/lib/postgresql/data/db-init_dump.sql
    exit
    docker cp baseservice_postgresql:/var/lib/postgresql/data/db-init_dump.sql ./db-init_dump.sql
}


case "$1" in
    construct-up)
        construct-up
        ;;
    construct-down)
        construct-down
        ;;
    construct-copy)
        construct-copy
        ;;
    up)
        up
        ;;
    down)
        down
        ;;
    devup)
        devup
        ;;
    devdown)
        devdown
        ;;
    cont)
        cont
        ;;
esac