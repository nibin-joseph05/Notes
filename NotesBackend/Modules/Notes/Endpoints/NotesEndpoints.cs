using NotesBackend.Common;
using NotesBackend.Modules.Notes.DTOs;
using NotesBackend.Modules.Notes.Services;

namespace NotesBackend.Modules.Notes.Endpoints;

public static class NotesEndpoints
{
    public static void Map(RouteGroupBuilder group)
    {
        group.MapGet("/", async (INoteService service, ILogger<Program> logger) =>
        {
            logger.LogInformation("[REQUEST] GET /api/notes — received from client");
            var notes = await service.GetAllAsync();
            return Results.Ok(ApiResponse<List<NoteDto>>.Ok(notes));
        });

        group.MapPost("/", async (UpsertNoteRequest request, INoteService service, ILogger<Program> logger) =>
        {
            logger.LogInformation("[REQUEST] POST /api/notes — received upsert for id={Id} title=\"{Title}\"", request.Id, request.Title);
            var note = await service.UpsertAsync(request);
            return Results.Ok(ApiResponse<NoteDto>.Ok(note));
        });

        group.MapDelete("/{id}", async (string id, INoteService service, ILogger<Program> logger) =>
        {
            logger.LogInformation("[REQUEST] DELETE /api/notes/{Id} — received delete request", id);
            var deleted = await service.DeleteAsync(id);
            return deleted
                ? Results.Ok(ApiResponse.Ok())
                : Results.NotFound(ApiResponse.Fail("Note not found."));
        });
    }
}
