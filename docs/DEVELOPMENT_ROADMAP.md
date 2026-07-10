# VisitFlow Development Roadmap

## Delivery principle

Complete one verified milestone before beginning the next. Each milestone uses focused branches, reviewed migrations, documented decisions, and a known-good commit or tag.

## Milestone 0 — Product and architecture

Goals:

- Product vision and MVP boundaries
- System and Flutter architecture
- Logical database schema
- Security and privacy model
- Roles and routes
- API boundaries
- Offline and testing strategies
- Initial roadmap and decisions

Exit criteria:

- Required documentation exists
- No unresolved contradiction between product, architecture, schema, and security
- Foundation pull request reviewed and merged

## Milestone 1 — Flutter and repository foundation

Goals:

- Initialize Flutter application under `apps/staff_mobile`
- Initialize visitor web portal under `apps/visitor_web`
- Initialize Supabase project structure
- Add Flutter linting and analysis configuration
- Configure Riverpod and GoRouter
- Add Material 3 theme and reusable design tokens
- Add environment templates without secrets
- Add GitHub Actions foundation

Exit criteria:

- Flutter app starts on Android
- Web portal builds locally
- CI checks pass
- No production credentials committed

## Milestone 2 — Authentication and organizations

Goals:

- Staff sign-in and password recovery
- Session handling
- Organization onboarding
- Transactional organization and owner membership creation
- Protected routes
- Initial RLS membership policies

Exit criteria:

- Authenticated owner can create an organization
- Cross-organization access tests pass
- Logout and suspended membership behavior verified

## Milestone 3 — Locations and employees

Goals:

- Locations
- Entrances
- Departments
- Employee directory
- Membership invitations and role assignment
- Location scope

Exit criteria:

- Owner/admin can configure a location and entrance
- Employee and guard permissions are enforced

## Milestone 4 — Visitor registration

Goals:

- Entrance QR generation
- Public visitor registration context
- Mobile web form
- Privacy notice and consent versioning
- Visitor and visit creation
- Host or department selection

Exit criteria:

- Visitor can submit a valid request without installing an app
- Public endpoint cannot enumerate organization data

## Milestone 5 — Approval flow

Goals:

- Pending approval queue
- Host notification
- Approval and rejection
- Decision notes and status event
- Expiration and cancellation behavior

Exit criteria:

- Only permitted host/admin actions succeed
- Invalid state transitions fail

## Milestone 6 — QR check-in and check-out

Goals:

- Secure invitation/pass token generation
- Flutter scanner
- Server-side pass verification
- Check-in and check-out
- Current visitor list
- Overdue check-out detection

Exit criteria:

- Expired, revoked, malformed, and replayed tokens fail
- Full visit lifecycle works on a real Android device

## Milestone 7 — Invitations

Goals:

- Employee-created invitations
- Confirmation web flow
- Revocation and expiry
- Visitor digital pass
- Arrival notification

Exit criteria:

- Invitation restrictions and use count are enforced

## Milestone 8 — Reports and audit

Goals:

- Search and filters
- Dashboard metrics
- CSV export
- Audit history
- Export authorization and logging

Exit criteria:

- Reports match source records
- Unauthorized exports fail

## Milestone 9 — Limited offline operations

Goals:

- Local operational cache
- Check-in/check-out queue
- Idempotent synchronization
- Conflict display
- Cache-clearing rules

Exit criteria:

- Required offline test scenarios pass
- UI distinguishes pending and confirmed states

## Milestone 10 — Launch preparation

Goals:

- Privacy and terms documents
- Retention and deletion workflows
- Production environments
- Error monitoring and log redaction
- Backup and recovery documentation
- Security review
- Performance and accessibility review
- Play Store preparation
- Pilot onboarding materials

Exit criteria:

- Pilot organization can operate the complete workflow
- Critical security and tenant tests pass
- Production rollback process documented

## Post-MVP candidates

Prioritized only after usage evidence:

- Emergency roll call
- Delivery and contractor forms
- Incident reporting
- Badge printing
- Kiosk mode
- Multiple advanced location scopes
- Calendar integration
- API and webhooks
- Optional access-control integrations

## Branch examples

- `docs/project-foundation`
- `feature/flutter-foundation`
- `feature/authentication`
- `feature/organization-onboarding`
- `feature/employee-directory`
- `feature/visitor-registration`
- `feature/host-approval`
- `feature/qr-check-in`
- `feature/offline-queue`

## Version checkpoints

Suggested tags after verified milestones:

- `v0.1.0-foundation`
- `v0.2.0-auth-organizations`
- `v0.3.0-visitor-registration`
- `v0.4.0-check-in`
- `v0.5.0-mvp-beta`
