# 🚀 NotesBackend — .NET 8 API

A robust, highly scalable REST API built with **.NET 8** and **C#** to power the Notes Flutter application. This backend is designed with a modern modular architecture, fully supporting an **offline-first sync pattern** for mobile clients.

📌 **Developed by Nibin Joseph**

---

## 🏗️ Architecture & Design Patterns

The backend follows a strict **Modular Monolith** architecture. Instead of grouping files purely by technical concern (e.g., having one massive `Controllers` folder), the codebase is organized by **feature modules** (e.g., `Notes`, `Uploads`). 

This mirrors modern enterprise patterns (similar to Spring Boot domains) and ensures the code is highly cohesive, scalable, and easy to split into microservices in the future if required.

### Key Architectural Concepts:
- **Controller-Service-Repository Pattern**: Clean separation of concerns. Endpoints handle HTTP logic, Services handle business logic, and Entity Framework handles data access.
- **Data Transfer Objects (DTOs)**: Used to decouple the database entities from the API contracts, ensuring secure and controlled data exposure.
- **Dependency Injection**: Extensively utilizing .NET's built-in DI container to inject Services, DbContexts, and Loggers.

---

## 🛠️ Tech Stack

- **Framework**: .NET 8 (ASP.NET Core Web API)
- **Language**: C# 12
- **Database**: PostgreSQL
- **ORM**: Entity Framework Core 8
- **Environment Management**: DotNetEnv (for `.env` file support)
- **Logging**: Microsoft.Extensions.Logging

---

## ✨ Key Features

- **Full CRUD REST API**: Comprehensive endpoints to Create, Read, Update, and Delete notes.
- **Advanced Data Schema**: Supports rich text, custom background colors (stored as integers), font families, and pinned statuses.
- **Media Uploads**: Dedicated `/api/uploads` endpoints to handle multipart form data for Images and Audio files, returning hosted URLs.
- **Offline-First Support**: The API is specifically designed to work seamlessly with the Flutter app's local Hive database. The frontend handles local state, while the backend serves as the persistent cloud sync layer, effortlessly processing asynchronous background updates and media swaps.
- **Cross-Origin Resource Sharing (CORS)** & **Global Binding**: Configured to listen on `0.0.0.0` for easy local network development and mobile device testing.

---

## 📂 Project Structure

```text
NotesBackend/
 ├─ Program.cs                 → App entry point, Middleware & DI Configuration
 ├─ NotesBackend.csproj        → Project file & Dependencies
 ├─ .env                       → Environment variables (Database connection strings)
 ├─ Infrastructure/            → Cross-cutting concerns
 │   └─ Data/
 │       └─ AppDbContext.cs    → EF Core Database Context & Model Builder
 └─ Modules/                   → Feature Modules
     ├─ Notes/
     │   ├─ Endpoints/         → API Route mapping (Controllers)
     │   ├─ Services/          → Business logic layer
     │   ├─ Entities/          → Database schemas
     │   ├─ DTOs/              → Data Transfer Objects
     │   └─ Mappers/           → Conversion between DTOs and Entities
     └─ Uploads/
         └─ Endpoints/         → Multipart file upload handling
```

---

## 🚀 Getting Started

### Prerequisites
- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- [PostgreSQL](https://www.postgresql.org/download/)

### Setup Instructions

1. **Clone the repository** and navigate to the backend folder:
   ```bash
   cd NotesBackend
   ```

2. **Configure your Environment**:
   Create a `.env` file in the root directory (alongside `Program.cs`) and add your PostgreSQL connection string:
   ```env
   DB_CONNECTION_STRING="Host=localhost;Port=5432;Database=notes;Username=postgres;Password=YOUR_PASSWORD"
   ```

3. **Apply Database Migrations**:
   Run the following command to create the database schema using Entity Framework Core:
   ```bash
   dotnet ef database update
   ```

4. **Run the API**:
   ```bash
   dotnet run
   ```
   The API will start and listen on port `5103`.

---

## 👨‍💻 Developer

**Nibin Joseph**  
📌 Full-Stack & Flutter Developer  
🔗 Portfolio: [nibin-joseph05.github.io/portfolio-nibin](https://nibin-joseph05.github.io/portfolio-nibin)

---

## 📃 License

This project is open for learning and personal use. Redistribution or republishing as-is is not permitted without permission.
