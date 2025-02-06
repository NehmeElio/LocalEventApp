namespace LocalAppBackend.Application.Interface;

public interface IAccountService
{   
    Task RegisterUserAsync(string username, string password, string email,string fname,string lname);
    Task<bool> AuthenticateUserAsync(string username, string password);
}