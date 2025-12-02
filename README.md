🗒️ Notes — Smart Personal Note-Taking App

A modern and beautifully designed Flutter notes application that allows users to create, customize, and secure notes with rich personalization features.

📌 Developed by Nibin Joseph

🚀 Features
✨ Core Note-Taking

Create and edit notes with title + body

Auto timestamp (Created / Last Updated)

Pin notes (max 4 allowed)

Real-time search & fast load with local storage

🎨 Personalization

Background customization

Solid colors

Wallpapers / gallery images

Live brightness logic (auto white/black text based on background)

Font customization

Global font theme support from settings

Per-note font selection

🖼️ Media Support

Add images from:

📷 Camera

🖼️ Gallery

Add voice recordings using waveform recorder UI

Live waveform display while recording

Stores audio locally per note

⏰ Smart Reminders

Set reminders using date & time picker

Friendly reminder prompt via snackbar

🔧 App Settings

Theme controls:

Dark mode UI

Global wallpaper selector + wallpaper cropping

Font selector

Voice permission toggle — microphone request handling included

🧩 Robust Architecture
Layer	Description
domain	Entities & repositories
data	Hive models & persistence
presentation	UI screens + widgets
providers	Riverpod state management
core	Fonts, themes & routes
📂 Project Structure
lib/
 ├─ main.dart
 ├─ firebase_options.dart
 └─ src/
     ├─ core/         → fonts, routes, theme
     ├─ data/         → Hive models
     ├─ domain/       → entities & repos
     ├─ presentation/ → screens, providers, widgets

🛠️ Tech Stack
Tool	Purpose
Flutter	UI Framework
Riverpod	State Management
Hive	Local NoSQL database
Firebase Core	Crash-free initialization support
Path Provider	Local storage
Permission Handler	Runtime permissions
Audio Waveforms	Voice recording with waveform
Google Fonts	Typography
📦 Dependencies (important ones)
flutter_riverpod
hive
image_picker
permission_handler
path_provider
audio_waveforms
google_fonts
intl

▶️ Run the Project
flutter pub get
flutter run


⚠️ For release builds on Android:

flutter build apk --release

👨‍💻 Developer

Nibin Joseph
📌 Full-Stack & Flutter Developer
🔗 Portfolio: nibin-joseph05.github.io/portfolio-nibin

❤️ Contribution

This is a personal showcase project.
However, suggestions or improvements are always welcome.

📃 License

This project is open for learning and personal use.
Redistribution or republishing as-is is not permitted without permission.