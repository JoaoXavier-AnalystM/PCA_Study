# PCA Notes

Guia de estudos para a certificação **Prometheus Certified Associate (PCA)**. Reúne notas, referências, exemplos e questões para quem quer aprender observabilidade e monitoramento com Prometheus.

O conteúdo está disponível em **português e inglês**, com navegação adaptada para computador e celular.

## Acesso

- **Produção:** [pca-notes.jxops.com.br](https://pca-notes.jxops.com.br/)
- **Desenvolvimento:** [pca-notes-dev.jxops.com.br](https://pca-notes-dev.jxops.com.br/)

## O que você encontra

- **Trilha de estudos:** sete tópicos que vão dos fundamentos à revisão para a prova.
- **Fichas de estudo:** explicações, exemplos de PromQL e questões de revisão.
- **Simulado:** questões de múltipla escolha com respostas comentadas e filtros por domínio.
- **Referência rápida:** resumo dos principais conceitos, operadores e funções.
- **Progresso local:** tópicos revisados e respostas ficam salvos no navegador.
- **Preferências:** alternância entre temas claro e escuro e entre português e inglês.

## Trilha de estudos

| Tópico | Conteúdo |
| --- | --- |
| 1 | Observabilidade e fundamentos do Prometheus |
| 2 | PromQL básico: seletores, funções e agregações |
| 3 | PromQL avançado: operadores, histogramas e consultas |
| 4 | Instrumentação e exporters |
| 5 | Alertas, Alertmanager e dashboards |
| 6 | Simulado completo e revisão |
| 7 | Revisão rápida e preparação para o dia da prova |

## Assuntos abordados

- Métricas, logs, traces, SLI, SLO e SLA.
- Arquitetura do Prometheus, coleta de métricas e service discovery.
- Modelo de dados, labels, tipos de métricas e consultas PromQL.
- Bibliotecas de instrumentação, exporters e boas práticas de métricas.
- Regras de alerta, Alertmanager, Grafana e monitoramento em Kubernetes.

## Estrutura do repositório

```text
web/                 Site e fichas de estudo em português e inglês
notas/               Anotações e imagens de apoio
deploy/              Configuração do Nginx e containers
tests/               Verificações de regressão
PCA_Curriculum.pdf   Currículo do exame
```

O site é estático, feito com HTML, CSS e JavaScript. As preferências e o progresso são armazenados no navegador, sem cadastro.

## Referências

- [Documentação do Prometheus](https://prometheus.io/docs/)
- [Projeto Prometheus na CNCF](https://www.cncf.io/projects/prometheus/)
- [Certificação PCA — Linux Foundation](https://training.linuxfoundation.org/certification/prometheus-certified-associate/)
