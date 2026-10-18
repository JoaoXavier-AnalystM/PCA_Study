---
type: architecture
source: repository inspection and docs/setup.md
verified: 2026-10-18
invalidate_when: stack, deployment ports, page model or canonical QA command changes
---

# Project context

PCA Study is a static bilingual HTML/CSS/JS guide served by Nginx in Docker. Homepage and seven PT/EN study pages are the product surface; `web/day-quiz.js` is shared study-page behavior. Browser state uses localStorage only.

Canonical verification: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tests/qa-regressions.ps1 -Case all`.

Preserve local changes and keep PT/EN page pairs synchronized. No framework, database or package manager is part of current contract.
