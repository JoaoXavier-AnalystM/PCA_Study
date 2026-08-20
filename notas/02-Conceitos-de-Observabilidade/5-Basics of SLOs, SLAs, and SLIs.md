# Fundamentos do SRE: SLIs, SLAs e SLOs

O conceito de SRE começa com a ideia de que as métricas devem estar intimamente ligadas aos objetivos de negócios. Utilizamos várias ferramentas essenciais—SLO, SLA e SLI—in planeamento e prática de SRE.

## Definição dos termos de engenharia de confiabilidade do site

## 1. Objetivo de Nível de Serviço (SLO)

É um acordo entre o provedor e o cliente sobre métricas mensuráveis, como disponibilidade, capacidade de resposta e responsabilidades.

Em geral, esses acordos são elaborados pelas equipes novas de negócios e jurídicas de uma empresa e representam as promessas que você faz aos clientes e as consequências se você não cumpri-las. As consequências incluem penalidades financeiras, créditos de serviço ou extensões de licença.

### Quem precisa de SLA?

Um SLA é um acordo entre um fornecedor e um cliente pagante. É improvável que as empresas que prestam serviço gratuito aos usuários queiram ou precisem de um SLA para esses usuários gratuitos.


## 2. Acordo de Nível de Serviço (SLA)

É um acordo dentro de um SLA sobre uma métrica específica, como disponibilidade ou tempo de resposta. Portanto, se o SLA for o acordo formal entre você e o cliente, os SLOs são as promessas individuais que você faz a esse cliente. Os SLOs são o que definem as expectativas do cliente e dizem às equipes de TI e DevOps quais metas precisam atingir e considerar como referência.

### Quem precisa de SLOs?
Quando os SLAs só forem relevantes no caso de clientes pagantes, os SLOs podem ser úteis para contas pagas e não pagas, bem como para clientes internos e externos.

Sistemas internos, como CRMs, repositórios de dados do cliente e intranet, podem ser tão importantes quanto os sistemas voltados para o público externo


## 3. Indicador de nível de serviço (SLI)

mede a conformidade com o SLO (objetivo de nível de serviço). Assim, por exemplo, se o SLA especificar que os sistemas vão estar disponíveis 99,95% do tempo, é provável que o SLO vá ter 99,95% de disponibilidade, e o SLI é a medição real da disponibilidade. Talvez seja 99,96%. Talvez 99,99%. Para se manter em conformidade com o SLA, o SLI vai precisar cumprir ou superar as promessas feitas nesse documento.

### Quem precisa de SLIs?
Qualquer empresa que faça medição do desempenho em relação aos SLOs precisa de SLIs para fazer essas medições. Não é possível ter SLOs sem SLIs.

## Links de Artigos

[Fundamentos do SRE](https://cloud.google.com/blog/products/devops-sre/sre-fundamentals-slis-slas-and-slos)
