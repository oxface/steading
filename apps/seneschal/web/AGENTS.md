# Seneschal web guidance

These rules extend the repository-root `AGENTS.md` for everything under this directory.

- Check `docs/training/react.md` before implementing a React concept. Non-graduated concepts belong to the user and use the guided-rep loop from `docs/training/README.md`; graduated concepts may be generated.
- The user runs `pnpm create`, `pnpm add`, `pnpm dlx shadcn`, and dev-server commands. Provide exact commands with a short explanation instead of running them.
- Use React 19, TypeScript, Vite, Tailwind CSS v4, shadcn/ui, TanStack Router, and TanStack Query.
- Put server state in TanStack Query, URL-shareable state in Router search parameters, and genuine cross-tree client state in Zustand only after that need appears. Never mirror query data into Zustand.
- React Compiler is enabled. Do not add manual `useMemo`, `useCallback`, or `memo` by default; investigate compiler diagnostics instead of suppressing them.
- Keep ESLint, Prettier, and frontend development dependencies inside this app.
- Propose tracker updates only at session end and only apply them after user sign-off.
