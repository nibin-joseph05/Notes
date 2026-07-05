using NotesBackend.Modules.Notes.DTOs;
using NotesBackend.Modules.Notes.Entities;

namespace NotesBackend.Modules.Notes.Mappers;

public static class NoteMapper
{
    public static NoteDto ToDto(Note note) => new()
    {
        Id = note.Id,
        Title = note.Title,
        Body = note.Body,
        ImageUrl = note.ImageUrl,
        BgColor = note.BgColor,
        FontFamily = note.FontFamily,
        AudioUrl = note.AudioUrl,
        IsPinned = note.IsPinned,
        CreatedAt = note.CreatedAt,
        UpdatedAt = note.UpdatedAt,
    };

    public static Note ToEntity(UpsertNoteRequest req) => new()
    {
        Id = req.Id,
        Title = req.Title,
        Body = req.Body,
        ImageUrl = req.ImageUrl,
        BgColor = req.BgColor,
        FontFamily = req.FontFamily,
        AudioUrl = req.AudioUrl,
        IsPinned = req.IsPinned,
        CreatedAt = req.CreatedAt,
        UpdatedAt = req.UpdatedAt,
    };
}
