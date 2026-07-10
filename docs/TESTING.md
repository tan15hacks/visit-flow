# VisitFlow Testing Strategy

## Quality rule

A feature is not complete because code was written. It is complete only when its behavior, authorization, failure states, documentation, and relevant builds have been verified.

## Flutter verification commands

Run where applicable from `apps/staff_mobile`:

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
flutter test integration_test
flutter build apk --debug
```

Do not claim these passed unless they were actually executed.

## Visitor web verification

Expected commands after initialization:

```bash
npm run lint
npm run typecheck
npm run test
npm run build
```

## Test layers

### Unit tests

Use for:

- Validation
- Value objects
- Permission decisions represented in domain code
- Visit-state transition rules
- QR expiration calculations
- Offline queue ordering and retry logic

### Repository and data tests

Use for:

- DTO mapping
- Supabase query handling
- Local cache behavior
- Idempotency handling
- Error translation

### Provider/controller tests

Use for:

- Loading, success, empty, failure, and refresh states
- Duplicate submission prevention
- Route-triggering state changes
- Offline queued state

### Widget tests

Use for:

- Sign-in form
- Dashboard critical metrics
- Visitor list states
- Approval card
- Scanner result state
- Check-in and check-out confirmations
- Permission-denied and offline indicators

### Integration tests

Prioritize:

1. Staff sign-in
2. Organization onboarding
3. Add employee
4. Visitor walk-in registration
5. Host approval
6. QR pass verification
7. Check-in
8. Current visitor display
9. Check-out
10. History and export initiation

## Database and RLS testing

Use local or isolated test environments to prove:

- Organization A cannot read Organization B records
- Organization A cannot write relationships using Organization B identifiers
- Employees see only permitted hosted visits and invitations
- Guards are restricted to assigned locations
- Suspended members lose access
- Public routes cannot list tenant data
- Private storage policies reject unauthorized access

RLS tests are release-blocking for tenant-owned features.

## Security cases

- Expired token
- Revoked token
- Malformed token
- Replayed single-use token
- Token for wrong location
- Invalid visit state transition
- Modified client role value
- Unauthorized report export
- Excessive public registration requests
- Sensitive data absent from logs

## Offline cases

- Successful queued check-in
- Successful queued check-out
- Duplicate retry remains idempotent
- Stale state produces visible conflict
- Membership revoked before synchronization
- App restart preserves pending queue
- Logout clears sensitive cache according to policy

## Manual device testing

Test at minimum on:

- A low-end or older Android device
- A current Android device
- Phone portrait and landscape
- A tablet or tablet-sized emulator
- Slow and interrupted network conditions
- Camera permission granted and denied
- Notification permission granted and denied

## Regression checklist

Before merging a feature:

- Existing routes still open
- Authentication state remains stable
- Organization isolation tests pass
- Navigation does not duplicate submissions
- Loading and empty states remain usable
- No unrelated dependency or migration changes
- Documentation and `CURRENT_STATUS.md` are updated

## CI direction

Pull requests should eventually run:

- Flutter formatting
- Flutter analysis
- Flutter tests
- Web lint and typecheck
- Web tests and build
- Migration checks
- Secret scanning
- Dependency review where available

## Test data

Seed data should use fictional names and organizations. Never commit real visitor information, personal phone numbers, credentials, or production exports.

## Bug reports

A useful bug report includes:

- Branch and commit
- Device or browser
- Command or workflow
- Expected result
- Actual result
- Full sanitized error output
- Reproduction steps
- Screenshots without unnecessary personal data
