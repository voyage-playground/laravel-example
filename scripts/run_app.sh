#!/bin/sh
set -e

APP_ENV="${APP_ENV:-local}"

DB_HOSTNAME=$([ -n "$DB_HOST" ] && echo "tcp://$DB_HOST:5432" || echo "tcp://127.0.0.1:5432")

if [ "$APP_ENV" == "development" ] || [ "$APP_ENV" == "local" ] || [ -n "$RUNNING_IN_VOYAGE" ]; then
  echo "🚀 Wait for DB to start"
  dockerize -wait $DB_HOSTNAME -timeout 60s
fi

echo "🚀 Dump Autoloader"
composer dumpautoload

echo "🚀 Generate App Key"
php artisan key:generate --force

php artisan migrate

php artisan db:seed
