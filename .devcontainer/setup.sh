#!/bin/bash

# 🚀 Moodle 5.0.1 GitHub Codespaces Setup Script
# Simplified setup for Codespaces environment

set -e

echo "🚀 Setting up Moodle 5.0.1 in GitHub Codespaces..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Update system and install essential packages
echo -e "${YELLOW}📦 Installing required packages...${NC}"
sudo apt-get update
sudo apt-get install -y \
    php8.1-mysql \
    php8.1-xml \
    php8.1-curl \
    php8.1-zip \
    php8.1-gd \
    php8.1-mbstring \
    php8.1-xmlrpc \
    php8.1-soap \
    php8.1-intl \
    php8.1-opcache \
    mysql-client

# Configure PHP for Moodle
echo -e "${YELLOW}⚙️  Configuring PHP...${NC}"
sudo tee -a /etc/php/8.1/cli/php.ini << 'EOF'

; Moodle optimizations
memory_limit = 512M
upload_max_filesize = 100M
post_max_size = 100M
max_execution_time = 300
max_input_vars = 5000
EOF

# Wait for MySQL to be ready (when using Docker Compose)
echo -e "${YELLOW}⏳ Waiting for MySQL to be ready...${NC}"
for i in {1..30}; do
    if mysql -h mysql -u root -proot -e "SELECT 1" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ MySQL is ready${NC}"
        break
    fi
    echo "Waiting for MySQL... ($i/30)"
    sleep 2
done

# Create Moodle database and user
echo -e "${YELLOW}🗄️  Setting up database...${NC}"
mysql -h mysql -u root -proot << 'EOF'
CREATE DATABASE IF NOT EXISTS moodle CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'moodleuser'@'%' IDENTIFIED BY 'CodespacePass123!';
GRANT ALL PRIVILEGES ON moodle.* TO 'moodleuser'@'%';
FLUSH PRIVILEGES;
EXIT;
EOF

# Create moodledata directory
echo -e "${YELLOW}📁 Creating Moodle data directory...${NC}"
sudo mkdir -p /workspace/moodledata
sudo chown -R vscode:vscode /workspace/moodledata
chmod -R 777 /workspace/moodledata

echo -e "\n${GREEN}✅ Codespaces setup completed!${NC}"
echo -e "\n${BLUE}📋 Access Information:${NC}"
echo "  🌐 Development: Use quick-start.sh"
echo "  �️  Database: mysql:3306"
echo "  👤 DB User: moodleuser"
echo "  🔑 DB Password: CodespacePass123!"
echo "  � Data Directory: /workspace/moodledata"
