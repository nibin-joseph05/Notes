using NotesBackend.Modules.Uploads.Endpoints;

namespace NotesBackend.Modules.Uploads;

public static class UploadsModule
{
    public static IEndpointRouteBuilder MapUploadsModule(this IEndpointRouteBuilder app, IWebHostEnvironment env)
    {
        var group = app.MapGroup("/api/uploads");
        UploadsEndpoints.Map(group, env);
        return app;
    }
}
