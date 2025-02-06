using LocalAppBackend.Domain.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace LocalEventBackend.Infrastructure.Context;

public partial class LocalEventContext : DbContext
{
    private readonly IConfiguration _configuration;
    
    /*public LocalEventContext()
    {
    }*/

    public LocalEventContext(DbContextOptions<LocalEventContext> options, IConfiguration configuration)
        : base(options)
    {
        _configuration = configuration;
    }

    public virtual DbSet<Account> Accounts { get; set; }

    public virtual DbSet<Category> Categories { get; set; }

    public virtual DbSet<CategoryEvent> CategoryEvents { get; set; }

    public virtual DbSet<Country> Countries { get; set; }

    public virtual DbSet<Event> Events { get; set; }

    public virtual DbSet<EventGuest> EventGuests { get; set; }

    public virtual DbSet<Favorite> Favorites { get; set; }

    public virtual DbSet<ImageGallery> ImageGalleries { get; set; }

    public virtual DbSet<Region> Regions { get; set; }

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

            entity.HasIndex(e => e.Email, "account_email_pk").IsUnique();

            entity.HasIndex(e => e.PhoneNb, "account_phone_nb_pk").IsUnique();

            entity.HasIndex(e => e.Username, "account_username_pk").IsUnique();

            entity.Property(e => e.AccountId)
                .HasDefaultValueSql("nextval('account_account_id_seq'::regclass)")
                .HasColumnName("account_id");
            entity.Property(e => e.CreatedAt).HasColumnName("created_at");
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
                .HasMaxLength(100)
                .HasColumnName("password");
            entity.Property(e => e.PhoneNb)
                .HasMaxLength(20)
                .HasColumnName("phone_nb");
            entity.Property(e => e.ProfilePicture).HasColumnName("profile_picture");
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

        modelBuilder.Entity<Country>(entity =>
        {
            entity.HasKey(e => e.CountryId).HasName("country_pk");

            entity.ToTable("Country");

            entity.Property(e => e.CountryId).HasColumnName("country_id");
            entity.Property(e => e.CountryName)
                .HasMaxLength(200)
                .HasColumnName("country_name");
        });

        modelBuilder.Entity<Event>(entity =>
        {
            entity.HasKey(e => e.EventId).HasName("event_pk");

            entity.ToTable("Event");

            entity.Property(e => e.EventId).HasColumnName("event_id");
            entity.Property(e => e.Description)
                .HasMaxLength(200)
                .HasColumnName("description");
            entity.Property(e => e.EventDate)
                .HasColumnType("timestamp without time zone")
                .HasColumnName("event_date");
            entity.Property(e => e.EventImage).HasColumnName("event_image");
            entity.Property(e => e.HostId).HasColumnName("host_id");
            entity.Property(e => e.Punchline1)
                .HasMaxLength(200)
                .HasColumnName("punchline1");
            entity.Property(e => e.Punchline2)
                .HasMaxLength(200)
                .HasColumnName("punchline2");
            entity.Property(e => e.RegionId).HasColumnName("region_id");
            entity.Property(e => e.Title)
                .HasMaxLength(60)
                .HasColumnName("title");

            entity.HasOne(d => d.Host).WithMany(p => p.Events)
                .HasForeignKey(d => d.HostId)
                .HasConstraintName("event_account_account_id_fk");

            entity.HasOne(d => d.Region).WithMany(p => p.Events)
                .HasForeignKey(d => d.RegionId)
                .HasConstraintName("event_region_region_id_fk");
        });

        modelBuilder.Entity<EventGuest>(entity =>
        {
            entity.HasKey(e => e.EventGuestId).HasName("event_guest_pk");

            entity.ToTable("Event_Guest");

            entity.Property(e => e.EventGuestId)
                .HasDefaultValueSql("nextval('event_guest_event_guest_id_seq'::regclass)")
                .HasColumnName("event_guest_id");
            entity.Property(e => e.AccountId).HasColumnName("account_id");
            entity.Property(e => e.EventId).HasColumnName("event_id");

            entity.HasOne(d => d.Account).WithMany(p => p.EventGuests)
                .HasForeignKey(d => d.AccountId)
                .HasConstraintName("event_guest_account_account_id_fk");

            entity.HasOne(d => d.Event).WithMany(p => p.EventGuests)
                .HasForeignKey(d => d.EventId)
                .HasConstraintName("event_guest_event_event_id_fk");
        });

        modelBuilder.Entity<Favorite>(entity =>
        {
            entity.HasKey(e => e.FavoriteId).HasName("favorite_pk");

            entity.ToTable("Favorite");

            entity.Property(e => e.FavoriteId).HasColumnName("favorite_id");
            entity.Property(e => e.AccountId).HasColumnName("account_id");
            entity.Property(e => e.EventId).HasColumnName("event_id");

            entity.HasOne(d => d.Account).WithMany(p => p.Favorites)
                .HasForeignKey(d => d.AccountId)
                .HasConstraintName("favorite_account_account_id_fk");

            entity.HasOne(d => d.Event).WithMany(p => p.Favorites)
                .HasForeignKey(d => d.EventId)
                .HasConstraintName("favorite_event_event_id_fk");
        });

        modelBuilder.Entity<ImageGallery>(entity =>
        {
            entity.HasKey(e => e.ImageGalleryId).HasName("image_gallery_pk");

            entity.ToTable("Image_Gallery");

            entity.Property(e => e.ImageGalleryId).HasColumnName("image_gallery_id");
            entity.Property(e => e.EventId).HasColumnName("event_id");
            entity.Property(e => e.Image).HasColumnName("image");

            entity.HasOne(d => d.Event).WithMany(p => p.ImageGalleries)
                .HasForeignKey(d => d.EventId)
                .HasConstraintName("image_gallery_event_event_id_fk");
        });

        modelBuilder.Entity<Region>(entity =>
        {
            entity.HasKey(e => e.RegionId).HasName("region_pk");

            entity.ToTable("Region");

            entity.HasIndex(e => e.RegionName, "Region_region_name_key").IsUnique();

            entity.Property(e => e.RegionId).HasColumnName("region_id");
            entity.Property(e => e.CountryId).HasColumnName("country_id");
            entity.Property(e => e.Latitude)
                .HasPrecision(9, 6)
                .HasColumnName("latitude");
            entity.Property(e => e.Longitude)
                .HasPrecision(9, 6)
                .HasColumnName("longitude");
            entity.Property(e => e.RegionName)
                .HasMaxLength(255)
                .HasColumnName("region_name");

            entity.HasOne(d => d.Country).WithMany(p => p.Regions)
                .HasForeignKey(d => d.CountryId)
                .HasConstraintName("region_country_country_id_fk");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
