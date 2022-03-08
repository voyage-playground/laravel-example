FROM voyageapp/php:8.1-fpm-alpine-nginx

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY composer.* ./
RUN composer install --no-scripts --no-autoloader

COPY scripts/run_app.sh /init.d
RUN chmod +x /init.d/run_app.sh

COPY . .

RUN npm run prod

RUN chown -R nobody:nobody /app/storage
