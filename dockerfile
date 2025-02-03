# Usa la imagen oficial de PHP con extensiones necesarias
FROM php:8.2-fpm

# Instala dependencias del sistema
RUN apt-get update && apt-get install -y \
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

# Crear directorio de la aplicación
WORKDIR /var/www/html

# Copiar archivos del proyecto al contenedor
COPY . .

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Establecer permisos correctos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exponer el puerto 9000 (por defecto para PHP-FPM)
EXPOSE 9000

# Comando para iniciar PHP-FPM
CMD ["php-fpm"]
