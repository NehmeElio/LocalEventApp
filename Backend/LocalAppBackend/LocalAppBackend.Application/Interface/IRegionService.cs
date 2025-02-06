using LocalAppBackend.Domain.Models;

namespace LocalAppBackend.Application.Interface;

public interface IRegionService
{
    Task<IEnumerable<Region>> GetAllRegionsAsync();
}