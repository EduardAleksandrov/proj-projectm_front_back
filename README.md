# Проект "Project M"

## Что сделать

- flag -d (detach) для production добавить
- на продакшене проверить UID (User Identifier) и GID (Group Identifier) для docker-compose
- миграции на сервере

## Настройка

1) Установка сети docker:
- В папке backend запускаем ``` ./load.sh cnet``` для создания сети docker
- В папке backend запускаем ``` ./load.sh delnet``` для удаления сети docker

2) Запуск frontend:
- На сервере:
- В папке frontend запускаем ``` ./load.sh up``` для запуска фронта на сервере
- В папке frontend запускаем ``` ./load.sh down``` для остановки фронта на сервере
- В папке frontend запускаем ``` ./load.sh up-b``` для пересборки build контейнеров на сервере

- В разработке:
- В папке frontend запускаем ``` ./load.sh devup``` для запуска фронта в разработке
- В папке frontend запускаем ``` ./load.sh devdown``` для остановки фронта в разработке
- В папке frontend запускаем ``` ./load.sh devup-b``` для пересборки build контейнеров в разработке

3) Запуск backend:
- На сервере:
- В папке backend запускаем ``` ./load.sh up``` для запуска бекэнда на сервере
- В папке backend запускаем ``` ./load.sh down``` для остановки бекэнда на сервере
- В папке backend запускаем ``` ./load.sh up-b``` для пересборки build контейнеров на сервере

- В разработке:
- В папке backend запускаем ``` ./load.sh devup``` для запуска бекэнда в разработке
- В папке backend запускаем ``` ./load.sh devdown``` для остановки бекэнда в разработке
- В папке backend запускаем ``` ./load.sh devup-b``` для пересборки build контейнеров в разработке

4) Отладка backend vscode
- В контейнер нужно установить debugger ``` BaseServiceDev.Dockerfile ```
- .vscode/launch.json нужен для отладки .net
- Для отладчика выбираем Процесс с ``` app/bin/Debug/net10.0/.../ВашеПриложение.dll ```

5) Миграции
- При разработке миграции создаются в контейнере и выполняются там же, а дальше копируюся из контейнера в папку Migrations.
- При production миграции берутся из папки Migrations и при первом запуске запускаются.
- При production используется метод - Migration Bundles (Modern Standard). A Migration Bundle is a self-contained executable that includes everything needed to run migrations without requiring the .NET SDK in your production environment. 

6) .env для Jwt key
- Для сервера .env файл создается на лету в github используя github actions. Для dev используется локальный .env файл.
```
- name: Create .env file
  uses: SpicyPizza/create-envfile@v2.0
  with:
    # Перечисляйте переменные, которые должны попасть в файл
    envkey_DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
    envkey_API_KEY: ${{ secrets.API_KEY }}
    envkey_JWT_SECRET: ${{ secrets.JWT_SECRET }}
    file_name: .env
    directory: ./ # Укажите папку, если нужно (напр. ./src)

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # 1. Создаем файл во временной папке раннера GitHub
      - name: Create .env file
        uses: SpicyPizza/create-envfile@v2.0
        with:
          envkey_JWT_SECRET: ${{ secrets.JWT_SECRET }}
          file_name: .env

      # 2. Копируем .env (и docker-compose.yml) на ваш сервер
      - name: Copy files to Server
        uses: appleboy/scp-action@master
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          source: "docker-compose.yml, .env,"
          target: "/home/user/app"

      # 3. Запускаем docker-compose на сервере
      - name: Run Docker Compose
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            cd /home/user/app
            docker compose up -d

- name: Checkout code
  uses: actions/checkout@v4

# 1. Создаем .env файл ВНУТРИ папки backend на раннере GitHub
- name: Create .env file in backend folder
  uses: SpicyPizza/create-envfile@v2.0
  with:
    envkey_JWT_SECRET: ${{ secrets.JWT_SECRET }}
    envkey_DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
    file_name: .env
    directory: ./backend  # Важно: создаем именно в папке с кодом

# 2. Копируем всю папку backend (уже с файлом .env внутри) на сервер
- name: Copy backend folder to server
  uses: appleboy/scp-action@master
  with:
    host: ${{ secrets.HOST }}
    username: ${{ secrets.USER }}
    key: ${{ secrets.SSH_KEY }}
    source: "backend/" # Копирует содержимое папки backend
    target: "/home/user/app" # На сервере будет /home/user/app/backend/...

# 1. Сначала удаляем старую папку на сервере (если она есть)
- name: Cleanup server folder
  uses: appleboy/ssh-action@master
  with:
    host: ${{ secrets.HOST }}
    username: ${{ secrets.USER }}
    key: ${{ secrets.SSH_KEY }}
    script: |
        rm -rf /home/user/app/backend
        mkdir -p /home/user/app/backend
```

```
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # 1. Сначала удаляем старую папку на сервере (если она есть)
      - name: Cleanup server folder
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.HOST }}
          username: ${{ secrets.USER }}
          key: ${{ secrets.SSH_KEY }}
          script: |
            rm -rf /home/user/app/backend
            mkdir -p /home/user/app/backend

      # 2. Копируем новую папку backend на сервер
      - name: Copy backend folder
        uses: appleboy/scp-action@master
        with:
          host: ${{ secrets.HOST }}
          username: ${{ secrets.USER }}
          key: ${{ secrets.SSH_KEY }}
          source: "backend/"
          target: "/home/user/app"

      # 3. Создаем .env файл внутри уже скопированной папки
      - name: Create .env file on server
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.HOST }}
          username: ${{ secrets.USER }}
          key: ${{ secrets.SSH_KEY }}
          script: |
            cd /home/user/app/backend
            echo "JWT_SECRET=${{ secrets.JWT_SECRET }}" > .env
            echo "DB_PASSWORD=${{ secrets.DB_PASSWORD }}" >> .env
            # Проверка: docker compose подхватит этот файл автоматически

      # 4. Запуск контейнеров
      - name: Start Docker Compose
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.HOST }}
          username: ${{ secrets.USER }}
          key: ${{ secrets.SSH_KEY }}
          script: |
            cd /home/user/app/backend
            docker compose up -d --build

```
