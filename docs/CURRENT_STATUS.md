# VisitFlow Current Status

## Current milestone

Milestone 1B — Visitor web foundation

## Current branch

`feature/visitor-web-foundation`

## Pull request

Draft pull request #3 — `feat: establish visitor web portal foundation`

## Base

`main` after merged Flutter foundation pull request #2.

## Latest verified implementation commit

`00a88bfcfa4a873923711cb89042a93dad091305`

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
- Exact npm dependency lockfile committed
- Visitor web CI hardened to read-only permissions and `npm ci`
- ESLint passed
- Strict TypeScript verification passed
- Next.js production build passed

## In progress

- Manual browser review on phone-sized and desktop-sized viewports
- Pull request review and merge decision

## Security boundaries

- URL references are treated as opaque values.
- Dynamic token values are not rendered into the page.
- Dynamic token values are not intentionally written to browser logs.
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
- Hosting and deployment configuration are not part of this foundation PR.
- CI verification does not replace manual responsive and usability review.

## Verification state

GitHub Actions run `29071291276` completed successfully for implementation commit `00a88bfcfa4a873923711cb89042a93dad091305`.

Verified steps:

1. Node.js 22 setup
2. Locked dependency installation with `npm ci`
3. ESLint
4. Strict TypeScript checks
5. Next.js production build

## Next recommended task

1. Pull the feature branch locally.
2. Run the visitor portal in a browser.
3. Review home, registration, invitation, pass, checkout, error, and not-found layouts.
4. Review mobile and desktop widths.
5. Merge pull request #3 using squash only after manual review succeeds.
6. Begin Supabase project and authentication planning in a separate branch.

## Session handover rule

At the beginning of the next session:

1. Read `docs/VISION.md`.
2. Read `docs/ARCHITECTURE.md`, `docs/SECURITY.md`, `docs/API.md`, and this file.
3. Confirm the active branch, pull request, and latest workflow result.
4. Do not add backend submission or token validation inside the foundation PR.
5. Do not start the Supabase milestone until pull request #3 is reviewed and merged.
