using System;
using System.Collections.Generic;

namespace LocalAppBackend.Domain.Models;

public partial class Country
{
    public int CountryId { get; set; }

    public string? CountryName { get; set; }

    public virtual ICollection<Region> Regions { get; set; } = new List<Region>();
}
