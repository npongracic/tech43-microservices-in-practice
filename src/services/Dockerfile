FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS build-env
WORKDIR /app

COPY ./ ./
RUN dotnet restore
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine
ARG APP_NAME
WORKDIR /app
COPY --from=build-env /app/out .
ENV ENV_APP_NAME=$APP_NAME

EXPOSE 80

ENTRYPOINT ["sh", "-c", "dotnet ${ENV_APP_NAME}.dll"]