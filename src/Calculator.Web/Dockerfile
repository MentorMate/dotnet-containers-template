ARG NET_TAG=6.0-bullseye-slim
FROM mcr.microsoft.com/dotnet/sdk:${NET_TAG} AS build
EXPOSE 80
EXPOSE 443
WORKDIR /app

# INSTALL NODEJS
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
 && apt-get install -y --no-install-recommends nodejs \
 && echo "node version: $(node --version)" \
 && echo "npm version: $(npm --version)" \
 && rm -rf /var/lib/apt/lists/*

FROM build AS publish
WORKDIR /src
COPY Calculator.Web .
RUN cd calculator-app && npm i && npm run build

FROM node:17-alpine
WORKDIR /usr/src/app
EXPOSE 80
EXPOSE 443
COPY --from=publish /src/*.json /usr/src/app
COPY --from=publish /src/*.js /usr/src/app
COPY --from=publish /src/calculator-app/build /usr/src/app/calculator-app/build

RUN npm install --only=prod --no-optional

CMD [ "npm", "run", "start" ]
