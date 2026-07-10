# VisitFlow User Roles and Permissions

## Principles

- Permissions are denied by default.
- Roles are enforced by backend policies and controlled operations.
- UI visibility improves usability but does not provide authorization.
- Location-scoped roles should access only assigned operational data.
- Organization owners retain final membership and subscription authority.

## Roles

### Owner

Typical user: business owner, school administrator, property manager, or project owner.

Allowed:

- View and manage organization settings
- Manage subscription and billing configuration
- Add, change, suspend, and remove members
- Assign administrators
- Manage all locations and entrances
- View all authorized reports and audit history
- Configure privacy and retention settings
- Delete or transfer organization ownership through protected workflows

Restricted:

- Cannot bypass retention, legal, or platform safety controls
- Cannot access another organization's records

### Administrator

Allowed:

- Manage locations, entrances, departments, and employees
- Configure visitor fields and approval rules
- View organization visitor records
- Create reports and exports
- Manage operational incident or restriction modules when enabled
- Assist with invitations and visits

Restricted by default:

- Cannot transfer ownership
- Cannot manage platform billing unless explicitly delegated
- Cannot access another organization

### Guard or receptionist

Allowed:

- View current, expected, and pending visitors for assigned locations
- Register walk-in visitors
- Search operational visitor records needed for entry
- Scan and verify passes
- Check approved visitors in
- Check checked-in visitors out
- Assign or record badge numbers
- Record operational notes permitted by policy

Restricted:

- Cannot manage organization settings
- Cannot change roles
- Cannot export unrestricted organization-wide data
- Cannot approve their own access to another location
- Cannot bypass required host approval

### Employee or host

Allowed:

- Create invitations for permitted locations
- View invitations they created
- View visits where they are the host
- Approve or reject requests addressed to them
- Receive arrival notifications
- Cancel their own future invitation when policy permits

Restricted:

- Cannot browse all visitors
- Cannot process check-in unless separately granted an operational role
- Cannot edit organization settings
- Cannot view other employees' private visitor history without permission

### Auditor

Optional post-MVP role.

Allowed:

- Read approved reports and audit records
- View historical operational data within assigned scope

Restricted:

- No create, update, approve, check-in, check-out, or configuration permissions

### Visitor

Visitors are normally unauthenticated external users.

Allowed through narrow token-based flows:

- Submit registration for a specific entrance
- Confirm an invitation
- Accept the privacy notice
- View their active digital pass
- Cancel or check out their visit when explicitly allowed

Restricted:

- Cannot list employees beyond configured host selection
- Cannot view other visitors
- Cannot view internal organization records
- Cannot alter approval or check-in state directly

## Permission matrix

| Capability | Owner | Admin | Guard/Reception | Employee | Visitor |
|---|---:|---:|---:|---:|---:|
| Manage organization | Yes | Limited | No | No | No |
| Manage members and roles | Yes | Limited | No | No | No |
| Manage locations | Yes | Yes | No | No | No |
| Register walk-in visitor | Yes | Yes | Yes | Optional | Self only |
| Create invitation | Yes | Yes | Optional | Yes | No |
| Approve hosted visit | Yes | Yes | No | Yes | No |
| Verify QR pass | Yes | Yes | Yes | No | No |
| Check in/out | Yes | Yes | Yes | No | Self-check-out only if enabled |
| View current visitors | Yes | Yes | Assigned locations | Hosted visitors only | No |
| Export reports | Yes | Yes | No by default | No | No |
| View audit history | Yes | Yes | No | No | No |
| Manage retention | Yes | Limited | No | No | No |

## Location scope

A membership may be organization-wide or restricted to locations. Backend checks must determine whether the acting user may access the target visit's location.

## Role changes

- Role changes are audited.
- Removing or suspending membership immediately removes effective tenant access.
- The final active owner cannot be removed without a protected ownership-transfer workflow.
- Users must not assign a role above their own permitted authority.

## Multiple roles

The initial schema may store one primary role per membership. If customers later require multiple permission sets, migrate to explicit role assignments or permission grants through a documented decision rather than adding scattered boolean flags.
