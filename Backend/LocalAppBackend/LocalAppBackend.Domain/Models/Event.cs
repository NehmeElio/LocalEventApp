using System;
using System.Collections.Generic;

namespace LocalAppBackend.Domain.Models;

public partial class Event
{
    public int EventId { get; set; }

    public string? Description { get; set; }

    public byte[]? EventImage { get; set; }

    public string? Title { get; set; }

    public string? Punchline1 { get; set; }

    public string? Punchline2 { get; set; }

    public int? HostId { get; set; }

    public int? RegionId { get; set; }

    public DateTime? EventDate { get; set; }

    public virtual ICollection<CategoryEvent> CategoryEvents { get; set; } = new List<CategoryEvent>();

    public virtual ICollection<EventGuest> EventGuests { get; set; } = new List<EventGuest>();

    public virtual ICollection<Favorite> Favorites { get; set; } = new List<Favorite>();

    public virtual Account? Host { get; set; }

    public virtual ICollection<ImageGallery> ImageGalleries { get; set; } = new List<ImageGallery>();

    public virtual Region? Region { get; set; }
}
