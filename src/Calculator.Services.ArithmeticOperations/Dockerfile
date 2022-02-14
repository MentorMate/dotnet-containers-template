ARG NET_IMAGE=6.0-bullseye-slim
FROM mcr.microsoft.com/dotnet/aspnet:${NET_IMAGE} AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:${NET_IMAGE} AS build
WORKDIR /src

# restore project
COPY Calculator.Services.ArithmeticOperations/Calculator.Services.ArithmeticOperations.csproj Calculator.Services.ArithmeticOperations/
RUN dotnet restore "Calculator.Services.ArithmeticOperations/Calculator.Services.ArithmeticOperations.csproj"

# copy data
COPY Calculator.Services.ArithmeticOperations/ Calculator.Services.ArithmeticOperations/
COPY .config/ .config/

# publish
FROM build AS publish
WORKDIR /src/Calculator.Services.ArithmeticOperations
RUN dotnet publish --no-restore "Calculator.Services.ArithmeticOperations.csproj" -c Release -o /app/publish

FROM base AS final
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Calculator.Services.ArithmeticOperations.dll"]
