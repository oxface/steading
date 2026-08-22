# seneschal web

React + TypeScript SPA for the Seneschal cluster-operations companion.

## Current stage

The repository-foundation stage builds the application shell by hand with Vite, Tailwind CSS v4, and React Compiler enabled. TanStack Router, TanStack Query, and shadcn/ui are added as the screen that needs each one is built; Zustand remains conditional on genuine shared client state.

The user runs dependency and scaffold commands personally. See the repository [training protocol](../../../docs/training/README.md) and [frontend tracker](../../../docs/training/react.md) before extending the app.

## Commands

Run from this directory:

```text
pnpm dev
pnpm build
pnpm lint
pnpm exec prettier --check .
```

`pnpm build` runs the TypeScript project build before Vite's production build. The repository-level Lefthook configuration formats staged frontend files, but CI and manual checks remain authoritative because Git hooks can be bypassed.
