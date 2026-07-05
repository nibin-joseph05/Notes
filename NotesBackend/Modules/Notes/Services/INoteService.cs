using NotesBackend.Modules.Notes.DTOs;

namespace NotesBackend.Modules.Notes.Services;

public interface INoteService
{
    Task<List<NoteDto>> GetAllAsync();
    Task<NoteDto> UpsertAsync(UpsertNoteRequest request);
    Task<bool> DeleteAsync(string id);
}
