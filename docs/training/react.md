# React/FE Training Plan & Tracker

Rule: collaborative area with mastery gate — non-graduated concepts are user-implemented; agent coaches then reviews. All CLI scaffolding (`pnpm create`, `pnpm dlx shadcn add`, installing deps) is run by the user; agent provides the command as a hint only.

## Learning outcomes (what mastery looks like)

1. Build a production-quality SPA screen from a blank file — no generator, no copy-paste.
2. Predict and debug re-renders from an understanding of the render model (with and without Compiler).
3. Place state correctly by instinct: Query vs URL vs local vs Zustand.
4. Style common layouts with Tailwind without docs; extend shadcn components confidently.
5. Review agent-generated FE code critically and spot non-idiomatic patterns on sight.

## React foundations
- [ ] JSX, component composition, props & `children` — 0/2
- [ ] lists & keys (and *why* keys), conditional rendering — 0/2
- [ ] `useState`: functional updates, object state pitfalls — 0/2
- [ ] controlled form inputs — 0/2
- [ ] lifting state up / choosing component boundaries — 0/2
- [ ] `useRef`: DOM access + mutable-value uses — 0/2
- [ ] `useEffect`: subscribe + cleanup to an external system — 0/3
- [ ] "you might not need an effect" — refactor one away — 0/2
- [ ] custom hooks: extract reusable logic — 0/2
- [ ] context: provider/consumer (theme or auth) — 0/2
- [ ] `useReducer` for complex local state — 0/2
- [ ] error boundaries + Suspense basics — 0/2
- [ ] React 19 features: `use()`, transitions, `useOptimistic` — 0/2
- [ ] composition patterns: compound components, controlled vs uncontrolled — 0/2
- [ ] THEORY: re-render model, referential equality, why `useMemo`/`memo` existed pre-Compiler — 0/1
- [ ] React DevTools profiling session — 0/2
- [ ] React Compiler: read + fix an `eslint-plugin-react-compiler` violation — 0/2

## TypeScript in React
- [ ] typing props, generics in components/hooks — 0/2
- [ ] discriminated unions for UI state machines — 0/2

## TanStack Router
- [ ] routes, layouts, path params, navigation — 0/2
- [ ] search params as validated state — 0/2
- [ ] loaders + preloading — 0/2

## TanStack Query
- [ ] `useQuery`: key design, staleTime, enabled — 0/3
- [ ] mutations + cache invalidation — 0/2
- [ ] optimistic updates — 0/2
- [ ] pagination or infinite query — 0/2

## State
- [ ] Zustand: store, selectors, persist middleware — 0/2

## Styling & platform (Tailwind before shadcn — one raw-Tailwind layout first)
- [ ] Tailwind: layout by hand (flex/grid page) — 0/3
- [ ] Tailwind: responsive + dark-mode variants — 0/2
- [ ] Tailwind v4 `@theme` customization — 0/2
- [ ] shadcn/ui: add, restyle, extend a component; cva variants — 0/2
- [ ] modern layout patterns spike: grid, container queries, `:has()` — 0/2
- [ ] native HTML replacing JS: `<dialog>`, popover, form validation — 0/2

## Forms
- [ ] form library + zod schema validation (lib TBD at first form) — 0/2
