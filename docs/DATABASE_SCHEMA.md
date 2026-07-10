# VisitFlow Database Schema

## Status

Logical MVP schema. Exact SQL, indexes, constraints, and RLS policies will be implemented and reviewed through versioned Supabase migrations.

## General rules

- Primary keys use UUIDs.
- Tenant-owned tables include `organization_id` directly unless a safely enforced parent relationship is preferable.
- Timestamps use timezone-aware values.
- Soft deletion is used only where recovery or audit requirements justify it.
- Sensitive state transitions should use constrained database functions or narrowly scoped repositories.
- Foreign keys must prevent cross-organization relationship mismatches.

## Enumerations

### Membership role

- owner
- admin
- guard
- receptionist
- employee
- auditor

The MVP may combine guard and receptionist permissions while retaining distinct labels.

### Membership status

- invited
- active
- suspended
- removed

### Visit status

- draft
- invited
- awaiting_approval
- approved
- rejected
- checked_in
- checked_out
- cancelled
- expired
- overdue

### Approval decision

- pending
- approved
- rejected
- more_information_required

### Visitor type

- walk_in
- guest
- contractor
- delivery
- interview
- event
- temporary_worker
- other

## Core tables

### organizations

- `id`
- `name`
- `slug`
- `industry`
- `logo_path`
- `timezone`
- `visitor_retention_days`
- `photo_retention_days`
- `created_by`
- `created_at`
- `updated_at`

### organization_members

- `id`
- `organization_id`
- `user_id`
- `role`
- `status`
- `default_location_id` nullable
- `invited_by` nullable
- `joined_at` nullable
- `created_at`
- `updated_at`

Unique constraint: one membership per user and organization.

### locations

- `id`
- `organization_id`
- `name`
- `address_line` nullable
- `timezone`
- `is_active`
- `created_at`
- `updated_at`

### entrances

- `id`
- `organization_id`
- `location_id`
- `name`
- `registration_token_hash`
- `registration_token_version`
- `is_active`
- `created_at`
- `updated_at`

The entrance QR should resolve an opaque token. Rotating a token must invalidate the previous value according to documented policy.

### departments

- `id`
- `organization_id`
- `location_id` nullable
- `name`
- `is_active`
- `created_at`
- `updated_at`

### employees

Represents the organization-facing employee profile associated with an authenticated account when applicable.

- `id`
- `organization_id`
- `user_id` nullable until invitation accepted
- `department_id` nullable
- `default_location_id` nullable
- `full_name`
- `email`
- `phone` nullable
- `can_receive_visitors`
- `is_active`
- `created_at`
- `updated_at`

### visitors

Represents a visitor identity within one organization. Cross-organization visitor profiles are not shared by default.

- `id`
- `organization_id`
- `full_name`
- `phone` nullable
- `email` nullable
- `company` nullable
- `photo_path` nullable
- `id_type` nullable
- `masked_id_reference` nullable
- `created_at`
- `updated_at`

Do not store full government ID numbers by default.

### visits

- `id`
- `organization_id`
- `location_id`
- `entrance_id` nullable
- `visitor_id`
- `host_employee_id` nullable
- `department_id` nullable
- `visitor_type`
- `purpose`
- `status`
- `scheduled_start` nullable
- `expected_end` nullable
- `approval_required`
- `check_in_at` nullable
- `check_out_at` nullable
- `check_in_entrance_id` nullable
- `check_out_entrance_id` nullable
- `check_in_processed_by` nullable
- `check_out_processed_by` nullable
- `badge_number` nullable
- `vehicle_plate` nullable
- `companion_count`
- `notes` nullable
- `consent_version`
- `consented_at`
- `created_by` nullable for public registration
- `created_at`
- `updated_at`

Indexes should support organization, location, status, scheduled date, host, and check-in/check-out queries.

### approvals

- `id`
- `organization_id`
- `visit_id`
- `requested_from_employee_id`
- `decision`
- `decision_notes` nullable
- `requested_at`
- `decided_at` nullable
- `decided_by_user_id` nullable

A visit may have more than one approval record in future workflows, but the MVP should keep approval rules simple.

### invitations

- `id`
- `organization_id`
- `visit_id`
- `token_hash`
- `expires_at`
- `maximum_uses`
- `use_count`
- `revoked_at` nullable
- `revoked_by` nullable
- `created_by`
- `created_at`

Raw invitation tokens must not be stored after issuance when a hash is sufficient.

### visit_status_events

Append-only event history for operational traceability.

- `id`
- `organization_id`
- `visit_id`
- `from_status` nullable
- `to_status`
- `actor_user_id` nullable
- `source` such as staff_app, visitor_web, system, offline_sync
- `occurred_at`
- `metadata` constrained JSON

### audit_logs

- `id`
- `organization_id`
- `actor_user_id` nullable
- `action`
- `entity_type`
- `entity_id` nullable
- `location_id` nullable
- `request_id` nullable
- `metadata` constrained JSON
- `created_at`

Audit metadata must not contain passwords, access tokens, raw QR tokens, or unnecessary personal data.

## Supporting tables

### visitor_companions

- `id`
- `organization_id`
- `visit_id`
- `full_name`
- `phone` nullable
- `created_at`

### visit_items

- `id`
- `organization_id`
- `visit_id`
- `item_name`
- `quantity`
- `serial_number` nullable
- `entry_condition` nullable
- `exit_condition` nullable
- `created_at`
- `updated_at`

### device_registrations

Used later for push notification delivery and device session management.

- `id`
- `organization_id` nullable
- `user_id`
- `platform`
- `push_token`
- `last_seen_at`
- `revoked_at` nullable

### offline_operations

Server-side receipt table for idempotent synchronization where needed.

- `id`
- `organization_id`
- `client_operation_id`
- `device_id`
- `operation_type`
- `entity_id`
- `received_at`
- `result_status`
- `result_metadata`

Unique constraint: organization and client operation identifier.

## Storage buckets

Potential private buckets:

- `organization-assets`
- `visitor-photos`
- `incident-attachments` in a later milestone

Storage object paths should begin with the organization identifier and policies must verify membership and permission.

## Transactional workflows

The following operations should be transactional or implemented through controlled functions:

- Create organization and owner membership
- Approve or reject a pending visit
- Verify invitation and increment allowed usage
- Check in an approved visit and append status event
- Check out a checked-in visit and append status event
- Revoke invitation
- Apply retention deletion or anonymization

## RLS direction

Every tenant table enables RLS. Policies should rely on reusable membership checks while avoiding recursive or overly broad rules.

Examples of intended behavior:

- Owners and admins can manage organization settings.
- Guards and receptionists can read operational visit data for assigned locations and process allowed transitions.
- Employees can view invitations they created and visits where they are the host.
- Public visitor flows cannot list visitors, employees, or visits broadly.
- Public endpoints return only the minimum data required for the active token.

## Data retention

Retention should eventually distinguish:

- Visitor identity details
- Visit records
- Visitor photos
- Audit logs
- Incident records

Deletion jobs must be documented, reversible only where policy permits, and auditable without retaining deleted personal content.

## Migration rules

- Every schema change uses a new migration.
- Never edit a migration already applied to shared environments.
- Include rollback notes for destructive changes.
- Test migrations from a clean database and from the previous known schema.
- Security policies and grants are versioned with schema changes.
