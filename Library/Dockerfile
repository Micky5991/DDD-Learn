FROM mcr.microsoft.com/dotnet/aspnet:10.0-preview AS base
USER $APP_UID

WORKDIR /app

EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:10.0-preview AS build
ARG BUILD_CONFIGURATION=Release

WORKDIR /src

COPY ["Library/Library.csproj", "Library/"]
RUN --mount=type=cache,target=/root/.nuget/packages \
    --mount=type=cache,target=/root/.local/share/NuGet/http-cache \
    --mount=type=cache,target=/root/.local/share/NuGet/plugin-cache \
    --mount=type=cache,target=/tmp/NuGetScratchroot \dotnet restore "Library/Library.csproj"

COPY . .

WORKDIR "/src/Library"
RUN --mount=type=cache,target=/root/.nuget/packages dotnet build "./Library.csproj" -c $BUILD_CONFIGURATION -o /app/build --no-restore

FROM build AS publish

ARG BUILD_CONFIGURATION=Release
RUN --mount=type=cache,target=/root/.nuget/packages dotnet publish "./Library.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false --no-restore

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Library.dll"]
