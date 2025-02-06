using System;
using System.Collections.Generic;

namespace LocalAppBackend.Domain.Models;

public partial class Favorite
{
    public int FavoriteId { get; set; }

    public int? AccountId { get; set; }

    public int? EventId { get; set; }

    public virtual Account? Account { get; set; }

    public virtual Event? Event { get; set; }
}
