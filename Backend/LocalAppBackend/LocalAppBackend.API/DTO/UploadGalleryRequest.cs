namespace LocalAppBackend.API.DTO;

public class UploadGalleryRequest
{
    public int eventId { get; set; }
    public IList<IFormFile> galleryImages { get; set; }
}