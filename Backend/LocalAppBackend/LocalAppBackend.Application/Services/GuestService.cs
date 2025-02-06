using LocalAppBackend.Application.Interface;
using LocalAppBackend.Domain.Models;
using LocalEventBackend.Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace LocalAppBackend.Application.Services;

public class GuestService(ILogger<GuestService> logger, LocalEventContext context) : IGuestService
{
    private readonly ILogger<GuestService> _logger = logger;
    private readonly LocalEventContext _context = context;

    public async Task<List<Account>> GetAllEventGuestsAsync(int eventId)
    {
        // First, fetch the list of guest IDs for the given eventId
        var guestsIdList = await _context.EventGuests
            .Where(eg => eg.EventId == eventId)
            .Select(eg => eg.AccountId)  // Select only the AccountIds
            .ToListAsync();

        // Then, fetch the guests' details using those AccountIds
        var guests = await _context.Accounts
            .Where(account => guestsIdList.Contains(account.AccountId))  // Filter accounts by the list of IDs
            .ToListAsync();

        return guests;
    }


    public async Task AddGuestAsync(int eventId, int userId)
    {
        var existingGuest = await _context.EventGuests.Where(eg => eg.EventId == eventId && eg.AccountId == userId)
            .FirstOrDefaultAsync();

        if (existingGuest is not null)
        {
            throw new ApplicationException("Guest already exists");
        }
        var eventGuest = new EventGuest()
        {
            EventId = eventId,
            AccountId = userId
        };
        _context.EventGuests.Add(eventGuest);
        await _context.SaveChangesAsync();
    }

    public async Task RemoveGuestAsync(int eventId, int userId)
    {
        var guestEvent = await _context.EventGuests.Where(eg => eg.EventId == eventId && eg.AccountId == userId).FirstOrDefaultAsync();

        if (guestEvent is not null)
        {
            _context.EventGuests.Remove(guestEvent);
            await _context.SaveChangesAsync();
            Console.WriteLine($"Guest with UserId {userId} successfully removed from event {eventId}.");
        }
        else
        {
            Console.WriteLine($"No guest found for UserId {userId} in event {eventId}.");
            throw new ApplicationException("No guest found for UserId {userId} in event {eventId}.");
        }
    }

    public async Task<List<Event>> GetAllEvents(int accountId)
    {
        // Assuming userId here is the AccountId of the user


        // Get all events where the user is a guest
        var events = await _context.EventGuests
            .Where(eg => eg.AccountId == accountId)
            .Join(_context.Events,
                eg => eg.EventId,
                e => e.EventId,
                (eg, e) => e) // Join EventGuests and Events to fetch the Event details
            .ToListAsync();

        return events;
    }
}