using System.ComponentModel.DataAnnotations;

namespace LocalAppBackend.API.DTO;

public class AddEventRequest
{
    [Required]
    public string Title { get; set; }

    public string? Description { get; set; }

    [Required]
    public int RegionId { get; set; }

    [Required]
    public DateTime Date { get; set; }

    [Required]
    public int CategoryId { get; set; }

    [Required]
    public string PunchLine1 { get; set; }

    [Required]
    public string PunchLine2 { get; set; }
    
    public IFormFile? EventImage { get; set; }
    
    public int HostId { get; set; }

    public List<IFormFile>? GalleryImages { get; set; }
}