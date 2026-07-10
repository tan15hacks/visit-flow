# VisitFlow Visitor Web

Mobile-first Next.js portal for visitors who should not need to install the Flutter staff application.

## Foundation routes

- `/` — public portal overview
- `/register/[entranceToken]` — entrance registration
- `/invite/[token]` — invitation confirmation
- `/pass/[token]` — digital visitor pass
- `/checkout/[token]` — optional visitor self-checkout

The dynamic references are opaque values. Pages must never render, log, or place those values in analytics.

## Current milestone

The portal is a safe UI foundation only.

Included:

- Next.js App Router
- TypeScript strict mode
- Tailwind CSS
- responsive and accessible public shell
- preview versions of the core visitor routes
- non-indexed metadata
- error and not-found experiences
- public environment template
- CI for linting, type checking, and production builds

Not included:

- Supabase client installation
- organization lookup
- visitor data submission
- privacy-consent persistence
- invitation validation
- QR pass generation
- check-in or check-out mutations
- analytics

## Requirements

- Node.js 20.9 or later
- npm

## Run locally

```powershell
cd apps\visitor_web
npm install
npm run dev
```

Open `http://localhost:3000`.

## Verify

```powershell
npm run lint
npm run typecheck
npm run build
```

## Environment

Copy `.env.example` to `.env.local` only when backend integration begins.

Only browser-safe values may use the `NEXT_PUBLIC_` prefix. Never place service-role keys or server secrets in public environment variables.
