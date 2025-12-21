#!/bin/bash

# $chmod u+x load
# ls -l load

# Create new dotnet 10 project
function construct-up() {
    docker-compose -f docker-compose.construct.yml up --build
}
function construct-copy() {
    docker cp backend_webconstructm_1:/app/BaseService .
}
function construct-down() {
    docker-compose -f docker-compose.construct.yml down
}

# Production
function up() {
    docker-compose -f docker-compose.yml up --build
}
function down() {
    docker-compose -f docker-compose.yml down
}
function downup() {
    docker-compose -f docker-compose.yml down
    docker-compose -f docker-compose.yml up --build
}

# Development
function devup() {
    docker-compose -f docker-compose.dev.yml up --build
}
function devdown() {
    docker-compose -f docker-compose.dev.yml down
}

function cont() {
    docker exec -it baseservice_service /bin/sh
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
    downup)
        downup
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