using LocalAppBackend.API.DTO;
using LocalAppBackend.Application.Interface;
using LocalEventBackebd.Infrastructure.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LocalAppBackend.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AccountController : ControllerBase
{
    private readonly IAccountService _accountService;
    private readonly IJwtTokenService _jwtTokenService;
    

    public AccountController(IAccountService accountService, IJwtTokenService jwtTokenService)
    {
        _accountService = accountService;
        _jwtTokenService = jwtTokenService;
    }

    // POST: api/Account/Register
    [HttpPost("Register")]
    public async Task<IActionResult> Register([FromBody] RegisterRequest request)
    {
        try
        {
            await _accountService.RegisterUserAsync(
                request.Username, 
                request.Password, 
                request.Email, 
                request.FirstName, 
                request.LastName
            );
            return Ok(new { Message = "User registered successfully" });
        }
        catch (InvalidOperationException ex)
        {
            return Conflict(new { Error = ex.Message });
        }
    }

    // POST: api/Account/Login
    [HttpPost("Login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        var isAuthenticated = await _accountService.AuthenticateUserAsync(request.Username, request.Password);
        if (!isAuthenticated)
        {
            return Unauthorized(new { Error = "Invalid username or password" });
        }
        
        var token = _jwtTokenService.GenerateToken(request.Username);

        return Ok(new { Token = token });
    }
    [Authorize]
    [HttpGet("hello")]
    public IActionResult GetHelloWorld()
    {
        return Ok("Hello, world!");
    }
}
