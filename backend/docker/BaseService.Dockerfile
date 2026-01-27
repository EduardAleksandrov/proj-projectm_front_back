# Use the official .NET SDK image for building the application
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

# Установка Entity Framework
RUN dotnet tool install --global dotnet-ef
ENV PATH="$PATH:/root/.dotnet/tools"

WORKDIR /app
# Copy the .csproj and restore any dependencies
COPY ./BaseService/*.csproj ./
RUN dotnet restore
# Copy the entire project and build it
COPY ./BaseService/ ./

# Миграции
# Install the required design-time package in the project
RUN dotnet add package Microsoft.EntityFrameworkCore.Design --version 10.0.0
RUN mkdir -p /app/wwwroot
RUN dotnet ef migrations bundle --self-contained -r linux-x64 -o efbundle

RUN dotnet publish -c Release -o out

# Use the official runtime image for running the application
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app/out .
COPY --from=build /app/efbundle .
# Expose the application port
EXPOSE 80
# Specify the entry point for the application. 
# Миграции применяются при запуске
ENTRYPOINT ./efbundle --connection "$DB_CONNECTION_STRING" && dotnet BaseService.dll