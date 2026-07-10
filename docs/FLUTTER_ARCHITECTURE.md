# VisitFlow Flutter Architecture

## Scope

This document governs the Flutter staff application used by organization owners, administrators, guards, receptionists, and employees.

## Platform direction

- Flutter and Dart are permanent for the primary application.
- Android is the first release target.
- iOS compatibility must be preserved.
- Phone and tablet layouts are required.
- The Flutter app is not the visitor registration portal.

## Proposed application location

```text
apps/staff_mobile/
```

## Feature-first structure

```text
lib/
  app/
    app.dart
    bootstrap.dart
    router.dart

  core/
    config/
    constants/
    errors/
    extensions/
    logging/
    network/
    security/
    storage/
    theme/
    utils/
    widgets/

  features/
    authentication/
      data/
      domain/
      presentation/
    onboarding/
      data/
      domain/
      presentation/
    organizations/
      data/
      domain/
      presentation/
    locations/
      data/
      domain/
      presentation/
    employees/
      data/
      domain/
      presentation/
    visitors/
      data/
      domain/
      presentation/
    visits/
      data/
      domain/
      presentation/
    invitations/
      data/
      domain/
      presentation/
    approvals/
      data/
      domain/
      presentation/
    check_in/
      data/
      domain/
      presentation/
    reports/
      data/
      domain/
      presentation/
    settings/
      data/
      domain/
      presentation/

  main.dart
```

Folders should be created only when the feature needs them. Empty ceremonial layers are not required.

## Recommended dependencies

Initial candidates:

- `flutter_riverpod` for dependency injection and state management
- `go_router` for declarative routing and route guards
- `supabase_flutter` for authentication and backend access
- `flutter_secure_storage` for protected local session-related values where needed
- `mobile_scanner` for QR scanning
- `flutter_local_notifications` for local reminders
- Firebase Cloud Messaging for push notifications when notification work begins
- Drift for structured offline queue and cached operational records, subject to an implementation decision
- `freezed` and `json_serializable` only where generated immutable models reduce risk and boilerplate

No package is approved merely because it appears here. Package versions and maintenance status must be checked when Milestone 1 begins.

## Layer responsibilities

### Presentation

May contain:

- Screens and dialogs
- Reusable feature widgets
- Riverpod providers and controllers
- View state
- Form coordination
- Navigation triggers

Must not contain:

- Direct Supabase queries
- Tenant authorization logic
- Complex state transition rules
- Secret handling

### Domain

May contain:

- Entities
- Value objects
- Repository contracts
- Use cases
- Validation rules
- Permission and state-transition abstractions

Domain code should not depend on Flutter widgets or Supabase DTOs.

### Data

May contain:

- Supabase data sources
- Local cache and queue data sources
- DTOs
- Repository implementations
- Mapping and synchronization logic

## Application bootstrap

Bootstrap should:

1. Load environment-specific public configuration.
2. Initialize Flutter bindings.
3. Initialize Supabase.
4. Initialize local storage required by the current milestone.
5. Configure structured logging and error boundaries.
6. Start the Riverpod application scope.

Initialization failures must show a recoverable error experience rather than an endless splash screen.

## Routing

Routes should be centralized and named. Recommended route groups:

```text
/splash
/auth/sign-in
/auth/forgot-password
/onboarding/organization
/app/dashboard
/app/visitors
/app/visitors/:visitId
/app/scan
/app/invitations
/app/more
/app/settings
```

Route guards should react to:

- Authentication state
- Required organization onboarding
- Active organization membership
- Role restrictions

Route guards improve UX but do not replace backend authorization.

## State management

Use Riverpod with explicit states such as:

- initial
- loading
- data
- empty
- failure
- refreshing
- offlineQueued

Avoid provider trees that mix unrelated feature state. Long-lived providers must be justified. Use auto-dispose where appropriate.

## Organization context

The active organization must be represented explicitly. Queries must not infer tenant context from arbitrary cached values alone. Repositories should receive or resolve a validated organization context and the backend must still enforce RLS.

## Forms and validation

- Validate locally for immediate feedback.
- Validate again on the backend.
- Prevent duplicate submissions.
- Preserve user input after recoverable failures.
- Normalize phone numbers and text only through documented rules.
- Never log personal form values in production error reports.

## UI design system

Use Material 3 as a base with shared tokens for:

- Typography
- Spacing
- Radius
- Elevation
- Surface colors
- Status colors
- Icon sizing
- Touch targets

Core reusable components should include:

- Primary and secondary buttons
- Form fields
- Status chips with icon and text
- Loading, empty, and error states
- Confirmation dialogs
- Visitor cards
- Metric cards
- Responsive app shell

Status must not rely on color alone.

## Primary navigation

Recommended destinations:

1. Dashboard
2. Visitors
3. Scan
4. Invitations
5. More

Scan should remain prominent and reachable in one tap from the main shell.

## Responsiveness

- Phones use bottom navigation and stacked layouts.
- Tablets may use navigation rail and split views.
- Forms must support keyboard navigation and landscape operation.
- Avoid fixed widths that break on small devices.

## Performance rules

- Paginate visitor history.
- Avoid loading full-size photos into lists.
- Use thumbnails and caching with limits.
- Avoid network calls from `build()`.
- Minimize broad provider invalidation.
- Measure before introducing manual optimization.
- Avoid decorative blur, particle effects, and heavy animation.

## Offline behavior

Flutter owns the local operational queue. Queued operations must include:

- Operation identifier
- Organization and location identifiers
- Visit identifier
- Requested transition
- Device timestamp
- Last synchronization attempt
- Retry count
- Failure or conflict reason

The UI must distinguish confirmed server state from pending local state.

## Security rules

- Store only public Supabase client configuration in the app.
- Never include service-role credentials.
- Use secure storage for sensitive local tokens when required.
- Do not encode visitor data inside QR codes.
- Do not trust role values supplied by the client.
- Clear sensitive cached views on logout and organization switch.
- Avoid screenshots of sensitive screens only if a documented customer or threat requirement justifies platform restrictions.

## Error handling

Use typed application failures and map them to user-facing messages. Preserve original exceptions for non-sensitive diagnostic reporting without exposing SQL, tokens, or personal information.

## Testing expectations

- Unit tests for validation and state transitions
- Repository tests with mocked or local backend boundaries
- Provider/controller tests
- Widget tests for critical states
- Router guard tests
- Integration tests for sign-in, registration approval, scan, check-in, and check-out

## Architecture change rule

Changes to state management, routing, code generation, offline database, or folder conventions require an entry in `DECISIONS.md` before implementation.
