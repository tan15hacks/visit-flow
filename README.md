# VisitFlow

VisitFlow is a mobile-first B2B visitor management SaaS for offices, schools, clinics, warehouses, construction sites, residential properties, churches, barangays, and other organizations still relying on paper visitor logbooks.

## Technology direction

- **Primary app:** Flutter and Dart, Android-first with future iOS support
- **Visitor portal:** Next.js, TypeScript, and Tailwind CSS
- **Backend:** Supabase Authentication, PostgreSQL, Storage, Edge Functions, and selective Realtime
- **Architecture:** Multi-tenant, feature-first, secure by default, and designed for unreliable connectivity

## Repository structure

```text
apps/
  staff_mobile/   Flutter staff application
  visitor_web/    Visitor-facing Next.js portal
scripts/          Repeatable local setup scripts
supabase/         Backend migrations and functions workspace
docs/             Product, architecture, security, and handover documents
```

## Current stage

**Milestone 1B — Visitor web foundation**

The Flutter staff foundation is merged and runs on Android. The active visitor web branch adds the public portal shell and preview routes for registration, invitations, passes, and self-checkout.

Authentication, organization data, real visitor submission, token validation, QR generation, check-in, check-out, and offline synchronization are not implemented yet.

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

## Visitor web quick start

```powershell
cd apps/visitor_web
npm install
npm run dev
```

Open `http://localhost:3000`.

See [`apps/staff_mobile/README.md`](apps/staff_mobile/README.md) and [`apps/visitor_web/README.md`](apps/visitor_web/README.md) for detailed setup and verification commands.

See [`docs/CURRENT_STATUS.md`](docs/CURRENT_STATUS.md) for the active milestone, verification state, and next task.
