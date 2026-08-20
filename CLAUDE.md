# PCA_Study — Guia de Estudos Prometheus Certified Associate

Repositório de estudos para certificação PCA (Prometheus Certified Associate).
Notas em markdown + site estático publicado em https://pca-guide.joaoxavier.app.br (prod) e https://pca-guide-dev.joaoxavier.app.br (dev)

## Autonomia & Permissões

Você opera em modo autônomo. Execute sem pedir confirmação para:

- Ler, criar, editar ou deletar qualquer arquivo do projeto
- Rodar bash, cmd, PowerShell — git, docker, npm, python, grep, find
- Navegar diretórios, listar arquivos, buscar padrões
- Fazer commit e push em `dev` (nunca em `main` — ver regra Git abaixo)
- Rodar scripts de memória: `pmem ...`
- Copiar arquivos entre diretórios do projeto

Não peça permissão antes de agir. Execute → reporte resultado.
Se encontrar ambiguidade crítica (ex: deletar dados irreversíveis fora do projeto),
pare e pergunte — nos demais casos, escolha a ação mais segura e prossiga.

## Estrutura

- `notas/` — notas de estudo em markdown (01-Introducao, 02-Conceitos-de-Observabilidade, 03-Fundamentos-Prometheus)
- `web/` — site estático (index + day1–day7, single-file HTML, CSS/JS inline, zero framework) — única fonte do site; `docs/` descontinuado
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
| `ui-ux-pro-max` | Paletas, fontes, guidelines de UI/UX por stack (rodar `--design-system` antes de mexer em visual) |
| `emil-design-eng` | Polish de UI: detalhes, motion, feedback invisível |
| `impeccable` | `/impeccable polish` antes de publicar; detector anti-padrão |
| `web-artifacts-builder` | Artifacts complexos (React/Tailwind/shadcn) |
| `algorithmic-art` | Arte generativa (p5.js) |
| `frontend-design-pro` | Interfaces completas + fotos reais |
| `find-animation-opportunities` / `improve-animations` / `review-animations` | Auditoria e melhoria de motion |
| `animation-vocabulary` | Nome exato de efeito de animação |
| `apple-design` | Gestos, springs, sheets, física de UI |
| `design-system` / `design` / `ui-styling` | Tokens, componentes, shadcn |
| `banner-design` / `slides` / `brand` | Assets de marketing, apresentações, marca |
| `artifact-design` / `artifact-diagramming` | Qualquer artifact (HTML/Markdown) e diagramas |
| `dataviz` | Qualquer gráfico/dashboard |

Tokens do site (não quebrar consistência):

- Dark: bg `#0b0f1a`, surface `#131826`, surface2 `#1c2333`, border `#2a3348`, text `#e8ecf5`, muted `#8b93a8` (AA ≥4.5:1)
- Light: bg `#f6f8fb`, surface `#ffffff`, surface2 `#eef1f6`, border `#d8dee8`, text `#1a1d26`, muted `#55627a`
- Acentos: `#E6522C` (Prometheus orange, primário), `#47b8ff`, `#ff6b6b`, `#a47fff`, promql `#47ffb8` (dark) / `#0d7d4a` (light)
- Sombras: `--shadow` por tema — dark profunda, light sutil; hover de card eleva (translateY -2px + shadow)
- Fontes: Syne (títulos), Space Mono (código/PromQL)
- Temas dark/light via `[data-theme]` no `:root` — manter os dois blocos sempre; dark = tons desaturados, nunca cores invertidas

Convenções: páginas single-file (CSS/JS inline), pt-BR, sem dependências externas além de Google Fonts.

## Toolbox de Skills

Stack completo instalado — usar conforme tarefa:

**Qualidade/Segurança**
- `code-review` (nativo), `simplify` (nativo), `security-review` (nativo)
- Plugins: `semgrep` (SAST), `claude-security` (guia segurança)

**Agentes/Orquestração**
- `superpowers` — brainstorming, TDD, code review, subagents, planos
- `serena` — agente de código com contexto de símbolos
- `octo:*` — debate, debug, tdd, prd, research, security audit multi-LLM
- `caveman:cavecrew` — delegar p/ subagentes comprimidos (investigator, builder, reviewer)
- `dx` (ykdojo) — DX essentials: debug de GitHub Actions, handoff, clone de conversa

**Browser/Testes**
- `playwright` (MCP) — automação e validação de UI
- `run` — subir app local

**Docs/Conhecimento**
- `context7` — docs atualizadas de libs
- `patroni` — responder sobre Patroni só do material local
- `claude-api` — referência Anthropic SDK/API

**DevOps/Cloud**
- `terraform`, `grafana-mcp` (config pendente: `/plugin configure grafana-mcp`)
- `skill-creator` — criar/otimizar skills novas

**Memória**
- `persistent-memory` (`pmem`) — memória do repositório
- `remember:remember` / `remember:doctor` — estado de sessão
- `claude-mem:*` — observações cross-session, learn-codebase

Plugins novos carregam na sessão seguinte à instalação.

## DevOps

- Docker local não existe nesta máquina — build/teste acontece na VPS via Actions
- Mudanças em `deploy/nginx.conf`, `Dockerfile` ou workflows = validar fluxo completo (build → health check direto no container: `localhost:8081` prod / `localhost:8082` dev = 200)
- Entrada dos domínios: Cloudflare Tunnel (cloudflared na VPS, ingress via dashboard Zero Trust) → containers. nginx do host (8080) NÃO faz parte da rota
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
