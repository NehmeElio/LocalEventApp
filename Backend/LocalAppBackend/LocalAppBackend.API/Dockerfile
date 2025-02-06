FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["LocalAppBackend.API/LocalAppBackend.API.csproj", "LocalAppBackend.API/"]
COPY ["LocalAppBackend.Application/LocalAppBackend.Application.csproj", "../LocalAppBackend.Application/"]
COPY ["LocalAppBackend.Infrastructure/LocalAppBackend.Infrastructure.csproj", "../LocalAppBackend.Infrastructure/"]
COPY ["LocalAppBackend.Domain/LocalAppBackend.Domain.csproj", "../LocalAppBackend.Domain/"]
RUN dotnet restore "LocalAppBackend.API/LocalAppBackend.API.csproj"
COPY . .
WORKDIR "/src/LocalAppBackend.API"
RUN dotnet build "LocalAppBackend.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "LocalAppBackend.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "LocalAppBackend.API.dll"]
