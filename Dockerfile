FROM php:8.2-cli

# Install basic tools
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    libzip-dev \
    zip \
    && docker-php-ext-install zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /app

# Copy app source
COPY . .

# Install dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Disable production migration lock loop
ENV APP_ENV=local

# Laravel cleanup (no auto migrate)
RUN php artisan config:clear && php artisan route:clear

# Expose app port
EXPOSE 8000

# Hard-code Laravel to just serve
ENTRYPOINT ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
