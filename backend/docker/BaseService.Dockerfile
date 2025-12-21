# Use the official .NET SDK image for building the application
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /app
# Copy the .csproj and restore any dependencies
COPY ./BaseService/*.csproj ./
RUN dotnet restore
# Copy the entire project and build it
COPY ./BaseService/ ./
RUN dotnet publish -c Release -o out

# Use the official runtime image for running the application
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app/out .
# Expose the application port
EXPOSE 80
# Specify the entry point for the application
ENTRYPOINT ["dotnet", "BaseService.dll"]