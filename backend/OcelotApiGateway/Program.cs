using Ocelot.DependencyInjection;
using Ocelot.Middleware;

var builder = WebApplication.CreateBuilder(args);

// Add Ocelot services to the container
builder.Services.AddOcelot(builder.Configuration);

builder.Configuration.AddJsonFile("ocelot.json");

var app = builder.Build();

// Включаем обслуживание статических файлов
app.UseStaticFiles();

// Configure the Ocelot middleware
app.UseRouting();

app.UseEndpoints(endpoints =>
{
    endpoints.MapGet("/", async context =>
    {
        await context.Response.WriteAsync("Ocelot is running");
    });
});

app.UseOcelot().Wait(); 

app.Run();
