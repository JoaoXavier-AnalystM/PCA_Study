# Local onboarding

## Prerequisites

- Windows, macOS or Linux shell.
- Python 3 for a local static server.
- Docker Desktop/Engine for container parity.
- `agent-browser` for browser regression checks.
- No credentials or database are required for local development.

## First run

```powershell
python -m http.server 8080 --directory web
```

Open `http://localhost:8080/index.html`. Stop the server with `Ctrl+C`.

## Dev container

```powershell
docker compose -f deploy/docker-compose.dev.yml up -d --build
```

Open `http://localhost:8082`. Stop with:

```powershell
docker compose -f deploy/docker-compose.dev.yml down
```

## Verify

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tests/qa-regressions.ps1 -Case all
```

The suite starts an isolated local Python server, uses a unique agent-browser session and port, checks homepage localization/quiz/headings/landmarks, and checks direct PT/EN study-page quiz feedback.

## Agents

Read [AGENTS.md](../AGENTS.md) before editing. `CLAUDE.md` imports the same shared rules. See [setup evidence](setup.md) for installed or pending integrations.

## Known issues

None observed in baseline regression run on 2026-10-18. Future content and accessibility findings must identify page, language variant and reproducible browser state.
