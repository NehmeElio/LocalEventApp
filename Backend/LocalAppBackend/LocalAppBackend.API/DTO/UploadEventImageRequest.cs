namespace LocalAppBackend.API.DTO;

public class UploadEventImageRequest
{
    public int eventId {get; set;}
    public IFormFile eventImage {get; set;}
}