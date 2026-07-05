using NotesBackend.Common;

namespace NotesBackend.Modules.Uploads.Endpoints;

public static class UploadsEndpoints
{
    public static void Map(RouteGroupBuilder group, IWebHostEnvironment env)
    {
        group.MapPost("/image", async (IFormFile file, IWebHostEnvironment hostEnv) =>
        {
            if (file.Length == 0)
                return Results.BadRequest(ApiResponse.Fail("No file provided."));

            var allowedExtensions = new[] { ".jpg", ".jpeg", ".png", ".webp", ".gif" };
            var ext = Path.GetExtension(file.FileName).ToLowerInvariant();

            if (!allowedExtensions.Contains(ext))
                return Results.BadRequest(ApiResponse.Fail("Invalid file type."));

            var uploadsDir = Path.Combine(hostEnv.ContentRootPath, "uploads", "images");
            Directory.CreateDirectory(uploadsDir);

            var fileName = $"{Guid.NewGuid()}{ext}";
            var filePath = Path.Combine(uploadsDir, fileName);

            await using var stream = new FileStream(filePath, FileMode.Create);
            await file.CopyToAsync(stream);

            var url = $"/uploads/images/{fileName}";
            return Results.Ok(ApiResponse<object>.Ok(new { url }));
        })
        .DisableAntiforgery();

        group.MapPost("/audio", async (IFormFile file, IWebHostEnvironment hostEnv) =>
        {
            if (file.Length == 0)
                return Results.BadRequest(ApiResponse.Fail("No file provided."));

            var allowedExtensions = new[] { ".m4a", ".mp3", ".aac", ".wav", ".ogg" };
            var ext = Path.GetExtension(file.FileName).ToLowerInvariant();

            if (!allowedExtensions.Contains(ext))
                return Results.BadRequest(ApiResponse.Fail("Invalid file type."));

            var uploadsDir = Path.Combine(hostEnv.ContentRootPath, "uploads", "audio");
            Directory.CreateDirectory(uploadsDir);

            var fileName = $"{Guid.NewGuid()}{ext}";
            var filePath = Path.Combine(uploadsDir, fileName);

            await using var stream = new FileStream(filePath, FileMode.Create);
            await file.CopyToAsync(stream);

            var url = $"/uploads/audio/{fileName}";
            return Results.Ok(ApiResponse<object>.Ok(new { url }));
        })
        .DisableAntiforgery();
    }
}
