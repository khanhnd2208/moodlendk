#!/bin/bash

# 🌊 DigitalOcean $4/month Moodle Deployment
# Rẻ nhất, setup nhanh, reliable

echo "🌊 DigitalOcean Moodle Deployment - $4/month"
echo "============================================"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}💰 DigitalOcean Pricing:${NC}"
echo "  - Basic Droplet: $4/month (1GB RAM, 1 CPU, 25GB SSD)"
echo "  - Better Droplet: $12/month (2GB RAM, 1 CPU, 50GB SSD)"
echo "  - Domain: $12/year (optional)"
echo "  - Total: $48-144/year"

echo -e "\n${YELLOW}🚀 Setup Steps:${NC}"
echo "1. Tạo DigitalOcean account: https://digitalocean.com"
echo "2. Tạo Droplet Ubuntu 22.04"
echo "3. Chạy script này để tự động setup"

read -p "📧 Nhập email DigitalOcean: " DO_EMAIL
read -p "💧 Nhập Droplet IP: " DROPLET_IP
read -p "🔑 SSH Key path: " SSH_KEY

echo -e "\n${YELLOW}📤 Uploading Moodle...${NC}"

# Compress Moodle
cd /Users/duykhanh/Documents/Moodle
tar -czf moodle-do.tar.gz moodle-source/

# Upload to DigitalOcean
scp -i "$SSH_KEY" moodle-do.tar.gz root@$DROPLET_IP:/root/

# Setup script
cat > do_setup.sh << 'EOF'
#!/bin/bash

# DigitalOcean Moodle Setup
apt update && apt upgrade -y

# Install LEMP
apt install -y nginx mysql-server php8.1-fpm php8.1-mysql php8.1-xml php8.1-curl php8.1-zip php8.1-gd php8.1-mbstring php8.1-xmlrpc php8.1-soap php8.1-intl

# Configure MySQL
mysql << 'MYSQL_EOF'
CREATE DATABASE moodle CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'moodleuser'@'localhost' IDENTIFIED BY 'DOPass123!';
GRANT ALL PRIVILEGES ON moodle.* TO 'moodleuser'@'localhost';
FLUSH PRIVILEGES;
MYSQL_EOF

# Extract Moodle
tar -xzf moodle-do.tar.gz
mv moodle-source /var/www/moodle
mkdir -p /var/moodledata
chown -R www-data:www-data /var/www/moodle /var/moodledata
chmod -R 755 /var/www/moodle
chmod -R 777 /var/moodledata

# Configure Nginx
cat > /etc/nginx/sites-available/moodle << 'NGINX_EOF'
server {
    listen 80;
    server_name _;
    root /var/www/moodle;
    index index.php;
    
    client_max_body_size 100M;
    
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
NGINX_EOF

ln -s /etc/nginx/sites-available/moodle /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
nginx -t && systemctl reload nginx

echo "✅ DigitalOcean setup completed!"
echo "🌐 Access: http://$1"
EOF

# Upload and run setup
scp -i "$SSH_KEY" do_setup.sh root@$DROPLET_IP:/root/
ssh -i "$SSH_KEY" root@$DROPLET_IP "chmod +x do_setup.sh && ./do_setup.sh $DROPLET_IP"

# Create config
ssh -i "$SSH_KEY" root@$DROPLET_IP << EOF
cat > /var/www/moodle/config.php << 'CONFIG_EOF'
<?php
unset(\$CFG);
\$CFG = new stdClass();

\$CFG->dbtype    = 'mysqli';
\$CFG->dblibrary = 'native';
\$CFG->dbhost    = 'localhost';
\$CFG->dbname    = 'moodle';
\$CFG->dbuser    = 'moodleuser';
\$CFG->dbpass    = 'DOPass123!';
\$CFG->prefix    = 'mdl_';

\$CFG->wwwroot   = 'http://$DROPLET_IP';
\$CFG->dataroot  = '/var/moodledata';
\$CFG->admin     = 'admin';

\$CFG->directorypermissions = 0777;
require_once(__DIR__ . '/lib/setup.php');
CONFIG_EOF
EOF

# Cleanup
rm -f moodle-do.tar.gz do_setup.sh

echo -e "\n${GREEN}🎉 DigitalOcean deployment completed!${NC}"
echo -e "${BLUE}🌐 Access: http://$DROPLET_IP${NC}"
echo -e "${YELLOW}💡 Next: Setup Cloudflare for domain + SSL${NC}"
