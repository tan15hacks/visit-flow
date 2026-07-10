# VisitFlow Product Vision

## Purpose

VisitFlow exists to replace exposed, slow, and difficult-to-search paper visitor logbooks with a simple digital workflow that small and medium organizations can operate using ordinary phones, tablets, and web browsers.

The product must help organizations register visitors, approve visits, verify entry, track who is currently inside, record check-out, respond during emergencies, and produce useful records without requiring expensive access-control hardware.

## Initial target customers

VisitFlow is designed first for organizations that currently rely on paper, spreadsheets, or chat messages:

- Small and medium offices
- Private schools and colleges
- Clinics and diagnostic centers
- Warehouses and distribution sites
- Construction sites
- Condominiums and subdivisions
- Churches and community organizations
- Barangays and local government offices
- Factories and coworking spaces

The first sales focus should be offices, schools, clinics, warehouses, and construction sites because they commonly have a guard, receptionist, or front desk and a clear operational need.

## Core value proposition

> Visitors register through a QR code or staff-assisted form, hosts approve arrivals, guards check visitors in and out, and administrators receive organized and searchable records.

VisitFlow should be meaningfully better than paper by providing:

- Privacy: visitors cannot read previous visitors' personal information
- Speed: repeatable registration and QR-based verification
- Visibility: a current list of people inside the premises
- Accountability: recorded approvals, check-ins, check-outs, and staff actions
- Searchability: fast filtering and exports
- Safety: emergency visitor lists and overdue check-out awareness
- Affordability: no proprietary kiosk or access-control hardware required

## Product principles

1. **Mobile-first operations.** Guards, receptionists, employees, and administrators should complete common tasks from Flutter mobile and tablet layouts.
2. **No visitor app requirement.** Visitors use a lightweight mobile web experience for registration, consent, invitations, passes, and check-out.
3. **Simple before powerful.** Common workflows must take very few taps and remain understandable to non-technical staff.
4. **Secure by default.** Tenant isolation, backend authorization, opaque QR tokens, minimized personal data, and auditability are mandatory.
5. **Affordable for small organizations.** The MVP must work with free or low-cost infrastructure and ordinary hardware.
6. **Resilient connectivity.** The architecture must tolerate unstable internet and support limited queued operations.
7. **Low-end Android support.** Avoid unnecessary visual effects, large payloads, and expensive background work.
8. **Operational clarity.** Status, errors, offline state, and required staff actions must be explicit.
9. **Documentation is part of the product.** Architecture, security, database, and workflow decisions must remain current.
10. **Measured expansion.** Features are added only when they strengthen the visitor-management workflow or proven customer demand.

## MVP outcome

The first production release must allow an organization to:

- Create a secure organization workspace
- Add staff with owner, administrator, guard/receptionist, and employee roles
- Configure a location, departments, and entrances
- Display an entrance registration QR code
- Receive walk-in visitor registrations through the web portal
- Create and send pre-registered invitations
- Request and record host approval
- Issue a secure QR visitor pass
- Verify the pass from the Flutter app
- Check visitors in and out
- View visitors currently inside
- Search visit history and export CSV reports
- Record audit events
- Operate a limited offline check-in/check-out queue

## MVP boundaries

The MVP will prioritize one reliable end-to-end workflow over a broad feature set:

1. Organization setup
2. Staff and role setup
3. Visitor registration or invitation
4. Host approval
5. QR pass verification
6. Check-in
7. Current visitor visibility
8. Check-out
9. History and reporting

Specialized contractor, delivery, incident, and emergency modules may be introduced after the core workflow is stable unless a limited version is required for a pilot customer.

## Explicitly out of scope for the MVP

- Artificial intelligence
- Facial recognition
- OCR or government ID scanning
- Government identity verification
- Biometric identification
- SMS notifications
- NFC cards
- Turnstile, smart-lock, or door-access integrations
- Payroll or employee attendance
- Meeting-room booking
- Equipment management
- Full property management
- Advanced workflow builders
- White-label mobile applications
- Enterprise single sign-on
- Predictive analytics

## One-year direction

After the MVP proves demand, VisitFlow may expand in this order:

1. Stronger emergency roll call and evacuation status
2. Delivery and contractor visit types
3. Incident reporting
4. Badge printing and kiosk mode
5. Multiple locations and advanced role scopes
6. Calendar and email integrations
7. Visitor retention controls and advanced audit exports
8. API and webhook access
9. Optional access-control integrations for larger customers

The product should remain centered on visitor entry and premises awareness rather than becoming a generic HR or property-management suite.

## Decision rule

Every proposed feature must answer:

> Does this improve visitor registration, approval, entry, tracking, safety, reporting, or administration for the target organization?

If the answer is no, the feature should normally be rejected, postponed, or developed as a separate product.

## Success criteria

The MVP is successful when pilot organizations can operate a full workday without a paper visitor logbook and can reliably answer:

- Who is currently inside?
- Who approved each visitor?
- When did each visitor enter and leave?
- Who was expected but did not arrive?
- Which visitors are overdue for check-out?
- Can authorized staff retrieve and export records without seeing another organization's data?
