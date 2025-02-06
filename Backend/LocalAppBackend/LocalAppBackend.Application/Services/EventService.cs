using LocalAppBackend.Application.Interface;
using LocalAppBackend.Domain.Models;
using LocalEventBackend.Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Http;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Formats.Jpeg;
using SixLabors.ImageSharp.Processing;

namespace LocalAppBackend.Application.Services;

public class EventService(ILogger<EventService> logger, LocalEventContext context) : IEventService
{
    private readonly ILogger<EventService> _logger = logger;
    private readonly LocalEventContext _context = context;

    public async Task<bool> AddEventAsync(string title, string? description, int regionId, DateTime date, int categoryId,
        string punchLine1, string punchLine2, IFormFile? eventImage, int hostId, List<IFormFile>? galleryImages)
    {
        _logger.LogInformation("Adding event");
       
        var newEvent = new Event
        {
            Title = title,
            Description = description,
            RegionId = regionId,
            EventDate = date,
            Punchline1 = punchLine1,
            Punchline2 = punchLine2,
            HostId = hostId,
        };

        // Process the event image if provided
        if (eventImage != null)
        {
            newEvent.EventImage = await ProcessImage(eventImage);
        }

        _context.Events.Add(newEvent);
        await _context.SaveChangesAsync();

        _logger.LogInformation($"Adding category for event with eventId: {newEvent.EventId} and categoryId: {categoryId}");
        _context.CategoryEvents.Add(new CategoryEvent
        {
            EventId = newEvent.EventId,
            CategoryId = categoryId
        });

        _logger.LogInformation("Processing gallery images");

        if (galleryImages != null && galleryImages.Any())
        {
            var imageGalleries = new List<ImageGallery>();

            foreach (var file in galleryImages)
            {
                // Process each gallery image
                var processedImage = await ProcessImage(file);
                imageGalleries.Add(new ImageGallery
                {
                    EventId = newEvent.EventId,
                    Image = processedImage
                });
            }

            _context.ImageGalleries.AddRange(imageGalleries);
        }

        await _context.SaveChangesAsync();
        return true;
    }

    // Helper method to process and resize/compress image
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

    public async Task<List<Event>?> GetEventsAsync()
    {
        var categories = await _context.CategoryEvents.ToListAsync();
        var images = await _context.ImageGalleries.ToListAsync();
        var events=await  _context.Events.ToListAsync();
        
        var firstEvent = events.FirstOrDefault();
        var eventcategories = categories.Where(x => x.EventId == firstEvent?.EventId).ToList();
        var eventimages = images.Where(x => x.EventId == firstEvent?.EventId).ToList();
        _logger.LogInformation("Matching categories: " + eventcategories.Count);
        _logger.LogInformation("Matching images: " + eventimages.Count);
        
        return  events;
    }

    public async Task<List<Event>?> GetEventByCategoryAsync(int categoryId)
    {
        return await _context.Events
            .Where(e => e.CategoryEvents.Any(ce => ce.CategoryId == categoryId))
            .ToListAsync();
    }

    public async Task<List<Event>?> GetEventByHostAsync(int accountId)
    {
        return await _context.Events
            .Where(e => e.HostId == accountId)
            .ToListAsync();
    }
}
