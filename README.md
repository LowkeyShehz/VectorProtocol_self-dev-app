# Vector Protocol

> A gamified, tactical self-development tracking app.

Built with Flutter. The app uses a dark cyberpunk aesthetic with JetBrains Mono typography, a radar chart bio-metrics system and RPG-style progression. Fully local — no account required.

---

## Features

| Feature | Description |
|---|---|
| **Habits** | Track daily/weekly good & bad habits, linked to Radar Chart attributes |
| **Missions (Tasks)** | Create and manage tasks with due dates, priority, and image attachments |
| **OCR Task Scan** | Use your camera to scan handwritten text — tasks are auto-created from the image |
| **Reminders** | Schedule reminders with custom times and image attachments |
| **Journal** | Write daily journal entries with optional image |
| **Radar Chart** | Visual bio-metrics dashboard showing your progress across custom life-axes |
| **Achievements** | Unlock XP-based achievements as you complete habits and tasks |
| **Custom Notifications** | Schedule a personal daily "signal" with an attached image or video |
| **XP & Level System** | Earn XP by completing habits and missions, level up over time |
| **App Streak** | Tracks consecutive days of app usage |
| **Light & Dark Theme** | Fully adaptive UI for both light and dark mode |
| **Profile** | Configure username, radar axes, and notification preferences |

---

## OCR Library (Task Scan)

The **camera scan button** in the Missions (Tasks) screen uses **[Google ML Kit Text Recognition](https://pub.dev/packages/google_mlkit_text_recognition)** (`google_mlkit_text_recognition`).

- It captures an image from the camera using `image_picker`.
- ML Kit processes the image on-device using the **Latin script** recognizer.
- The recognized text is placed into the task's description field for review before saving.
- The captured image is also attached to the task as a visual reference.

---

## Tech Stack

| Layer | Library |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Riverpod (`flutter_riverpod`, `riverpod_annotation`) |
| Database | Isar (local, NoSQL) |
| Navigation | go_router |
| Fonts | Google Fonts (JetBrains Mono, Inter) |
| Charts | fl_chart |
| Animations | flutter_animate |
| Camera & Image | image_picker |
| OCR | google_mlkit_text_recognition |
| Notifications | flutter_local_notifications |
| Timezones | timezone |
| Video Playback | video_player |
| Permissions | permission_handler |
| URL Launch | url_launcher |

---

## Getting Started

### Prerequisites
- Flutter SDK `>=3.2.0`
- Android device / emulator (Android 5.0+)

### Run

```bash
flutter pub get
dart run build_runner build
flutter run
```

### Release Build

```bash
flutter build apk --release
```

---

## Developer

Developed by **Shehzan Faqqih**
Instagram: [@lowkeyshehz](https://www.instagram.com/lowkeyshehz/)
