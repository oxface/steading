# Agent Engineering Practices — binding for seneschal (and every future agent app)

These are commitments, not suggestions. If a slice ships an agent feature violating one of these, the slice isn't done. Rationale for each traces to the 2026 trend research (evals gap, lethal trifecta, production-agent failure modes).

## Build order
1. **Evals first.** Before an agent feature is built, write the eval cases that define "works": input, expected behavior, scoring method. The eval set grows with every feature and every discovered failure. CI gates on it (slice 8 makes this automatic; until then, run manually).
2. **Raw before framework.** New capability class (tool calling, streaming, structured output) gets a hand-rolled implementation before the LangGraph/`create_agent` version. Understanding what the framework wraps is the skill.

## Runtime rules
3. **Structured outputs everywhere.** Every LLM response that code consumes is Pydantic-validated (or JSON-schema-constrained). Free text is only for humans.
4. **Durable by default.** Agent graphs run with PostgresSaver checkpointing from the first version — resume-after-crash is a feature, not a hardening step.
5. **Human-in-the-loop for writes.** Any tool with side effects on the cluster (or the world) goes through an interrupt/approval gate. Read tools may run free; write tools never do.
6. **Least-privilege tools.** Each tool gets the narrowest credential/scope that works (read-only kubeconfig for read tools, scoped tokens, no blanket admin). Design against the lethal trifecta: private data + untrusted input + exfiltration path must never coexist in one context.
7. **Cost and token telemetry from day one.** Every LLM call emits OTel metrics (tokens in/out, model, latency, cost estimate) — the FinOps discipline is part of the build, not an afterthought.

## Engineering hygiene
8. **Context is engineered, not accumulated.** System prompts are versioned files in the repo (not string literals); context budget is explicit; message pruning is deliberate.
9. **Traces per run.** Every agent run is an OTel trace with per-node spans — debugging a graph without traces is flying blind.
10. **Provider-switchable.** No code path may assume a specific provider; ollama ↔ Anthropic switching stays a config change.
11. **Prompt-injection review.** Any feature that feeds external/untrusted content (logs, cluster events, web) into context gets an explicit injection review against rules 5–6 before it ships.

## Environment practices (the meta-rule)
The same standard applies to how we use Claude Code itself: prefer official mechanisms over improvisation — path-scoped rules over monolithic CLAUDE.md, hooks for deterministic enforcement (the `.py` block is a hook, not a promise), skills for repeatable workflows when they emerge. When unsure what the official mechanism is, check the docs before hand-rolling.
