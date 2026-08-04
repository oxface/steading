# Training Plans & Trackers

The mastery-gate system: each area has one doc that is both the curriculum and the tracker. A concept must be practiced **by hand** the listed number of times before agents may freely generate code using it.

## Protocol

- **Rep 1 (guided)**: agent explains the pattern and why; user implements. **Rep 2 (cold)**: user implements in a *different context*; agent only reviews. Then → **graduated**. Items marked `/3` need one extra rep (the genuinely hard ones).
- Reps must be **distinct contexts** — repeating the identical exercise doesn't count.
- **Plan-ahead partitioning**: at the start of each slice, the agent scans the slice plan against these trackers and pre-assigns non-graduated concepts to the user. Mid-generation stop is the fallback if something unplanned surfaces.
- **Tracker updates only with user sign-off**, proposed by the agent at session end ("you implemented X cold — graduate it?"). Counts are never updated silently.
- Notation: `- [ ] concept — 0/2` → `- [~] concept — 1/2 (context note)` → `- [x] concept — graduated YYYY-MM-DD`.

## Area rules (also in CLAUDE.md)

| Area | Rule |
|------|------|
| Python (api) | **Every `.py` file hand-written, always** — the gate governs when explanations get shorter, not who types. Agents may write non-Python artifacts (pyproject deps, Dockerfile, CI) and always explain/review/debug. |
| AI (LangGraph etc.) | Same as Python — it's `.py`. |
| React (web) | Collaborative, gated: non-graduated concepts are user-implemented; CLI scaffolds (`npm create`, shadcn add, etc.) are always run by the user (agent gives the command as a hint). |
| Infra | Collaborative, gated: agent may write manifests for graduated concepts; setup/install/debug commands are executed by the user. |
