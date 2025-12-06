# Spec Requirements: Configuração Base do Laravel 12

## Initial Description
Configuração Base do Laravel 12 com setup completo do ambiente de desenvolvimento, instalação de dependências, docker-compose com PostgreSQL e Redis, variáveis de ambiente (.env) e estrutura de pastas do projeto. Sistema de Gestão Agropecuária para gerenciamento integrado do ciclo de vida de bovinos e operações de fazenda.

## Requirements Discussion

### First Round Questions

**Q1:** Qual estrutura de domínio você prefere para organizar o código (DDD, Feature-Based ou Standard Laravel)?
**Answer:** Usuário quer conhecer as 3 opções principais com análise de escalabilidade para tomar a melhor decisão sem quebrar o Laravel no futuro.

**Q2:** Volumes do PostgreSQL no Docker devem usar bind mount (arquivo local)?
**Answer:** Sim, sempre com volume montado (bind mount) para persistência de dados.

**Q3:** Qual porta para o Nginx no ambiente de teste?
**Answer:** Porta 8080 para ambiente de teste.

**Q4:** Redis deve ser container separado?
**Answer:** Sim, container separado no docker-compose.

**Q5:** Seeders devem ser criados agora ou depois?
**Answer:** Deixar para criação posterior de cada item, não incluir nesta spec.

**Q6:** Qual IDE para configuração do Xdebug?
**Answer:** PhpStorm (gerar arquivo de configuração automático).

**Q7:** Logs devem ser salvos onde?
**Answer:** Arquivo apenas (não usar stdout).

### Existing Code to Reference
No similar existing features identified for reference. Esta é a configuração base inicial do projeto.

### Follow-up Questions

**Follow-up 1:** Estrutura de Domínio Recomendada
**Answer Contexto:** Baseado no tipo de projeto (Sistema de Gestão Agropecuária), na escalabilidade desejada e nas melhores práticas com Laravel 12.

## Visual Assets

### Files Provided:
No visual assets provided.

## Requirements Summary

### Estrutura de Domínio Recomendada

Após análise, a recomendação é **Feature-Based Architecture** com subdivisões por contexto de negócio. Eis a análise das 3 principais opções:

#### 1. **Standard Laravel (Recomendação: Não - limitada para este projeto)**
```
app/
├── Models/
├── Controllers/
├── Services/
└── Repositories/
```
- **Vantagens:** Familiaridade, documentação abundante, menos overhead inicial
- **Desvantagens:** Difícil de escalar em projetos grandes; modelos e controladores ficam muito grandes; difícil de manter contextos de negócio separados
- **Escalabilidade:** Baixa. Problemas começam com 50+ modelos/controladores

#### 2. **Domain-Driven Design - DDD (Recomendação: Muito complexo para MVP)**
```
src/
├── Domain/
│   ├── Cattle/
│   │   ├── Entities/
│   │   ├── ValueObjects/
│   │   └── Repositories/
│   └── Farm/
├── Application/
│   ├── DTO/
│   └── Services/
└── Infrastructure/
```
- **Vantagens:** Escalabilidade excelente; separação clara de domínios; facilita testes; alinhado com regras de negócio
- **Desvantagens:** Complexidade inicial alta; curva de aprendizado; pode ser overkill para MVP; quebra padrões Laravel convencionais
- **Escalabilidade:** Excelente. Suporta centenas de modelos e contextos complexos

#### 3. **Feature-Based Architecture (RECOMENDAÇÃO: Ideal para este projeto)**
```
app/
├── Features/
│   ├── Cattle/
│   │   ├── Models/
│   │   ├── Controllers/
│   │   ├── Services/
│   │   ├── Repositories/
│   │   ├── Requests/
│   │   ├── Resources/
│   │   └── database/
│   │       ├── migrations/
│   │       └── factories/
│   ├── Farm/
│   ├── Reproduction/
│   ├── HealthMonitoring/
│   └── Inventory/
├── Shared/
│   ├── DTOs/
│   ├── Enums/
│   ├── Traits/
│   └── Utilities/
└── Core/
    ├── Auth/
    └── Notifications/
```
- **Vantagens:**
  - Balance perfeito entre simplicidade e escalabilidade
  - Mantém padrões Laravel convencionais
  - Cada feature é semi-independente (facilita equipes)
  - Fácil navegar entre modelos relacionados
  - Migrations ficam próximas à feature
  - Simples para evoluir para DDD later se necessário
- **Desvantagens:** Requer mais disciplina de organização; não é padrão 100% Laravel mas é amplamente aceito
- **Escalabilidade:** Muito boa. Suporta 15+ features sem grandes problemas

#### **Justificativa da Recomendação: Feature-Based**

Este projeto é perfeito para Feature-Based porque:
1. **Domínios de Negócio Claros:** Gado, Reprodução, Saúde, Inventário são features naturais
2. **Crescimento Esperado:** MVP agora, mas com roadmap de expansão
3. **Time Distribuído:** Cada feature pode ser proprietária de um mini-time
4. **Manutenibilidade:** Fácil encontrar código relacionado (cattle + migrations + factories juntos)
5. **Preparado para o Futuro:** Se virar microserviços, cada feature já está isolada

### Configurações Técnicas Confirmadas

#### Docker & Docker Compose
- **Containers:** PHP/Laravel 8.2+, PostgreSQL 15+, Redis, Nginx
- **PostgreSQL:** Volume com bind mount (persistência local)
- **Redis:** Container separado
- **Nginx:** Porta 8080 para desenvolvimento
- **Arquivo:** docker-compose.yml configurado e pronto para `docker-compose up`

