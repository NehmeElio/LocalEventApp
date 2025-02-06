namespace LocalAppBackend.API.DTO;

public class UserDto
{
    public int AccountId { get; set; }
    public string Email { get; set; }
    public string Name { get; set; }
    public string Lastname { get; set; }
    public string Username { get; set; }
    public string? PhoneNb { get; set; }
    public DateOnly? CreatedAt { get; set; }
}
