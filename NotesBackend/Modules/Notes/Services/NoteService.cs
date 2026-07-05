using Microsoft.EntityFrameworkCore;
using NotesBackend.Infrastructure.Data;
using NotesBackend.Modules.Notes.DTOs;
using NotesBackend.Modules.Notes.Mappers;

namespace NotesBackend.Modules.Notes.Services;

public class NoteService : INoteService
{
    private readonly AppDbContext _db;
    private readonly ILogger<NoteService> _logger;

    public NoteService(AppDbContext db, ILogger<NoteService> logger)
    {
        _db = db;
        _logger = logger;
    }

    public async Task<List<NoteDto>> GetAllAsync()
    {
        _logger.LogInformation("[NOTES] GET ALL — fetching all notes from database");

        var notes = await _db.Notes
            .OrderByDescending(n => n.IsPinned)
            .ThenByDescending(n => n.UpdatedAt)
            .ToListAsync();

        _logger.LogInformation("[NOTES] GET ALL — returned {Count} notes", notes.Count);

        return notes.Select(NoteMapper.ToDto).ToList();
    }

    public async Task<NoteDto> UpsertAsync(UpsertNoteRequest request)
    {
        var existing = await _db.Notes.FindAsync(request.Id);

        if (existing is null)
        {
            _logger.LogInformation("[NOTES] CREATE — adding new note id={Id} title=\"{Title}\"", request.Id, request.Title);

            var entity = NoteMapper.ToEntity(request);
            _db.Notes.Add(entity);
            await _db.SaveChangesAsync();

            _logger.LogInformation("[NOTES] CREATE — note saved successfully id={Id}", request.Id);

            return NoteMapper.ToDto(entity);
        }

        _logger.LogInformation("[NOTES] UPDATE — updating note id={Id} title=\"{Title}\"", request.Id, request.Title);

        existing.Title = request.Title;
        existing.Body = request.Body;
        existing.ImageUrl = request.ImageUrl;
        existing.BgColor = request.BgColor;
        existing.FontFamily = request.FontFamily;
        existing.AudioUrl = request.AudioUrl;
        existing.IsPinned = request.IsPinned;
        existing.UpdatedAt = request.UpdatedAt;

        await _db.SaveChangesAsync();

        _logger.LogInformation("[NOTES] UPDATE — note updated successfully id={Id}", request.Id);

        return NoteMapper.ToDto(existing);
    }

    public async Task<bool> DeleteAsync(string id)
    {
        _logger.LogInformation("[NOTES] DELETE — deleting note id={Id}", id);

        var note = await _db.Notes.FindAsync(id);
        if (note is null)
        {
            _logger.LogWarning("[NOTES] DELETE — note not found id={Id}", id);
            return false;
        }

        _db.Notes.Remove(note);
        await _db.SaveChangesAsync();

        _logger.LogInformation("[NOTES] DELETE — note removed successfully id={Id}", id);

        return true;
    }
}
