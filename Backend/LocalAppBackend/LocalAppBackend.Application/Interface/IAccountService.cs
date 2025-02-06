using LocalAppBackend.Domain.Models;
using Microsoft.AspNetCore.Http;

namespace LocalAppBackend.Application.Interface;

public interface IAccountService
{
    Task<(bool Success, string? ErrorMessage)> RegisterUserAsync(string username, string password, string email,
        string fname, string lname, string phoneNumber);
    Task<bool> AuthenticateUserAsync(string username, string password);

    Task<Account?> GetUserByUsername(string username);
    Task<bool> UploadProfilePicture(IFormFile? file, int userId);
    
    Task<byte[]> GetProfilePictureAsync(int userId);
}