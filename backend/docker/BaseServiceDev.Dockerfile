FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /app
COPY ./BaseService/*.csproj ./
RUN dotnet restore
COPY ./BaseService/ .
EXPOSE 80
ENTRYPOINT ["dotnet", "watch", "run", "--project", "/app/BaseService.csproj"]
