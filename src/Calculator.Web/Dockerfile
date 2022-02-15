ARG NET_TAG=6.0-bullseye-slim
FROM mcr.microsoft.com/dotnet/sdk:${NET_TAG} AS build
WORKDIR /app

# INSTALL NODEJS
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
 && apt-get install -y --no-install-recommends nodejs \
 && echo "node version: $(node --version)" \
 && echo "npm version: $(npm --version)" \
 && rm -rf /var/lib/apt/lists/*

FROM build AS publish
WORKDIR /app
COPY Calculator.Web/calculator-app .
RUN npm i && npm run build --prod

FROM nginx:latest as final
EXPOSE 80
RUN rm -rf /usr/share/nginx/html/*
COPY --from=publish /app/build /usr/share/nginx/html
