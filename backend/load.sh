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

# Создание сети
function create-network() {
    docker network create --driver bridge projectm
    docker network ls
}
function delete-network() {
    docker network rm projectm
    docker network ls
}

# Production
function up() {
    docker-compose --env-file .env.prod -f docker-compose.yml up 
}
function up-b() {
    docker-compose --env-file .env.prod -f docker-compose.yml up --build
}
function down() {
    docker-compose --env-file .env.prod -f docker-compose.yml down
}

# Development
function devup() {
    docker-compose --env-file .env.dev -f docker-compose.yml up
}
function devup-b() {
    docker-compose --env-file .env.dev -f docker-compose.yml up --build
}
function devdown() {
    docker-compose --env-file .env.dev -f docker-compose.yml down
}

# Для работы разное
function cont() {
    hostname -I
    # ip хоста
    ip addr show
    # docker контейнер
    docker exec -it baseservice_service /bin/sh
}

# Сохранение базы данных на сервере
function postgre-init-dump() {
    docker exec -it baseservice_postgresql bash
    pg_dump -U user -d db-init -f /var/lib/postgresql/data/db-init_dump.sql
    pg_dump -U user -d db-init -f /var/lib/postgresql/data/db-init_dump_$(date +%Y%m%d).sql
    exit
    docker cp baseservice_postgresql:/var/lib/postgresql/data/db-init_dump.sql ./db-init_dump.sql
}
    # Рабочая функция для сервера
function postgre-init-dump-server() {
    # Создаем дамп с датой в имени файла
    docker exec baseservice_postgresql bash -c "\
        pg_dump -U user -d db-init -f /var/lib/postgresql/data/db-init_dump_\$(date +%Y%m%d).sql
    "
    
    # Копируем файл дампа на хост
    docker cp baseservice_postgresql:/var/lib/postgresql/data/db-init_dump_$(date +%Y%m%d).sql ./db-init_dump_$(date +%Y%m%d).sql
}

# Команды очистки
function clear-docker() {
    docker system prune # для всех неиспользуемых объектов (образы, контейнеры, тома). 
    docker builder prune --all # для кэша 

    docker image prune #(для неиспользуемых образов)
    docker container prune 
    docker volume prune
    docker network prune
}
# Для сервера
function clear-docker() {
    create-network # Первое, что сделать на сервере. В конвеер развертывания не входит.
    mkdir files

    postgre-init-dump-server
    cd backend
    down
    cd ../frontend
    down

    docker container prune
    docker image prune
    rm -rf backend
    rm -rf frontend

    copy frontend
    cd frontend
    up
    copy backend
    cd backend
    up
    Entity_Framework
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
    cnet)
        create-network
        ;;
    delnet)
        delete-network
        ;;
    up)
        up
        ;;
    up-b)
        up-b
        ;;
    down)
        down
        ;;
    devup)
        devup
        ;;
    devup-b)
        devup-b
        ;;
    devdown)
        devdown
        ;;
esac