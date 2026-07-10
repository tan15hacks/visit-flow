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

## ADR-006 — Riverpod and GoRouter are the preferred Flutter foundation

**Status:** Proposed pending Milestone 1 package review

**Decision:** Use Riverpod for dependency injection and state management and GoRouter for declarative navigation and guards unless current package compatibility review reveals a material issue.

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

## Decisions still required

- Exact Flutter and Dart version policy
- Exact package versions
- Drift versus another local database
- Supabase local-development workflow
- Monorepo tooling, if any
- Visitor web hosting and server-action pattern
- Push notification implementation details
- Error monitoring provider
- Subscription and billing provider
