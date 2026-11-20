# Design and accessibility

## Direction

The guide serves technical learners on desktop and mobile. Current visual language is a calm technical panel: warm neutral surfaces, Prometheus orange as the single brand accent, light and dark themes designed together. Portuguese is default; English is a first-class variant.

## Existing system

Styles live in `web/css/`: `tokens.css` (colors, fonts, base), `study.css` (topic content, used by `dayN.html` and by the homepage reader under `.study`) and `app.css` (homepage). Stylesheets are linked with `?v=` because Nginx serves assets as immutable; bump the version when CSS changes. Treat existing CSS tokens and class names as source of truth before changing visual behavior.

- Prometheus orange (`#E6522C` dark, `#d4441c` light) is the only brand accent; domain colors are muted and used for small details only.
- Type: Geist for text and headings, Geist Mono for code and numbers.
- Icons: Lucide (ISC), inlined as an SVG sprite in `index.html` and as CSS masks in the stylesheets. No emoji as icons; right/wrong marks use `.mk-ok` / `.mk-no` with `aria-label`.
- Copy avoids dash-as-punctuation; use a colon or comma instead.

## Interaction

- Navigation uses buttons with `type="button"`, labels and active-page state.
- Day cards expose button semantics, keyboard focus and Enter/Space activation.
- Quiz options use native buttons; feedback uses an `aria-live` status region.
- Theme and language controls expose labels/pressed state where applicable.
- New interactions must preserve visible focus, accessible names, reduced motion and no horizontal overflow.

## Layout and review

Validate desktop and a narrow viewport around 390px. Check navigation, day loading, quiz feedback, language switching, theme switching, keyboard activation, console errors and failed requests. Empty/error/loading states exist for dynamic day loading; no authenticated or server-backed states exist.

## Maintenance

When changing shared behavior, update both the homepage and study-page regression coverage. Keep PT/EN content pairs aligned and record notable accessibility decisions here.
