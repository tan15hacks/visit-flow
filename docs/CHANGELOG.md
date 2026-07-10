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
- Visitor web lint, typecheck, and production build workflow

### Changed

- Project status advanced from Milestone 1A to Milestone 1B
- Riverpod and GoRouter moved from proposed to selected foundation dependencies
- Flutter staff and visitor web foundations remain isolated in separate pull requests
- Visitor web routes are explicitly preview-only until backend token validation exists

### Security

- Supabase service-role and secret keys are explicitly prohibited from Flutter and public web configuration
- The Flutter QR screen remains nonfunctional until server-side token verification exists
- Visitor web token values are not rendered into route output
- Visitor web pages are marked non-indexable during foundation development
- No real visitor information is stored, submitted, or displayed in either foundation application

### Notes

- Authentication, organization isolation migrations, visitor workflows, camera access, and offline synchronization remain intentionally unimplemented.
- Android and iOS scaffolding is generated using the installed Flutter SDK during bootstrap and CI.
- Visitor web dependency lockfile and production build verification are pending CI.
