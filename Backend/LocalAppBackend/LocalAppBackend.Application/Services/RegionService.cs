using LocalAppBackend.Application.Interface;
using LocalAppBackend.Domain.Models;
using LocalEventBackend.Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace LocalAppBackend.Application.Services;

public class RegionService(ILogger<RegionService> logger, LocalEventContext context) : IRegionService
{
    private readonly ILogger<RegionService> _logger = logger;
    private readonly LocalEventContext _context = context;

    public async Task<IEnumerable<Region>> GetAllRegionsAsync()
    {
        return await _context.Regions.ToListAsync();
    }
}