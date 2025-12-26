FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

# Установка curl и unzip (нужны для скрипта установки vsdbg)
RUN apt-get update && apt-get install -y curl unzip
# Загрузка и установка отладчика vsdbg в указанную папку
RUN curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l /remote_debugger

WORKDIR /app
COPY ./BaseService/*.csproj ./
RUN dotnet restore
COPY ./BaseService/ .
EXPOSE 80
ENTRYPOINT ["dotnet", "watch", "run", "--project", "/app/BaseService.csproj"]
