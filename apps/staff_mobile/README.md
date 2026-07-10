# VisitFlow Staff Mobile

Flutter application for organization owners, administrators, guards, receptionists, and employee hosts.

## Requirements

- Flutter stable 3.44.x
- Dart included with the Flutter SDK
- Android Studio or the Android SDK for Android development
- Xcode on macOS for iOS development
- Docker Desktop and Supabase CLI for local authentication testing

## First-time setup

The repository generates Android and iOS scaffolding using the installed Flutter SDK.

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

Running without Supabase Dart defines keeps the existing preview shell available. Preview mode does not show real authentication or tenant data.

```bash
flutter run
```

## Supabase authentication

VisitFlow accepts only the public Supabase URL and public publishable key. Never use a service-role key, database password, or server secret in the Flutter application.

For a hosted project:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLIC_PUBLISHABLE_KEY
```

For local Supabase development, start the stack from the repository root:

```bash
supabase start
supabase db reset
supabase status
```

When testing on a physical Android phone, the phone cannot reach the PC through `127.0.0.1`. Keep the phone and PC on the same network and replace the localhost portion of the local API URL with the PC's LAN IPv4 address.

Example:

```powershell
flutter run `
  --dart-define=SUPABASE_URL=http://192.168.1.10:54321 `
  --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_LOCAL_PUBLIC_KEY
```

The public key is shown by `supabase status`. Local email confirmation is currently disabled for development, so a successful local sign-up can create an active session immediately.

## Authentication behavior

When Supabase is configured:

- signed-out users are sent to the sign-in screen;
- staff can create an account with email and password;
- existing sessions are restored by the official Supabase client;
- authenticated users can enter the protected `/app/*` routes;
- signing out returns the user to sign-in;
- passwords are never stored or logged by VisitFlow.

Organization creation, membership selection, and role-aware data access are intentionally deferred to the next milestone.

## Verification

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build apk --debug
```

## Current scope

This milestone includes:

- application bootstrap and optional Supabase initialization;
- Riverpod root scope;
- centralized GoRouter configuration;
- Material 3 theme;
- responsive phone and tablet shell;
- Supabase password sign-in and sign-up;
- authentication-state listening and session restoration;
- protected application routes;
- sign-out;
- preview-mode compatibility;
- controller, router, and widget tests;
- Android debug build verification.

Tenant onboarding, visitor workflows, camera access, QR verification, notifications, reporting, and offline synchronization remain intentionally deferred.
