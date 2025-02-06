using AutoMapper;
using LocalAppBackend.API.DTO;
using LocalAppBackend.Application.Interface;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LocalAppBackend.API.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class GuestController : ControllerBase
{
    private readonly ILogger<GuestController> _logger;
    private readonly IGuestService _guestService;
    private readonly IMapper _mapper;

    public GuestController(ILogger<GuestController> logger, IGuestService guestService, IMapper mapper)
    {
        _logger = logger;
        _guestService = guestService;
        _mapper = mapper;
    }

    [HttpGet("GetAllGuests")]
    public async Task<IActionResult> GetAllGuests(int eventId)
    {
        var guestList = await _guestService.GetAllEventGuestsAsync(eventId);
        return Ok(_mapper.Map<List<GuestDto>>(guestList));
    }
    
    [HttpGet("GetAllEvents")]
    public async Task<IActionResult> GetAllEvents(int accountId)
    {
        var eventList = await _guestService.GetAllEvents(accountId);
        return Ok(_mapper.Map<List<EventDto>>(eventList));
    }

    [HttpPost("AddGuest")]
    public async Task<IActionResult> AddGuest(int eventId, int userId)
    {
        await _guestService.AddGuestAsync(eventId, userId);
        return CreatedAtAction(nameof(GetAllGuests), new { eventId = eventId }, null);
    }
    
    [HttpPost("RemoveGuest")]
    public async Task<IActionResult> RemoveGuest(int eventId, int userId)
    {
        await _guestService.RemoveGuestAsync(eventId, userId);
        return Ok("guest Removed");
    }
}