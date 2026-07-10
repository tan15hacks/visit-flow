# VisitFlow Routes and Screens

## Flutter staff application

### Public authentication routes

- `/splash`
- `/auth/sign-in`
- `/auth/forgot-password`
- `/auth/reset-password`

### Onboarding routes

- `/onboarding/welcome`
- `/onboarding/organization`
- `/onboarding/location`
- `/onboarding/team`
- `/onboarding/complete`

### Main application shell

Primary destinations:

- `/app/dashboard`
- `/app/visitors`
- `/app/scan`
- `/app/invitations`
- `/app/more`

Phones should use bottom navigation. Tablets may use a navigation rail and split detail views.

### Dashboard

- Current visitor count
- Pending approval count
- Expected visitors today
- Overdue check-outs
- Recent activity
- Quick actions for registration, scanning, and check-out

### Visitors

- `/app/visitors`
- `/app/visitors/current`
- `/app/visitors/expected`
- `/app/visitors/pending`
- `/app/visitors/history`
- `/app/visitors/:visitId`
- `/app/visitors/register`

Visitor detail should show only role-authorized information and operational actions valid for the current state.

### Scan

- `/app/scan`
- `/app/scan/result`

The scanner verifies invitation or pass tokens through the backend before offering check-in or check-out actions.

### Invitations

- `/app/invitations`
- `/app/invitations/new`
- `/app/invitations/:invitationId`
- `/app/invitations/:invitationId/edit`

### Approvals

- `/app/approvals`
- `/app/approvals/:visitId`

Approvals may also appear as dashboard cards and deep links from notifications.

### Organization administration

- `/app/more/organization`
- `/app/more/locations`
- `/app/more/locations/:locationId`
- `/app/more/entrances`
- `/app/more/departments`
- `/app/more/employees`
- `/app/more/employees/:employeeId`
- `/app/more/roles`

### Reports and audit

- `/app/more/reports`
- `/app/more/reports/visits`
- `/app/more/reports/current`
- `/app/more/audit`

### Settings

- `/app/more/settings`
- `/app/more/settings/profile`
- `/app/more/settings/notifications`
- `/app/more/settings/privacy`
- `/app/more/settings/retention`
- `/app/more/settings/security`

## Visitor web portal

Public routes must be token-scoped and expose minimal information.

- `/e/:entranceToken` — entrance registration
- `/invite/:invitationToken` — invitation confirmation
- `/pass/:passToken` — digital visitor pass
- `/visit/:token/cancel` — cancellation when allowed
- `/visit/:token/checkout` — self-check-out when allowed
- `/privacy/:organizationSlug` — active privacy notice

## Screen-state requirements

Every data-driven screen must define:

- Loading state
- Empty state
- Success state
- Validation state
- Recoverable failure state
- Authorization-denied state
- Offline or stale-data state where relevant

## Deep links

Potential deep links:

- Approval request
- Visitor arrival
- Invitation detail
- Overdue visitor

Deep links must pass route guards and backend permission checks after opening.

## Access rules

- Unauthenticated staff routes redirect to sign-in.
- Authenticated users without an organization enter onboarding.
- Suspended members see an access-disabled screen.
- Employee-only users cannot open administration screens.
- Guard/reception roles are restricted to assigned locations.
- Visitor web tokens are verified before page data is returned.

## Navigation principles

- Scan remains one tap from the main shell.
- Current visitors and pending approvals are visible from the dashboard.
- Destructive actions require confirmation.
- Back navigation must not repeat check-in or approval submissions.
- Screens should avoid exposing sensitive visitor data in notification previews or recent-app snapshots without a documented requirement.
