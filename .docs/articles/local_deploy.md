# Local deploy steps

## Docker build and push

```shell
docker build src --file src/Calculator.Services.ArithmeticOperations/Dockerfile --tag ghcr.io/mentormate/dotnet-containers-template/calc-api:latest
docker build src --file src/Calculator.web/Dockerfile --tag ghcr.io/mentormate/dotnet-containers-template/calc-web:latest
# test run locally
docker run -it --rm --name "calc-api" -p 80:80 ghcr.io/mentormate/dotnet-containers-template/calc-api:latest
docker run -it --rm --name "calc-web" -p 80:80 ghcr.io/mentormate/dotnet-containers-template/calc-web:latest
# replace CR_PAT and USERNAME
echo CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
docker push ghcr.io/mentormate/dotnet-containers-template/calc-api:latest
docker push ghcr.io/mentormate/dotnet-containers-template/calc-web:latest
```

## Deploy biceps

```shell
cd .github\\biceps
az login
az deployment sub create --name container-app -location WestEurope --subscription XXX --template-file main.bicep --parameters registry=ghcr.io containerRegistryUsername=username containerRegistryPassword=*** apiImage=ghcr.io/mentormate/dotnet-containers-template/calc-api:sha-52f8d3c webImage=ghcr.io/mentormate/dotnet-containers-template/calc-web:sha-52f8d3c
az deployment sub show -s XXX --query properties.outputs.fqdnWeb.value -n container-app -o tsv
```

## Run github package locally

```shell
echo $PAT | docker login ghcr.io --username username --password-stdin
docker run -it --rm --name calc-web -p 80:80 ghcr.io/mentormate/dotnet-containers-template/calc-web:sha-52f8d3c
```