# VisitFlow Supabase

This directory contains the local Supabase configuration, versioned SQL migrations, seed file, database tests, and future Edge Functions for VisitFlow.

## Current scope

Milestone 2A establishes only the tenant foundation:

- organizations;
- organization memberships;
- audit events for organization creation;
- reusable membership and role checks;
- Row Level Security;
- transactional organization creation;
- pgTAP tenant-isolation tests.

Locations, employees, visitors, invitations, approvals, QR tokens, and visit state transitions are intentionally deferred to later migrations.

## Requirements

- Docker Desktop or another Docker-compatible container runtime
- Supabase CLI 2.84.2 or a reviewed compatible version

The official Supabase local stack runs through Docker. Do not expose the local stack to an untrusted public network.

## Local commands

From the repository root:

```powershell
supabase start
supabase db reset
supabase db lint --level warning
supabase test db
```

Stop the stack when finished:

```powershell
supabase stop --no-backup
```

## CI verification

The database workflow rebuilds the local stack from a clean state, lints the schema, and runs the pgTAP suite. Pull request #4 first passed this workflow in GitHub Actions run `29071873228`.

Future database changes must pass the same workflow from the current branch head before merge.

## Migration rules

- Every schema or policy change uses a new migration.
- Never edit a migration already applied to a shared environment.
- Keep destructive operations out of feature work unless rollback and recovery are documented.
- RLS policies and grants are versioned with the schema.
- CI must rebuild the database from a clean state and pass pgTAP tests before merge.

## Security requirements

- Every tenant-owned table uses Row Level Security.
- Organization membership and role checks are enforced in PostgreSQL policies or controlled functions.
- Client applications never receive the service-role key, database password, or private signing secrets.
- Direct tenant writes are denied unless a reviewed policy or controlled function permits them.
- Public visitor endpoints will be token-scoped and return minimal data.
- QR tokens will be opaque, expiring, revocable, and stored as hashes where appropriate.
- Tests that prove cross-organization reads and writes fail are release-blocking.

## Current structure

```text
supabase/
  config.toml
  migrations/
  tests/database/
  functions/
  seed.sql
```

No remote Supabase project is linked by this milestone. Deployment credentials and production database changes are intentionally excluded.
