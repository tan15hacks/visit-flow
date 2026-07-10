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
- Reserved visitor web and Supabase workspaces

### Changed

- Project status advanced from Milestone 0 to Milestone 1A
- Riverpod and GoRouter moved from proposed to selected foundation dependencies
- Visitor web initialization was separated into a later focused pull request

### Security

- Supabase service-role and secret keys are explicitly prohibited from Flutter configuration
- The current QR screen remains nonfunctional until server-side token verification exists
- No real visitor information is stored or displayed in the foundation shell

### Notes

- Authentication, organization isolation migrations, visitor workflows, camera access, and offline synchronization remain intentionally unimplemented.
- Android and iOS scaffolding is generated using the installed Flutter SDK during bootstrap and CI.
- Runtime and build verification is pending GitHub Actions on the Flutter foundation pull request.
