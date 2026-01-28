using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Data;
using System.Text.Json;

namespace LibraryAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ExecuteController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public ExecuteController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok("API is running");
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] ExecuteRequest request)
        {
            try
            {
                var connectionString = _configuration.GetConnectionString("DefaultConnection");

                using var connection = new SqlConnection(connectionString);
                using var command = new SqlCommand(request.ProcedureName, connection)
                {
                    CommandType = CommandType.StoredProcedure
                };

                foreach (var param in request.Parameters)
                {
                    object value = param.Value;

                    if (value is JsonElement jsonElement)
                    {
                        value = ConvertJsonElement(jsonElement);
                    }

                    command.Parameters.AddWithValue($"@{param.Key}", value ?? DBNull.Value);
                }

                await connection.OpenAsync();

                var results = new List<Dictionary<string, object>>();
                using var reader = await command.ExecuteReaderAsync();

                while (await reader.ReadAsync())
                {
                    var row = new Dictionary<string, object>();
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        row[reader.GetName(i)] = reader.IsDBNull(i) ? null! : reader.GetValue(i);
                    }
                    results.Add(row);
                }

                return Ok(results);
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = ex.Message });
            }
        }

        private object ConvertJsonElement(JsonElement element)
        {
            return element.ValueKind switch
            {
                JsonValueKind.String => element.GetString(),
                JsonValueKind.Number => element.TryGetInt32(out int intValue) ? intValue : element.GetDouble(),
                JsonValueKind.True => true,
                JsonValueKind.False => false,
                JsonValueKind.Null => null,
                _ => element.ToString()
            };
        }
    }

    public class ExecuteRequest
    {
        public string ProcedureName { get; set; } = "";
        public Dictionary<string, object> Parameters { get; set; } = new();
    }
}
