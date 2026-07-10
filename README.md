# VisitFlow

VisitFlow is a mobile-first B2B visitor management SaaS for offices, schools, clinics, warehouses, construction sites, residential properties, churches, barangays, and other organizations still relying on paper visitor logbooks.

## Technology direction

- **Primary app:** Flutter and Dart, Android-first with future iOS support
- **Visitor portal:** Lightweight Next.js, TypeScript, and Tailwind CSS web experience
- **Backend:** Supabase Authentication, PostgreSQL, Storage, Edge Functions, and selective Realtime
- **Architecture:** Multi-tenant, feature-first, secure by default, and designed for unreliable connectivity

## Repository structure

```text
apps/
  staff_mobile/   Flutter staff application
  visitor_web/    Visitor-facing web portal workspace
scripts/          Repeatable local setup scripts
supabase/         Backend migrations and functions workspace
docs/             Product, architecture, security, and handover documents
```

## Current stage

**Milestone 1A — Flutter application foundation**

The active branch contains the Flutter bootstrap, Riverpod root scope, centralized GoRouter navigation, Material 3 theme, responsive phone/tablet shell, foundation screens, smoke testing, and GitHub Actions verification.

Authentication, organization data, visitor workflows, camera scanning, QR validation, and offline synchronization are not implemented yet.

## Flutter quick start

On Windows:

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

See [`apps/staff_mobile/README.md`](apps/staff_mobile/README.md) for configuration and verification commands.

See [`docs/CURRENT_STATUS.md`](docs/CURRENT_STATUS.md) for the active milestone, verification state, and next task.
