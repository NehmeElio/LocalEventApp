using System;
using System.Collections.Generic;

namespace LocalAppBackend.Domain.Models;

public partial class EventGuest
{
    public int EventGuestId { get; set; }

    public int? EventId { get; set; }

    public int? GuestId { get; set; }

    public virtual Event? Event { get; set; }

    public virtual Guest? Guest { get; set; }
}
