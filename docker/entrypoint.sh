#!/bin/sh

set -e

echo "Iniciando aplicação Laravel..."

# Aguardar PostgreSQL estar pronto
echo "Aguardando PostgreSQL estar disponível..."
until pg_isready -h postgres -U postgres > /dev/null 2>&1; do
    echo "PostgreSQL ainda não está pronto, aguardando..."
    sleep 2
done
echo "PostgreSQL está pronto!"

# Aguardar Redis estar pronto
echo "Aguardando Redis estar disponível..."
until redis-cli -h redis ping > /dev/null 2>&1; do
    echo "Redis ainda não está pronto, aguardando..."
    sleep 2
done
echo "Redis está pronto!"

# Instalar dependências do Composer
echo "Instalando dependências do Composer..."
composer install --no-interaction --no-progress

# Executar migrations
echo "Executando migrations..."
php artisan migrate --force

# Limpar cache
echo "Limpando cache..."
php artisan cache:clear

# Cachear configurações
echo "Cacheando configurações..."
php artisan config:cache

# Otimizar autoloader
echo "Otimizando autoloader..."
php artisan optimize

echo "Aplicação iniciada com sucesso!"

# Manter container rodando com PHP-FPM
exec php-fpm
