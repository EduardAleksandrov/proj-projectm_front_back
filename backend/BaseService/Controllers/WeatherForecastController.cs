using Microsoft.AspNetCore.Mvc;

namespace BaseService.Controllers;

[ApiController]
[Route("api/base/[controller]")]
public class WeatherForecastController : ControllerBase
{
    private readonly IConfiguration _configuration;
    public WeatherForecastController(IConfiguration configuration)
    {
        _configuration = configuration;
    }
    private static readonly string[] Summaries =
    [
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    ];

    [HttpGet(Name = "GetWeatherForecast")]
    public IEnumerable<WeatherForecast> Get()
    {
        var apiKey = _configuration["JWT:KEY"];
        return Enumerable.Range(1, 5).Select(index => new WeatherForecast
        {
            Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            TemperatureC = Random.Shared.Next(-20, 55),
            Summary = Summaries[Random.Shared.Next(Summaries.Length)],
            Key = apiKey
        })
        .ToArray();
    }
}
