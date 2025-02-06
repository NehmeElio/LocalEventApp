using LocalAppBackend.Domain.Models;
using Microsoft.AspNetCore.Http;

namespace LocalAppBackend.Application.Interface;

public interface IEventService
{
    Task<bool> AddEventAsync(string title, string? description, int regionId, DateTime date, int categoryId,
        string punchLine1, string punchLine2,IFormFile? eventImage,int hostId, List<IFormFile>? galleryImages);
    Task<List<Event>?> GetEventsAsync();
    Task<List<Event>?> GetEventByCategoryAsync(int categoryId);
    Task<List<Event>?> GetEventByHostAsync(int accountId);
    
}