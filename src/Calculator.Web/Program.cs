var app = WebApplication.CreateBuilder(args).Build();
app.MapFallbackToFile("index.html"); ;
app.Run();
