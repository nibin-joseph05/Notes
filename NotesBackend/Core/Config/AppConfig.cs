namespace NotesBackend.Core.Config;

public static class AppConfig
{
    public static string DbConnectionString =>
        Environment.GetEnvironmentVariable("ConnectionStrings__DefaultConnection")
        ?? throw new InvalidOperationException("DB connection string not set in .env");
}
