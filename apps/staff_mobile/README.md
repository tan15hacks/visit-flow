# VisitFlow Staff Mobile

Flutter application for organization owners, administrators, guards, receptionists, and employee hosts.

## Requirements

- Flutter stable 3.44.x
- Dart included with the Flutter SDK
- Android Studio or the Android SDK for Android development
- Xcode on macOS for iOS development
- Docker Desktop and Supabase CLI for local authentication and onboarding testing
- Android Platform Tools for physical-device USB testing

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

## Supabase authentication and onboarding

VisitFlow accepts only the public Supabase URL and public publishable key. Never use a service-role key, database password, or server secret in the Flutter application.

For a hosted project:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLIC_PUBLISHABLE_KEY
```

For local Supabase development, start and reset the stack from the repository root:

```bash
supabase start
supabase db reset
supabase status
```

When testing on a physical Android phone connected through USB debugging, forward the local Supabase API port:

```powershell
adb reverse tcp:54321 tcp:54321
```

Then run the app using the public local key shown by `supabase status`:

```powershell
cd apps/staff_mobile
flutter run `
  --dart-define=SUPABASE_URL=http://127.0.0.1:54321 `
  --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_LOCAL_PUBLIC_KEY
```

Without USB port forwarding, keep the phone and PC on the same trusted network and replace `127.0.0.1` with the PC's LAN IPv4 address.

Local email confirmation is currently disabled for development, so a successful local sign-up can create an active session immediately.

## Authentication and organization behavior

When Supabase is configured:

- signed-out users are sent to the sign-in screen;
- staff can create an account with email and password;
- existing sessions are restored by the official Supabase client;
- active organization memberships are loaded through RLS-protected tables;
- authenticated users without an active membership are sent to organization setup;
- organization setup calls only `public.create_organization`;
- the database transaction creates the organization, active owner membership, and audit event;
- successful onboarding refreshes membership access and opens the protected workspace;
- signing out clears organization access and returns the user to sign-in;
- passwords and service-role credentials are never stored or logged by VisitFlow.

Users with more than one active organization currently enter the first returned workspace. An explicit organization switcher is intentionally deferred to a separate milestone.

## Verification

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build apk --debug
```

Database verification runs from the repository root:

```bash
supabase db reset
supabase db lint --level warning
supabase test db
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
- active organization-membership loading;
- organization onboarding through the controlled database function;
- membership-aware protected routes;
- active workspace context on the dashboard;
- sign-out and preview-mode compatibility;
- controller, validator, router, widget, and database integration tests;
- Android debug build verification.

Organization switching, member invitations, locations, employees, visitor workflows, camera access, QR verification, notifications, reporting, billing, and offline synchronization remain intentionally deferred.
