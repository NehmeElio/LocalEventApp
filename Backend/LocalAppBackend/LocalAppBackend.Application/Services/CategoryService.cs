using LocalAppBackend.Application.Interface;
using LocalAppBackend.Domain.Models;
using LocalEventBackend.Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace LocalAppBackend.Application.Services;

public class CategoryService(ILogger<CategoryService> logger, LocalEventContext context) : ICategoryService
{
    private readonly ILogger<CategoryService> _logger = logger;
    private readonly LocalEventContext _context = context;

    public async Task<IEnumerable<Category>> GetCategoriesAsync()
    {
        return await _context.Categories.ToListAsync();
        
    }
}