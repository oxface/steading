# Local Coding Agent Evaluation

Decision record from the August 18, 2026 experiments. This concerns optional developer tooling only. It does not change Seneschal's LangGraph runtime, provider boundary, or delivery roadmap.

## Question and boundary

The experiment asked whether a local open-weight model and coding harness can handle useful repository work on the existing Windows GPU host. The inspected benchmark repository was Patchline, not Steading. The goal is to learn and occasionally save hosted-model usage, not to create an autonomous software-development process.

The current host has an RTX 4080 Super with 16 GB VRAM. Ollama runs on Windows. The harness and model are separate variables: changing a harness can change prompting, tool selection, compaction, and token efficiency, but cannot add model intelligence or remove CPU offload.

## Observations

| Model and harness | Ollama context | Residency and speed | Result quality |
|---|---:|---|---|
| Qwen3.8 27B `UD-Q3_K_XL`, DeepSeek Harness | 32K | 85% GPU / 15% CPU; about 10 minutes; 8.3 tokens/s | Better repository comprehension, but too slow for routine interactive coding on this host |
| Qwen3.5 9B `Q4_K_M`, DeepSeek Harness | 64K | About 8 GB; 100% GPU; under 2 minutes; about 81 tokens/s | Fast and broadly useful, but the overview remained shallow |
| Qwen3.5 9B `Q4_K_M`, DeepSeek Harness | 128K | About 10 GB; 100% GPU; about 2 minutes; about 80 tokens/s | More investigation steps, but still made basic evidence and state distinctions poorly |
| Qwen3.5 9B `Q4_K_M`, Pi, correct repository | 128K | 52.9 seconds; 28 model calls; 27 tool calls; 187,826 cumulative input tokens; 3,503 output tokens | Faster and leaner, but contained serious factual errors after reading contrary evidence |

The Pi run incorrectly reported that Postgres was not configured in Patchline after reading the AppHost definition that configured it. It also described web implementation files that did not exist and blurred the distinction between configured, planned, and currently running resources. These are disqualifying errors for unsupervised architecture or repository-status work.

Harness input totals are cumulative across model calls, including repeated context after tool use; they are not the size of one prompt. The harness footer's advertised context can also differ from Ollama's actual allocation. Ollama's allocation is the limit that matters for inference and KV-cache fit.

## Decisions

- Use Qwen3.5 9B with Pi as the preferred optional local coding experiment for now, with Ollama and Pi both configured for a 128K ceiling.
- Use it only for bounded tasks whose desired behavior, affected area, and acceptance checks have already been written down.
- Do not use it as the authority for architecture, roadmap changes, ambiguous debugging, repository assessment, security decisions, or final review.
- Keep DeepSeek Harness as an optional comparison surface. It does not replace LangGraph, which remains Seneschal's product runtime.
- Keep Pi's terminal-first interface; adding a third-party GUI has no demonstrated benefit for the experiment.
- Do not route Qwen through Claude Code merely to obtain a different harness. That can change tool orchestration but does not provide Claude-model capability, expand Ollama's actual context, or make Qwen3.8's CPU offload disappear.
- Defer Qwen3.8 27B for routine coding on this machine. Partial CPU/RAM offload preserves capability but makes the current interactive workflow impractically slow.
- Do not continue shopping among Kimi, Gemma, LFM, or other models without a concrete task that Qwen3.5 fails and a repeatable evaluation for that task.
- MLX is not part of this Windows/NVIDIA path; it is an Apple-silicon machine-learning framework rather than an alternative harness.
- Do not buy an RTX 3060 or build another inference PC for this experiment. Revisit hardware only after a measured need for concurrency, always-on serving, or a larger fully resident model.
- Start Seneschal workload-model evaluations with bounded 16K–32K contexts. Increase context only when eval evidence shows that retrieval or tool results require it.

## No-vibecoding operating rules

Local generation is acceptable only when all of the following are true:

1. A human or higher-trust planning pass defines the behavior, non-goals, files or boundary, and objective acceptance criteria before generation.
2. The task is small enough that its complete diff can be understood and reviewed.
3. Repository instructions and learning ownership remain binding. In particular, the local agent does not write the user's Python or run their infrastructure setup commands.
4. The agent is given the narrowest relevant context instead of being asked to infer the whole repository from a broad scan.
5. Deterministic checks—tests, type checking, linting, builds, and a focused smoke test as appropriate—are run by the responsible person.
6. Passing checks do not replace review. The diff is inspected for invented facts, accidental scope growth, security changes, and configured-versus-running confusion.
7. The local agent does not commit, push, deploy, alter secrets, or make infrastructure changes unattended.

Failure on factual grounding ends the run; it is not repaired by accepting plausible prose. A stronger model or the user re-establishes the facts, narrows the task, and decides whether another local attempt is worthwhile.

## Revisit triggers

- A repeatable Seneschal task cannot be completed reliably by Qwen3.5 9B despite a narrow specification and objective checks.
- A newer fully resident model materially improves the same fixed evaluation.
- Concurrent OpenWebUI and Seneschal demand causes measured contention on the Windows host.
- An always-on serving requirement justifies a separate machine.
- A 24 GB or larger GPU becomes available without purchasing hardware solely for experimentation.
