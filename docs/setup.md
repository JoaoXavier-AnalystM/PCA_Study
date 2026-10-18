# Setup and evidence

## Source and context

- Toolkit: `soumatheusgomes/vibe-coding-toolkit`, revision `de66fe371a49f5a4d3b521759e5c401f390b6424`.
- Adoption date: 2026-10-18.
- Client: Codex in Orca-managed Windows workspace; project branch `dev`.
- Product: static PCA Study Guide; existing local changes preserved.
- No provider, proxy or API key changes.

## Decisions and sources

- Used prompt 12 existing-project setup and current toolkit catalog.
- Preserved static HTML/CSS/JS instead of introducing Next.js, database, ORM or package manager.
- Reused existing `tests/qa-regressions.ps1` and globally available agent-browser.
- Added project-local context and documentation; did not copy client credentials or machine caches.

## Components

| Component | Action and reason | Scope | State and evidence |
|---|---|---|---|
| Shared instructions | Added `AGENTS.md` and Claude bridge | Project | Configured; commands and boundaries reflect actual static stack |
| Project docs | Added `PRODUCT.md` and five `docs/` records | Project | Configured; facts based on repository inspection |
| Parallel-wave rule | Added `.claude/rules/parallel-subagent-driven-development.md` | Claude project | Configured; disjoint files/resources and coordinator-owned commits |
| Browser QA | Reused `agent-browser` and existing PowerShell suite | Global/project | Validated; `-Case all` passed on 2026-10-18 |
| Focused agents | Two supervised Codex workers with disjoint file ownership | Orca run `run_25d6dd5647b7` | Validated; both settled `succeeded`, terminals released, no commits by workers |
| Reduced motion | Updated shared study quiz and added focused regression | Project | Validated; normal/reduced PT/EN paths pass |
| Nginx headers | Added conservative response headers and config contract test | Project | Validated; focused test passes; `nginx -t` skipped because executable unavailable |
| Memory | Added `MEMORY.md` and `memory/project-context.md` | Project | Configured; lightweight index, no external vault |
| RTK | Not installed or observed in this client | Machine | Pending; no installation needed for current small task |
| Context7 | Not executed in this adoption | Client | Pending; official project/toolkit sources used instead |
| Graphify | Not installed; project small and static | Machine/project | Inapplicable for current change surface; reevaluate on growth |
| Next/Vercel/PostgreSQL/Sentry/shadcn | Not applicable to static site | Project | Explicitly skipped; no compatible need |
| ESLint/Biome | Not applicable without package/runtime contract | Project | Explicitly skipped; browser regression remains canonical check |
| Obsidian | No concrete external-memory need | External | Skipped; lightweight memory is sufficient |

## Documentation created

Created `PRODUCT.md`, `AGENTS.md`, `CLAUDE.md`, `docs/architecture.md`, `docs/design.md`, `docs/onboarding.md`, `docs/quality.md` and this file. Existing `README.md` remains product entry point.

## Checks

| Item | State | Evidence |
|---|---|---|
| Baseline browser regressions | Validated | `tests/qa-regressions.ps1 -Case all`; issues 1–4 passed |
| Dev deployment | Validated previously | GitHub Actions run `38994694310`, health HTTP 200 |
| Workflow syntax | Validated by GitHub execution | Dev workflow completed successfully on `dev` |
| Full lint/types/build | Inapplicable | No package manifest or framework |
| Production deployment | Not run | No production publishing requested in this setup |
| Harness evaluation prompt 14 | Pending | Requires disposable authorization fixture and separate evidence |

## Memory and harness evidence

`MEMORY.md` is the short project index; topic details live in `memory/`. Client loads `AGENTS.md` at project root; `CLAUDE.md` bridges Claude. Existing browser regression is product QA, not proof of cross-client harness behavior; disposable harness evaluation remains pending.

## Pending work and next delivery

- Agent wave completed: reduced-motion behavior and safe Nginx security-header coverage are implemented and verified.
- Review next: inspect accumulated pre-existing web/test changes before any broad content or layout wave.
- Re-run setup against a fresh toolkit revision when instructions, client integrations or project boundaries change.
