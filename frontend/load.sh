#!/bin/bash

# $chmod u+x load
# ls -l load

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


case "$1" in
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
esac
