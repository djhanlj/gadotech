# Especificação: Configuração Base do Laravel 12

## Objetivo

Estabelecer ambiente de desenvolvimento completo e pronto para produção com Laravel 12, Docker Compose orquestrando 5 serviços (PHP, PostgreSQL, Redis, Nginx, Mailhog), estrutura Feature-Based Architecture, variáveis de ambiente configuradas e ferramentas de desenvolvimento integradas (Xdebug, Telescope, Pint, PHPStan).

## Histórias de Usuário

- Como desenvolvedor, quero subir todo o ambiente com um único comando (`docker-compose up`) para começar a trabalhar imediatamente
- Como arquiteto, quero uma estrutura de código organizada por features que permita escalar com múltiplos domínios de negócio sem degradação de manutenibilidade
- Como desenvolvedor backend, quero debugar código em tempo real usando Xdebug integrado ao PhpStorm para diagnosticar problemas rapidamente

## Requisitos Específicos

**Estrutura Feature-Based Architecture**
- Padrão organizacional `app/Features/{NomeFuncionalidade}/` com subpastas: Models, Controllers, Services, Repositories, Requests, Resources, database (migrations, factories, seeders)
- Pasta `app/Shared/` para código reutilizável entre features: DTOs, Enums, Traits, Utilities
- Pasta `app/Core/` para funcionalidades transversais: Auth, Notifications, Middleware
- Permitir que cada feature seja semi-independente, facilitando trabalho em paralelo entre times
- Documentar estrutura em arquivo `STRUCTURE.md` na raiz do projeto com exemplos claros de organização

**Containers Docker Configurados**
- Service PHP/Laravel 8.2+ com Composer instalado, extensões necessárias (pgsql, redis, mbstring)
- Service PostgreSQL 15+ com volume bind mount em `./storage/postgres` para persistência local de dados
- Service Redis separado para cache e sessions, acessível em `redis:6379`
- Service Nginx na porta 8080 respondendo como reverse proxy para aplicação Laravel
- Service Mailhog na porta 1025 (SMTP) e 8025 (dashboard web) para captura de emails em desenvolvimento

**Variáveis de Ambiente**
- Arquivo `.env` configurado especificamente para Docker com APP_URL=http://localhost:8080
- Arquivo `.env.example` como template com placeholders comentados para fácil onboarding
- Arquivo `.env.testing` para ambiente de testes com banco separado `app_testing`
- Todos os serviços Docker acessíveis por nome (postgres, redis, mailhog) ao invés de localhost

**Scripts de Inicialização e Migrations**
- Arquivo `docker/entrypoint.sh` que executa: composer install, php artisan migrate, php artisan cache:clear
- Migrations executadas automaticamente ao subir containers
- Seeding de dados deixado para especificações futuras de features específicas
- Arquivo `.dockerignore` para evitar copiar arquivos desnecessários

**Ferramentas de Desenvolvimento**
- Xdebug pré-configurado no Dockerfile com `xdebug.mode=debug` e `xdebug.client_host=host.docker.internal`
- Arquivo `PhpStorm.xml` (ou equivalente) com configuração automática de Xdebug para conexão remota
- Laravel Telescope instalado e acessível em `/telescope` para monitoramento de requisições, queries, logs
- Pint (Laravel code formatter) instalado como dev-dependency com configuration padrão
- PHPStan nível 8 instalado com phpstan.neon para análise estática de código

**Logs em Arquivo**
- Driver de log configurado como `single` ou `daily` em `config/logging.php`
- Diretório `storage/logs/` criado com permissões adequadas (775)
- Logs salvos apenas em arquivo, não em stdout
- Formato de log estruturado com timestamps e níveis de severidade

## Requisitos Técnicos

