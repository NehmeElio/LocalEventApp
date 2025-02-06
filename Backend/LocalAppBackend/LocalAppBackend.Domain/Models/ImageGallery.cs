using System;
using System.Collections.Generic;

namespace LocalAppBackend.Domain.Models;

public partial class ImageGallery
{
    public int ImageGalleryId { get; set; }

    public byte[]? Image { get; set; }

    public int? EventId { get; set; }

    public virtual Event? Event { get; set; }
}
