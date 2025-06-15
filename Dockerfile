FROM php:8.2-cli

# Install system dependencies
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

# Copy app code
COPY . .

# Install Laravel dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Set environment variable to avoid interactive prompts
ENV APP_ENV=production

# Expose port
EXPOSE 8000

# Start Laravel safely in production
CMD php artisan config:clear && php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000
