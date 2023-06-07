
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

COPY POCAZfuncion.csproj .
COPY . .

RUN dotnet restore

RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/azure-functions/dotnet:4.0 AS final

COPY --from=build /app/publish /home/site/wwwroot