#!/bin/bash

# 🚀 Universal VPS Deployment Script for Moodle 5.0.1
# Supports: Ubuntu 20.04+, CentOS 8+, Debian 11+

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
PHP_VERSION="8.1"
MYSQL_VERSION="8.0"
DOMAIN=""
DB_PASSWORD=""
ADMIN_EMAIL=""

echo -e "${BLUE}"
echo "🚀 Moodle 5.0.1 VPS Deployment"
echo "=============================="
echo "Universal installer for VPS servers"
echo -e "${NC}"

# Detect OS
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    else
        OS=$(uname -s)
        VER=$(uname -r)
    fi
    
    echo -e "${BLUE}🖥️  Detected OS: $OS $VER${NC}"
}

# Get user input
get_configuration() {
    echo -e "${YELLOW}📝 VPS Configuration${NC}"
    
    read -p "Domain name (e.g., yourdomain.com): " DOMAIN
    read -p "MySQL root password: " -s DB_ROOT_PASSWORD
    echo
    read -p "Moodle DB password: " -s DB_PASSWORD
    echo
    read -p "Admin email: " ADMIN_EMAIL
    read -p "Enable SSL/HTTPS? (y/n): " ENABLE_SSL
    
    echo -e "\n${BLUE}📋 Configuration Summary:${NC}"
    echo "Domain: $DOMAIN"
    echo "SSL: $ENABLE_SSL"
    echo "Admin Email: $ADMIN_EMAIL"
    
    read -p "Continue with this configuration? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}⏹️  Installation cancelled${NC}"
        exit 0
    fi
}

# Install dependencies based on OS
install_dependencies() {
    echo -e "${YELLOW}📦 Installing dependencies...${NC}"
    
    if [[ "$OS" == *"Ubuntu"* ]] || [[ "$OS" == *"Debian"* ]]; then
        # Ubuntu/Debian
        sudo apt-get update
        sudo apt-get install -y software-properties-common curl wget git unzip
        
        # Add PHP repository
        sudo add-apt-repository ppa:ondrej/php -y
        sudo apt-get update
        
        # Install PHP 8.1
        sudo apt-get install -y \
            php${PHP_VERSION} \
            php${PHP_VERSION}-fpm \
            php${PHP_VERSION}-mysql \
            php${PHP_VERSION}-xml \
            php${PHP_VERSION}-curl \
            php${PHP_VERSION}-zip \
            php${PHP_VERSION}-gd \
            php${PHP_VERSION}-mbstring \
            php${PHP_VERSION}-xmlrpc \
            php${PHP_VERSION}-soap \
            php${PHP_VERSION}-intl \
            php${PHP_VERSION}-opcache
        
        # Install MySQL
        sudo apt-get install -y mysql-server-${MYSQL_VERSION}
        
        # Install Nginx
        sudo apt-get install -y nginx
        
        # Install Certbot for SSL
        if [[ "$ENABLE_SSL" =~ ^[Yy]$ ]]; then
            sudo apt-get install -y certbot python3-certbot-nginx
        fi
        
    elif [[ "$OS" == *"CentOS"* ]] || [[ "$OS" == *"Red Hat"* ]]; then
        # CentOS/RHEL
        sudo dnf update -y
        sudo dnf install -y curl wget git unzip
        
        # Install PHP 8.1
        sudo dnf module install -y php:8.1
        sudo dnf install -y \
            php-mysql \
            php-xml \
            php-curl \
            php-zip \
            php-gd \
            php-mbstring \
            php-soap \
            php-intl \
            php-opcache \
            php-fpm
        
        # Install MySQL
        sudo dnf install -y mysql-server
        
        # Install Nginx
        sudo dnf install -y nginx
        
        # Install Certbot for SSL
        if [[ "$ENABLE_SSL" =~ ^[Yy]$ ]]; then
            sudo dnf install -y certbot python3-certbot-nginx
        fi
    fi
    
    echo -e "${GREEN}✅ Dependencies installed${NC}"
}

