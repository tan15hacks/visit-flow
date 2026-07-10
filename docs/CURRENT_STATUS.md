# VisitFlow Current Status

## Current milestone

Milestone 2C completed — Organization onboarding

## Current branch

`main`

## Latest merged pull request

Pull request #9 — `feat: add organization onboarding`

## Latest main commit

`53f15b64e23df6bf309081bfa4371d244ae5b4e9`

## Completed

- Milestone 0 product and architecture documentation merged
- Milestone 1A Flutter staff foundation merged and reviewed on Android
- Milestone 1B visitor web foundation merged
- Milestone 2A Supabase tenant foundation merged
- Milestone 2B Flutter authentication foundation merged
- Milestone 2C organization onboarding merged
- Email/password sign-up, sign-in, restored sessions, and sign-out implemented
- Organizations, organization memberships, audit logs, RLS, and transactional organization creation implemented
- Organization membership and workspace domain models added
- Organization data isolated behind a testable gateway
- Active memberships loaded through RLS-protected tables
- Membership queries explicitly scoped to the authenticated user ID
- Membership-aware organization access controller added
- Authenticated users without an active membership are routed to organization setup
- Organization name, slug, and timezone validation added
- Editable workspace slug generation added
- Organization creation calls only `public.create_organization`
- Successful creation refreshes memberships before entering the staff workspace
- Active organization name, role, slug, and timezone displayed on the dashboard
- Retry and sign-out recovery states added
- Preview mode remains available without backend credentials
- Organization controller, validator, route, widget, and preview regression tests added
- Dedicated pgTAP organization-onboarding transaction tests added
- USB `adb reverse` instructions documented for physical Android testing
- Architecture decision ADR-020 records the active-membership workspace gate

## Current state

- A configured Flutter app can authenticate a staff user and resolve that user's active organization memberships.
- A newly authenticated account with no membership is routed to a focused organization setup screen.
- Creating an organization atomically creates the organization, active owner membership, and audit event.
- After onboarding, the app refreshes tenant access and opens the organization dashboard.
- Accounts with one or more active memberships currently use the first returned membership as their selected workspace.
- The repository is still local-development-first and is not connected to a hosted Supabase project.
- The smallest safe next task is the Milestone 3 location and entrance foundation.

## Security boundaries

- Passwords are handled only by the official Supabase Auth client and are not stored or logged by VisitFlow.
- Flutter accepts only the public Supabase URL and public publishable key.
- Service-role keys, database passwords, and server secrets remain prohibited from client builds.
- Signed-out users cannot access protected Flutter routes when Supabase is configured.
- Authenticated users cannot enter `/app/*` until an active organization membership is resolved.
- Organization membership queries filter by both active status and the authenticated user ID.
- Client-side route guards never replace PostgreSQL RLS or backend authorization.
- Flutter never inserts organization, membership, or audit rows directly.
- Organization creation remains limited to the reviewed `public.create_organization` function.
- Organization, owner membership, and audit creation remain one transaction.
- Every introduced tenant table remains protected by RLS and active-membership checks.
- Preview mode is visibly separate from authenticated tenant access and contains no real organization or visitor data.

## Intentionally deferred

- Linking and deploying to a hosted Supabase project
- Production authentication policy and email-confirmation decision
- Password recovery and social sign-in
- Explicit organization switching for accounts with multiple memberships
- Membership invitations and role-management functions
- Locations, entrances, departments, and employees
- Visitors, visits, approvals, and invitations
- Public entrance-token validation
- QR pass generation and verification
- Notifications, reports, billing, and offline synchronization

## Known limitations

- Authentication and onboarding require public Supabase configuration supplied through Dart defines.
- Physical-device local testing requires USB port forwarding or network access to the development computer.
- Local Supabase currently disables email confirmation for development.
- No remote Supabase project is linked.
- Multiple-organization accounts automatically enter the first active membership returned; there is no switcher yet.
- Password recovery is not implemented.
- The dashboard metrics and visitor, scan, and invitation pages still contain placeholders rather than operational tenant data.
- Locations and entrances do not exist yet, so visitor registration cannot begin safely.

## Verification state

Final Flutter GitHub Actions run `29074998455` completed successfully for organization-onboarding head commit `d874005457e37ec6caab18691b1846ad8791d079` before pull request #9 was squash-merged.

Final Supabase GitHub Actions run `29074998467` completed successfully for the same head commit.

Verified Flutter steps:

1. Read-only GitHub Actions permissions
2. Flutter 3.44.0 setup
3. Native Android and iOS scaffold generation
4. Dependency installation
5. Strict Dart formatting verification
6. Flutter static analysis
7. Organization access controller tests
8. Organization validator tests
9. Authentication and membership route guards
10. Onboarding-to-dashboard widget flow
11. Existing preview-shell regression test
12. Android debug APK build
13. Debug APK artifact upload

Verified Supabase steps:

1. Supabase CLI 2.84.2 setup
2. Local Docker stack startup
3. Clean database rebuild from migrations
4. Database schema lint
5. Existing tenant-isolation pgTAP tests
6. Normalized organization data persistence
7. Active owner membership creation
8. Organization audit-event creation
9. Duplicate-slug rejection
10. Transactional rollback verification
11. Clean local stack shutdown

## Next recommended task

Milestone 3A — Location and entrance foundation:

1. Create `feature/location-entrance-foundation` from `main`.
2. Add immutable migrations for organization-owned locations and entrances.
3. Add constrained organization relationships, indexes, grants, and RLS policies.
4. Define owner/admin management permissions and guard/receptionist read scope.
5. Add transactional or tightly constrained create/update operations where direct writes would be unsafe.
6. Add pgTAP cross-tenant and role-permission tests.
7. Add Flutter location and entrance domain/repository/controller foundations.
8. Add a focused owner/admin management screen without starting entrance QR generation.
9. Keep departments, employees, visitor registration, and QR tokens in later focused branches.
10. Merge only after Supabase and Flutter CI pass.

## Session handover rule

At the beginning of the next session:

1. Read `docs/VISION.md`.
2. Read `docs/ARCHITECTURE.md`, `docs/FLUTTER_ARCHITECTURE.md`, `docs/DATABASE_SCHEMA.md`, `docs/SECURITY.md`, `docs/API.md`, `docs/DEVELOPMENT_ROADMAP.md`, and this file.
3. Confirm `main` includes merge commit `53f15b64e23df6bf309081bfa4371d244ae5b4e9` or a later verified commit.
4. Do not edit the verified initial migration; create a new migration for every schema or policy change.
5. Reuse the existing authentication and organization gateway/controller boundaries.
6. Preserve explicit current-user membership filtering in addition to RLS.
7. Do not begin visitor registration or entrance QR generation before locations and entrances are verified.
