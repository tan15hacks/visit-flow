# VisitFlow Current Status

## Current milestone

Milestone 0 — Product and architecture foundation

## Current branch

`docs/project-foundation`

## Base commit

`fbed1c212026f6c24359c5adc318f9e1e2d69de9` — Initial commit

## Latest documentation commit

This value should be updated after the foundation pull request is finalized.

## Completed

- Repository inspected
- Initial README expanded on the documentation branch
- Product vision and MVP boundaries defined
- Product specification defined
- System architecture defined
- Flutter architecture defined
- Logical database schema defined
- Security and visitor privacy model defined
- User roles and permission matrix defined
- Flutter and visitor web route map defined
- Backend operation boundaries defined
- Limited offline strategy defined
- Testing strategy defined
- Development roadmap defined
- Initial architecture decisions recorded

## In progress

- Final Milestone 0 documentation review
- Changelog and project governance prompt archival
- Foundation pull request preparation

## Not started

- Flutter application initialization
- Next.js visitor portal initialization
- Supabase local project structure
- CI workflows
- Authentication
- Organization onboarding
- Locations, entrances, departments, and employees
- Visitor registration
- Approvals
- QR pass verification
- Check-in and check-out
- Reports
- Offline implementation

## Known issues

- No application code exists, so no Flutter or web commands can be run yet.
- Package versions have not been selected or verified.
- Supabase project credentials and environments have not been configured.
- Logical schema and security policy still require SQL migration design during the appropriate milestone.

## Verification performed

- Repository metadata and initial commit inspected through the GitHub connection.
- Documentation files were created on a dedicated feature branch.
- No build, static analysis, test, migration, or runtime verification has been performed because no application code exists.

## Next recommended task

Review and merge the Milestone 0 documentation pull request. After merge, create `feature/flutter-foundation` and initialize only the repository/application foundation described in Milestone 1.

## Session handover rule

At the beginning of the next session:

1. Read `VISION.md`.
2. Read `ARCHITECTURE.md`, `FLUTTER_ARCHITECTURE.md`, `DATABASE_SCHEMA.md`, and `SECURITY.md`.
3. Confirm the current branch and latest commit.
4. Inspect the pull request and unresolved feedback.
5. Do not initialize application code until Milestone 0 is approved and merged.
