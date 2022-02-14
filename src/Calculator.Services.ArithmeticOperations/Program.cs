var executingAssembly = Assembly.GetExecutingAssembly();
var builder = WebApplication.CreateBuilder(args);

builder.Services.ConfigureServices(executingAssembly.GetName());

var app = builder.Build();

app.ConfigureApplication(
    app.Services.GetRequiredService<IApiVersionDescriptionProvider>());

app.Run();
