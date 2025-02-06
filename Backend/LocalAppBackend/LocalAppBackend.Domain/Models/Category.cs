using System;
using System.Collections.Generic;

namespace LocalAppBackend.Domain.Models;

public partial class Category
{
    public int CategoryId { get; set; }

    public string? CategoryName { get; set; }

    public string? CategoryDescription { get; set; }

    public string? Icon { get; set; }

    public virtual ICollection<CategoryEvent> CategoryEvents { get; set; } = new List<CategoryEvent>();
}
