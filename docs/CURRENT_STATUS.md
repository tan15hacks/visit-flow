# VisitFlow Current Status

## Current milestone

Milestone 1B — Visitor web foundation

## Current branch

`feature/visitor-web-foundation`

## Base

`main` after merged Flutter foundation pull request #2.

## Latest verified implementation commit

Pending visitor web CI verification.

## Completed

- Milestone 0 product and architecture documentation merged
- Milestone 1A Flutter staff foundation merged and reviewed on an Android device
- Next.js visitor portal package initialized
- Next.js App Router and strict TypeScript configuration added
- Tailwind CSS design foundation added
- Accessible public header, footer, skip link, and responsive shell added
- Portal metadata set to prevent search indexing during foundation development
- Public portal overview route added
- Entrance registration preview route added
- Invitation confirmation preview route added
- Digital visitor pass preview route added
- Visitor self-checkout preview route added
- Safe not-found and recoverable error experiences added
- Public environment template added
- Visitor web CI workflow added

## In progress

- Dependency resolution and package lock capture
- ESLint verification
- TypeScript verification
- Next.js production build verification
- Visitor web foundation pull request preparation

## Security boundaries

- URL references are treated as opaque values.
- Dynamic token values are not rendered into the page.
- No organization, visitor, invitation, pass, or visit data is loaded.
- No backend mutation or public Supabase call is implemented.
- No service-role key or server secret may use a `NEXT_PUBLIC_` environment variable.
- Core actions remain disabled until server-side validation and authorization exist.

## Intentionally deferred

- Supabase client and server integration
- Organization and entrance lookup
- Visitor registration submission
- Privacy-consent persistence
- Invitation validation and confirmation mutations
- QR pass generation
- Visitor check-in and check-out mutations
- Authentication and organization onboarding in Flutter
- SQL migrations and Row Level Security policies
- Notifications, reports, and offline synchronization

## Known limitations

- The visitor portal currently uses preview content only.
- Dynamic routes recognize that a reference exists but do not validate it.
- No real visitor information can be submitted.
- The dependency lockfile will be committed after CI generates and verifies it.
- Hosting and deployment configuration are not part of this foundation PR.

## Verification state

Pending GitHub Actions verification for:

1. Node.js setup
2. Dependency installation
3. ESLint
4. TypeScript checks
5. Next.js production build

## Next recommended task

1. Open the visitor web foundation pull request.
2. Resolve only confirmed CI failures.
3. Commit the generated dependency lockfile.
4. Run the hardened CI workflow using `npm ci`.
5. Review the portal locally in a mobile-sized browser.
6. Merge using squash only after CI and manual review succeed.
7. Begin Supabase project and authentication planning in a separate branch.

## Session handover rule

At the beginning of the next session:

1. Read `docs/VISION.md`.
2. Read `docs/ARCHITECTURE.md`, `docs/SECURITY.md`, `docs/API.md`, and this file.
3. Confirm the active branch, pull request, and latest workflow result.
4. Inspect CI diagnostics before editing code.
5. Do not add backend submission or token validation inside the foundation PR.
