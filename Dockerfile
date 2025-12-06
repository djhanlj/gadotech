FROM php:8.2-fpm-alpine

# Definir workdir
WORKDIR /var/www/html

# Instalar dependências do sistema
RUN apk add --no-cache \
    git \
    curl \
    wget \
    zip \
    unzip \
    postgresql-client \
    bash

# Instalar extensões PHP necessárias
RUN docker-php-ext-install \
    pdo \
    pdo_pgsql \
    pgsql \
    mbstring \
    json \
    bcmath \
    ctype \
    fileinfo \
    tokenizer \
    xml

# Instalar extensão Redis
RUN pecl install redis && docker-php-ext-enable redis

# Instalar Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Configurar Xdebug
RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.start_with_request=no" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar arquivos da aplicação
COPY . .

# Copiar entrypoint script
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expor porta FPM
EXPOSE 9000

# Definir entrypoint
ENTRYPOINT ["/entrypoint.sh"]
