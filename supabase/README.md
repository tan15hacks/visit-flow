# VisitFlow Supabase

This directory will contain local Supabase configuration, SQL migrations, seed data, and Edge Functions.

No production database migration is included in the Flutter foundation pull request.

## Security requirements

- Every tenant-owned table must use Row Level Security.
- Organization membership and role checks must be enforced in PostgreSQL policies or controlled server functions.
- Public visitor endpoints must be token-scoped and return minimal data.
- Service-role and secret keys must never be committed or bundled into Flutter or browser code.
- QR tokens must be opaque, time-limited, revocable, and stored as hashes where appropriate.

## Planned structure

```text
supabase/
  config.toml
  migrations/
  functions/
  seed.sql
```

The actual local project will be initialized in the backend foundation task before authentication and organization onboarding are implemented.
