# Training Plans & Trackers

The mastery-gate system: each area has one doc that is both the curriculum and the tracker. A concept must be practiced **by hand** the listed number of times before agents may freely generate code using it.

## Protocol

- **Rep 1 (guided)**: agent runs the guided-rep loop below; user implements. **Rep 2 (cold)**: user implements in a *different context*; agent only reviews (loop steps 4–5 only). Then → **graduated**. Items marked `/3` need one extra rep (the genuinely hard ones).

## The guided-rep loop (how every guided step runs)

1. **Frame** — what this step builds and why it matters; explicitly name what we are *deliberately not doing yet* and which slice it's deferred to ("no routers yet — those arrive in slice 2 with real resources").
2. **Sample** — pattern-level guidance so no external docs are needed: the imports, signatures, decorator/structure shapes, and small snippets with blanks. Never the complete finished code for user-owned work — the gap between the sample and the working result is where the learning lives.
3. **Build** — the user implements (and personally runs any CLI).
4. **Review** — agent reviews the actual code: idiom, correctness, what a senior reviewer would flag.
5. **Quiz** — 2–4 free-text questions in chat, immediately after review, probing *why* and *what-if* (not syntax recall). **Informative only** — never gates rep credit; shaky answers get a re-explanation and the concept naturally re-probed next time it appears.

The learning happens *while building* — the agent supplies whatever reference material the step needs inline; the user should never have to leave the conversation to look up how to do the step.
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
