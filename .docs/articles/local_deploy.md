# Local deploy steps

## Docker build and push

```shell
docker build src --file src/Calculator.Services.ArithmeticOperations/Dockerfile --tag dotnet-containers-template-api --label "runnumber=1"
docker build src --file src/Calculator.web/Dockerfile --tag dotnet-containers-template-web --label "runnumber=1"
# replace CR_PAT and USERNAME
echo CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
docker tag dotnet-containers-template-api ghcr.io/mentormate/dotnet-containers-template/api:latest
docker tag dotnet-containers-template-web ghcr.io/mentormate/dotnet-containers-template/web:latest
docker push ghcr.io/mentormate/dotnet-containers-template/api:latest
docker push ghcr.io/mentormate/dotnet-containers-template/web:latest
```
