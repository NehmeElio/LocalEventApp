using AutoMapper;
using LocalAppBackend.API.DTO;
using LocalAppBackend.Application.Interface;
using LocalEventBackend.Infrastructure.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LocalAppBackend.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AccountController : ControllerBase
{
    private readonly IAccountService _accountService;
    private readonly IJwtTokenService _jwtTokenService;
    private readonly IMapper _mapper;
    private readonly ILogger<AccountController> _logger;
    

    public AccountController(IAccountService accountService, IJwtTokenService jwtTokenService, IMapper mapper, ILogger<AccountController> logger)
    {
        _accountService = accountService;
        _jwtTokenService = jwtTokenService;
        _mapper = mapper;
        _logger = logger;
    }

    // POST: api/Account/Register
    [HttpPost("Register")]
    public async Task<IActionResult> RegisterUserAsync([FromBody] RegisterRequest request)
    {
        var (success, errorMessage) = await _accountService.RegisterUserAsync(
            request.Username, request.Password, request.Email, request.FirstName, request.LastName, request.PhoneNumber
        );
       // (string username, string password, string email, string fname, string lname, string phoneNumber)
        if (!success)
        {
            return Conflict(new { message = errorMessage }); // 409 Conflict
        }

        return Ok(new { message = "User registered successfully." }); // 200 OK
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
        
        var user=await _accountService.GetUserByUsername(request.Username);
        var userDto = _mapper.Map<UserDto>(user);
        
        var token = _jwtTokenService.GenerateToken(request.Username,userDto.AccountId);

        return Ok(new
        {
            Token = token,
            user=userDto
        });
    }

    [Authorize]
    [HttpPost("UploadProfilePicture")]
    public async Task<IActionResult> UploadProfilePicture([FromForm] UploadProfileRequest request)
    {
        if (request.ProfilePicture == null || request.ProfilePicture.Length == 0)
        {
            return BadRequest("No file uploaded.");
        }

        var result = await _accountService.UploadProfilePicture(request.ProfilePicture,request.UserId);

        if (result)
        {
            return Ok("Profile picture uploaded successfully.");
        }
        else
        {
            return StatusCode(500, "An error occurred while uploading the profile picture.");
        }
    }

    [Authorize]
    [HttpGet("GetProfilePicture")]
    public async Task<IActionResult> GetProfilePicture(int accountId)
    {
        try
        {
            var profilePic = await _accountService.GetProfilePictureAsync(accountId);

            return File(profilePic, "image/png");
        }
        catch (KeyNotFoundException)
        {
            return NotFound("User not found.");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving profile picture.");
            return StatusCode(500, "Internal server error");
        }
    }


}
