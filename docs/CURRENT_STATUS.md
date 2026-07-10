# VisitFlow Current Status

## Current milestone

Milestone 2A — Supabase tenant foundation

## Current branch

`feature/supabase-foundation`

## Pull request

Pending — database foundation pull request will be opened after the first CI run is available.

## Base

`main` after merged visitor web foundation pull request #3.

## Latest implementation commit

`e00e68e13f83328b0035bc5ebbf1806635515bab`

## Completed

- Milestone 0 product and architecture documentation merged
- Milestone 1A Flutter staff foundation merged and reviewed on Android
- Milestone 1B visitor web foundation merged
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

## In progress

- Starting the local Supabase stack in GitHub Actions
- Rebuilding the database from a clean state
- Database lint verification
- pgTAP tenant-isolation verification
- Pull request creation and automatic merge after successful checks

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

Verification is pending GitHub Actions.

Required checks:

1. Supabase CLI 2.84.2 setup
2. Local Supabase stack startup
3. Clean database reset from migrations
4. Database lint at warning level
5. pgTAP database tests
6. Cross-tenant read isolation
7. Employee least privilege
8. Suspended-membership access revocation
9. Transactional organization-owner-audit creation

## Next recommended task

After this milestone passes CI and is merged:

1. Create the Flutter authentication foundation branch.
2. Add sign-in, sign-up, session restoration, and sign-out using Supabase Auth.
3. Add route guards without implementing organization onboarding UI yet.
4. Verify authentication locally and in Flutter CI.
5. Add organization onboarding UI in a separate focused branch.

## Session handover rule

At the beginning of the next session:

1. Read `docs/VISION.md`.
2. Read `docs/ARCHITECTURE.md`, `docs/DATABASE_SCHEMA.md`, `docs/SECURITY.md`, `docs/API.md`, and this file.
3. Confirm the active branch, pull request, and latest Supabase workflow result.
4. Inspect exact migration or pgTAP failures before changing SQL.
5. Do not start Flutter authentication until the tenant foundation is verified and merged.
