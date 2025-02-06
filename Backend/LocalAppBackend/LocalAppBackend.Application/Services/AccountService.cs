using LocalAppBackend.Application.Interface;
using LocalAppBackend.Domain.Models;
using LocalEventBackend.Infrastructure.Context;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace LocalAppBackend.Application.Services;

 public class AccountService(LocalEventContext context, ILogger<AccountService> logger) : IAccountService
 {
     
     public async Task<(bool Success, string? ErrorMessage)> RegisterUserAsync(string username, string password, string email, string fname, string lname, string phoneNumber)
     {
         logger.LogInformation($"Registering user {username}");

         var existingUser = await context.Accounts
             .FirstOrDefaultAsync(u => u.Username == username || u.Email == email || (u.PhoneNb != null && u.PhoneNb == phoneNumber));

         if (existingUser != null)
         {
             if (existingUser.Username == username)
                 return (false, "Username is already taken.");
        
             if (existingUser.Email == email)
                 return (false, "Email is already registered.");
        
             if (!string.IsNullOrEmpty(phoneNumber) && existingUser.PhoneNb == phoneNumber)
                 return (false, "Phone number is already in use.");
         }
         
    
         var newUser = new Account()
         {
             Username = username,
             Email = email,
             Password = password,//we should hash but for testing will keep it this way
             Name = fname,
             Lastname = lname,
             PhoneNb = phoneNumber,
             CreatedAt = DateOnly.FromDateTime(DateTime.Now)
         };

         context.Accounts.Add(newUser);
         await context.SaveChangesAsync();

         logger.LogInformation("User {Username} registered successfully.", username);
    
         return (true, null);
     }


     public async Task<bool> AuthenticateUserAsync(string username, string password)
        {
            logger.LogInformation($"Authenticating user {username}");
            var user = await context.Accounts.FirstOrDefaultAsync(u => u.Username == username);
            return user != null && user.Password == password;
            /*if (user == null || !VerifyPassword(password, user.PasswordHash))
            {
                return false;
            }*/

           // return true;
        }

        public async Task<Account?> GetUserByUsername(string username)
        {
            var user=await context.Accounts.FirstOrDefaultAsync(u=>u.Username == username);
            return user;
        }
        
        public async Task<bool> UploadProfilePicture(IFormFile? file, int userId)
        {
            try
            {
                if (file == null || file.Length == 0)
                {
                    return false;
                }

                // Convert the file to a byte array
                using var memoryStream = new MemoryStream();
                await file.CopyToAsync(memoryStream);
                byte[] profilePicData = memoryStream.ToArray();

                // Find the user by userId
                var user = await context.Accounts
                    .FirstOrDefaultAsync(u => u.AccountId == userId);

                if (user == null)
                {
                    return false;
                }

                // Set the profile picture as byte array
                user.ProfilePicture= profilePicData;

                // Save the changes to the database
                await context.SaveChangesAsync();
                return true;
            }
            catch
            {
                return false;
            }
        }

    

        public async Task<byte[]> GetProfilePictureAsync(int userId)
        {
            var user = await context.Accounts.FindAsync(userId);
        
            if (user == null || user.ProfilePicture == null)
            {
                throw new KeyNotFoundException("User or profile picture not found.");
            }

            return user.ProfilePicture;  // Return the raw byte array
        }
 }

    
       
    