using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Data;
using System.Text.Json;


namespace LibararyAPI.Controllers
{
    [ApiController]
    [Route("api/exec")]
    public class ExecuteController : ControllerBase
    {
        private readonly string _connectionString = "Server=localhost\\SQLEXPRESS;Database=LibraryDB;Integrated Security=true;TrustServerCertificate=true;";

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
                using var connection = new SqlConnection(_connectionString);
                using var command = new SqlCommand(request.ProcedureName, connection);
                command.CommandType = CommandType.StoredProcedure;

                // ���� �������
                // ���� �������
                foreach (var param in request.Parameters)
                {
                    object value = param.Value;

                    // ��� JsonElement
                    if (param.Value is JsonElement jsonElement)
                    {
                        value = jsonElement.ValueKind switch
                        {
                            JsonValueKind.String => jsonElement.GetString(),
                            JsonValueKind.Number => jsonElement.GetInt32(),
                            JsonValueKind.True => true,
                            JsonValueKind.False => false,
                            JsonValueKind.Null => DBNull.Value,
                            _ => jsonElement.ToString()
                        };
                    }

                    command.Parameters.AddWithValue($"@{param.Key}", value ?? DBNull.Value);
                }

                await connection.OpenAsync();

                var result = new List<Dictionary<string, object>>();
                using var reader = await command.ExecuteReaderAsync();

                while (await reader.ReadAsync())
                {
                    var row = new Dictionary<string, object>();
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        row[reader.GetName(i)] = reader.IsDBNull(i) ? null! : reader.GetValue(i);
                    }
                    result.Add(row);
                }

                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = ex.Message });
            }
        }
    }

    public class ExecuteRequest
    {
        public string ProcedureName { get; set; } = "";
        public Dictionary<string, object> Parameters { get; set; } = new();
    }
}