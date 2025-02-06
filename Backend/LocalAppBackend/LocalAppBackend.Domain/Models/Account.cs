using System;
using System.Collections.Generic;

namespace LocalAppBackend.Domain.Models;

public partial class Account
{
    public int AccountId { get; set; }

    public string? Email { get; set; }

    public string? Name { get; set; }

    public string? Lastname { get; set; }

    public string? Password { get; set; }

    public string? Username { get; set; }

    public virtual ICollection<Event> Events { get; set; } = new List<Event>();
}
