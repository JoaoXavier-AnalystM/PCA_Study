# Architecture

## Actual stack

Static HTML, CSS and browser JavaScript served by Nginx in Docker. No framework, package manifest, backend process, database or ORM exists. Docker Compose exposes dev on `8082` and production on `8081`; public HTTPS termination is outside the container.

## Code map

```text
web/index.html       application shell, navigation, translations, homepage and mock exam
web/day1..day7.html  Portuguese study pages
web/day1..day7-en.html English study pages
web/day-quiz.js      shared quiz behavior for study pages
tests/               PowerShell regression checks using local HTTP and agent-browser
deploy/              Dockerfile, Nginx config and Compose files
.github/workflows/   validation, dev deploy and production deploy
```

## Boundaries and flow

Browser loads static assets from Nginx. Homepage JavaScript selects sections, fetches the selected day HTML, applies translations, stores local progress and renders the mock exam. Study pages load `day-quiz.js`; no server-side data flow exists.

## Data and deployment

No database. Browser-only state uses `localStorage` for language, theme, visited days and quiz progress. `deploy/Dockerfile` copies `web/` into Nginx. Dev workflow rebuilds `pca-study-dev` and checks `localhost:8082`; production follows `pca-study-prod` on `8081`.

## Decisions

- Preserve static architecture: product has no backend requirement, and framework migration would add scope and deployment risk.
- Keep bilingual pages as explicit files: current content and deployment are static; shared quiz logic remains in one JS file.
- Keep browser regression suite in PowerShell: it matches current Windows/Orca environment and proves real local navigation.

## Maintenance

Update this map when adding runtime dependencies, server boundaries, persistence, generated assets or deployment contracts.