# Configure MySQL
configure_mysql() {
    echo -e "${YELLOW}🗄️  Configuring MySQL...${NC}"
    
    # Start MySQL
    sudo systemctl start mysql
    sudo systemctl enable mysql
    
    # Secure MySQL installation
    sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$DB_ROOT_PASSWORD';"
    sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
    sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    sudo mysql -e "DROP DATABASE IF EXISTS test;"
    sudo mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    sudo mysql -e "FLUSH PRIVILEGES;"
    
    # Create Moodle database and user
    sudo mysql -u root -p$DB_ROOT_PASSWORD << EOF
CREATE DATABASE IF NOT EXISTS moodle CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'moodleuser'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON moodle.* TO 'moodleuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF
    
    echo -e "${GREEN}✅ MySQL configured${NC}"
}

# Configure PHP
configure_php() {
    echo -e "${YELLOW}🐘 Configuring PHP...${NC}"
    
    # Configure PHP-FPM
    sudo tee /etc/php/${PHP_VERSION}/fpm/pool.d/moodle.conf << 'EOF'
[moodle]
user = www-data
group = www-data
listen = /run/php/php8.1-fpm-moodle.sock
listen.owner = www-data
listen.group = www-data
listen.mode = 0660

pm = dynamic
pm.max_children = 50
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 35
pm.max_requests = 500

; Moodle optimizations
php_admin_value[memory_limit] = 512M
php_admin_value[upload_max_filesize] = 100M
php_admin_value[post_max_size] = 100M
php_admin_value[max_execution_time] = 300
php_admin_value[max_input_vars] = 5000
EOF
    
    # Configure PHP settings
    sudo tee -a /etc/php/${PHP_VERSION}/fpm/php.ini << 'EOF'

; Moodle optimizations
memory_limit = 512M
upload_max_filesize = 100M
post_max_size = 100M
max_execution_time = 300
max_input_vars = 5000
date.timezone = "UTC"

; OPcache configuration
opcache.enable = 1
opcache.memory_consumption = 128
opcache.interned_strings_buffer = 8
opcache.max_accelerated_files = 4000
opcache.revalidate_freq = 2
opcache.fast_shutdown = 1
EOF
    
    # Start PHP-FPM
    sudo systemctl start php${PHP_VERSION}-fpm
    sudo systemctl enable php${PHP_VERSION}-fpm
    
    echo -e "${GREEN}✅ PHP configured${NC}"
}

# Configure Nginx
configure_nginx() {
    echo -e "${YELLOW}🌐 Configuring Nginx...${NC}"
    
    # Create Nginx configuration
    sudo tee /etc/nginx/sites-available/moodle << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    root /var/www/html/moodle;
    index index.php index.html;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;

    # File upload size
    client_max_body_size 100M;
    client_body_timeout 120s;
    client_header_timeout 120s;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 10240;
    gzip_proxied expired no-cache no-store private must-revalidate max-stale post-check pre-check auth;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/x-javascript
        application/xml+rss
        application/javascript
        application/json;

    # Main location block
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    # PHP processing
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/run/php/php8.1-fpm-moodle.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
        fastcgi_param PATH_TRANSLATED \$document_root\$fastcgi_path_info;
        fastcgi_read_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_connect_timeout 300;
        fastcgi_buffer_size 128k;
        fastcgi_buffers 4 256k;
        fastcgi_busy_buffers_size 256k;
        fastcgi_temp_file_write_size 256k;
    }

    # Security: Block access to sensitive files
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }

    location ~ ^/(config|lib|theme|lang)/ {
        deny all;
        access_log off;
        log_not_found off;
    }

    # Allow access to Moodle files
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }

    # Error and access logs
    error_log /var/log/nginx/moodle_error.log;
    access_log /var/log/nginx/moodle_access.log;
}
EOF
    
    # Enable site
    sudo ln -sf /etc/nginx/sites-available/moodle /etc/nginx/sites-enabled/
    sudo rm -f /etc/nginx/sites-enabled/default
    
    # Test Nginx configuration
    sudo nginx -t
    
    # Start Nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    
    echo -e "${GREEN}✅ Nginx configured${NC}"
}

