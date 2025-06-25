#!/bin/bash

# Railway.app Startup Script for Moodle

echo "🚀 Starting Moodle on Railway.app..."

# Create necessary directories
mkdir -p /tmp/moodledata
chmod 777 /tmp/moodledata

# Copy Railway config if in production
if [ "$RAILWAY_ENVIRONMENT" = "production" ]; then
    echo "📋 Using Railway configuration..."
    cp config-railway.php config.php
fi

# Install PostgreSQL PHP extension if not present
if ! php -m | grep -q pgsql; then
    echo "📦 Installing PostgreSQL PHP extension..."
    apt-get update && apt-get install -y php-pgsql
fi

# Start PHP server
echo "🌐 Starting PHP server on port ${PORT:-8080}..."
php -S 0.0.0.0:${PORT:-8080} -t /app
