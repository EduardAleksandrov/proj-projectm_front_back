# Use the official .NET SDK image
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Create a new ASP.NET Core project
# RUN dotnet new webapi --use-controllers -n BaseService 
RUN dotnet new web -n OcelotApiGateway

WORKDIR /app/OcelotApiGateway

# Expose port
EXPOSE 5071

ENTRYPOINT ["dotnet", "run"]