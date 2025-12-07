## Setup rápido (Docker)

1. Copie o `docker-compose.example.yml` para `docker-compose.yml` (ajuste se precisar de overrides locais).
2. Copie o `.env.example` para `.env` e ajuste variáveis se necessário.
3. Suba os containers (PHP, Postgres, Redis, Nginx, Node):\
   `docker compose up -d --build`
4. Instale dependências PHP/JS (apenas na primeira vez ou após updates):\
   `docker compose exec php composer install`\
   `docker compose exec php npm ci`
5. Gere os assets do frontend (cria `public/build/manifest.json`):\
   `docker compose exec php npm run build`\
   Para HMR: `docker compose exec php npm run dev -- --host` (mantém processo rodando).
6. A aplicação estará disponível em `http://localhost:8080`.

## Testes rápidos

- `docker compose exec php php artisan test`
