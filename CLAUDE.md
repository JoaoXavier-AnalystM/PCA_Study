# PCA_Study — Guia de Estudos Prometheus Certified Associate

Repositório de estudos para certificação PCA (Prometheus Certified Associate).
Notas em markdown + site estático publicado em https://pca-guide.joaoxavier.app.br (prod) e https://pca-guide-dev.joaoxavier.app.br (dev)

## Estrutura

- `1_Introdução/`, `2-Conceitos de Observabilidade/`, `3-Fundamentos Prometheus.md/` — notas de estudo
- `web/` — site estático (index + day1–day7, single-file HTML, CSS/JS inline, zero framework)
- `docs/` — cópia independente do index (não sincronizar automaticamente com `web/`)
- `deploy/` — nginx.conf do container
- `PCA_Curriculum.pdf` — currículo oficial do exame

## Stack & Deploy

- Site: HTML estático puro, uma página por arquivo, sem build step
- Container: nginx:1.27-alpine (Dockerfile + docker-compose.yml)
- **Dois containers sempre**: `pca-study-prod` (`127.0.0.1:8081`, domínio pca-guide.joaoxavier.app.br) e `pca-study-dev` (`127.0.0.1:8082`, domínio pca-guide-dev.joaoxavier.app.br)
- Pipeline: push em `main` → `deploy-prod.yml`; push em `dev` → `deploy-dev.yml`; ambos SCP p/ VPS → `docker compose build --pull && up -d`
- Rollback prod: `docker tag pca-study-prod:previous pca-study-prod:latest && docker compose up -d`
- Secrets Actions: `VPS_HOST`, `VPS_USER`, `VPS_SSH_KEY`

## Git

- **Regra fixa**: commits em `dev` → pode subir (push) direto. Commits em `main` → **somente o usuário faz**; nunca commitar nem dar push direto em `main`. Mudanças em `main` só via PR mergeado pelo usuário.
- Branch protection: `main` exige PR (admins têm bypass)
- Fluxo: branch `dev` → PR → merge em `main`
- Commits em pt-BR, curtos e descritivos (ex: `Ajuste div(titulo-topicos)`)
- Nunca commitar `.claude/`, `.remember/`, `.impeccable/` (ver `.gitignore`)

## Design

Skills de design disponíveis e quando usar cada uma:

| Skill | Quando usar |
|-------|-------------|
| `design-taste-frontend` | Landing pages, portfolios, redesigns — direção anti-slop |
| `ui-ux-pro-max` | Paletas, fontes, guidelines de UI/UX por stack |
| `emil-design-eng` | Polish de UI: detalhes, motion, feedback invisível |
| `impeccable` | `/impeccable polish` antes de publicar; detector anti-padrão |
| `web-artifacts-builder` | Artifacts complexos (React/Tailwind/shadcn) |
| `algorithmic-art` | Arte generativa (p5.js) |

Tokens do site (não quebrar consistência):

- Dark: bg `#0a0c10`, surface `#111318`, text `#e8eaf0`, muted `#6b7280`
- Acentos: `#E6522C` (Prometheus orange, primário), `#47b8ff`, `#ff6b6b`, `#a47fff`
- Fontes: Syne (títulos), Space Mono (código/PromQL)
- Temas dark/light via `[data-theme]` no `:root` — manter os dois blocos sempre

Convenções: páginas single-file (CSS/JS inline), pt-BR, sem dependências externas além de Google Fonts.

## DevOps

- Docker local não existe nesta máquina — build/teste acontece na VPS via Actions
- Mudanças em `deploy/nginx.conf`, `Dockerfile` ou `deploy.yml` = validar fluxo completo (build → health check `http://localhost:8080` = 200)
- Observabilidade: plugins `grafana-mcp` (config pendente: `/plugin configure`), `terraform` para IaC
- Health check do deploy faz 5 tentativas com retry de 2s

## Programming

- Sem backend — projeto é conteúdo + site estático
- Edições em `web/*.html`: preservar estrutura single-file e temas
- Antes de commit em página: validar HTML (grep `<html>`, `</html>`, `<body>`, `</body>` — mesma checagem do CI)
- PromQL em exemplos: sempre dentro de blocos de código, sem aspas de terminal

## Memória

- Memória persistente: `pmem` (`python C:/Users/joaox/.claude/skills/persistent-memory/scripts/memory.py <comando>`)
- Buscar contexto antes de tarefa grande: `pmem search "<tema>" --limit 8`

## Comandos rápidos

```bash
# container (só na VPS, não há docker local)
docker compose up -d --build

# memória
pmem search "prometheus" --limit 8
pmem add "<fato durável>" --tags "tema" --source "assistant"
```
