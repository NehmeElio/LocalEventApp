using LocalAppBackend.Domain.Models;

namespace LocalAppBackend.Application.Interface;

public interface IFavoriteService
{
    Task<List<Event>?> GetFavoriteEventAsync(int accountId);
    Task AddFavoriteEventAsync(int accountId, int eventId);
    Task RemoveFavoriteEventAsync(int accountId, int eventId);
}