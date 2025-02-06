using System;
using System.Collections.Generic;

namespace LocalAppBackend.Domain.Models;

public partial class CategoryEvent
{
    public int CategoryEventId { get; set; }

    public int? CategoryId { get; set; }

    public int? EventId { get; set; }

    public virtual Category? Category { get; set; }

    public virtual Event? Event { get; set; }
}
