# VisitFlow API and Backend Operations

## Purpose

This document defines backend operation boundaries. Exact endpoint names may change during implementation, but privileged workflows must remain server-validated and narrowly scoped.

## Access categories

### Authenticated staff operations

Called by the Flutter app with a valid Supabase session and protected by RLS or Edge Functions.

### Public token-scoped operations

Called by the visitor web portal. These operations validate an opaque entrance, invitation, or pass token and return only the minimum necessary data.

### Administrative operations

Protected operations for owner or administrator roles. Service-role credentials remain server-side.

## Proposed authenticated operations

### Organization

- `create_organization(name, industry, timezone)`
- `get_active_organization()`
- `update_organization_settings(...)`
- `list_locations()`
- `create_location(...)`
- `create_entrance(...)`

Creating an organization and owner membership must be transactional.

### Employees and memberships

- `list_employees(filters)`
- `invite_employee(email, role, location_scope)`
- `update_member_role(member_id, role)`
- `suspend_member(member_id)`
- `remove_member(member_id)`

### Visits

- `list_visits(filters, cursor)`
- `get_visit(visit_id)`
- `create_staff_assisted_visit(payload)`
- `approve_visit(visit_id, notes)`
- `reject_visit(visit_id, notes)`
- `check_in_visit(visit_id, entrance_id, client_operation_id)`
- `check_out_visit(visit_id, entrance_id, client_operation_id)`
- `cancel_visit(visit_id, reason)`

All state-changing operations validate organization, role, location, current status, and idempotency where applicable.

### Invitations

- `create_invitation(payload)`
- `revoke_invitation(invitation_id)`
- `list_invitations(filters, cursor)`

Raw invitation tokens should be returned only at creation and stored as hashes where possible.

### Reports

- `get_dashboard_summary(location_id, date)`
- `export_visit_csv(filters)`

Exports must enforce the same permissions as interactive records and generate an audit event.

## Proposed public operations

### Entrance registration context

`resolve_entrance_token(token)` returns only:

- Organization display name and logo
- Location and entrance display names
- Configured visitor fields
- Host-selection options allowed by policy
- Active privacy notice and consent version

It must not expose internal employee details, broad directories, or operational records.

### Submit walk-in registration

`submit_walk_in_registration(token, payload)`:

- Validates token and rate limits
- Validates configured fields
- Records consent
- Creates visitor and visit within one organization
- Returns a limited confirmation token or status

### Resolve invitation

`resolve_invitation_token(token)` returns limited visit details required for confirmation.

### Confirm invitation

`confirm_invitation(token, visitor_payload, consent)` validates expiration, revocation, location, and use limits.

### Resolve digital pass

`resolve_pass_token(token)` returns only the visitor-facing pass state and display details. It must not reveal internal notes or authorization data.

### Visitor cancellation or self-check-out

These operations are permitted only when organization policy and current visit state allow them.

## Response conventions

Successful responses should use typed payloads. Failures should map to stable categories:

- validation_error
- authentication_required
- permission_denied
- not_found
- token_invalid
- token_expired
- token_revoked
- invalid_state_transition
- conflict
- rate_limited
- offline_not_supported
- internal_error

Public errors must avoid confirming the existence of unrelated records.

## Pagination

Historical lists use cursor-based pagination where practical. Clients must not request unrestricted full organization history.

## Idempotency

Check-in, check-out, and offline synchronization requests include a client operation identifier. Repeated delivery of the same operation must return the original outcome rather than duplicate state changes.

## Validation

- Flutter and web clients validate for user experience.
- Backend operations validate again.
- Database constraints remain the final integrity boundary.

## Rate limiting and abuse prevention

Public registration, invitation resolution, pass verification, and authentication-sensitive functions require rate limits. Detailed values will be set after usage testing.

## Versioning

The MVP may use internal versioned function names or route prefixes. Breaking API changes require documentation, migration notes, and coordinated client updates.

## Logging

Operations should attach a request identifier and record security-relevant actions without logging passwords, raw tokens, or complete personal payloads.
