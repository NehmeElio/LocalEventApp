using LocalAppBackend.Application.Interface;
using LocalAppBackend.Domain.Models;
using LocalEventBackend.Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace LocalAppBackend.Application.Services;

public class FavoriteService(ILogger<FavoriteService> logger, LocalEventContext context) : IFavoriteService
{
    private readonly LocalEventContext _context = context;
    private readonly ILogger<FavoriteService> _logger = logger;

    public async Task<List<Event>?> GetFavoriteEventAsync(int accountId)
    {
        var favoriteEventsId = await _context.Favorites
            .Where(f => f.AccountId == accountId)
            .Select(f => f.EventId)
            .ToListAsync();

        var favoriteEvents = await _context.Events
            .Where(e => favoriteEventsId.Contains(e.EventId))
            .ToListAsync();

        return favoriteEvents;
    }


    public async Task AddFavoriteEventAsync(int accountId, int eventId)
    {
        var exists = await _context.Favorites
            .AnyAsync(f => f.AccountId == accountId && f.EventId == eventId);

        if (exists)
            throw new InvalidOperationException("Event is already in favorites.");

        var favorite = new Favorite
        {
            AccountId = accountId,
            EventId = eventId
        };

        _context.Favorites.Add(favorite);
        await _context.SaveChangesAsync();
    }

    public async Task RemoveFavoriteEventAsync(int accountId, int eventId)
    {
        var favorite = await _context.Favorites
            .FirstOrDefaultAsync(f => f.AccountId == accountId && f.EventId == eventId);

        if (favorite == null)
            throw new KeyNotFoundException("Favorite event not found.");

        _context.Favorites.Remove(favorite);
        await _context.SaveChangesAsync();
    }

}