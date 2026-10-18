# Vibe Coding Toolkit adoption

## Intent

Prepare PCA Study for repeatable AI-assisted development without changing product stack or deployment contracts, then use focused agents for safe improvements.

## Goals

- Make product scope, commands, architecture, design and quality evidence discoverable.
- Preserve static HTML/CSS/JS and existing user changes.
- Reuse real local browser regression coverage.
- Define safe delegation: one writer per file, disjoint waves, coordinator-owned integration.

## Non-goals

- No Next.js, database, package manager, auth, analytics or external memory service.
- No production deployment, credentials, branch protection or Git hooks.
- No broad rewrite of existing HTML or content as part of toolkit setup.

## Decisions

- Canonical instructions: `AGENTS.md`; `CLAUDE.md` imports it.
- Canonical verification: existing PowerShell + agent-browser suite.
- Lightweight memory: `MEMORY.md` plus `memory/`; no Obsidian vault.
- Project-specific toolkit additions: docs, setup evidence and parallel-wave rule only.

## Acceptance

Toolkit documents reflect observed repository state; baseline suite passes; existing local modifications remain uncommitted and untouched; future agents receive explicit file/resource ownership and return evidence.
