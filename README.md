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
supabase/         Backend migrations, tests, and functions workspace
docs/             Product, architecture, security, and handover documents
```

## Current stage

**Milestone 2B completed — Flutter authentication foundation**

The repository now contains:

- a runnable Flutter staff application;
- a Next.js visitor-facing portal foundation;
- a migration-first Supabase tenant database foundation with RLS tests;
- Flutter email/password sign-up and sign-in;
- restored authentication sessions and sign-out;
- protected staff routes when Supabase is configured;
- backend-free preview mode for UI review.

Organization onboarding, membership selection, locations, employees, real visitor workflows, QR verification, reporting, and offline synchronization are not implemented yet.

The next focused milestone is **Milestone 2C — Organization onboarding** using the existing transactional `public.create_organization` database function.

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

Running without Supabase Dart defines opens preview mode. See [`apps/staff_mobile/README.md`](apps/staff_mobile/README.md) for hosted and local Supabase authentication commands, including physical-device configuration.

## Visitor web quick start

```powershell
cd apps/visitor_web
npm ci
npm run dev
```

Open `http://localhost:3000`.

## Local Supabase quick start

Docker Desktop must be running.

```powershell
supabase start
supabase db reset
supabase test db
supabase status
```

Use `supabase stop` when local development is complete.

See [`apps/staff_mobile/README.md`](apps/staff_mobile/README.md), [`apps/visitor_web/README.md`](apps/visitor_web/README.md), and [`supabase/README.md`](supabase/README.md) for detailed setup and verification commands.

See [`docs/CURRENT_STATUS.md`](docs/CURRENT_STATUS.md) for the active milestone, verification state, and next task.
