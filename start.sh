#!/bin/bash

# 🚀 Moodle Quick Start Script

echo "🚀 Starting Moodle..."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Start services
echo -e "${YELLOW}🔄 Starting MySQL...${NC}"
sudo service mysql start

# Determine URL
if [ -n "$CODESPACE_NAME" ]; then
    CODESPACE_URL="https://${CODESPACE_NAME}-8080.app.github.dev"
    echo -e "${BLUE}🌐 Codespace URL: $CODESPACE_URL${NC}"
    sed -i "s|https://localhost:8080|$CODESPACE_URL|g" config.php 2>/dev/null || true
else
    CODESPACE_URL="http://localhost:8080"
fi

# Start PHP server
echo -e "${YELLOW}🚀 Starting PHP development server...${NC}"
echo -e "${GREEN}Access Moodle at: $CODESPACE_URL${NC}"
php -S 0.0.0.0:8080

echo -e "\n${GREEN}🎉 Moodle is starting up!${NC}"
echo -e "\n${BLUE}📋 Access Information:${NC}"
echo "  🌐 URL: $CODESPACE_URL"
echo "  📊 Database: moodle (user: moodleuser)"
echo "  📁 Data: /workspaces/moodledata"

if [ "$MOODLE_INSTALLED" = false ]; then
    echo -e "\n${YELLOW}📋 First Time Setup:${NC}"
    echo "  1. ✅ Open the URL above"
    echo "  2. ✅ Follow Moodle installation wizard"
    echo "  3. ✅ Database is pre-configured"
    echo "  4. ✅ Create admin account"
else
    echo -e "\n${GREEN}✅ Moodle is ready - login with your existing account${NC}"
fi

echo -e "\n${BLUE}💡 Useful Commands:${NC}"
echo "  - Stop server: kill $PHP_PID"
echo "  - View logs: tail -f /var/log/nginx/error.log"
echo "  - MySQL: mysql -u moodleuser -p moodle"
echo "  - Services: sudo systemctl status mysql"

# Keep script running
echo -e "\n${YELLOW}📡 Server running on PID $PHP_PID...${NC}"
echo "Press Ctrl+C to stop"

wait $PHP_PID
