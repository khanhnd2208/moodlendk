#!/bin/bash

# 🚀 Moodle 5.0.1 Quick Start Script for GitHub Codespaces
# Script khởi động nhanh cho development

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "🚀 Moodle 5.0.1 Quick Start"
echo "=========================="
echo -e "${NC}"

# Check if running in Codespaces
if [ -n "$CODESPACES" ]; then
    echo -e "${GREEN}✅ Running in GitHub Codespaces${NC}"
    CODESPACE_URL="https://$CODESPACE_NAME-8080.githubpreview.dev"
else
    echo -e "${YELLOW}⚠️  Running locally${NC}"
    CODESPACE_URL="http://localhost:8080"
fi

# Function to check if service is running
check_service() {
    if systemctl is-active --quiet $1; then
        echo -e "${GREEN}✅ $1 is running${NC}"
        return 0
    else
        echo -e "${YELLOW}⚙️  Starting $1...${NC}"
        sudo systemctl start $1
        return 1
    fi
}

# Function to check if port is occupied
check_port() {
    if lsof -i:$1 >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  Port $1 is already in use${NC}"
        return 0
    else
        return 1
    fi
}

echo -e "${BLUE}🔍 Checking system status...${NC}"

# Check MySQL
if command -v mysql >/dev/null 2>&1; then
    check_service mysql
else
    echo -e "${RED}❌ MySQL not found${NC}"
fi

# Check PHP
if command -v php >/dev/null 2>&1; then
    PHP_VERSION=$(php -v | head -n1 | cut -d' ' -f2 | cut -d'.' -f1,2)
    echo -e "${GREEN}✅ PHP $PHP_VERSION is available${NC}"
else
    echo -e "${RED}❌ PHP not found${NC}"
    exit 1
fi

# Check if config.php exists
if [ ! -f "config.php" ]; then
    echo -e "${YELLOW}⚙️  config.php not found${NC}"
    echo -e "${BLUE}📋 Creating config.php from sample...${NC}"
    
    if [ -f "config-codespaces-sample.php" ]; then
        cp config-codespaces-sample.php config.php
        
        # Update the Codespace URL in config.php
        if [ -n "$CODESPACES" ]; then
            sed -i "s|https://your-codespace-url.githubpreview.dev|$CODESPACE_URL|g" config.php
            echo -e "${GREEN}✅ config.php created and updated with Codespace URL${NC}"
        else
            echo -e "${YELLOW}⚠️  Please update the \$CFG->wwwroot in config.php manually${NC}"
        fi
    else
        echo -e "${RED}❌ config-codespaces-sample.php not found${NC}"
        echo -e "${YELLOW}💡 Please create config.php manually${NC}"
    fi
else
    echo -e "${GREEN}✅ config.php exists${NC}"
fi

# Check moodledata directory
if [ ! -d "/workspaces/moodledata" ]; then
    echo -e "${YELLOW}📁 Creating moodledata directory...${NC}"
    sudo mkdir -p /workspaces/moodledata
    sudo chown -R $(whoami):$(whoami) /workspaces/moodledata
    sudo chmod -R 777 /workspaces/moodledata
    echo -e "${GREEN}✅ moodledata directory created${NC}"
else
    echo -e "${GREEN}✅ moodledata directory exists${NC}"
fi

# Check database connection
echo -e "${BLUE}🗄️  Checking database connection...${NC}"
if mysql -u moodleuser -pCodespacePass123! -e "USE moodle;" 2>/dev/null; then
    echo -e "${GREEN}✅ Database connection successful${NC}"
else
    echo -e "${YELLOW}⚠️  Database connection failed${NC}"
    echo -e "${BLUE}Creating database and user...${NC}"
    
    mysql -u root << 'EOF'
CREATE DATABASE IF NOT EXISTS moodle CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'moodleuser'@'localhost' IDENTIFIED BY 'CodespacePass123!';
GRANT ALL PRIVILEGES ON moodle.* TO 'moodleuser'@'localhost';
FLUSH PRIVILEGES;
EOF
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Database and user created successfully${NC}"
    else
        echo -e "${RED}❌ Failed to create database${NC}"
    fi
fi

# Ask user which server to start
echo -e "\n${BLUE}🚀 Choose server to start:${NC}"
echo "1. PHP built-in server (Recommended for development)"
echo "2. Nginx + PHP-FPM (Production-like)"
echo "3. Both servers"
echo "4. Skip server start"

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo -e "${YELLOW}🚀 Starting PHP built-in server...${NC}"
        if check_port 8080; then
            echo -e "${YELLOW}Stopping existing process on port 8080...${NC}"
            pkill -f "php -S.*8080" || true
            sleep 2
        fi
        
        echo -e "${GREEN}🌐 Starting server on $CODESPACE_URL${NC}"
        php -S 0.0.0.0:8080 &
        PHP_PID=$!
        echo "PHP server PID: $PHP_PID"
        ;;
    2)
        echo -e "${YELLOW}🚀 Starting Nginx + PHP-FPM...${NC}"
        check_service php8.1-fpm
        check_service nginx
        ;;
    3)
        echo -e "${YELLOW}🚀 Starting both servers...${NC}"
        check_service php8.1-fpm
        check_service nginx
        
        if check_port 8080; then
            echo -e "${YELLOW}Stopping existing process on port 8080...${NC}"
            pkill -f "php -S.*8080" || true
            sleep 2
        fi
        
        php -S 0.0.0.0:8080 &
        PHP_PID=$!
        echo "PHP server PID: $PHP_PID"
        ;;
    4)
        echo -e "${BLUE}⏩ Skipping server start${NC}"
        ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

echo -e "\n${GREEN}🎉 Moodle 5.0.1 Quick Start completed!${NC}"
echo -e "\n${BLUE}📋 Access Information:${NC}"
echo -e "  🌐 Main URL: $CODESPACE_URL"
echo -e "  🗄️  Database: moodle (moodleuser/CodespacePass123!)"
echo -e "  📁 Data Directory: /workspaces/moodledata"

if [ -n "$CODESPACES" ]; then
    echo -e "\n${YELLOW}💡 Codespaces Tips:${NC}"
    echo -e "  - Use the 'Ports' tab to access your application"
    echo -e "  - Port 8080: Main Moodle application"
    echo -e "  - Port 8081: phpMyAdmin (if running)"
    echo -e "  - Port 80: Nginx server (if running)"
fi

echo -e "\n${BLUE}🔧 Useful Commands:${NC}"
echo -e "  📊 Check status: systemctl status mysql nginx php8.1-fpm"
echo -e "  🔄 Restart services: sudo systemctl restart mysql nginx php8.1-fpm"
echo -e "  📝 View logs: tail -f /var/log/nginx/error.log"
echo -e "  🛑 Stop PHP server: kill $PHP_PID (if started)"

echo -e "\n${GREEN}Happy coding with Moodle 5.0.1! 🎓${NC}"

# Keep the script running if PHP server was started
if [ -n "$PHP_PID" ]; then
    echo -e "\n${YELLOW}Press Ctrl+C to stop PHP server${NC}"
    trap "kill $PHP_PID; echo 'PHP server stopped'; exit" INT
    wait $PHP_PID
fi
