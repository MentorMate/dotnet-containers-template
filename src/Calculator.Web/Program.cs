using Microsoft.AspNetCore.SpaServices.ReactDevelopmentServer;

const string ClientAppDirectory = ".";
var builder = WebApplication.CreateBuilder(args);
builder.Services.AddSpaStaticFiles(configuration =>
    configuration.RootPath = Path.Combine(ClientAppDirectory, "dist"));

var app = builder.Build();
app.UseSpaStaticFiles();
app.UseSpa(spa =>
{
    spa.Options.SourcePath = ClientAppDirectory;
    spa.UseReactDevelopmentServer("dev");
});
app.Run();
