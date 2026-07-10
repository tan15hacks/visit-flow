# VisitFlow Current Status

## Current milestone

Milestone 2B completed — Flutter authentication foundation

## Current branch

`main`

## Latest merged pull request

Pull request #7 — `feat: add Flutter authentication foundation`

## Latest main commit

`6c3796197ee37ac67fc38ce295e14def62c8901f`

## Completed

- Milestone 0 product and architecture documentation merged
- Milestone 1A Flutter staff foundation merged and reviewed on Android
- Milestone 1B visitor web foundation merged
- Milestone 2A Supabase tenant foundation merged
- Milestone 2B Flutter authentication foundation merged
- Local Supabase configuration and immutable tenant migration added
- Organizations, organization memberships, audit logs, RLS, and transactional organization creation added
- Supabase email/password sign-in and sign-up adapter added
- Authentication domain gateway added to isolate UI from SDK response objects
- Session controller added for restored sessions, auth-state changes, sign-in, sign-up, and sign-out
- Riverpod authentication provider added
- Responsive sign-in and sign-up screens added
- Password and email validation added
- Email-confirmation-required state added
- GoRouter authentication redirects added
- Signed-out users are blocked from `/app/*` routes when Supabase is configured
- Preview mode remains available without backend credentials
- Signed-in account information and sign-out action added to the More screen
- Fake authentication gateway added for tests
- Authentication controller tests passed
- GoRouter redirect and sign-in flow tests passed
- Preview-shell regression test passed
- Strict read-only Flutter CI restored
- Android debug APK built and uploaded successfully
- Physical-device local Supabase instructions documented

## Current state

- The Flutter app has a verified authentication layer but is not linked to a hosted Supabase project.
- Users can sign up, sign in, restore a session, and sign out when valid public Supabase configuration is provided.
- Authenticated users currently enter the existing preview dashboard because organization onboarding and tenant selection are not implemented yet.
- The smallest safe next task is organization onboarding using the existing transactional `create_organization` database function.

## Security boundaries

- Passwords are handled by the official Supabase Auth client and are not stored or logged by VisitFlow.
- Flutter accepts only the public Supabase URL and public publishable key.
- Service-role keys, database passwords, and server secrets remain prohibited from client builds.
- Signed-out users cannot access protected Flutter routes when Supabase is configured.
- Client-side route guards improve navigation but do not replace PostgreSQL RLS or backend authorization.
- Every introduced tenant table remains protected by RLS and active-membership checks.
- Organization creation remains limited to the reviewed `public.create_organization` function.
- Preview mode is visibly separate from an authenticated session and contains no real tenant or visitor data.

## Intentionally deferred

- Linking and deploying to a hosted Supabase project
- Production authentication policy and email-confirmation decision
- Password reset and social sign-in
- Organization onboarding UI
- Organization membership selection for users who belong to multiple organizations
- Membership invitations and role-management functions
- Locations, entrances, departments, and employees
- Visitors, visits, approvals, and invitations
- Public entrance-token validation
- QR pass generation and verification
- Notifications, reports, and offline synchronization

## Known limitations

- The app cannot authenticate without public Supabase configuration supplied through Dart defines.
- Local authentication on a physical phone requires the phone to reach the development computer over the local network; `127.0.0.1` refers to the phone itself.
- The local Supabase configuration currently disables email confirmation for development.
- No remote Supabase project is linked.
- A newly authenticated account has no organization until Milestone 2C is implemented.
- The dashboard, visitors, scan, and invitation pages still contain foundation placeholders rather than tenant data.
- Password recovery is not yet implemented.

## Verification state

Final GitHub Actions run `29073591100` completed successfully for authentication head commit `da0b0c5723458ecad68276f01d5e883e5266b180` before pull request #7 was squash-merged.

Verified steps:

1. Read-only GitHub Actions permissions
2. Flutter 3.44.0 setup
3. Native Android and iOS scaffold generation
4. Dependency installation
5. Strict Dart formatting verification
6. Flutter static analysis
7. Authentication controller tests
8. Restored-session behavior
9. Sign-in and sign-out behavior
10. Email-confirmation-required sign-up behavior
11. GoRouter protected-route redirects
12. Existing preview-shell regression test
13. Android debug APK build
14. Debug APK artifact upload

## Next recommended task

Milestone 2C — Organization onboarding:

1. Create `feature/organization-onboarding` from `main`.
2. Load the authenticated user's active organization memberships.
3. Route users with no organization to a focused onboarding screen.
4. Create an organization through `public.create_organization`; never insert organization or membership rows directly.
5. Validate organization name, slug, and timezone in the UI while keeping the database function authoritative.
6. Refresh memberships after successful creation and enter the organization workspace.
7. Add repository, controller, route, widget, and database integration tests.
8. Keep locations, employee management, and subscription billing outside this branch.

## Session handover rule

At the beginning of the next session:

1. Read `docs/VISION.md`.
2. Read `docs/ARCHITECTURE.md`, `docs/FLUTTER_ARCHITECTURE.md`, `docs/DATABASE_SCHEMA.md`, `docs/SECURITY.md`, `docs/API.md`, and this file.
3. Confirm `main` includes merge commit `6c3796197ee37ac67fc38ce295e14def62c8901f` or a later verified commit.
4. Do not edit the verified initial migration; create a new migration for every future schema or policy change.
5. Use the existing authentication gateway and session controller rather than adding direct Supabase Auth calls in widgets.
6. Use `public.create_organization` for onboarding and preserve tenant isolation.
