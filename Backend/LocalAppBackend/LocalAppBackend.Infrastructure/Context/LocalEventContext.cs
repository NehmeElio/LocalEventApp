using LocalAppBackend.Domain.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace LocalEventBackebd.Infrastructure.Context;

public partial class LocalEventContext : DbContext
{
    private readonly IConfiguration _configuration;
    public LocalEventContext()
    {
    }

    public LocalEventContext(DbContextOptions<LocalEventContext> options, IConfiguration configuration)
        : base(options)
    {
        _configuration = configuration;
    }

    public virtual DbSet<Account> Accounts { get; set; }

    public virtual DbSet<Category> Categories { get; set; }

    public virtual DbSet<CategoryEvent> CategoryEvents { get; set; }

    public virtual DbSet<Event> Events { get; set; }

    public virtual DbSet<EventGuest> EventGuests { get; set; }

    public virtual DbSet<Guest> Guests { get; set; }

    public virtual DbSet<ImageGallery> ImageGalleries { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        var connectionString = _configuration.GetConnectionString("DefaultConnection");
        optionsBuilder.UseNpgsql(connectionString);
    }


    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Account>(entity =>
        {
            entity.HasKey(e => e.AccountId).HasName("account_pk");

            entity.ToTable("Account");

            entity.Property(e => e.AccountId)
                .ValueGeneratedNever()
                .HasColumnName("account_id");
            entity.Property(e => e.Email)
                .HasMaxLength(100)
                .HasColumnName("email");
            entity.Property(e => e.Lastname)
                .HasMaxLength(50)
                .HasColumnName("lastname");
            entity.Property(e => e.Name)
                .HasMaxLength(50)
                .HasColumnName("name");
            entity.Property(e => e.Password)
                .HasMaxLength(50)
                .HasColumnName("password");
            entity.Property(e => e.Username)
                .HasMaxLength(100)
                .HasColumnName("username");
        });

        modelBuilder.Entity<Category>(entity =>
        {
            entity.HasKey(e => e.CategoryId).HasName("categories_pk");

            entity.HasIndex(e => e.CategoryName, "categories_name_pk").IsUnique();

            entity.Property(e => e.CategoryId).HasColumnName("category_id");
            entity.Property(e => e.CategoryDescription)
                .HasMaxLength(200)
                .HasColumnName("category_description");
            entity.Property(e => e.CategoryName)
                .HasMaxLength(40)
                .HasColumnName("category_name");
            entity.Property(e => e.Icon)
                .HasMaxLength(40)
                .HasColumnName("icon");
        });

        modelBuilder.Entity<CategoryEvent>(entity =>
        {
            entity.HasKey(e => e.CategoryEventId).HasName("category_event_pk");

            entity.ToTable("Category_Event");

            entity.Property(e => e.CategoryEventId).HasColumnName("category_event_id");
            entity.Property(e => e.CategoryId).HasColumnName("category_id");
            entity.Property(e => e.EventId).HasColumnName("event_id");

            entity.HasOne(d => d.Category).WithMany(p => p.CategoryEvents)
                .HasForeignKey(d => d.CategoryId)
                .HasConstraintName("category_event_categories_category_id_fk");

            entity.HasOne(d => d.Event).WithMany(p => p.CategoryEvents)
                .HasForeignKey(d => d.EventId)
                .HasConstraintName("category_event_event_event_id_fk");
        });

        modelBuilder.Entity<Event>(entity =>
        {
            entity.HasKey(e => e.EventId).HasName("event_pk");

            entity.ToTable("Event");

            entity.Property(e => e.EventId).HasColumnName("event_id");
            entity.Property(e => e.Description)
                .HasMaxLength(200)
                .HasColumnName("description");
            entity.Property(e => e.EventImage).HasColumnName("event_image");
            entity.Property(e => e.HostId).HasColumnName("host_id");
            entity.Property(e => e.Location)
                .HasMaxLength(100)
                .HasColumnName("location");
            entity.Property(e => e.Punchline1)
                .HasMaxLength(200)
                .HasColumnName("punchline1");
            entity.Property(e => e.Punchline2)
                .HasMaxLength(200)
                .HasColumnName("punchline2");
            entity.Property(e => e.Title)
                .HasMaxLength(60)
                .HasColumnName("title");

            entity.HasOne(d => d.Host).WithMany(p => p.Events)
                .HasForeignKey(d => d.HostId)
                .HasConstraintName("event_account_account_id_fk");
        });

        modelBuilder.Entity<EventGuest>(entity =>
        {
            entity.HasKey(e => e.EventGuestId).HasName("event_guest_pk");

            entity.ToTable("Event_Guest");

            entity.Property(e => e.EventGuestId)
                .HasDefaultValueSql("nextval('event_guest_event_guest_id_seq'::regclass)")
                .HasColumnName("event_guest_id");
            entity.Property(e => e.EventId).HasColumnName("event_id");
            entity.Property(e => e.GuestId).HasColumnName("guest_id");

            entity.HasOne(d => d.Event).WithMany(p => p.EventGuests)
                .HasForeignKey(d => d.EventId)
                .HasConstraintName("event_guest_event_event_id_fk");

            entity.HasOne(d => d.Guest).WithMany(p => p.EventGuests)
                .HasForeignKey(d => d.GuestId)
                .HasConstraintName("event_guest_guest_guest_id_fk");
        });

        modelBuilder.Entity<Guest>(entity =>
        {
            entity.HasKey(e => e.GuestId).HasName("guest_pk");

            entity.ToTable("Guest");

            entity.Property(e => e.GuestId).HasColumnName("guest_id");
            entity.Property(e => e.GuestImage).HasColumnName("guest_image");
            entity.Property(e => e.GuestName)
                .HasMaxLength(50)
                .HasColumnName("guest_name");
        });

        modelBuilder.Entity<ImageGallery>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Image_Gallery");

            entity.Property(e => e.EventId).HasColumnName("event_id");
            entity.Property(e => e.Image).HasColumnName("image");
            entity.Property(e => e.ImageGalleryId)
                .ValueGeneratedOnAdd()
                .HasColumnName("image_gallery_id");

            entity.HasOne(d => d.Event).WithMany()
                .HasForeignKey(d => d.EventId)
                .HasConstraintName("image_gallery_event_event_id_fk");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
