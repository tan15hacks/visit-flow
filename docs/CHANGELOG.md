# VisitFlow Changelog

All notable product, architecture, security, schema, and application changes should be recorded here.

## Unreleased

### Added

- Expanded repository README
- Product vision and explicit MVP boundaries
- Mobile-first product specification
- Monorepo and backend architecture direction
- Flutter feature-first architecture standards
- Logical multi-tenant database schema
- Security, privacy, QR token, and tenant-isolation model
- User roles and permission matrix
- Flutter and visitor web route map
- Backend operation and public endpoint boundaries
- Limited offline operation strategy
- Testing and verification strategy
- Milestone-based development roadmap
- Initial architecture decision records
- Current project status and session handover process
- Flutter staff package foundation
- Riverpod root application scope
- Centralized GoRouter navigation
- Material 3 VisitFlow theme
- Responsive phone and tablet staff shell
- Dashboard, visitors, scanner, invitations, and more foundation screens
- Optional Supabase initialization using public Dart defines
- Preview mode and recoverable bootstrap failure experience
- Flutter widget smoke test
- Windows and shell native-platform bootstrap scripts
- GitHub Actions formatting, analysis, testing, and Android build workflow
- Next.js visitor portal foundation
- Mobile-first public visitor design system using Tailwind CSS
- Public portal overview route
- Entrance registration preview route
- Invitation confirmation preview route
- Digital visitor pass preview route
- Visitor self-checkout preview route
- Safe not-found and error experiences
- Visitor web environment template
- Committed npm dependency lockfile
- Visitor web lint, typecheck, and production build workflow
- Supabase local project configuration
- Initial immutable tenant-foundation migration
- Organization and membership role/status enums
- Organizations, organization memberships, and audit-log tables
- Security-definer membership and role helper functions
- Transactional `create_organization` database function
- Row Level Security policies and deny-by-default client grants
- pgTAP tests for cross-tenant isolation and onboarding integrity
- Supabase migration, lint, and database-test GitHub Actions workflow
- Flutter authentication gateway abstraction and Supabase Auth adapter
- Email/password sign-in and sign-up screens
- Authentication-state listening and restored-session handling
- GoRouter authentication redirects for protected application routes
- Signed-in account display and sign-out action
- Authentication controller, route-guard, and preview regression tests

### Changed

- Project status advanced from Milestone 2A to Milestone 2B
- Riverpod and GoRouter moved from proposed to selected foundation dependencies
- Flutter staff and visitor web foundations remain isolated in separate pull requests
- Visitor web routes are explicitly preview-only until backend token validation exists
- Visitor web CI now uses read-only permissions and reproducible `npm ci`
- Supabase development is now migration-first and verified against a clean local database
- Organization creation now uses one controlled database transaction instead of direct table inserts
- Configured Flutter sessions now require authentication before entering `/app/*` routes
- Backend-free Flutter preview mode remains available for UI review

### Security

- Supabase service-role and secret keys are explicitly prohibited from Flutter and public web configuration
- The Flutter QR screen remains nonfunctional until server-side token verification exists
- Visitor web token values are not rendered into route output
- Visitor web error handling does not intentionally log route context
- Visitor web pages are marked non-indexable during foundation development
- No real visitor information is stored, submitted, or displayed in either foundation application
- RLS is enabled on every tenant-owned table introduced in Milestone 2A
- Anonymous users receive no organization, membership, audit, or onboarding access
- Authenticated clients receive read-only tenant access and cannot directly insert organizations or memberships
- Cross-organization visibility, employee least privilege, and suspended-membership revocation are release-blocking database tests
- Passwords are handled only by the official Supabase Auth client and are not stored or logged by VisitFlow
- Signed-out users cannot open protected staff routes when Supabase is configured
- Authentication errors are converted to limited user-facing messages without exposing tokens or backend details

### Verification

- Flutter formatting, analysis, widget testing, and Android debug build passed for the application foundation
- Visitor web ESLint, strict TypeScript checks, and Next.js production build passed using the committed lockfile
- Supabase clean reset, schema lint, and pgTAP verification passed for the tenant foundation
- Flutter authentication formatting, analysis, controller tests, route-guard tests, preview regression test, and Android debug build are enforced in CI

### Notes

- Remote Supabase project linking, organization onboarding, membership selection, locations, employees, visitor workflows, camera access, QR validation, and offline synchronization remain intentionally unimplemented.
- Android and iOS scaffolding is generated using the installed Flutter SDK during bootstrap and CI.
- Local physical-device authentication requires the phone to reach the development computer's Supabase API over the local network.
