# Calculator

A template project for showing the company CI/CD strategy

# Run Local
1. Open with Visual Studio
2. Run docker/docker-compose

# Test Api
```
& docker build --no-cache -t calc/arithmetics.api:local -f src/Calculator.Services.ArithmeticOperations/Dockerfile src/
& docker run -d -p "80:80" --rm --name=api-local-instance-for-contract-testing calc/arithmetics.api:local
Invoke-RestMethod -Uri "http://localhost/v1.0/add" -Method Post -Body '{ "operandTwo": "2", "operandOne": "4" }' -ContentType "application/json"
```
