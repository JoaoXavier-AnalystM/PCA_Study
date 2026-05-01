# Prometheus Certified Associate (PCA) Study


## 📚 Sobre o Projeto

Este repositório foi criado para centralizar estudos, laboratórios práticos e materiais relacionados à certificação **Prometheus Certified Associate (PCA)** da Cloud Native Computing Foundation.

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
* laboratório prático de observabilidade
* referência para consultas PromQL
* portfólio DevOps/SRE/Observability Engineer

---

## 🏗 Estrutura do Repositório

```txt
.
├── 1-Introdução
├── 2-Conceitos-de-Observabilidade
├── 3-Fundamentos-Prometheus
├── detail
├── index.html
└── .github/workflows
```

---

## 🔥 CI/CD Automatizado

Este projeto utiliza:

* GitHub Actions
* Deploy automático para VPS
* Servidor web com Nginx
* Proxy/CDN com Cloudflare

Fluxo:

```txt
git push
   ↓
GitHub Actions
   ↓
Deploy automático no VPS
   ↓
Reload do Nginx
   ↓
Site atualizado automaticamente
```

---

## 🛠 Tecnologias Utilizadas

* Prometheus
* Grafana
* Nginx
* GitHub Actions
* Cloudflare
* Linux
* Docker
* Kubernetes

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

## 🌐 Deploy

O projeto é publicado automaticamente via pipeline CI/CD.

---

## 📖 Referências

* Documentação oficial do Prometheus
* Documentação oficial da Cloud Native Computing Foundation
* Laboratórios práticos
* Simulados PCA

---