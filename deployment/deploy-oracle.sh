#!/bin/bash

# 🔥 Oracle Cloud Moodle Deployment Script
# Tự động deploy Moodle lên Oracle Cloud Free Tier

set -e

echo "🔥 Oracle Cloud Moodle Deployment Script"
echo "======================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Get user input
echo -e "${BLUE}📋 Cấu hình deployment:${NC}"
read -p "🌐 Oracle Cloud Public IP: " ORACLE_IP
read -p "🔑 SSH Key path (default: ~/.ssh/id_rsa): " SSH_KEY
SSH_KEY=${SSH_KEY:-~/.ssh/id_rsa}
read -p "🗄️  MySQL password cho moodleuser: " MYSQL_PASSWORD
read -p "🌍 Domain name (để trống nếu dùng IP): " DOMAIN_NAME

# Set wwwroot
if [ -z "$DOMAIN_NAME" ]; then
    WWWROOT="http://$ORACLE_IP"
else
    WWWROOT="https://$DOMAIN_NAME"
fi

echo -e "\n${YELLOW}📋 Cấu hình:${NC}"
echo "  - Oracle IP: $ORACLE_IP"
echo "  - SSH Key: $SSH_KEY"
echo "  - WWW Root: $WWWROOT"
echo "  - Domain: ${DOMAIN_NAME:-'N/A'}"

read -p "✅ Tiếp tục? (y/N): " CONFIRM
if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled"
    exit 1
fi

# Step 1: Prepare local files
echo -e "\n${YELLOW}📦 Step 1: Chuẩn bị files local...${NC}"
cd /Users/duykhanh/Documents/Moodle

# Create production config
cat > moodle-source/config_oracle.php << EOF
<?php
unset(\$CFG);
\$CFG = new stdClass();

\$CFG->dbtype    = 'mysqli';
\$CFG->dblibrary = 'native';
\$CFG->dbhost    = 'localhost';
\$CFG->dbname    = 'moodle';
\$CFG->dbuser    = 'moodleuser';
\$CFG->dbpass    = '$MYSQL_PASSWORD';
\$CFG->prefix    = 'mdl_';

\$CFG->wwwroot   = '$WWWROOT';
\$CFG->dataroot  = '/var/moodledata';
\$CFG->admin     = 'admin';

\$CFG->directorypermissions = 0777;

require_once(__DIR__ . '/lib/setup.php');
EOF

# Backup current database
echo -e "\n${YELLOW}💾 Backup database...${NC}"
if command -v mysqldump &> /dev/null; then
    mysqldump -u root moodle > "oracle_backup_$(date +%Y%m%d_%H%M%S).sql"
    echo -e "${GREEN}✅ Database backup created${NC}"
fi

# Compress Moodle files
echo -e "\n${YELLOW}📦 Compressing Moodle files...${NC}"
tar -czf moodle-oracle.tar.gz moodle-source/
echo -e "${GREEN}✅ Moodle files compressed${NC}"

# Step 2: Setup Oracle Cloud server
echo -e "\n${YELLOW}🛠️  Step 2: Setup Oracle Cloud server...${NC}"

# Create setup script
cat > oracle_setup.sh << 'EOF'
#!/bin/bash

# Oracle Cloud Server Setup for Moodle
echo "🛠️  Setting up Oracle Cloud server for Moodle..."

# Update system
sudo apt update && sudo apt upgrade -y

# Install LEMP stack
sudo apt install -y nginx mysql-server php8.1-fpm php8.1-mysql php8.1-xml php8.1-curl php8.1-zip php8.1-gd php8.1-mbstring php8.1-xmlrpc php8.1-soap php8.1-intl php8.1-json php8.1-opcache unzip wget curl

# Configure PHP
sudo sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/8.1/fpm/php.ini
sudo sed -i 's/upload_max_filesize = .*/upload_max_filesize = 100M/' /etc/php/8.1/fpm/php.ini
sudo sed -i 's/post_max_size = .*/post_max_size = 100M/' /etc/php/8.1/fpm/php.ini
sudo sed -i 's/max_execution_time = .*/max_execution_time = 300/' /etc/php/8.1/fpm/php.ini
sudo sed -i 's/;max_input_vars = .*/max_input_vars = 5000/' /etc/php/8.1/fpm/php.ini

# Restart PHP-FPM
sudo systemctl restart php8.1-fpm

# Create directories
sudo mkdir -p /var/www/moodle
sudo mkdir -p /var/moodledata
sudo chown -R www-data:www-data /var/www/moodle /var/moodledata
sudo chmod -R 755 /var/www/moodle
sudo chmod -R 777 /var/moodledata

echo "✅ Server setup completed!"
EOF

