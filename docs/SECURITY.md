# VisitFlow Security Model

## Security objective

VisitFlow must protect visitor personal information, organization records, operational access, and tenant boundaries while remaining practical for small organizations and a solo development team.

Security is enforced through architecture, database policy, controlled state transitions, testing, and operational discipline—not through hidden UI elements alone.

## Primary threats

- Cross-organization data access
- Excessive staff permissions
- Modified mobile requests
- Guessed or copied QR links
- Replayed invitation or check-in tokens
- Stolen sessions or devices
- Public file exposure
- Malicious or oversized uploads
- Sensitive data written to logs
- Accidental deletion or destructive migrations
- Compromised administrator credentials
- Offline operation conflicts or replay

## Authentication

- Staff users authenticate through Supabase Authentication.
- Email verification may be required before organization access.
- Session state must be handled by the official client SDK.
- Passwords are never stored or logged by VisitFlow.
- Two-factor authentication should be considered for owners and administrators after the MVP foundation.
- Staff removal or suspension must revoke effective organization access even if a valid authentication session remains.

## Authorization

Every request must pass these checks where applicable:

1. The user is authenticated.
2. The user has an active membership in the target organization.
3. The user's role permits the action.
4. The user's location scope permits the action.
5. The target record belongs to the same organization.
6. The requested state transition is valid.

Authorization must be enforced in PostgreSQL RLS, constrained functions, or protected server endpoints.

## Tenant isolation

- RLS is enabled on every tenant-owned table.
- Tenant filters must not be supplied and trusted solely from the client.
- Relationships must prevent connecting a record from one organization to a parent in another organization.
- Cross-tenant read and write tests are release-blocking.
- Service-role credentials are never included in Flutter or visitor web bundles.

## Role principles

- Owner: organization-level control and subscription authority
- Admin: operational administration without unnecessary billing authority
- Guard/receptionist: limited visitor processing and assigned-location access
- Employee: own invitations and hosted visits
- Auditor: read-only approved reporting and audit access when introduced

Permissions should be explicit and deny by default.

## Visitor data minimization

Default registration should avoid collecting:

- Full government ID numbers
- Birth dates
- Full residential addresses
- Unnecessary identity documents
- Sensitive personal information unrelated to entry

Use masked references such as `****4821` when an organization needs a verification note.

## Consent

Store:

- Consent version
- Consent timestamp
- Relevant organization or entrance context

Changing the privacy notice requires versioning. Consent records must not imply agreement beyond the displayed purpose.

## QR and invitation security

- QR payloads contain opaque, high-entropy tokens or links.
- Raw personal information is never encoded.
- Store token hashes where raw token recovery is unnecessary.
- Verification checks expiration, revocation, organization, location, visit status, and allowed usage count.
- Single-use passes reject replay.
- Token comparison should avoid insecure predictable identifiers.
- Pass screenshots may still be shared, so high-risk sites may require visual identity verification by policy.

## Public visitor endpoints

Public endpoints must:

- Return only the minimum information required for the active entrance or invitation
- Validate and normalize input
- Apply rate limits and abuse controls
- Avoid exposing employee directories beyond configured host selection
- Prevent enumeration of visitors, invitations, or organizations
- Use generic errors when detailed errors would aid attackers

## File and photo handling

The MVP should minimize uploads. When photos or files are supported:

- Use private buckets
- Restrict MIME types and maximum size
- Validate file signatures where possible
- Generate safe storage paths
- Avoid user-controlled executable filenames
- Use short-lived signed URLs or authenticated downloads
- Remove metadata when appropriate
- Define retention and deletion rules
- Consider malware scanning before introducing broader attachment support

## Secrets

Allowed in client builds:

- Public Supabase URL
- Public/publishable Supabase key
- Public analytics or messaging identifiers where designed for client exposure

Never allowed in client builds or Git:

- Supabase service-role key
- Database passwords
- Private signing keys
- Raw webhook secrets
- Production encryption keys
- Administrative API tokens

Use environment-specific secret stores and rotate exposed credentials immediately.

## Local device security

- Use platform-protected storage for sensitive local values.
- Do not store unnecessary visitor data offline.
- Clear organization-sensitive cache on logout and membership removal.
- Limit cached emergency and current-visitor data by time and device role.
- Temporary images must not remain in public media folders by default.
- The app must show when data is pending synchronization.

## Offline operation security

- Every queued operation receives a unique client operation ID.
- Server processing is idempotent.
- Server authorization and state validation occur again on synchronization.
- Client timestamps are recorded but not blindly trusted as authoritative.
- Conflicting or stale operations are rejected or escalated visibly.
- A queued check-in must not bypass approval requirements.

## Audit logging

Audit critical events:

- Organization membership changes
- Role changes
- Visitor registration by staff
- Approval and rejection
- Check-in and check-out
- Invitation creation, revocation, and failed verification
- Report export
- Retention or deletion actions
- Restricted-list changes when that module is introduced

Do not log:

- Passwords
- Access or refresh tokens
- Raw QR tokens
- Full sensitive ID references
- Full request payloads containing personal information

## Error and diagnostic handling

- User-facing errors must not reveal SQL, stack traces, keys, or internal identifiers.
- Production diagnostics should use request IDs and structured categories.
- Personal information should be redacted before remote error reporting.
- Authorization failures should be distinguishable internally but not reveal another tenant's record existence.

## Retention and deletion

Organizations should eventually configure retention within policy limits. The system must support:

- Visitor record deletion or anonymization
- Separate photo retention
- Organization account deletion workflow
- Export before deletion where appropriate
- Logged deletion actions without retaining deleted personal content

## Backups and recovery

Before production:

- Confirm Supabase backup capability for the selected plan
- Define backup retention
- Restrict backup access
- Test restoration
- Document recovery objectives
- Ensure deleted personal data is handled consistently with backup retention commitments

## Secure development workflow

- Feature branches and pull requests
- No direct unreviewed production changes
- Static analysis and tests in CI
- Dependency review
- Secret scanning
- Migration review
- Security test cases for every authorization-sensitive feature

## Required security tests

- User from Organization A cannot read or modify Organization B data
- Employee cannot perform admin actions
- Guard cannot export organization-wide data without permission
- Expired, revoked, malformed, and replayed tokens fail
- Invalid visit state transitions fail
- Suspended membership immediately loses effective access
- Public registration cannot enumerate employees or visitors
- Private storage objects cannot be opened through permanent public URLs
- Offline replay remains idempotent

## Incident response baseline

Before launch, document:

1. How suspected incidents are reported
2. How credentials and tokens are rotated
3. How affected access is disabled
4. How logs are preserved
5. How affected customers are informed
6. How remediation is verified

Never describe VisitFlow as completely secure or unhackable.
