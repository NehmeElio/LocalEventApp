using LocalAppBackend.Domain.Models;

namespace LocalAppBackend.Application.Interface;

public interface IGuestService
{
    Task<List<Account>> GetAllEventGuestsAsync(int eventId);
    Task AddGuestAsync(int eventId,int userId);
    
    Task RemoveGuestAsync(int eventId, int userId);
    
    Task<List<Event>> GetAllEvents(int accountId);
    

}