**Feature-Based Architecture**
- Estrutura de diretórios: `app/Features/{Feature}/Models/`, `Controllers/`, `Services/`, `Repositories/`, `Requests/`, `Resources/`, `database/migrations/`, `database/factories/`
- Namespace PSR-4: `App\Features\NomeFuncionalidade\`
- Pasta compartilhada: `app/Shared/DTOs/`, `Enums/`, `Traits/`, `Utilities/`
- Pasta transversal: `app/Core/Auth/`, `Notifications/`, `Middleware/`
- Manter compatibilidade com padrão Laravel (routes, config, etc na raiz de app)

**Docker Compose com 5 Serviços**
- `docker-compose.yml` na raiz do projeto com versão 3.8+
- Service `php` (8.2+): porta interna 9000, volumes em `./app`, `./storage`, `./bootstrap/cache`
- Service `postgres` (15+): porta 5432, volume em `./storage/postgres`, variáveis DB_HOST=postgres, DB_PASSWORD via .env
- Service `redis` (7+): porta 6379, sem volume persistente (cache ephemeral), acessível como REDIS_HOST=redis
- Service `nginx`: porta 8080 externa → 80 interna, volume de configuração em `./nginx/conf.d/`
- Service `mailhog`: SMTP na 1025, web na 8025, sem volume persistente

**PostgreSQL com Volume Bind Mount**
- Volume local em `./storage/postgres` para persistência entre restarts
- Conexão string: `postgresql://user:password@postgres:5432/app`
- Banco de dados padrão: `app`
- Banco de testes: `app_testing` (criado em .env.testing)
- Inicialização automática via docker-compose com POSTGRES_DB e POSTGRES_USER

**Redis como Serviço Separado**
- Conectado ao Laravel via `config/cache.php` com driver redis
- Sessions configuradas em `config/session.php` para usar Redis (driver=redis)
- Suporta balanceamento de carga futuro mantendo sessions em cache distribuído
- Sem autenticação por padrão (desenvolvimento local)

**Nginx na Porta 8080**
- Arquivo de configuração em `nginx/conf.d/app.conf`
- Proxy reverso para PHP-FPM em `php:9000`
- Servir `public/` como document root
- Suportar rewrite de URLs para Laravel (todos requests → index.php exceto assets)

**Xdebug Pré-configurado para PhpStorm**
- Modo debug habilitado no Dockerfile: `RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini`
- Remote host: `xdebug.client_host=host.docker.internal` (macOS/Windows) ou detectar host (Linux)
- Porta de escuta: 9003
- Auto-start desabilitado (deve clicar "Start Listening" no PhpStorm)
- Arquivo de configuração PhpStorm exportado para `.idea/runConfigurations/Xdebug.xml`

**Logs Estruturados em Arquivo**
- Driver single: `storage/logs/laravel.log`
- Ou driver daily: `storage/logs/laravel-YYYY-MM-DD.log`
- Permissões: 0644 para leitura/escrita
- Limpeza automática de logs antigos (>14 dias) via artisan command

## Arquivos a Serem Criados

**docker-compose.yml**
- Configuração completa de 5 serviços com variáveis de ambiente reutilizáveis
- Volumes para persistência e desenvolvimento (bind mounts)
- Health checks para serviços críticos (postgres, redis)
- Dependência entre serviços (php depende de postgres e redis)

**.env.example**
- Template com todas as variáveis necessárias
- Valores comentados para facilitar setup
- Incluir: APP_KEY, APP_URL, DB_*, REDIS_*, MAIL_*, CACHE_*

**.env.testing**
- Variáveis específicas para testes
- DB_DATABASE=app_testing
- APP_DEBUG=true
- CACHE_DRIVER=array
- SESSION_DRIVER=array

**Dockerfile**
- Base: `php:8.2-fpm-alpine` ou `php:8.2-fpm-debian`
- Instalar extensões: pgsql, redis, mbstring, json, bcmath, ctype, fileinfo, tokenizer, xml
- Instalar Composer via script oficial
- Copiar código da aplicação
- Executar `composer install --no-interaction --no-progress`
- Configurar Xdebug no php.ini
- Entrypoint: `/bin/sh docker/entrypoint.sh`

**nginx/conf.d/app.conf**
- Server block escutando na porta 80
- Proxy para `http://php:9000` via FastCGI
- Document root em `/var/www/html/public`
- Rewrite para index.php (padrão Laravel)
- Gzip compression habilitado

**docker/entrypoint.sh**
- Script shell que executa na inicialização do container PHP
- Passos: composer install, php artisan migrate, php artisan cache:clear, php artisan optimize
- Executável: `chmod +x docker/entrypoint.sh`

