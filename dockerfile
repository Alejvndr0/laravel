# Usa la imagen oficial de Nginx con PHP-FPM
FROM php:8.2-fpm

# Instala dependencias necesarias
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    zip \
    unzip \
    git \
    nano \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copiar archivos del proyecto
WORKDIR /var/www/html
COPY . .

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Establecer permisos correctos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Configurar Nginx
COPY ./nginx/default.conf /etc/nginx/sites-available/default

# Exponer puertos
EXPOSE 80

# Comando para ejecutar Nginx y PHP-FPM juntos
CMD service nginx start && php-fpm
