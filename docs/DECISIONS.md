# VisitFlow Architecture Decisions

This file records decisions that affect long-term product or technical direction. New decisions should include context, decision, consequences, and status.

## ADR-001 — Flutter is the primary application framework

**Status:** Accepted

**Context:** VisitFlow requires Android-first mobile operations, tablet support, future iOS compatibility, camera scanning, notifications, and limited offline behavior.

**Decision:** Build the staff application with Flutter and Dart. Do not replace Flutter without an explicitly approved migration decision.

**Consequences:** One primary mobile codebase; Flutter-specific architecture and testing investment; visitor-facing browser workflows remain separate.

## ADR-002 — Visitors do not install the staff application

**Status:** Accepted

**Decision:** Use a lightweight mobile web portal for entrance registration, invitation confirmation, consent, digital passes, cancellation, and optional self-check-out.

**Consequences:** Lower visitor friction; requires a separately secured public web surface with narrow token-scoped endpoints.

## ADR-003 — Supabase is the initial backend platform

**Status:** Accepted

**Decision:** Use Supabase Authentication, PostgreSQL, Storage, Edge Functions, and selective Realtime.

**Consequences:** Fast MVP development and strong PostgreSQL/RLS foundation; platform-specific integration must remain contained behind repositories and documented backend operations.

## ADR-004 — Multi-tenant isolation is database-enforced

**Status:** Accepted

**Decision:** Tenant-owned data is scoped by organization and protected with RLS, constrained relationships, backend role checks, and cross-tenant tests.

**Consequences:** More migration and policy work; substantially lower risk than client-only filtering.

## ADR-005 — Feature-first Flutter architecture

**Status:** Accepted

**Decision:** Organize Flutter code by business feature with presentation, domain, and data responsibilities introduced where useful.

**Consequences:** Features remain easier to understand and change; avoid empty ceremonial layers and over-engineering.

## ADR-006 — Riverpod and GoRouter are the Flutter foundation

**Status:** Accepted

**Decision:** Use `flutter_riverpod` for dependency injection and state management and `go_router` for declarative navigation and future route guards.

**Selected foundation versions:**

- `flutter_riverpod: ^3.3.2`
- `go_router: ^17.3.0`
- `supabase_flutter: ^2.16.0`
- `flutter_lints: ^6.0.0`

**Consequences:** Application state and navigation use explicit, testable framework boundaries. Major dependency upgrades require a focused compatibility review.

## ADR-007 — QR codes contain opaque tokens

**Status:** Accepted

**Decision:** Never encode raw visitor information, permissions, or internal identifiers in QR payloads. Validate tokens server-side for expiry, revocation, use count, organization, location, and visit state.

## ADR-008 — No full government ID storage by default

**Status:** Accepted

**Decision:** Collect only an ID type and masked reference when an organization requires a verification note. Full ID storage or image capture is excluded from the default MVP.

## ADR-009 — Offline support is limited and explicit

**Status:** Accepted

**Decision:** Begin with cached operational views and queued check-in/check-out for locally known visits. Revalidate every operation on the server.

**Consequences:** Safer than broad offline mutation support; some actions remain unavailable without connectivity.

## ADR-010 — Realtime is selective

**Status:** Accepted

**Decision:** Use Realtime only for operationally valuable changes such as pending approvals and current visitor state.

**Consequences:** Lower complexity and resource use than subscribing to all tables.

## ADR-011 — No application code before Milestone 0 review

**Status:** Accepted

**Decision:** Complete and review the product, architecture, database, security, role, route, API, offline, testing, and roadmap documentation before initializing Flutter or Next.js code.

## ADR-012 — Flutter stable 3.44 is the initial CI baseline

**Status:** Accepted

**Context:** The foundation requires a reproducible SDK target while preserving compatibility with the current stable Flutter channel.

**Decision:** Verify the first Flutter foundation with Flutter 3.44.0 in GitHub Actions. Keep the package SDK constraint broad enough for compatible later Flutter 3.x releases, but review SDK upgrades in focused pull requests.

**Consequences:** CI is reproducible while local developers may use compatible newer stable patch releases. Breaking Flutter upgrades do not enter unrelated feature work.

## ADR-013 — Native platform scaffolding is generated from the installed Flutter SDK

**Status:** Accepted for the foundation pull request

**Context:** The browser development environment cannot run Flutter locally, and manually recreating generated Android and iOS project files would be unreliable.

**Decision:** Keep application-owned Dart code in the repository and generate Android/iOS scaffold folders through repeatable Windows and shell scripts using `flutter create`. CI uses the same process before building.

**Consequences:** The foundation can be verified without hand-written generated files. A later maintenance task may commit the verified platform scaffolding if that improves local onboarding and release configuration.

## ADR-014 — Flutter and visitor web foundations use separate pull requests

**Status:** Accepted

**Decision:** Verify and merge the Flutter staff shell before initializing the Next.js visitor portal.

**Consequences:** Smaller diffs, clearer CI failures, simpler rollback, and less cross-framework debugging.

## ADR-015 — Next.js App Router is the visitor portal foundation

**Status:** Accepted

**Context:** Visitors need a lightweight browser experience for public token-scoped workflows without installing the Flutter staff application.

**Decision:** Use Next.js 16 App Router, strict TypeScript, Tailwind CSS, and Node.js 20.9 or later for the visitor portal foundation.

**Selected foundation versions:**

- `next: 16.2.10`
- `react: ^19.2.0`
- `react-dom: ^19.2.0`
- `tailwindcss: ^4.3.0`
- `typescript: ^5.9.0`

**Consequences:** Public routes use server-first rendering and file-system routing. Dependency upgrades require focused compatibility checks and a clean production build.

## ADR-016 — Public route tokens are never rendered or logged

**Status:** Accepted

**Context:** Entrance, invitation, pass, and checkout links will carry opaque references that function as sensitive capabilities.

**Decision:** Dynamic route references may be received by the server but must not be displayed, sent to analytics, included in client logs, or exposed in error messages. The backend will later validate them server-side before returning minimum necessary data.

**Consequences:** Preview pages can establish route structure without weakening future token security. Observability must use safe request identifiers rather than raw route references.

## ADR-017 — Supabase development is migration-first and locally verified

**Status:** Accepted

**Context:** Database structure, grants, functions, and RLS policies are security-critical and must remain reproducible across local, CI, staging, and production environments.

**Decision:** Version every database change as an immutable Supabase migration. Use the local Supabase stack through Docker, rebuild from a clean database in CI, run database linting, and execute pgTAP tests before merge. The initial CI baseline uses `supabase/setup-cli@v3` with Supabase CLI `2.84.2`.

**Consequences:** Backend changes can be reproduced and reviewed without depending on a manually edited hosted project. Docker is required for local database development. CLI upgrades require a focused compatibility review.

## ADR-018 — Organization creation uses a controlled transactional function

**Status:** Accepted

**Context:** Creating an organization also requires an active owner membership and an audit event. Allowing direct client inserts could leave partial or inconsistent tenant records.

**Decision:** Revoke direct organization and membership inserts from authenticated clients. Create the organization, owner membership, and audit event through the security-definer `public.create_organization` function in one database transaction. The function validates the authenticated user, normalized name, slug, and timezone.

**Consequences:** Onboarding has one controlled backend boundary and cannot leave an organization without an owner. Future membership changes should use similarly constrained operations instead of broad table permissions.

## Decisions still required

- Drift versus another local database for Flutter offline storage
- Whether verified native platform folders should be committed
- Visitor web hosting and server-action pattern
- Push notification implementation details
- Error monitoring provider
- Subscription and billing provider
