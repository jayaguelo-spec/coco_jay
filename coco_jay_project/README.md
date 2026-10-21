# Prenatal Care System

## Summary
A web-based system that helps expecting mothers and community health workers keep
prenatal records in one place — appointments, check-up records, and reminders.
First features in this checkpoint: a login gate, a home dashboard, and a reusable
UI component set (buttons and text fields).

## Current stack
- Implemented now: Flutter Web / Dart (client-side UI, widgets, navigation, forms).
- Planned: instructor-approved REST API (e.g., FastAPI) for business rules and
  PostgreSQL (IT 108) for persistent storage. No backend code exists yet.

## Project structure
```
lib/
├── main.dart        # entry point
├── app.dart         # MaterialApp, theme, routes
├── screens/         # login_screen.dart, landing_screen.dart, home_screen.dart (dashboard)
├── widgets/         # app_button.dart, app_text_field.dart
├── services/        # planned REST API client
├── models/          # client-side data structures
├── routes/          # named routes and navigation helpers
└── constants/       # app-wide constants (no secrets)
```

## Run locally
Prerequisites: Flutter SDK with web enabled, Google Chrome.

```
flutter pub get
flutter run -d chrome
```
The first compilation may take a few minutes; Chrome opens automatically.

## Verification commands
```
flutter doctor
flutter devices
flutter analyze
flutter test
```

## First checkpoint
Date: 2026-10-21 | Commit: 548e974 ("Initial Flutter Web project") | Branch: main
Repository: https://github.com/jayaguelo-spec/coco_jay
The repository root contains this Flutter project (`coco_jay_project/`), the
Activity 8 report (`ACTIVITY8_REPORT.md`), and the evidence `screenshots/`.
Run the Flutter commands from inside `coco_jay_project/` (the folder that
contains `pubspec.yaml`).
