# AI Training Plan & Tracker

Rule: same as Python — it's `.py`, so every line is hand-written. Curriculum note: raw-API items come *before* framework items on purpose; understanding the loop under LangGraph is the point.

## Learning outcomes (what mastery looks like)

1. Build an agent from raw API primitives up — and articulate exactly what a framework adds.
2. Operate a durable, evaluated, cost-instrumented LangGraph agent, production-style.
3. Design tool surfaces (incl. MCP) that agents can actually use well.
4. Evaluate nondeterministic systems: eval sets, LLM-as-judge, CI gates.
5. Reason about agent security (lethal trifecta, least privilege, sandboxing) at design-review level.

## Foundations (no framework)
- [ ] ollama: pull/run models, API, model selection for 16GB — 0/2
- [ ] chat completions by hand: system prompts, streaming, temperature — 0/2
- [ ] tool calling by hand: define tools, run the call loop, feed results back — 0/3
- [ ] structured output: JSON schema / Pydantic-validated responses — 0/2
- [ ] context engineering: system prompt design, context budget, message pruning — 0/2

## LangGraph
- [ ] StateGraph: state schema, nodes, edges — 0/2
- [ ] conditional edges & routing — 0/2
- [ ] tool nodes / ReAct-style agent — 0/3
- [ ] PostgresSaver checkpointing: persist, crash, resume — 0/2
- [ ] human-in-the-loop interrupts (approval gate for write actions) — 0/2
- [ ] subgraphs / multi-agent composition — 0/2
- [ ] `create_agent` (langchain 1.x) AFTER hand-built equivalents — compare to your own loop — 0/1
- [ ] Claude Agent SDK comparison spike: same assistant on SDK harness vs LangGraph, write-up — 0/1

## MCP
- [ ] consume an MCP server from the agent — 0/2
- [ ] build an MCP server in Python (cluster read-tools) — 0/2
- [ ] build the C# MCP server (slice 9; .NET is day-job skill, 1 rep) — 0/1

## Quality & safety
- [ ] evals: build a small eval set for seneschal, run it — 0/3
- [ ] LLM-as-judge eval + CI gate — 0/2
- [ ] token/cost telemetry as OTel metrics — 0/2
- [ ] agentic retrieval: tools-over-RAG for cluster/docs questions — 0/2
- [ ] pgvector: embeddings + hybrid search (when a real need appears) — 0/2
- [ ] prompt injection: lethal-trifecta review of seneschal + one hardening exercise — 0/2