# Upload and run setup script
echo -e "\n${YELLOW}📤 Uploading setup script...${NC}"
scp -i "$SSH_KEY" oracle_setup.sh ubuntu@$ORACLE_IP:/home/ubuntu/
ssh -i "$SSH_KEY" ubuntu@$ORACLE_IP 'chmod +x oracle_setup.sh && ./oracle_setup.sh'

# Step 3: Upload Moodle files
echo -e "\n${YELLOW}📤 Step 3: Uploading Moodle files...${NC}"
scp -i "$SSH_KEY" moodle-oracle.tar.gz ubuntu@$ORACLE_IP:/home/ubuntu/

# Extract and configure on server
ssh -i "$SSH_KEY" ubuntu@$ORACLE_IP << 'EOF'
echo "📦 Extracting Moodle files..."
tar -xzf moodle-oracle.tar.gz
sudo cp -r moodle-source/* /var/www/moodle/
sudo mv /var/www/moodle/config_oracle.php /var/www/moodle/config.php
sudo chown -R www-data:www-data /var/www/moodle
sudo chmod -R 755 /var/www/moodle
echo "✅ Moodle files uploaded and configured"
EOF

# Step 4: Configure Nginx
echo -e "\n${YELLOW}🌐 Step 4: Configuring Nginx...${NC}"
ssh -i "$SSH_KEY" ubuntu@$ORACLE_IP << EOF
sudo tee /etc/nginx/sites-available/moodle << 'NGINX_EOF'
server {
    listen 80;
    server_name $ORACLE_IP${DOMAIN_NAME:+ $DOMAIN_NAME};
    root /var/www/moodle;
    index index.php index.html;

    client_max_body_size 100M;
    
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_read_timeout 300;
    }
    
    location ~ /\.ht {
        deny all;
    }
}
NGINX_EOF

sudo ln -sf /etc/nginx/sites-available/moodle /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx
echo "✅ Nginx configured"
EOF

# Step 5: Setup MySQL
echo -e "\n${YELLOW}🗄️  Step 5: Setting up MySQL...${NC}"
ssh -i "$SSH_KEY" ubuntu@$ORACLE_IP << EOF
sudo mysql << 'MYSQL_EOF'
CREATE DATABASE IF NOT EXISTS moodle CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'moodleuser'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON moodle.* TO 'moodleuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
MYSQL_EOF
echo "✅ MySQL database created"
EOF

# Step 6: Configure firewall (Oracle specific)
echo -e "\n${YELLOW}🔥 Step 6: Configuring firewall...${NC}"
ssh -i "$SSH_KEY" ubuntu@$ORACLE_IP << 'EOF'
# Oracle Cloud uses iptables
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables-save | sudo tee /etc/iptables/rules.v4
echo "✅ Firewall configured"
EOF

# Step 7: Install SSL (if domain provided)
if [ ! -z "$DOMAIN_NAME" ]; then
    echo -e "\n${YELLOW}🔒 Step 7: Installing SSL certificate...${NC}"
    ssh -i "$SSH_KEY" ubuntu@$ORACLE_IP << EOF
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d $DOMAIN_NAME --non-interactive --agree-tos --email admin@$DOMAIN_NAME
sudo systemctl enable certbot.timer
echo "✅ SSL certificate installed"
EOF
fi

# Cleanup local files
rm -f moodle-oracle.tar.gz oracle_setup.sh

echo -e "\n${GREEN}🎉 DEPLOYMENT HOÀN TẤT!${NC}"
echo -e "\n${BLUE}📋 Thông tin truy cập:${NC}"
echo "  🌐 URL: $WWWROOT"
echo "  👤 Admin account: Đã tạo trước đó"
echo "  🔑 SSH: ssh -i $SSH_KEY ubuntu@$ORACLE_IP"
echo ""
echo -e "${YELLOW}📋 Bước tiếp theo:${NC}"
echo "1. ✅ Truy cập $WWWROOT"
echo "2. ✅ Đăng nhập với tài khoản admin"
echo "3. ✅ Kiểm tra Site Administration > Server"
echo "4. 🌐 Cấu hình Cloudflare (nếu có domain)"
echo ""
echo -e "${PURPLE}💡 Tips:${NC}"
echo "- 📊 Monitoring: htop, mysql status"
echo "- 📝 Logs: tail -f /var/log/nginx/error.log"
echo "- 🔄 Restart services: sudo systemctl restart nginx mysql php8.1-fpm"

if [ -z "$DOMAIN_NAME" ]; then
    echo ""
    echo -e "${YELLOW}⚠️  Sử dụng IP thay vì domain:${NC}"
    echo "- Có thể gặp lỗi mixed content"
    echo "- Khuyến nghị: setup domain + Cloudflare sau"
fi

echo -e "\n${GREEN}🚀 Moodle đã sẵn sàng trên Oracle Cloud Free!${NC}"
