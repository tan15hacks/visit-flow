# VisitFlow Product Specification

## Product summary

VisitFlow is a multi-tenant visitor management SaaS with a Flutter staff application and a lightweight visitor-facing web portal. It replaces paper logbooks while preserving simple front-desk and gate operations.

## Primary actors

- Organization owner
- Administrator
- Guard or receptionist
- Employee or host
- Visitor

## Core workflows

### Walk-in registration

1. Visitor scans an entrance QR code or receives guard assistance.
2. Visitor enters required information and accepts the privacy notice.
3. Visitor selects a host or department.
4. A visit request is created.
5. Host approval is requested when required.
6. Approved visitor receives a secure pass.
7. Guard verifies the pass and checks the visitor in.
8. Host receives arrival notification.
9. Guard or authorized staff checks the visitor out.

### Pre-registered invitation

1. Employee creates an invitation.
2. System generates an opaque, expiring token.
3. Visitor confirms details and consent through the web portal.
4. Guard scans and verifies the pass at the assigned location and time.
5. Visit is checked in and later checked out.

### Guard-assisted registration

1. Guard creates the visitor and visit record in the Flutter app.
2. Required approval is collected.
3. Guard records badge and entry details.
4. Visit proceeds through standard check-in and check-out states.

## MVP functional requirements

### Authentication and organizations

- Email/password staff authentication
- Secure session persistence
- Organization creation
- Organization membership and role assignment
- Protected application routes
- Organization data isolation

### Organization setup

- Organization profile
- Locations
- Entrances
- Departments
- Employee directory
- Approval settings
- Visitor form field settings

### Visitor registration

- Public mobile web form
- Organization and entrance-specific QR link
- Configurable required fields
- Privacy notice and consent timestamp
- Host or department selection
- Walk-in and pre-registered visit types

### Approvals

- Pending approval queue
- Approve or reject action
- Decision timestamp and actor
- Optional notes
- Expired and cancelled requests

### Invitations and passes

- One-time invitations
- Date, time, location, and host restrictions
- Opaque token rather than personal information in QR content
- Pass revocation and expiration
- Server-side verification

### Check-in and check-out

- Flutter QR scanner
- Manual code lookup fallback
- Verification before state transition
- Check-in and check-out timestamps
- Processing staff and entrance recorded
- Current visitor list
- Overdue visitor status

### Dashboard and reporting

- Currently inside
- Pending approval
- Expected today
- Overdue check-outs
- Visit history with filters
- CSV export
- Audit records for critical operations

### Notifications

- Push notifications for approval requests and arrivals
- Local operational notifications where appropriate
- No SMS in MVP

### Limited offline operation

- Cache current and expected visitor data
- Queue check-in and check-out operations
- Display synchronization state
- Resolve duplicate or stale operations on reconnect

## Core data collected

Default visitor data should be minimized:

- Full name
- Mobile number or email when required
- Company or affiliation
- Host or department
- Purpose
- Visit date and expected time
- Optional vehicle plate
- Optional photo
- Optional masked ID reference
- Consent record

Full government identification numbers, birth dates, and complete home addresses are not default fields.

## Visit states

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

State transitions must be validated by backend rules rather than trusted from the client.

## Non-functional requirements

- Android-first Flutter application
- Future iOS compatibility
- Responsive phone and tablet layouts
- Multi-tenant isolation through PostgreSQL RLS
- Low-end Android performance
- Clear failure and offline states
- Pagination for large records
- Structured audit logging
- No secrets stored in source control
- Accessibility-conscious controls and contrast

## MVP exclusions

See `VISION.md`. In particular, the MVP excludes AI, facial recognition, ID OCR, SMS, access-control hardware, employee attendance, payroll, and enterprise SSO.

## Acceptance outcome

A pilot organization must be able to complete the full visitor lifecycle—from registration to check-out—and retrieve authorized records without using a paper logbook or accessing another organization's data.
