# PCA Study Guide

## Problem

Learners preparing for Prometheus Certified Associate (PCA) need one practical, bilingual study path covering observability, Prometheus architecture, PromQL, exporters, alerting and Kubernetes monitoring.

## Audience

Developers, SREs, platform engineers, sysadmins and observability learners preparing for PCA or building Prometheus fundamentals.

## Current product

- Static bilingual guide in Portuguese (`pt-BR`) and English (`en`).
- Homepage with certification overview, seven-day study track, quick reference, PromQL reference, mock exam and watch-outs.
- Seven direct study pages in PT/EN with content, links and quizzes.
- Responsive desktop/mobile interface with dark/light theme and local progress state.
- Dev and production Docker/Nginx deployments.

## Goals

- Make PCA concepts easy to navigate and review.
- Keep PT/EN content and interaction behavior consistent.
- Provide fast, accessible, dependency-light study experience.
- Prove changes with browser regression checks before deployment.

## Non-goals

- User accounts, server-side persistence, payments, exam registration or learning analytics.
- Replacing official CNCF/Linux Foundation material.
- Migrating static site to a framework or adding a database without separate approval.

## Constraints and acceptance

- Preserve static HTML/CSS/JS architecture and deployment contracts.
- Avoid credentials and external state in local tests.
- Keep production and dev deployment paths separate.
- `tests/qa-regressions.ps1 -Case all` must pass before changes are accepted.
