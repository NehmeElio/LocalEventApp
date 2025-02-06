using AutoMapper;
using LocalAppBackend.API.DTO;
using LocalAppBackend.Application.Interface;
using LocalAppBackend.Domain.Models;
using LocalEventBackend.Infrastructure.Context;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Formats.Jpeg;
using SixLabors.ImageSharp.Processing;

namespace LocalAppBackend.API.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class RegionController : ControllerBase
{
    private readonly ILogger<RegionController> _logger;
    private readonly IRegionService _regionService;
    private readonly LocalEventContext _context;

    public RegionController(ILogger<RegionController> logger, IRegionService regionService, LocalEventContext context)
    {
        _logger = logger;
        _regionService = regionService;
        _context = context;
    }

    [HttpGet("GetAllRegions")]
    public async Task<IActionResult> GetAllRegionsAsync()
    {
        var regions = await _regionService.GetAllRegionsAsync();
        return Ok(regions);
    }

    [HttpPost("UploadEventImage")]
    public async Task<IActionResult> UploadEventImage(int eventId, IFormFile eventImage)
    {
        _logger.LogInformation($"Uploading event image for eventId {eventId}");

        var eventEntity = await _context.Events.FindAsync(eventId);
        if (eventEntity == null)
        {
            return NotFound("Event not found");
        }

        var imageBytes = await ProcessImage(eventImage);

        eventEntity.EventImage = imageBytes;

        await _context.SaveChangesAsync();
        _logger.LogInformation("Event image updated successfully");

        return Ok("Event image updated successfully");
    }

    [HttpPost("UploadGalleryImage")]
    public async Task<IActionResult> UploadGalleryImages([FromForm] UploadGalleryRequest uploadGalleryRequest)
    {
        _logger.LogInformation($"Uploading {uploadGalleryRequest.galleryImages.Count} gallery images for eventId {uploadGalleryRequest.eventId}");

        var eventExists = await _context.Events.AnyAsync(e => e.EventId == uploadGalleryRequest.eventId);
        if (!eventExists)
        {
            return NotFound("Event not found");
        }

        var imageGalleryList = new List<ImageGallery>();

        foreach (var galleryImage in uploadGalleryRequest.galleryImages)
        {
            var imageBytes = await ProcessImage(galleryImage);

            var newGalleryImage = new ImageGallery
            {
                EventId = uploadGalleryRequest.eventId,
                Image = imageBytes
            };

            imageGalleryList.Add(newGalleryImage);
        }

        _context.ImageGalleries.AddRange(imageGalleryList);
        await _context.SaveChangesAsync();

        _logger.LogInformation($"{uploadGalleryRequest.galleryImages.Count} gallery images added successfully");
        return Ok($"{uploadGalleryRequest.galleryImages.Count} gallery images added successfully");
    }

    // Method to handle image compression if needed
    private async Task<byte[]> ProcessImage(IFormFile image)
    {
        using var memoryStream = new MemoryStream();
        await image.CopyToAsync(memoryStream);

        // If image is over 200 KB, resize and compress it
        if (memoryStream.Length > 200 * 1024) // 200 KB
        {
            _logger.LogInformation("Image size exceeds 200 KB, resizing and compressing image");

            memoryStream.Seek(0, SeekOrigin.Begin);

            using var imageSharp = Image.Load(memoryStream);

            // Resize the image if it's too large (you can adjust these dimensions as needed)
            int maxWidth = 800;  // Max width for resizing
            int maxHeight = 600; // Max height for resizing

            // Resize the image proportionally, ensuring it doesn't exceed the max dimensions
            imageSharp.Mutate(x => x.Resize(new ResizeOptions
            {
                Mode = ResizeMode.Max, // Preserve aspect ratio
                Size = new Size(maxWidth, maxHeight)
            }));

            // Apply compression with lower quality (e.g., 50%)
            var jpegEncoder = new JpegEncoder { Quality = 50 };

            using var compressedMemoryStream = new MemoryStream();
            imageSharp.Save(compressedMemoryStream, jpegEncoder);

            return compressedMemoryStream.ToArray();
        }

        // If the image is under the size limit, just return the original
        return memoryStream.ToArray();
    }

}