# Install Moodle
install_moodle() {
    echo -e "${YELLOW}🎓 Installing Moodle...${NC}"
    
    # Create directories
    sudo mkdir -p /var/www/html
    sudo mkdir -p /var/moodledata
    
    # Clone Moodle from your repository
    cd /var/www/html
    sudo git clone https://github.com/khanhnd2208/moodlendk.git moodle
    
    # Set permissions
    sudo chown -R www-data:www-data /var/www/html/moodle
    sudo chown -R www-data:www-data /var/moodledata
    sudo chmod -R 755 /var/www/html/moodle
    sudo chmod -R 777 /var/moodledata
    
    # Create Moodle configuration
    cd /var/www/html/moodle
    sudo tee config.php << EOF
<?php  
unset(\$CFG);
global \$CFG;
\$CFG = new stdClass();

\$CFG->dbtype    = 'mysqli';
\$CFG->dblibrary = 'native';
\$CFG->dbhost    = 'localhost';
\$CFG->dbname    = 'moodle';
\$CFG->dbuser    = 'moodleuser';
\$CFG->dbpass    = '$DB_PASSWORD';
\$CFG->prefix    = 'mdl_';
\$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => 3306,
  'dbsocket' => '',
  'dbcollation' => 'utf8mb4_unicode_ci',
);

\$CFG->wwwroot   = 'http://$DOMAIN';
\$CFG->dataroot  = '/var/moodledata';
\$CFG->admin     = 'admin';

\$CFG->directorypermissions = 0777;

// Production settings
\$CFG->debug = 0;
\$CFG->debugdisplay = 0;
\$CFG->cachejs = true;
\$CFG->cachetemplates = true;
\$CFG->yuicomboloading = true;

require_once(__DIR__ . '/lib/setup.php');
EOF
    
    sudo chown www-data:www-data config.php
    
    echo -e "${GREEN}✅ Moodle installed${NC}"
}

# Configure SSL
configure_ssl() {
    if [[ "$ENABLE_SSL" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}🔒 Configuring SSL...${NC}"
        
        # Get SSL certificate
        sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email $ADMIN_EMAIL
        
        # Update Moodle config for HTTPS
        sudo sed -i "s|http://$DOMAIN|https://$DOMAIN|g" /var/www/html/moodle/config.php
        
        echo -e "${GREEN}✅ SSL configured${NC}"
    fi
}

# Final setup
final_setup() {
    echo -e "${YELLOW}🔧 Final setup...${NC}"
    
    # Restart services
    sudo systemctl restart nginx
    sudo systemctl restart php${PHP_VERSION}-fpm
    sudo systemctl restart mysql
    
    # Configure firewall
    if command -v ufw >/dev/null 2>&1; then
        sudo ufw allow 'Nginx Full'
        sudo ufw allow OpenSSH
        sudo ufw --force enable
    fi
    
    echo -e "\n${GREEN}🎉 Moodle VPS deployment completed!${NC}"
    echo -e "\n${BLUE}📋 Access Information:${NC}"
    echo -e "  🌐 URL: http${ENABLE_SSL:+s}://$DOMAIN"
    echo -e "  🗄️  Database: moodle"
    echo -e "  👤 Setup: Complete installation via web interface"
    
    echo -e "\n${YELLOW}📝 Next Steps:${NC}"
    echo "1. 🌐 Visit your domain to complete Moodle installation"
    echo "2. 📤 If migrating from Codespaces, restore your backup"
    echo "3. 🔧 Configure your Moodle settings"
    echo "4. 🧪 Test all functionality"
    
    echo -e "\n${BLUE}🛠️  Useful Commands:${NC}"
    echo "  📊 Check status: sudo systemctl status nginx mysql php${PHP_VERSION}-fpm"
    echo "  🔄 Restart services: sudo systemctl restart nginx mysql php${PHP_VERSION}-fpm"
    echo "  📝 View logs: sudo tail -f /var/log/nginx/moodle_error.log"
}

# Main execution
main() {
    detect_os
    get_configuration
    install_dependencies
    configure_mysql
    configure_php
    configure_nginx
    install_moodle
    configure_ssl
    final_setup
    
    echo -e "\n${GREEN}🚀 VPS deployment successful!${NC}"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}❌ This script should not be run as root${NC}"
   echo "Please run as a regular user with sudo privileges"
   exit 1
fi

# Run main function
main "$@"
