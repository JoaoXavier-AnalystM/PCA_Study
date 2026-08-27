# PCA_Study — Guia de Estudos Prometheus Certified Associate

Repositório de estudos para certificação PCA (Prometheus Certified Associate).
Notas em markdown + site estático (prod e dev, URLs no README).

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

- `notas/` — notas de estudo em markdown
- `web/` — site estático (index + day1–day7 + day1–7-en, single-file HTML, CSS/JS inline, zero framework) — única fonte do site; `docs/` descontinuado
- `deploy/` — config do container
- `PCA_Curriculum.pdf` — currículo oficial do exame

## Stack & Deploy

- Site: HTML estático puro, uma página por arquivo, sem build step
- Container nginx (Dockerfile + docker-compose.yml)
- Pipeline: push em `main` → `deploy-prod.yml`; push em `dev` → `deploy-dev.yml`
- Detalhes de infra (ports, VPS, secrets, tunnel) ficam no CLAUDE.md local — NÃO publicar no repo

## Git

- **Regra fixa**: commits em `dev` → pode subir (push) direto. Commits em `main` → **somente o usuário faz**; nunca commitar nem dar push direto em `main`. Mudanças em `main` só via PR mergeado pelo usuário.
- Branch protection: `main` exige PR (admins têm bypass)
- Fluxo: branch `dev` → PR → merge em `main`
- Commits em pt-BR, curtos e descritivos (1 linha; corpo só se o porquê não for óbvio)
- Nunca commitar `.claude/`, `.remember/`, `.impeccable/`, `.playwright-mcp/` (ver `.gitignore`)

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
- Fontes: Bricolage Grotesque (títulos), Inter (corpo), Space Mono (código/PromQL)
- Temas dark/light via `[data-theme]` no `:root` — manter os dois blocos sempre; dark = tons desaturados, nunca cores invertidas
- Site bilingue PT/EN: toggle no menu lateral (`pca_lang` no localStorage), dicionário `I18N` no script do index, fichas `dayN-en.html` — qualquer texto novo precisa de chave `data-i18n` nos dois idiomas

Convenções: páginas single-file (CSS/JS inline), pt-BR, sem dependências externas além de Google Fonts.

## Toolbox de Skills

Stack completo instalado — usar conforme tarefa:

**Qualidade/Segurança**
- `code-review` (nativo), `simplify` (nativo), `security-review` (nativo)

**Agentes/Orquestração**
- `superpowers` — brainstorming, TDD, code review, subagents, planos
- `octo:*` — debate, debug, tdd, prd, research, security audit multi-LLM
- `caveman:cavecrew` — delegar p/ subagentes comprimidos
- `dx` (ykdojo) — DX essentials: debug de GitHub Actions, handoff

**Browser/Testes**
- `playwright` (MCP) — automação e validação de UI

**Docs/Conhecimento**
- `context7` — docs atualizadas de libs
- `patroni` — responder sobre Patroni só do material local

**Memória**
- `persistent-memory` (`pmem`) — memória do repositório

Plugins novos carregam na sessão seguinte à instalação.

## DevOps

- Docker local não existe nesta máquina — build/teste acontece na VPS via Actions
- Mudanças em `deploy/`, `Dockerfile` ou workflows = validar fluxo completo (build → health check no container = 200)
- Health check do deploy faz 5 tentativas com retry de 2s

## Programming

- Sem backend — projeto é conteúdo + site estático
- Edições em `web/*.html`: preservar estrutura single-file, temas e i18n (toda string visível precisa de chave PT+EN)
- Antes de commit em página: validar HTML (grep `<html>`, `</html>`, `<body>`, `</body>` — mesma checagem do CI)
- PromQL em exemplos: sempre dentro de blocos de código, sem aspas de terminal
