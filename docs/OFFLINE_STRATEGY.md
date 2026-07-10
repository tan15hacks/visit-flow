# VisitFlow Offline Strategy

## Objective

VisitFlow must remain operational during short or unstable connectivity interruptions without pretending that all backend-dependent actions are safely available offline.

## MVP offline scope

The initial offline capability should support:

- Viewing recently synchronized current visitors for assigned locations
- Viewing recently synchronized expected visitors
- Queueing check-in for an already approved, locally known visit
- Queueing check-out for a locally known checked-in visit
- Showing pending synchronization clearly

Optional after the core queue is stable:

- Temporary staff-assisted walk-in registration
- Cached emergency list

## Explicitly online-only in the MVP

- Staff authentication when no valid session exists
- Organization and role changes
- New employee invitations
- Host approval and rejection
- Creating visitor invitations
- Generating new QR passes
- Report export
- Sensitive administrative settings

## Local data model

Cached records should contain only the minimum operational fields required by the signed-in role. Local storage must distinguish:

- Confirmed server records
- Pending local operations
- Failed operations
- Conflict records
- Cache freshness and last synchronization time

## Queued operation fields

- `client_operation_id`
- `operation_type`
- `organization_id`
- `location_id`
- `visit_id`
- `requested_transition`
- `device_id`
- `device_timestamp`
- `created_at`
- `retry_count`
- `last_attempt_at`
- `sync_status`
- `failure_code` nullable

## Synchronization behavior

1. Connectivity returns.
2. Queue processes oldest safe operation first.
3. Server revalidates authentication, membership, role, location, visit state, and approval.
4. Server uses the client operation ID for idempotency.
5. Confirmed operations update the local cache.
6. Rejected conflicts remain visible for staff resolution.

## Conflict examples

- Another guard already checked in the visitor.
- The invitation was revoked while the device was offline.
- Host approval was withdrawn.
- The visitor was checked out from another entrance.
- The staff membership was suspended.
- The cached visit belongs to a location no longer assigned to the device user.

The client must not silently overwrite the server state.

## Time handling

Record both device time and server acceptance time. The device timestamp helps operational review but does not override server authorization or ordering automatically.

## UI requirements

The app must show:

- Offline banner
- Time of last successful synchronization
- Pending-operation count
- Pending status on affected visitor cards
- Conflict or failure explanation
- Manual retry where appropriate

Do not display a queued check-in as fully confirmed until acknowledged by the server.

## Security and privacy

- Cache only the minimum visitor details required for the signed-in role.
- Encrypt or platform-protect sensitive local storage where supported.
- Clear tenant cache on logout, membership removal, or organization switch.
- Expire cached operational data after a documented period.
- Do not cache raw QR or invitation tokens longer than required.

## Implementation direction

Drift is the preferred candidate for a structured queue and cache because transactions and queryable sync state are important. Final package selection will be recorded in `DECISIONS.md` during Milestone 1 after compatibility review.

## Testing

Required scenarios:

- Queue one check-in and synchronize successfully
- Deliver the same operation twice without duplicate state changes
- Check in from two devices and surface conflict
- Suspend membership before queued synchronization
- Revoke a pass before queued synchronization
- Logout with pending operations
- Application restart with pending queue
- Partial synchronization failure
