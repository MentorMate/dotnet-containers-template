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
