# Steading repository guide

## Project direction

Steading is a learning-oriented, reproducible reference cluster. Seneschal is the product being built and Steading is its first installation, integration environment, and operational playground. Do not turn Steading into a generic homelab distribution unless a later discovery creates a concrete need.

Seneschal is a cluster-operations tool: a read-only dashboard and integration catalogue first, then a chatbot that investigates cluster state through typed tools. The current architecture and delivery stages are recorded in `docs/roadmap.md`; settled technology choices and revisit triggers are in `docs/stack.md`.

The repository belongs to a Principal .NET engineer deliberately learning Python, modern React, Kubernetes, and agent engineering. Optimize for learning value, clear boundaries, and working vertical slices over enterprise ceremony. Give reasoned pushback when the existing plan is weak, but do not reopen a settled choice without new evidence or a documented trigger.

## Read before acting

- `docs/roadmap.md` — product boundary, architecture, and staged delivery plan.
- `docs/stack.md` — canonical stack decisions and revisit triggers.
- `docs/training/README.md` — the mastery-gate protocol and tracker rules.
- `docs/agent-practices.md` — binding safety and quality practices for Seneschal.
- The nearest nested `AGENTS.md` — scope-specific rules for the API, web app, or platform.

## Learning contract

The user learns while building. For a non-graduated item in `docs/training/*.md`, use the guided-rep loop:

1. Frame what is being built, why, and what is deferred.
2. Give pattern-level samples with meaningful blanks, not the completed user-owned implementation.
3. Let the user build it and run the relevant CLI.
4. Review the actual result.
5. Ask two to four free-text why/what-if questions, then explain any shaky areas.

At the start of a delivery stage, compare its work with the training trackers and assign non-graduated concepts to the user before generating code. Never update tracker counts without explicit user sign-off.

## Always binding

1. Never create or edit a `.py` file. All Python, including FastAPI, LangGraph, and MCP code, is written by the user. Coaching, review, debugging, and edits to non-Python project files are allowed.
2. The user personally runs scaffolding and infrastructure setup/install/debug commands. Provide the exact command and explain it; do not execute it. Read-only repository inspection and validation commands are allowed.
3. Preserve unrelated working-tree changes. The repository is frequently used as a live learning workspace.
4. Do not introduce Next.js, Temporal, Azure Durable Functions, or MongoDB unless a recorded architecture decision explicitly replaces this constraint.
5. Use lowercase for machine-visible names and avoid fashionable service suffixes that do not describe a boundary.

## Current environment

- Windows 11 is the development and GPU host.
- A single Ubuntu VM on Hyper-V is the local cluster host. It runs single-node k3s and cluster workloads and is started/stopped on demand.
- WSL is an optional development shell, not the Kubernetes host.
- Ollama runs on Windows and is reached from the VM over a controlled, predictable Hyper-V network.
- Proxmox and in-cluster GPU inference are deferred until there is dedicated hardware or a concrete requirement.

## Repository layout

```text
apps/seneschal/web/   React SPA; see its nested AGENTS.md
apps/seneschal/api/   FastAPI + LangGraph; see its nested AGENTS.md
platform/             Hyper-V/k3s, Flux, workloads, observability; see its nested AGENTS.md
docs/                 product, architecture, and learning records
.agents/              portable agent assets; not an instruction-discovery mechanism
.codex/               thin Codex adapter for portable hooks
```
