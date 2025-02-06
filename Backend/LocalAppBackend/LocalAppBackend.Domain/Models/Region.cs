using System;
using System.Collections.Generic;

namespace LocalAppBackend.Domain.Models;

public partial class Region
{
    public int RegionId { get; set; }

    public string RegionName { get; set; } = null!;

    public int? CountryId { get; set; }

    public decimal Latitude { get; set; }

    public decimal Longitude { get; set; }

    public virtual Country? Country { get; set; }

    public virtual ICollection<Event> Events { get; set; } = new List<Event>();
}
