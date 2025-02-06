using Elio.Logging;
using LocalAppBackend.API.AutoMapper;
using LocalAppBackend.API.Configurations;
using LocalAppBackend.Application.Interface;
using LocalAppBackend.Application.Services;
using LocalAppBackend.Domain.Models;
using LocalEventBackend.Infrastructure.Authentication;
using LocalEventBackend.Infrastructure.Context;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
builder.Services.AddSwaggerGen();

builder.Services.AddJwtAuthentication(builder.Configuration);

// Register other services
builder.Services.AddTransient<IJwtTokenService, JwtTokenService>();
builder.Services.AddDbContext<LocalEventContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddOpenApi();
builder.Services.AddScoped<IAccountService, AccountService>();
builder.Services.AddScoped<IEventService, EventService>();
builder.Services.AddScoped<ICategoryService, CategoryService>();
builder.Services.AddScoped<IRegionService, RegionService>();
builder.Services.AddScoped<IGuestService, GuestService>();
builder.Services.AddScoped<IFavoriteService, FavoriteService>();

builder.Services.AddSwaggerGenConfiguration();

builder.Services.AddAutoMapper(typeof(MappingProfile));

builder.AddLoggingServices();
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
   // app.MapOpenApi();
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();
//var port = Environment.GetEnvironmentVariable("PORT") ?? "5000";  // Default to 5000 if not set
var port = Environment.GetEnvironmentVariable("PORT") ?? "5000";  // Default to 5000 if not set
app.Run($"http://0.0.0.0:{port}"); 
//app.Run();
