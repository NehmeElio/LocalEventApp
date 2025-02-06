using AutoMapper;
using LocalAppBackend.API.DTO;
using LocalAppBackend.Application.Interface;
using LocalAppBackend.Domain.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LocalAppBackend.API.Controllers;

[Authorize]
[Route("api/[controller]")]
[ApiController]
public class FavoriteController : ControllerBase
{
    private readonly IFavoriteService _favoriteService;
    private readonly IMapper _mapper;

    public FavoriteController(IFavoriteService favoriteService, IMapper mapper)
    {
        _favoriteService = favoriteService;
        _mapper = mapper;
    }

    [HttpGet("{accountId}")]
    public async Task<ActionResult<List<EventDto>>> GetFavoriteEvents(int accountId)
    {
        var events = await _favoriteService.GetFavoriteEventAsync(accountId);

        if (events == null || !events.Any())
            return NotFound("No favorite events found.");

        var eventDtos = _mapper.Map<List<EventDto>>(events);
        return Ok(eventDtos);
    }

    [HttpPost("Add")]
    public async Task<IActionResult> AddFavoriteEvent(int accountId, int eventId)
    {
        try
        {
            await _favoriteService.AddFavoriteEventAsync(accountId, eventId);
            return NoContent();
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(ex.Message);
        }
    }

    [HttpDelete("Remove")]
    public async Task<IActionResult> RemoveFavoriteEvent(int accountId, int eventId)
    {
        try
        {
            await _favoriteService.RemoveFavoriteEventAsync(accountId, eventId);
            return NoContent();
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(ex.Message);
        }
    }
}