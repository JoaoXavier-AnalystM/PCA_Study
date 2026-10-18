# Quality

## Commands

| Check | Command | Proves |
|---|---|---|
| Full browser regression | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tests/qa-regressions.ps1 -Case all` | Local HTTP loading, PT/EN localization, quiz score, heading hierarchy, landmarks, native controls, keyboard focus and feedback |
| Scoped regression | Same command with `-Case issue1`, `issue2`, `issue3` or `issue4` | One focused contract |
| HTML/container validation | GitHub Actions deploy workflows | File presence, basic HTML structure, size, container startup and VPS health endpoint |
| Manual UI QA | `agent-browser` against local dev server | Navigation, responsive layout, console, network and accessibility tree evidence |

No npm lint, typecheck, build or package audit exists; this project has no package manifest or framework. Adding ESLint/Biome only to satisfy toolkit defaults would be unnecessary scope.

## Baseline rules

- Preserve valid HTML landmarks and one main content region per page.
- Keep native controls for actions and quiz options.
- Keep labels, focus, language semantics and mobile layout intact.
- Keep external links `target="_blank"` paired with `rel="noopener"`.
- Never expose secrets or introduce server-side persistence without product decision.

## Testing strategy

Use real local HTTP serving plus agent-browser for behavior. Static file checks cover every day page and quiz option semantics. Add regression assertions for confirmed bugs or new shared behavior; avoid tests that only mirror constants.

## Review

Review exact diff, connected PT/EN pages, shared quiz behavior and deployment config. Independent review is required for security headers, destructive deployment changes or broad content rewrites. Agents do not commit; coordinator integrates after checks.

## Security and inapplicable capabilities

Use the toolkit security prompt for read-only baseline or precise-diff review when scope warrants it. Keep reports private and redact environment details. Next.js, PostgreSQL, Drizzle, shadcn, Sentry and typed async lint do not apply to current static stack. Graphify is optional and not needed for current project size.
