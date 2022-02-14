// cspell:ignore v'VVV
namespace Arithmetic.Operations;

/// <summary>Generic application extensions.</summary>
public static class ProgramExtensions
{
    /// <summary>Configure application services.</summary>
    public static void ConfigureServices(this IServiceCollection services, AssemblyName assemblyName)
    {
        // Register MVC controllers.
        services.AddControllers();

        // Register the API versioning.
        services.AddApiVersioning(options => options.ReportApiVersions = true);
        services.AddVersionedApiExplorer(
            options =>
            {
                options.GroupNameFormat = "'v'VVV";
                options.SubstituteApiVersionInUrl = true;
            });

        // Register the Swagger generator.
        services.AddSwaggerGen(options =>
        {
            options.SwaggerDoc("v1", new OpenApiInfo { Title = "API", Version = "v1" });

            // Set the comments path for the Swagger JSON and UI.
            var xmlFile = $"{assemblyName.Name}.xml";
            var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);

            options.IncludeXmlComments(xmlPath);
        });
    }

    /// <summary>Configure application.</summary>
    public static void ConfigureApplication(this WebApplication app, IApiVersionDescriptionProvider provider)
    {
        if (app.Environment.IsDevelopment())
        {
            app.UseDeveloperExceptionPage();
            app.UseCors(x => x.WithOrigins("http://localhost:44464").AllowAnyMethod().AllowAnyHeader());
        }

        if (app.Environment.IsProduction())
        {
            // Use only https.
            app.UseHttpsRedirection();
        }

        // enable routing.
        app.UseRouting();

        // swagger
        app.UseSwagger();
        app.UseSwaggerUI(options =>
        {
            foreach (var groupName in provider.ApiVersionDescriptions.Select(description => description.GroupName))
            {
                options.SwaggerEndpoint($"/swagger/{groupName}/swagger.json", groupName.ToUpperInvariant());
            }
        });

        // enable MVC controllers.
        app.UseEndpoints(endpoints =>
        {
            endpoints.MapControllers();
        });
    }
}
