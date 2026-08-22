# Portable agent assets

Repository instructions use the open `AGENTS.md` convention. The root file contains shared guidance and nested files scope API, web, and platform rules. Codex automatically merges a nested file when launched inside that subtree; when launched at the repository root, the root guide explicitly tells it to consult the nearest nested file for the target being changed.

This directory is reserved for assets that can be shared by agent clients but are not themselves automatically discovered instructions. Its pre-edit hook enforces the user-owned Python boundary for clients that support command hooks.

Codex requires a repository-specific discovery location for hooks, so `.codex/hooks.json` is a thin adapter that invokes the script here. Add other vendor-specific adapters only when a real capability cannot be expressed through `AGENTS.md` or a portable asset in this directory, and keep the portable source of truth here.
