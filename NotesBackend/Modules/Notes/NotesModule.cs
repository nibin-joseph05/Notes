using NotesBackend.Modules.Notes.Endpoints;
using NotesBackend.Modules.Notes.Services;

namespace NotesBackend.Modules.Notes;

public static class NotesModule
{
    public static IServiceCollection AddNotesModule(this IServiceCollection services)
    {
        services.AddScoped<INoteService, NoteService>();
        return services;
    }

    public static IEndpointRouteBuilder MapNotesModule(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/notes");
        NotesEndpoints.Map(group);
        return app;
    }
}
