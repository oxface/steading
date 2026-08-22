# Agent Engineering Practices — binding for Seneschal

These are commitments, not suggestions. If a delivery stage ships an agent feature violating one of these, that stage is not done. Rationale for each traces to the 2026 trend research (evals gap, lethal trifecta, production-agent failure modes).

## Build order
1. **Evals first.** Before an agent feature is built, write the eval cases that define "works": input, expected behavior, scoring method. The eval set grows with every feature and every discovered failure. Seed questions appear during local foundation work, the first agent stage runs them manually, and the hardening stage automates the same set as a CI gate.
2. **Raw before framework.** New capability class (tool calling, streaming, structured output) gets a hand-rolled implementation before the LangGraph/`create_agent` version. Understanding what the framework wraps is the skill.

## Runtime rules
3. **Structured outputs everywhere.** Every LLM response that code consumes is Pydantic-validated (or JSON-schema-constrained). Free text is only for humans.
4. **Durable by default.** Agent graphs run with PostgresSaver checkpointing from the first version — resume-after-crash is a feature, not a hardening step.
5. **Read and write tools are different security boundaries.** The initial product is read-only. A later write capability belongs in a separate tool server and service identity, not as an extra method on the read server, and always goes through an interrupt/approval gate.
6. **Least-privilege tools.** The orchestrator has no Kubernetes credentials, shell, `kubectl`, arbitrary HTTP, or Secret-value access. The read MCP server gets the narrowest service account and API scopes that work; every tool validates input, bounds and redacts output, and emits an audit record. Design against the lethal trifecta: private data + untrusted input + exfiltration path must never coexist in one context.
7. **Cost and token telemetry from the first LLM call.** Every LLM call emits OTel metrics (tokens in/out, model, latency, cost estimate). The hardening stage adds reviewed dashboards, budgets, and CI policy; it does not introduce the instrumentation.

## Engineering hygiene
8. **Context is engineered, not accumulated.** System prompts are versioned files in the repo (not string literals); context budget is explicit; message pruning is deliberate.
9. **Traces per run.** Every agent run is an OTel trace with per-node spans — debugging a graph without traces is flying blind.
10. **Provider-switchable by capability.** No domain code may assume a provider-specific response object. Local and hosted implementations switch by configuration; the hosted provider is chosen by eval quality, privacy, latency, and cost rather than hard-coded in the architecture.
11. **Prompt-injection review.** Any feature that feeds external/untrusted content (logs, cluster events, web) into context gets an explicit injection review against rules 5–6 before it ships.

## Deployment boundaries

```text
browser → seneschal-api → model provider
                    └→ seneschal-tools MCP → read-only cluster/Flux/telemetry APIs

future only:
seneschal-api → approval interrupt → seneschal-actions MCP → narrow write APIs
```

The model provider may be Ollama on the Windows host or a configured direct OpenAI/Azure OpenAI endpoint. Provider location never grants cluster access; tools remain the only path to operational data. The MCP server returns purpose-built summaries rather than raw command execution or unlimited API responses.

## Environment practices (the meta-rule)
The same standard applies to any coding agent used on the repository: prefer repository-visible, vendor-neutral instructions and deterministic enforcement over prompt-only promises; use vendor-specific configuration only as a thin compatibility layer. When unsure what an agent officially supports, check its current documentation before inventing a convention.
