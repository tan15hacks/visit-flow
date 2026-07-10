# VisitFlow Current Status

## Current milestone

Milestone 2A completed — Supabase tenant foundation

## Current branch

`main`

## Latest merged pull request

Pull request #4 — `feat: establish Supabase tenant foundation`

## Latest main commit

`711447e7c280f428ee6cfb561650793e0061b492`

## Completed

- Milestone 0 product and architecture documentation merged
- Milestone 1A Flutter staff foundation merged and reviewed on Android
- Milestone 1B visitor web foundation merged
- Milestone 2A Supabase tenant foundation merged
- Local Supabase configuration added
- Safe local seed placeholder added
- Initial immutable tenant-foundation migration added
- Membership role and status enums added
- Organizations table added
- Organization memberships table added
- Organization audit-log table added
- Updated-at triggers added
- Security-definer active-membership helper added
- Security-definer organization-role helper added
- Row Level Security enabled for all introduced tenant tables
- Anonymous access revoked
- Authenticated direct organization and membership writes revoked
- Transactional `create_organization` function added
- Organization creation now produces an active owner membership and audit event atomically
- pgTAP tenant-isolation test suite added
- Supabase CI workflow added
- Supabase local-development and migration rules documented
- Supabase and transactional-onboarding architecture decisions recorded
- Local Supabase stack started successfully in GitHub Actions
- Database rebuilt successfully from a clean migration state
- Database lint completed successfully
- All pgTAP tenant-isolation tests passed

## Current state

- The repository is on a verified, merged database foundation.
- No active feature pull request is open for the next milestone yet.
- The smallest safe next task is the Flutter authentication foundation.

## Security boundaries

- Every introduced tenant-owned table has RLS enabled.
- Tenant access depends on an active organization membership.
- Organization owners and admins may read membership and audit information; employees may read only their own membership.
- Suspended memberships lose organization access immediately.
- Anonymous clients cannot read tenant data or call organization creation.
- Authenticated clients cannot directly insert organizations, memberships, or audit events.
- Organization creation is limited to a reviewed security-definer function.
- The service-role key, database password, and private secrets are not committed or bundled into client applications.

## Intentionally deferred

- Linking a hosted Supabase project
- Production database deployment
- Flutter authentication screens and session guards
- Organization onboarding UI
- Membership invitations and role-management functions
- Locations, entrances, departments, and employees
- Visitors, visits, approvals, and invitations
- Public entrance-token validation
- QR pass generation and verification
- Notifications, reports, and offline synchronization

## Known limitations

- The migration currently covers only organizations, memberships, and organization-creation audit events.
- Organization profile updates and membership changes have no client-facing mutation functions yet.
- Local Supabase development requires Docker.
- Email confirmation is disabled in local configuration to simplify development; production auth policy remains undecided.
- No remote Supabase project is linked.
- No application currently calls `create_organization`.

## Verification state

Final head-level GitHub Actions run `29072014133` completed successfully for commit `e16c839e38fbe40c97f8f5366b13bcb15b0a38aa` before pull request #4 was squash-merged.

Verified steps:

1. Supabase CLI 2.84.2 setup
2. Local Supabase Docker stack startup
3. Clean database reset from migrations
4. Database lint at warning level
5. pgTAP database tests
6. Cross-tenant read isolation
7. Employee least privilege
8. Suspended-membership access revocation
9. Transactional organization-owner-audit creation
10. Clean local stack shutdown

## Next recommended task

Milestone 2B — Flutter authentication foundation:

1. Create `feature/flutter-authentication` from `main`.
2. Add sign-in and sign-up screens using Supabase Auth.
3. Add session restoration and sign-out.
4. Add GoRouter authentication guards.
5. Keep organization onboarding UI out of this branch.
6. Add unit/widget tests and run Flutter CI.
7. Auto-merge only after formatting, analysis, tests, and Android build pass.

## Session handover rule

At the beginning of the next session:

1. Read `docs/VISION.md`.
2. Read `docs/ARCHITECTURE.md`, `docs/FLUTTER_ARCHITECTURE.md`, `docs/DATABASE_SCHEMA.md`, `docs/SECURITY.md`, `docs/API.md`, and this file.
3. Confirm `main` includes merge commit `711447e7c280f428ee6cfb561650793e0061b492` or a later verified commit.
4. Do not edit the verified initial migration; create a new migration for every future schema or policy change.
5. Do not implement organization onboarding UI until Flutter authentication and session guards are verified.
