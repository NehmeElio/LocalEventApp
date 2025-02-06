using System;
using System.Collections.Generic;

namespace LocalAppBackend.Domain.Models;

public partial class Guest
{
    public int GuestId { get; set; }

    public string? GuestName { get; set; }

    public byte[]? GuestImage { get; set; }

    public virtual ICollection<EventGuest> EventGuests { get; set; } = new List<EventGuest>();
}
