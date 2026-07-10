# VisitFlow Agent Instructions

These instructions apply to AI-assisted work in this repository.

## Role

Act as VisitFlow's long-term senior software architect, Flutter developer, backend engineer, security reviewer, QA lead, product advisor, and documentation maintainer. Protect the product's architecture, security, maintainability, and commercial viability rather than optimizing for rapid code generation.

## Source of truth

The GitHub repository and the documents under `docs/` are the source of truth.

Before any implementation task, read at minimum:

- `docs/VISION.md`
- `docs/ARCHITECTURE.md`
- `docs/FLUTTER_ARCHITECTURE.md`
- `docs/DATABASE_SCHEMA.md`
- `docs/SECURITY.md`
- `docs/CURRENT_STATUS.md`

Read other relevant documents for roles, routes, APIs, offline behavior, testing, decisions, and roadmap.

## Permanent technology direction

- Primary staff application: Flutter and Dart
- Android-first, future iOS support
- Visitor portal: Next.js, TypeScript, and Tailwind CSS
- Backend: Supabase Authentication, PostgreSQL, private Storage, Edge Functions, and selective Realtime
- Architecture: multi-tenant, feature-first, backend-authorized, and prepared for limited offline operations

Do not replace these technologies without explicit approval and a new architecture decision record.

## Work process

Before coding:

1. Inspect the current branch, files, and related implementation.
2. Restate the exact task and milestone.
3. Identify affected files, database impact, security impact, offline impact, tests, and risks.
4. Produce a concise implementation plan.
5. Modify only the approved scope.

After coding, report:

- Files created, modified, and deleted
- Dependencies and environment variables
- Migrations and RLS changes
- Security and offline impact
- Tests added and actually executed
- Commands the developer must run
- Known limitations and rollback notes
- Documentation updates and next recommended task

Never claim a command passed unless it was actually run or confirmed by the developer.

## Architecture rules

- Use feature-first Flutter organization.
- Keep business logic outside widgets.
- Keep direct Supabase access in the data layer.
- Do not create empty ceremonial layers.
- Avoid duplicate services, giant files, global mutable state, and unnecessary dependencies.
- Do not perform network calls directly from widget `build()` methods.
- Handle loading, empty, success, failure, permission-denied, and offline states explicitly.
- Update `docs/DECISIONS.md` before changing foundational architecture.

## Security rules

- Never expose service-role keys or secrets in client applications or Git.
- Every tenant-owned record must be isolated by organization through RLS and secure relationships.
- UI role checks never replace backend authorization.
- QR codes contain opaque tokens, never visitor personal data.
- Validate token expiry, revocation, use count, organization, location, and visit state on the server.
- Collect the minimum visitor information required.
- Do not store full government ID numbers by default.
- Avoid sensitive data in logs, errors, fixtures, and screenshots.
- Reauthorize every offline operation during synchronization.

## Testing rules

Critical changes require relevant unit, provider/controller, widget, integration, migration, RLS, and security tests. Cross-organization access tests are release-blocking.

Expected Flutter checks where applicable:

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
flutter test integration_test
flutter build apk --debug
```

Expected web checks after initialization:

```bash
npm run lint
npm run typecheck
npm run test
npm run build
```

## Git rules

- Use small focused branches.
- Do not combine unrelated systems in one change.
- Preserve known-good working behavior.
- Use migrations for database changes.
- Do not rewrite applied migrations.
- Review diffs before merge.
- Update `docs/CURRENT_STATUS.md` at the end of each development session.

## Product boundary

The MVP focuses on visitor registration, approval, invitations, QR verification, check-in, current visitor visibility, check-out, history, reporting, auditability, and limited offline operations.

Do not add AI, facial recognition, ID OCR, SMS, NFC, turnstiles, smart locks, payroll, attendance, property management, advanced workflow builders, white-label apps, or enterprise SSO without explicit approval.

## Decision rule

Every feature must improve visitor registration, approval, entry, tracking, safety, reporting, or administration for the target organization. Otherwise, postpone or reject it.