**.dockerignore**
- Excluir: `.git`, `.env.local`, `storage/logs/*`, `node_modules`, `.vscode`, `.idea`

**STRUCTURE.md**
- Documentação da Feature-Based Architecture
- Exemplos de criação de nova feature
- Diagrama de estrutura de pastas
- Convenções de namespace
- Guia de reutilização de código em Shared/

**PhpStorm.xml (ou .idea/runConfigurations/Xdebug.xml)**
- Configuração automática de Xdebug no PhpStorm
- Incluir: Host (localhost), Port (9003), Debugger (Xdebug)
- Debug listener configurado para porta 9003

## Configurações Específicas

**Feature-Based Structure**
- Path base: `app/Features/{Feature}/`
- Exemplos de features iniciais: Cattle, Farm, Reproduction, HealthMonitoring, Inventory (estrutura, sem implementação)
- Namespace: `App\Features\Cattle\Models\Cattle`, `App\Features\Cattle\Controllers\CattleController`, etc
- Migrations em: `database/migrations/` (padrão Laravel) com naming: `YYYY_MM_DD_HHMMSS_create_cattle_table`
- Factories em: `database/factories/` (padrão Laravel)

**PostgreSQL Volume Bind Mount**
- Local: `./storage/postgres/` na raiz do projeto
- Criado automaticamente pelo docker-compose
- Persistência entre `docker-compose down` e `docker-compose up`
- Backup manual: `pg_dump -U postgres app > backup.sql`

**Redis Conectado ao Laravel**
- `config/cache.php`: CACHE_DRIVER=redis, REDIS_HOST=redis
- `config/session.php`: SESSION_DRIVER=redis, SESSION_CONNECTION=default
- `config/queue.php`: QUEUE_DRIVER=redis (para jobs futuros)

**Mailhog em Desenvolvimento**
- MAIL_MAILER=smtp, MAIL_HOST=mailhog, MAIL_PORT=1025
- Dashboard em http://localhost:8025
- Todos os emails enviados capturados e visualizáveis sem efeitos colaterais

**Xdebug Remote Configuration**
- IDE key: PHPSTORM (padrão PhpStorm)
- Cliente: PhpStorm rodando em máquina local
- Servidor: Container PHP acessando host via `host.docker.internal`
- Breakpoints funcionam em tempo real durante requisições

**Logs em arquivo**
- Single driver: todas as mensagens em um arquivo
- Daily driver: rotação diária de logs
- Log level padrão: DEBUG (desenvolvimento), WARNING (produção)
- Acesso: `tail -f storage/logs/laravel.log`

## Integração Futura (Documentada)

**pg-vector (MVP 7 - Integrações Avançadas)**
- Extensão PostgreSQL para vetores de alta dimensão
- Suportará: busca semântica, análise preditiva, recomendações baseadas em IA
- Implementação: adicionar extensão ao PostgreSQL, criar migrations com coluna `vector`
- Roadmap: após consolidação do sistema base

**WhatsApp Bot Integration (MVP 7 - Integrações Avançadas)**
- Orquestração com n8n para automação de workflows
- Fluxo: WhatsApp → WhatsApp Business API → n8n → Laravel webhooks → Database
- Funcionalidades: receber fotos, textos, enviar feedback
- Roadmap: após consolidação das funcionalidades core

## Dependências e Pré-requisitos

**Ambiente Local**
- Docker Desktop (Windows/Mac) ou Docker + Docker Compose (Linux)
- Docker versão 20.10+ e Docker Compose 1.29+
- Mínimo 4GB RAM disponível para containers

**PHP e Composer (Opcional - Pode rodar tudo via Docker)**
- PHP 8.2+ instalado localmente (opcional)
- Composer instalado localmente (opcional)
- Se não instalado, usar: `docker-compose exec php composer`

**IDE**
- PhpStorm com suporte a Xdebug (versão 2023.1+)
- Ou VS Code com PHP Debug extension

## Critérios de Sucesso

