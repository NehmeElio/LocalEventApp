namespace LocalAppBackend.API.DTO;

public class EventDto
{
    public int EventId { get; set; }
    public string Title { get; set; }
    public string? Description { get; set; }
    public int RegionId { get; set; }
    public DateTime EventDate { get; set; }
    public string Punchline1 { get; set; }
    public string Punchline2 { get; set; }
    public byte[]? EventImage { get; set; } // You can return a base64 string or the byte array depending on your needs.
    public int HostId { get; set; }
    public List<ImageGalleryDTO> GalleryImages { get; set; }
    public List<int> CategoryId { get; set; }
}

public class ImageGalleryDTO
{
    public int ImageGalleryId { get; set; }
    public byte[] Image { get; set; }
}