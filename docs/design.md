# Design and accessibility

## Direction

The guide serves technical learners on desktop and mobile. Current visual language is a dark observability dashboard with amber/green accents, monospace technical labels and a light-theme alternative. Portuguese is default; English is a first-class variant.

## Existing system

Styles and component rules are embedded in page HTML, with shared visual patterns repeated across static pages. Nginx serves Google Fonts and local badge/favicon assets. Treat existing CSS tokens and class names as source of truth before changing visual behavior.

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
