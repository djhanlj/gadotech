# Raw Idea - Configuração Base do Laravel 12

## Tarefa
Configuração Base do Laravel 12

## Descrição
Configurar ambiente de desenvolvimento com Laravel 12, instalação de dependências, setup do docker-compose com PostgreSQL e Redis, variáveis de ambiente e estrutura de pastas do projeto.

## Requisitos Específicos
- Utilizar **Docker e Docker Compose** para orquestração de serviços
- Containers necessários: PHP/Laravel, PostgreSQL 15+, Redis, Nginx
- Arquivo docker-compose.yml configurado e pronto para desenvolvimento
- Variáveis de ambiente (.env) configuradas para Docker
- Nginx para servir a aplicação (em produção será utilizado Traefik para gerenciar HTTPS)

## Contexto do Produto
Sistema de Gestão Agropecuária - plataforma web para gerenciamento integrado do ciclo de vida de bovinos e operações de fazenda.

## Tech Stack
- Backend: Laravel 12 com PHP 8.2+
- Frontend: Inertia.js + Vue.js 3
- Banco de Dados: PostgreSQL 15+
- Cache: Redis
- Web Server: Nginx (desenvolvimento), Traefik (produção - HTTPS)
- Container: Docker/Docker Compose
- Autenticação: Dual (web com cookies, mobile/API com JWT)
