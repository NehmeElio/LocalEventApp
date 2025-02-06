namespace LocalEventBackebd.Infrastructure.Authentication;

public interface IJwtTokenService
{
    string GenerateToken(string username);
}