using System;
using System.Collections.Generic;

namespace LocalAppBackend.Domain.Models;

public partial class Account
{
    public int AccountId { get; set; }

    public string Email { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string Lastname { get; set; } = null!;

    public string Password { get; set; } = null!;

    public string Username { get; set; } = null!;

    public string? PhoneNb { get; set; }

    public DateOnly? CreatedAt { get; set; }

    public byte[]? ProfilePicture { get; set; }

    public virtual ICollection<EventGuest> EventGuests { get; set; } = new List<EventGuest>();

    public virtual ICollection<Event> Events { get; set; } = new List<Event>();

    public virtual ICollection<Favorite> Favorites { get; set; } = new List<Favorite>();
}
