using LocalAppBackend.Domain.Models;

namespace LocalAppBackend.Application.Interface;

public interface ICategoryService
{
    public Task<IEnumerable<Category>> GetCategoriesAsync();
    /*public Task<Category?> GetCategoryByIdAsync(int categoryId);
    public Task<Category> CreateCategoryAsync(Category category);*/
    
}