#### Variáveis de Ambiente (.env)
- Configuradas para Docker
- Database: PostgreSQL em `postgres` (service name)
- Redis: Em `redis` (service name)
- APP_URL: http://localhost:8080

#### Xdebug & Debugging
- IDE: PhpStorm
- Arquivo de configuração automático (php.ini ou Dockerfile)
- Integração com container PHP

#### Logging
- Formato: Arquivo (não stdout)
- Localização: `storage/logs/`
- Driver: 'single' ou 'daily'

#### Seeders
- **Não inclusos nesta spec**
- Serão criados posteriormente conforme necessidade de cada feature

### Functional Requirements
- Instalar Laravel 12 com PHP 8.2+
- Configurar docker-compose.yml com 4 containers (PHP, PostgreSQL, Redis, Nginx)
- Setup de arquivo .env para ambiente Docker
- Estruturar pasta raiz do projeto com Feature-Based Architecture
- Configurar Xdebug com PhpStorm
- Configurar logging em arquivo
- Gerar arquivo de configuração automático para Xdebug no PhpStorm

### Reusability Opportunities
- Estrutura Feature-Based permite reutilização de padrões entre features
- Pasta `app/Shared/` para código comum (DTOs, Enums, Traits, Utilities)
- Pasta `app/Core/` para funcionalidades transversais (Auth, Notifications)
- Docker Compose pode servir como base para produção (com Traefik adicionado)

### Scope Boundaries

**In Scope:**
- Instalação e configuração do Laravel 12
- Setup completo do docker-compose com 4 containers
- Arquivo .env configurado para Docker
- Estrutura de pastas Feature-Based
- Configuração de Xdebug para PhpStorm
- Configuração de logging em arquivo
- Documentação de como usar (README com comandos Docker)

**Out of Scope:**
- Criação de seeders (será feito posteriormente)
- Configuração de CI/CD (GitHub Actions, etc)
- Configuração de Traefik (apenas Nginx nesta etapa)
- Implementação de features específicas (Cattle, Farm, etc)
- Testes automatizados (será feito em specs posteriores)
- Deployment em produção

### Technical Considerations
- Laravel 12 com PHP 8.2+ é requisito
- PostgreSQL 15+ (não usar MySQL)
- Redis para cache e queue
- Nginx como reverse proxy (porta 8080)
- Docker volumes para persistência de dados
- Xdebug para debugging com PhpStorm
- Sistema de logs em arquivo para desenvolvimento

### Architecture Pattern Chosen
**Feature-Based Architecture** com a seguinte estrutura:
```
app/
├── Features/
│   ├── Cattle/
│   ├── Farm/
│   ├── Reproduction/
│   ├── HealthMonitoring/
│   └── Inventory/
├── Shared/ (código reutilizável entre features)
├── Core/ (funcionalidades transversais)
└── [padrão Laravel padrão para config, etc]
```

Esta escolha oferece o melhor balanço entre simplicidade, escalabilidade e manutenibilidade para este projeto de Gestão Agropecuária.

## Requisitos Futuros Documentados

### 1. pg-vector (MVP 7 - Integrações Avançadas)

**Intenção:** Integração com modelos de IA para análise preditiva e busca semântica

**Descrição:**
- Extensão PostgreSQL para vetores de alta dimensão
- Permitirá armazenar e buscar embeddings de IA (análise de imagens de animais, textos descritivos, etc)
- Viabilizará funcionalidades como:
  - Busca semântica de registros de animais por similaridade
  - Análise preditiva de saúde com base em padrões históricos
  - Recomendações automáticas baseadas em similaridade de dados

**Status:** A ser adicionado quando necessário (custo mínimo de implementação)

**Estimativa de Complexidade:** Baixa - apenas adicionar extensão ao PostgreSQL e criar tabelas com coluna `vector`

**Roadmap Esperado:** MVP 7 ou posteriores, após consolidação do sistema base

---

### 2. WhatsApp Bot Integration (MVP 7 - Integrações Avançadas)

**Intenção:** Integração com WhatsApp Business API para coleta de dados via conversas

**Descrição:**
- Bot que recebe dados através da WhatsApp Business API
- Funcionalidades principais:
  - Receber fotos de animais para análise e registro
  - Receber textos descritivos de condições dos animais
  - Enviar dados diretamente para o sistema via webhook
  - Retornar feedback/confirmação para o usuário via WhatsApp

**Arquitetura Proposta:**
- Integração com WhatsApp Business API
- Orquestração de fluxos com n8n (automação de workflows)
- Webhooks para sincronização com o sistema principal

**Fluxo de Dados:**
```
WhatsApp → WhatsApp Business API → n8n (orquestração) → Laravel App (webhook) → Database
```

**Status:** A ser pensado e especificado posteriormente em detalhe

**Estimativa de Complexidade:** Média-Alta - requer coordenação entre múltiplos sistemas

**Dependências:**
- WhatsApp Business API (aprovação e setup)
- n8n instalado e configurado
- Endpoints de webhook no Laravel

**Roadmap Esperado:** MVP 7 ou posteriores, após consolidação das funcionalidades core

---

### Justificativa de Posterioridade

Ambas as integrações foram documentadas aqui porque:

1. **Não impedem o MVP atual:** O sistema de Gestão Agropecuária funciona plenamente sem elas
2. **Agregam valor futuro:** Quando implementadas, agradecem significativamente a experiência do usuário
3. **Requerem aprovação/setup externo:** Especialmente WhatsApp Business API requer processo de aprovação
4. **Podem evoluir:** O roadmap pode revelar novas necessidades antes da implementação
5. **Custo operacional:** pg-vector tem custo mínimo; WhatsApp requer investimento em orquestração n8n
