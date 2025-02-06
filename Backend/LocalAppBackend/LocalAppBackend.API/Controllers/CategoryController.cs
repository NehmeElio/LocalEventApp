using LocalAppBackend.Application.Interface;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LocalAppBackend.API.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class CategoryController(ICategoryService categoryService, ILogger<CategoryController> logger)
    : ControllerBase
{
    private readonly ICategoryService _categoryService = categoryService;
    private readonly ILogger<CategoryController> _logger = logger;

    [HttpGet("GetCategories")]
    public async Task<IActionResult> GetCategories()
    {
        var categories = await _categoryService.GetCategoriesAsync();
        return Ok(categories);
    }
}