# VisitFlow System Architecture

## Status

Proposed and locked for Milestone 0. Application code has not yet been initialized.

## System overview

VisitFlow will use a small monorepo containing:

```text
visit-flow/
  apps/
    staff_mobile/      # Flutter operational application
    visitor_web/       # Next.js visitor-facing portal
  packages/            # Optional shared contracts or tooling added only when justified
  supabase/
    migrations/
    functions/
    seed.sql
    config.toml
  docs/
  .github/workflows/
```

## Main components

### Flutter staff application

Used by owners, administrators, guards, receptionists, and employees.

Responsibilities:

- Authentication and organization context
- Organization setup
- Visitor and visit management
- Approval actions
- QR scanning
- Check-in and check-out
- Current visitor operations
- Reporting and settings
- Limited offline queue

### Visitor web portal

Used by visitors without requiring installation.

Responsibilities:

- Entrance QR registration
- Invitation confirmation
- Privacy consent
- Digital pass display
- Visit cancellation
- Optional self-check-out

The portal must not expose internal staff functionality or broad organization data.

### Supabase backend

Responsibilities:

- Staff authentication
- PostgreSQL multi-tenant data model
- Row Level Security
- Private object storage
- Controlled Edge Functions for privileged workflows
- Selective Realtime subscriptions
- Database migrations and audit records

## Architectural principles

1. GitHub is the source of truth.
2. Database authorization is mandatory; UI filtering is not security.
3. Every tenant-owned record is scoped to an organization.
4. Privileged state transitions are centralized and validated.
5. QR payloads contain opaque tokens, never raw visitor data.
6. Business logic is kept outside Flutter widgets and Next.js page components.
7. Offline behavior is explicit and limited rather than implied.
8. Dependencies are added only after documented review.
9. Features are implemented one milestone and one branch at a time.
10. Documentation changes accompany architectural changes.

## Request and data flow

### Staff workflow

```text
Flutter UI
  -> presentation controller/provider
  -> domain use case or repository contract
  -> repository implementation
  -> Supabase API / Edge Function / local cache
  -> PostgreSQL with RLS
```

### Public visitor workflow

```text
Visitor browser
  -> Next.js route or server action
  -> validated public endpoint / Edge Function
  -> limited database function
  -> PostgreSQL
```

Public flows should use narrowly scoped endpoints and should not receive general database access.

## Multi-tenancy

Organization membership determines tenant access. A staff user may belong to one or more organizations in the future, but the MVP may initially support one active organization at a time.

Tenant boundaries are enforced through:

- `organization_id` on tenant-owned records
- Foreign keys preventing mismatched tenant relationships
- RLS policies based on authenticated membership
- Role checks for sensitive operations
- Security-definer functions only when necessary and carefully constrained
- Tests proving cross-organization reads and writes fail

## Authorization model

Authorization is layered:

1. Authentication confirms user identity.
2. Membership confirms organization access.
3. Role and location scope confirm permission.
4. Domain rules confirm the requested state transition is valid.
5. Audit logging records security-sensitive actions.

## State transitions

Visit state changes should be performed through controlled repository methods or database functions rather than arbitrary client updates.

Examples:

- `awaiting_approval -> approved`
- `approved -> checked_in`
- `checked_in -> checked_out`
- `invited -> cancelled`

Invalid or replayed transitions must fail safely.

## Realtime use

Realtime may be used for:

- Pending approvals
- Current visitor list
- Check-in and check-out changes

It should not be enabled indiscriminately for reports, settings, or large historical datasets.

## Storage

The MVP should avoid unnecessary visitor document storage. Optional visitor photos, organization logos, and future incident attachments must use private storage buckets with RLS-backed access or short-lived signed URLs.

## Error handling

Applications must distinguish:

- Validation errors
- Authentication failures
- Authorization failures
- Connectivity failures
- Conflicts or stale data
- Backend failures
- Unsupported offline actions

User-facing messages should be clear without exposing stack traces, SQL details, tokens, or sensitive identifiers.

## Observability

Before production, add:

- Structured client error reporting
- Edge Function logs without sensitive payloads
- Database audit events for critical actions
- CI status checks
- Production health and deployment monitoring

## Environment strategy

Use separate configurations for:

- Local development
- Staging
- Production

No production secret may be committed. Flutter may receive only public client configuration. Service-role credentials remain in protected server environments.

## Deployment direction

- Flutter Android builds through local tooling and later CI release workflows
- Visitor web portal on Vercel or an equivalent platform
- Supabase migrations applied through reviewed deployment steps
- Production changes promoted from verified branches and pull requests

## Change control

Any change to framework, state management, backend provider, tenant model, routing approach, or offline database requires an entry in `DECISIONS.md` before implementation.
