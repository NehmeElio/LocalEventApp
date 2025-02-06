

using LocalAppBackend.API.Filters;
using Microsoft.OpenApi.Models;

namespace LocalAppBackend.API.Configurations;

public static class SwaggerConfiguration
{
    public static IServiceCollection AddSwaggerGenConfiguration(this IServiceCollection services)
    {
        services.AddSwaggerGen(c =>
        {       c.OperationFilter<SwaggerFileUploadOperationFilter>(); // Enable file uploads
            // Add JWT Authorization in Swagger
            c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
            {
                In = ParameterLocation.Header,
                Description = "Please enter JWT token",
                Name = "Authorization",
                Type = SecuritySchemeType.Http,
                Scheme = "bearer"
            });
            c.AddSecurityRequirement(new OpenApiSecurityRequirement
            {
                {
                    new OpenApiSecurityScheme
                    {
                        Reference = new OpenApiReference
                        {
                            Type = ReferenceType.SecurityScheme,
                            Id = "Bearer"
                        }
                    },
                    new string[] { }
                }
            });
        });

        return services;
    }
}