# VisitFlow Staff Mobile

Flutter application for organization owners, administrators, guards, receptionists, and employee hosts.

## Requirements

- Flutter stable 3.44.x
- Dart included with the Flutter SDK
- Android Studio or the Android SDK for Android development
- Xcode on macOS for iOS development

## First-time setup

The repository keeps generated Android and iOS scaffolding out of this first foundation branch so it can be produced by the exact installed Flutter SDK.

From the repository root on Windows:

```powershell
./scripts/bootstrap_staff_mobile.ps1
cd apps/staff_mobile
flutter pub get
flutter run
```

On macOS or Linux:

```bash
bash scripts/bootstrap_staff_mobile.sh
cd apps/staff_mobile
flutter pub get
flutter run
```

## Preview mode

The app runs without a backend and displays a preview-mode banner.

## Supabase configuration

Provide public client configuration with Dart defines. Never use a Supabase service-role or secret key in this application.

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLIC_PUBLISHABLE_KEY
```

## Verification

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build apk --debug
```

## Current scope

This milestone includes only:

- application bootstrap;
- optional Supabase initialization;
- Riverpod root scope;
- centralized GoRouter configuration;
- Material 3 theme;
- responsive phone and tablet shell;
- foundation screens;
- smoke testing and CI.

Authentication, tenant data, visitor workflows, camera access, QR verification, and offline synchronization are intentionally not implemented yet.