- Docker Compose sobe todos os 5 serviços sem erros: `docker-compose up -d` retorna status OK
- Laravel conecta com sucesso ao PostgreSQL: `docker-compose exec php php artisan migrate` executa sem erros
- Laravel conecta com sucesso ao Redis: `docker-compose exec php php artisan tinker` → Redis connection test
- Nginx responde em http://localhost:8080 com Laravel welcome page
- Mailhog funciona em http://localhost:8025 capturando emails de teste
- Xdebug conecta ao PhpStorm: breakpoint é alcançado durante requisição HTTP
- Estrutura Feature-Based criada e documentada em STRUCTURE.md
- Arquivos .env, .env.example, .env.testing existem e funcionam corretamente
- `docker-compose exec php php artisan pint` formata código sem erros
- `docker-compose exec php ./vendor/bin/phpstan analyse app/` executa análise sem erros críticos

## Ordem de Execução (Implementação)

1. **Criar docker-compose.yml** com configuração de 5 serviços, volumes, networks
2. **Criar Dockerfile** com PHP 8.2, extensões necessárias, Xdebug, Composer
3. **Criar nginx/conf.d/app.conf** com configuração de reverse proxy e rewrite rules
4. **Criar .env.example e .env.testing** com variáveis de template
5. **Configurar Xdebug** no Dockerfile e gerar arquivo PhpStorm.xml
6. **Documentar Feature-Based Architecture** em STRUCTURE.md com exemplos
7. **Criar docker/entrypoint.sh** com scripts de inicialização
8. **Criar .dockerignore** com extensões e pastas a ignorar
9. **Testar**: `docker-compose up -d`, validar todas as conexões (PostgreSQL, Redis, Nginx, Mailhog)
10. **Validar**: executar migrations, Pint, PHPStan, Xdebug

## Notas e Considerações

- **Não inclui:** Inertia.js/Vue.js (próxima tarefa), autenticação/RBAC (futuras tarefas), models de domínio específicos
- **Preparado para Redis:** Sessions e cache em Redis desde o início para suportar balanceamento de carga futuro
- **Logs apenas arquivo:** Não usar stdout para simplificar debugging em desenvolvimento
- **Estrutura escalável:** Feature-Based permite evolução futura para microserviços sem quebra de padrão
- **Xdebug desabilitado por padrão:** Usar switch "Start Listening" no PhpStorm para evitar overhead
- **Health checks:** Incluir health checks para postgres e redis no docker-compose para detectar problemas
- **Volumes locais:** PostgreSQL usa bind mount local para facilitar backup e inspeção de dados
- **Segurança em dev:** Mailhog e Xdebug seguros apenas em ambiente local; desabilitados em produção
- **Inertia/Vue:** Será instalado em especificação posterior sem quebra da configuração atual
- **Alinhamento com padrões:** Feature-Based Architecture segue convenções do projeto e permite crescimento sustentável

## Reusability & Patterns

**Padrões Reutilizáveis Entre Features**
- Pasta `app/Shared/DTOs/` para Data Transfer Objects compartilhados
- Pasta `app/Shared/Enums/` para enumerações (Status, Types, etc)
- Pasta `app/Shared/Traits/` para traits reutilizáveis (Timestamps, SoftDeletes, etc)
- Pasta `app/Shared/Utilities/` para helper functions e utilitários

**Docker Compose Base para Produção**
- Configuração de desenvolvimento pode servir como base para produção
- Adição de Traefik (reverse proxy com HTTPS) será overlay futuro
- Health checks e network security já considerados no design

## Out of Scope

- Criação de seeders específicos (será feito por feature posteriormente)
- Configuração de CI/CD (GitHub Actions, GitLab CI)
- Implantação de Traefik (apenas Nginx nesta etapa)
- Implementação de features de negócio específicas (Cattle, Farm, Reproduction, etc)
- Testes automatizados (PHPUnit, Pest - será feito em specs posteriores)
- Deployment em produção/staging
- Configuração de HTTPS (será adicionado com Traefik)
- Autenticação e RBAC (especificação dedicada futura)
- Front-end (Inertia.js + Vue.js - especificação dedicada futura)
- Integração com terceiros (WhatsApp, pg-vector, etc)
