using LocalAppBackend.Application.Interface;
using LocalAppBackend.Domain.Models;
using LocalEventBackebd.Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace LocalAppBackend.Application.Services;

 public class AccountService : IAccountService
    {
        private readonly LocalEventContext _context;
        private readonly ILogger<AccountService> _logger;

        public AccountService(LocalEventContext context, ILogger<AccountService> logger)
        {
            _context = context;
            _logger = logger;
        }

        public async Task RegisterUserAsync(string username, string password, string email,string fname,string lname)
        {
            var existingUser = await _context.Accounts
                .FirstOrDefaultAsync(u => u.Name == username || u.Email == email);
            
            if (existingUser != null)
            {
                throw new InvalidOperationException("Username or email is already taken.");
            }

            //var passwordHash = HashPassword(password);
            var passwordHash = password;
            var newUser = new Account()
            {
                Username = username,
                Email = email,
                Password = passwordHash,
                Name = fname,
                Lastname = lname
            };

            _context.Accounts.Add(newUser);
            await _context.SaveChangesAsync();
            _logger.LogInformation("User {Username} registered successfully.", username);
        }

        public async Task<bool> AuthenticateUserAsync(string username, string password)
        {
            var user = await _context.Accounts.FirstOrDefaultAsync(u => u.Username == username);
            if (user == null || user.Password != password)
            {
                return false;
            }
            return true;
            /*if (user == null || !VerifyPassword(password, user.PasswordHash))
            {
                return false;
            }*/

            return true;
        }

        /*private string HashPassword(string password)
        {
            // Use a static salt (hardcoded)
            byte[] staticSalt = Convert.FromBase64String("STATIC_SALT_VALUE"); 

            // Hash the password using PBKDF2
            var hashed = System.Security.Cryptography.KeyDerivation.Pbkdf2(
                password: password,
                salt: staticSalt,
                prf: System.Security.Cryptography.KeyDerivationPrf.HMACSHA256,
                iterationCount: 10000,
                numBytesRequested: 256 / 8
            );

            // Return the hashed password as a Base64 string
            return Convert.ToBase64String(hashed);
        }
        
        private bool VerifyPassword(string password, string storedHash)
        {
            // Use the same static salt for verification
            byte[] staticSalt = Convert.FromBase64String("STATIC_SALT_VALUE"); // Replace with the same Base64-encoded static salt

            // Hash the input password using the same salt
            var hashedPassword = System.Security.Cryptography.KeyDerivation.Pbkdf2(
                password: password,
                salt: staticSalt,
                prf: System.Security.Cryptography.KeyDerivationPrf.HMACSHA256,
                iterationCount: 10000,
                numBytesRequested: 256 / 8
            );

            // Compare the hashed password with the stored hash
            return storedHash == Convert.ToBase64String(hashedPassword);
        }



        private bool VerifyPassword(string password, string storedHash)
        {
            // Implement password verification logic using the same hashing method
            return storedHash == HashPassword(password);
        }*/
       
    }