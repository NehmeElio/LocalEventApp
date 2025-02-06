namespace LocalEventBackend.Infrastructure.Authentication;

public interface IJwtTokenService
{
    string GenerateToken(string username,int accountId);
}