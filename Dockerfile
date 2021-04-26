FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
RUN apt-get update \
    && apt-get install -y --no-install-recommends libgdiplus libc6-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app


FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["2020-2021-backend-labo09-ai.csproj", "./"]
RUN dotnet restore "2020-2021-backend-labo09-ai.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "2020-2021-backend-labo09-ai.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "2020-2021-backend-labo09-ai.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "2020-2021-backend-labo09-ai.dll"]
