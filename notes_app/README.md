# Notes — Smart Personal Note-Taking App

A modern and beautifully designed Flutter notes application that allows users to create, customize, and secure notes with rich personalization features.

**Developed by Nibin Joseph**

---

## Features

### Core Note-Taking
- Create and edit notes with title and body
- Auto timestamp (Created / Last Updated)
- Pin notes (max 4 allowed)
- **Real-time Local Search**: Lightning-fast full-text search across all notes (Powered by Riverpod).

### Offline-First Cloud Sync
- All notes instantly save locally to Hive for ultra-fast, offline access.
- Silently syncs to the .NET 8 PostgreSQL backend in the background.
- Automatically handles media uploading and URL swapping to ensure seamless cross-device compatibility.

### Personalization
- **Background customization**: Solid colors and custom wallpapers/gallery images.
- **Live brightness logic**: Automatically switches text color (white/black) based on background brightness.
- **Font customization**: Global font theme support from settings, plus per-note font selection.

### Media Support
- Add images from Camera or Gallery.
- Add voice recordings using a built-in waveform recorder UI.
- Live waveform display while recording.
- Stores audio locally per note and syncs seamlessly with the backend.

### Smart Reminders
- Set reminders using date and time picker.
- Friendly reminder prompt via snackbar.

### App Settings
- Theme controls: Dark mode UI.
- Global wallpaper selector with image cropping.
- Global font selector.
- Voice permission toggle with built-in microphone request handling.

---

## Architecture

| Layer | Description |
|-------|-------------|
| domain | Entities and repositories |
| data | Hive models and persistence |
| presentation | UI screens and widgets |
| providers | Riverpod state management |
| core | Fonts, themes, and routing |

### Project Structure
```text
lib/
 ├─ main.dart
 ├─ firebase_options.dart
 └─ src/
     ├─ core/         → fonts, routes, theme
     ├─ data/         → Hive models
     ├─ domain/       → entities & repos
     ├─ presentation/ → screens, providers, widgets
```

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| Flutter | UI Framework |
| Riverpod | State Management |
| Hive | Local NoSQL database |
| Firebase Core | Crash-free initialization support |
| Path Provider | Local storage |
| Permission Handler | Runtime permissions |
| Audio Waveforms | Voice recording with waveform |
| Google Fonts | Typography |

**Key Dependencies:**
- flutter_riverpod
- hive
- image_picker
- permission_handler
- path_provider
- audio_waveforms
- google_fonts
- intl

---

## Getting Started

### Run the Project

1. Fetch dependencies:
   ```bash
   flutter pub get
   ```

2. Run the application:
   ```bash
   flutter run
   ```

**For release builds on Android:**
```bash
flutter build apk --release
```

---

## Developer

**Nibin Joseph**  
Full-Stack & Flutter Developer  
Portfolio: [nibin-joseph05.github.io/portfolio-nibin](https://nibin-joseph05.github.io/portfolio-nibin)

---

## Contribution & License

**Contribution:** This is a personal showcase project. However, suggestions or improvements are always welcome.

**License:** This project is open for learning and personal use. Redistribution or republishing as-is is not permitted without permission.