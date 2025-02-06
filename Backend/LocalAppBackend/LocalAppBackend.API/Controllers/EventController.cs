using AutoMapper;
using LocalAppBackend.API.DTO;
using LocalAppBackend.Application.Interface;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LocalAppBackend.API.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class EventController : ControllerBase
{
    private readonly ILogger<EventController> _logger;
    private readonly IEventService _eventService;
    private readonly IMapper _mapper;
    private readonly ICategoryService _categoryService;

    public EventController(ILogger<EventController> logger, IEventService eventService, IMapper mapper, ICategoryService categoryService)
    {
        _logger = logger;
        _eventService = eventService;
        _mapper = mapper;
        _categoryService = categoryService;
    }

    // Endpoint to add an event
    [HttpPost("AddEvent")]
    public async Task<IActionResult> AddEvent([FromForm] AddEventRequest request)
    {
        _logger.LogInformation($"Adding event with date : {request.Date}");
        var result = await _eventService.AddEventAsync(
            request.Title, 
            request.Description, 
            request.RegionId, 
            request.Date, 
            request.CategoryId, 
            request.PunchLine1, 
            request.PunchLine2, 
            request.EventImage,
            request.HostId,
            request.GalleryImages
        );

        if (!result)
            return BadRequest("Failed to create event");

        return Ok(new { message = "Event created successfully" });
    }

    // Endpoint to fetch all events
    [HttpGet("GetEvents")]
    public async Task<IActionResult> GetEvents()
    {
        var events = await _eventService.GetEventsAsync();
        // If events are found, map them to DTOs for return
        if (events == null || !events.Any())
            return NotFound("No events found");
        
        // Eagerly load the CategoryEvents and GalleryImages if they are navigation properties
        

        // Debugging: Check CategoryId and GalleryImages count for the first event
        var firstEvent = events.FirstOrDefault();

        if (firstEvent != null)
        {
            Console.WriteLine("First Event:");
            Console.WriteLine($"CategoryEvents Count: {firstEvent.CategoryEvents?.Count ?? 0}");
            Console.WriteLine($"GalleryImages Count: {firstEvent.ImageGalleries?.Count ?? 0}");
        }

        var eventDtos = _mapper.Map<List<EventDto>>(events);

        // Return a list of event DTOs
        return Ok(eventDtos);
    }

    // Endpoint to fetch events by category
    [HttpGet("GetEventByCategory/{categoryId}")]
    public async Task<IActionResult> GetEventByCategory(int categoryId)
    {
        var events = await _eventService.GetEventByCategoryAsync(categoryId);
        
        if (events == null || !events.Any())
            return NotFound($"No events found for category {categoryId}");

        var eventDtos = _mapper.Map<List<EventDto>>(events);

        return Ok(eventDtos);
    }

    // Endpoint to fetch events by host
    [HttpGet("GetEventByHost/{accountId}")]
    public async Task<IActionResult> GetEventByHost(int accountId)
    {
        var events = await _eventService.GetEventByHostAsync(accountId);
        
        if (events == null || !events.Any())
            return NotFound($"No events found for host {accountId}");

        var eventDtos = _mapper.Map<List<EventDto>>(events);

        return Ok(eventDtos);
    }
}
