namespace LocalAppBackend.API.DTO;

public class UploadProfileRequest
{
    public IFormFile? ProfilePicture {get;set;}
    public int UserId {get;set;}
}