using Microsoft.EntityFrameworkCore;
using NotesBackend.Modules.Notes.Entities;

namespace NotesBackend.Infrastructure.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<Note> Notes => Set<Note>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Note>(entity =>
        {
            entity.HasKey(n => n.Id);
            entity.Property(n => n.Id).HasMaxLength(128);
            entity.Property(n => n.Title).IsRequired().HasMaxLength(500);
            entity.Property(n => n.Body).IsRequired();
            entity.Property(n => n.ImageUrl).HasMaxLength(1000);
            entity.Property(n => n.FontFamily).HasMaxLength(100);
            entity.Property(n => n.AudioUrl).HasMaxLength(1000);
        });
    }
}
