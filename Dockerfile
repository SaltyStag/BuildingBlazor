FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

COPY ./BuildingBlazor ./BuildingBlazor
RUN dotnet restore ./BuildingBlazor/BuildingBlazor.sln

RUN dotnet build ./BuildingBlazor/BuildingBlazor/BuildingBlazor.csproj -c Release --no-restore

RUN dotnet publish ./BuildingBlazor/BuildingBlazor/BuildingBlazor.csproj -c Release --framework net8.0 --runtime linux-x64 -o published --no-restore --self-contained

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/published .

ENV PORT 8080
EXPOSE 8080
ENV ASPNETCORE_URLS "http://*:${PORT}"
ENTRYPOINT [ "dotnet", "BuildingBlazor.dll" ]