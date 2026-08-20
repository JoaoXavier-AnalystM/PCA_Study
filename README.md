# Prometheus Certified Associate (PCA) Study


## 📚 Sobre o Projeto

Este repositório foi criado para centralizar estudos, laboratórios práticos e materiais relacionados à certificação **Prometheus Certified Associate (PCA)**.

O objetivo é fornecer uma base sólida sobre:

* Observabilidade
* Monitoramento moderno
* Arquitetura do Prometheus
* Consultas PromQL
* Alertas
* Métricas
* Integração com Kubernetes
* Dashboards e visualização
* Boas práticas de monitoramento

---

## 🚀 O que você encontrará neste repositório

### 📖 Fundamentos

* Conceitos de Observabilidade
* Métricas, Logs e Traces
* Golden Signals
* RED Method
* USE Method

### ⚙️ Prometheus

* Arquitetura do Prometheus
* Instalação e configuração
* Targets e Scrape Jobs
* Service Discovery
* Exporters
* Pushgateway
* Alertmanager

### 🔎 PromQL

* Seletores
* Operadores
* Funções
* Agregações
* Quantiles
* Queries avançadas

Exemplo:

rate(http_requests_total[5m])

### 📊 Visualização

* Dashboards com Grafana
* Boas práticas de visualização
* Criação de painéis estratégicos

### ☸️ Kubernetes Monitoring

* Monitoramento de clusters
* kube-state-metrics
* node-exporter
* ServiceMonitor
* Integração com Prometheus Operator

---

## 🎯 Objetivo

Este projeto serve como:

* guia de estudos para PCA

---

## 📌 Conteúdo do Exame PCA

Os principais tópicos cobrados incluem:

* Observabilidade
* Arquitetura Prometheus
* Instalação e configuração
* Exporters
* PromQL
* Alertmanager
* Service Discovery
* Instrumentação
* Kubernetes Monitoring

---

## 🌐 Acesso ao Projeto

O conteúdo deste projeto está disponível online:

🔗 https://pca-guide.joaoxavier.app.br/ (prod) · https://pca-guide-dev.joaoxavier.app.br/ (dev)

O site reúne materiais de estudo, anotações e recursos voltados para a certificação Prometheus Certified Associate (PCA).

---

## 🐳 Containers

Dois containers na VPS, um por ambiente:

| Ambiente | Domínio | Container | Porta host | Deploy |
|----------|---------|-----------|-----------|--------|
| Prod | `pca-guide.joaoxavier.app.br` | `pca-study-prod` | `127.0.0.1:8081` | push em `main` (`deploy-prod.yml`) |
| Dev | `pca-guide-dev.joaoxavier.app.br` | `pca-study-dev` | `127.0.0.1:8082` | push em `dev` (`deploy-dev.yml`) |

```bash
# prod
docker compose up -d --build

# dev
docker compose -f docker-compose.dev.yml up -d --build
```

O nginx do host faz proxy para os dois containers (domínio prod → `8081`, domínio dev → `8082`).

**Setup único na VPS** — config completa do nginx host pronta em [`deploy/nginx-vps.conf`](deploy/nginx-vps.conf) (server blocks prod/dev com TLS e redirect HTTP→HTTPS). Copiar para `/etc/nginx/conf.d/pca-study.conf`, ajustar caminhos dos certificados e rodar `nginx -t && systemctl reload nginx`.

Certificados (uma vez): `certbot certonly --webroot -w /var/www/certbot -d pca-guide.joaoxavier.app.br -d pca-guide-dev.joaoxavier.app.br`

Rollback prod: `docker tag pca-study-prod:previous pca-study-prod:latest && docker compose up -d` (imagem anterior é preservada a cada deploy).

---

## 📖 Referências

- 📘 Prometheus – Documentação oficial  
  https://prometheus.io/docs/

- ☁️ Cloud Native Computing Foundation (CNCF) – Prometheus Project  
  https://www.cncf.io/projects/prometheus/

- 🧪 Laboratórios práticos  
  Experimentos e práticas com Prometheus, exporters, métricas e dashboards em ambientes de observabilidade.

- 📝 Simulados PCA (Prometheus Certified Associate)  
  Questões práticas baseadas no currículo oficial da Linux Foundation e CNCF para preparação do exame.

---