#!/bin/bash

# 🚀 Moodle 5.0.1 GitHub Codespaces Setup Script
# Tự động setup environment cho development và deployment

set -e

echo "🚀 Setting up Moodle 5.0.1 in GitHub Codespaces..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Update system
echo -e "${YELLOW}📦 Updating system packages...${NC}"
sudo apt-get update

# Install additional PHP extensions for Moodle
echo -e "${YELLOW}🐘 Installing PHP extensions for Moodle...${NC}"
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
    php8.1-json \
    php8.1-opcache \
    unzip \
    wget \
    curl

# Configure PHP for Moodle
echo -e "${YELLOW}⚙️  Configuring PHP for Moodle...${NC}"
sudo tee -a /etc/php/8.1/cli/php.ini << 'EOF'

; Moodle optimizations
memory_limit = 512M
upload_max_filesize = 100M
post_max_size = 100M
max_execution_time = 300
max_input_vars = 5000
EOF

# Start and configure MySQL
echo -e "${YELLOW}🗄️  Configuring MySQL...${NC}"
sudo service mysql start

# Create Moodle database and user
sudo mysql << 'EOF'
CREATE DATABASE IF NOT EXISTS moodle CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'moodleuser'@'localhost' IDENTIFIED BY 'CodespacePass123!';
GRANT ALL PRIVILEGES ON moodle.* TO 'moodleuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

# Create moodledata directory
echo -e "${YELLOW}📁 Creating Moodle data directory...${NC}"
sudo mkdir -p /workspaces/moodledata
sudo chown -R vscode:vscode /workspaces/moodledata
chmod -R 777 /workspaces/moodledata

# Configure Nginx (optional, for production-like setup)
echo -e "${YELLOW}🌐 Configuring Nginx...${NC}"
sudo tee /etc/nginx/sites-available/moodle << 'EOF'
server {
    listen 80;
    server_name localhost;
    root /workspaces/Github\ Codespace;
    index index.php index.html;

    client_max_body_size 100M;
    
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_read_timeout 300;
    }
    
    location ~ /\.ht {
        deny all;
    }
}
EOF

# Enable the site
sudo ln -sf /etc/nginx/sites-available/moodle /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Start services
echo -e "${YELLOW}🔄 Starting services...${NC}"
sudo service php8.1-fpm start
sudo service nginx start
sudo service mysql start

# Set up auto-start services
echo -e "${YELLOW}⚡ Configuring services to auto-start...${NC}"
sudo systemctl enable mysql
sudo systemctl enable nginx
sudo systemctl enable php8.1-fpm

echo -e "\n${GREEN}✅ GitHub Codespaces setup completed!${NC}"
echo -e "\n${BLUE}📋 Next steps:${NC}"
echo "1. 📁 Copy your Moodle source files to this workspace"
echo "2. 🔧 Create/update config.php with Codespaces settings"
echo "3. 🚀 Start PHP development server: php -S 0.0.0.0:8080"
echo "4. 🌐 Access via the forwarded port URL"
echo ""
echo -e "${YELLOW}💾 Database info:${NC}"
echo "  - Host: localhost"
echo "  - Database: moodle"
echo "  - User: moodleuser"  
echo "  - Password: CodespacePass123!"
echo ""
echo -e "${YELLOW}📂 Directories:${NC}"
echo "  - Web root: /workspaces/Github\\ Codespace"
echo "  - Data root: /workspaces/moodledata"
