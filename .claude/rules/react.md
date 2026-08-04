---
paths:
  - "apps/*/web/**"
---

# FE (web) area rules

Collaborative area with a mastery gate — check `docs/training/react.md` before writing code.

- **Gate**: any non-graduated concept in what you're about to write → stop, hand it to the user, coach (rep 1 = explain then they implement; rep 2+ = they implement cold, you review). Graduated concepts you may generate freely; user still reviews.
- **CLI is theirs**: `pnpm create`, `pnpm add`, `pnpm dlx shadcn add`, dev-server runs — give the exact command as a hint with a one-line explanation of what it does; never execute it yourself. Package manager is pnpm, not npm.
- Stack constraints: React 19 + TS + Vite; Tailwind v4 + shadcn/ui; TanStack Router + Query; React Compiler ON (no manual `useMemo`/`useCallback`/`memo` — if the Compiler ESLint plugin complains, that's a teaching moment, not a suppression target).
- State placement (hold the user to this): server state → Query; URL-shareable state → Router search params; true client state only → Zustand. Never copy server data into Zustand.
- Never propose Next.js or non-TanStack routing/data layers.
- ESLint + Prettier (+ prettier-plugin-tailwindcss); config and devDeps live in the web app, not the repo root.
- Propose tracker updates (`docs/training/react.md`) at session end with user sign-off only.
