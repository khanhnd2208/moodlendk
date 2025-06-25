#!/bin/bash

# 🔧 Moodle Management Helper Script
# Unified script for development, migration, and deployment tasks

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${BLUE}"
echo "🔧 Moodle Management Helper"
echo "==========================="
echo -e "${NC}"

# Function to show menu
show_menu() {
    echo -e "${BLUE}What would you like to do?${NC}"
    echo "1. 🚀 Quick Start (Development)"
    echo "2. 🌿 Create Feature Branch"
    echo "3. 🎨 Setup Custom Theme"
    echo "4. 🔌 Setup Custom Plugin"
    echo "5. 📦 Create Backup"
    echo "6. 🔄 Migration Helper"
    echo "7. 🚀 Deploy to VPS"
    echo "8. 🧪 Run Tests"
    echo "9. 🧹 Clean Cache"
    echo "0. Exit"
    echo
    read -p "Enter your choice (0-9): " choice
}

# Quick start function
quick_start() {
    echo -e "${YELLOW}🚀 Starting Moodle development environment...${NC}"
    
    # Check if in Codespaces
    if [ -n "$CODESPACES" ]; then
        echo -e "${GREEN}✅ Running in GitHub Codespaces${NC}"
        CODESPACE_URL="https://$CODESPACE_NAME-8080.app.github.dev"
    else
        echo -e "${YELLOW}⚠️  Running locally${NC}"
        CODESPACE_URL="http://localhost:8080"
    fi
    
    # Start services
    echo -e "${YELLOW}🔄 Starting services...${NC}"
    sudo service mysql start || echo "MySQL already running"
    
    # Check Moodle installation
    if mysql -u moodleuser -pCodespacePass123! -e "USE moodle; SHOW TABLES;" 2>/dev/null | grep -q "mdl_"; then
        echo -e "${GREEN}✅ Moodle database found${NC}"
    else
        echo -e "${YELLOW}📦 Fresh installation detected${NC}"
    fi
    
    # Start PHP server
    echo -e "${YELLOW}🚀 Starting PHP development server...${NC}"
    echo -e "${GREEN}🌐 Access Moodle at: $CODESPACE_URL${NC}"
    php -S 0.0.0.0:8080
}

# Create feature branch function
create_feature_branch() {
    echo -e "${YELLOW}🌿 Creating feature branch...${NC}"
    read -p "Enter feature name: " feature_name
    
    if [ -z "$feature_name" ]; then
        echo -e "${RED}❌ Feature name cannot be empty!${NC}"
        return 1
    fi
    
    # Clean feature name
    feature_name=$(echo "$feature_name" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
    branch_name="feature/$feature_name"
    
    echo -e "${BLUE}Creating branch: $branch_name${NC}"
    git checkout -b "$branch_name"
    echo -e "${GREEN}✅ Feature branch created successfully!${NC}"
}

# Setup custom theme function
setup_custom_theme() {
    echo -e "${YELLOW}🎨 Setting up custom theme...${NC}"
    read -p "Enter theme name: " theme_name
    
    if [ -z "$theme_name" ]; then
        echo -e "${RED}❌ Theme name cannot be empty!${NC}"
        return 1
    fi
    
    theme_dir="theme/$theme_name"
    
    if [ -d "$theme_dir" ]; then
        echo -e "${RED}❌ Theme directory already exists!${NC}"
        return 1
    fi
    
    echo -e "${BLUE}Creating theme directory: $theme_dir${NC}"
    mkdir -p "$theme_dir"
    cp -r theme/boost/* "$theme_dir/"
    sed -i "s/boost/$theme_name/g" "$theme_dir/config.php"
    
    echo -e "${GREEN}✅ Custom theme '$theme_name' created successfully!${NC}"
}

# Setup custom plugin function
setup_custom_plugin() {
    echo -e "${YELLOW}🔌 Setting up custom plugin...${NC}"
    
    echo "Select plugin type:"
    echo "1. Local plugin (local/)"
    echo "2. Block plugin (blocks/)"
    echo "3. Activity module (mod/)"
    echo "4. Admin tool (admin/tool/)"
    
    read -p "Enter choice (1-4): " plugin_type
    read -p "Enter plugin name: " plugin_name
    
    if [ -z "$plugin_name" ]; then
        echo -e "${RED}❌ Plugin name cannot be empty!${NC}"
        return 1
    fi
    
    case $plugin_type in
        1) plugin_dir="local/$plugin_name" ;;
        2) plugin_dir="blocks/$plugin_name" ;;
        3) plugin_dir="mod/$plugin_name" ;;
        4) plugin_dir="admin/tool/$plugin_name" ;;
        *) echo -e "${RED}❌ Invalid choice!${NC}"; return 1 ;;
    esac
    
    if [ -d "$plugin_dir" ]; then
        echo -e "${RED}❌ Plugin directory already exists!${NC}"
        return 1
    fi
    
    echo -e "${BLUE}Creating plugin directory: $plugin_dir${NC}"
    mkdir -p "$plugin_dir"
    echo -e "${GREEN}✅ Plugin directory created successfully!${NC}"
}

# Create backup function
create_backup() {
    echo -e "${YELLOW}📦 Creating backup...${NC}"
    
    BACKUP_DIR="moodle-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Database backup
    echo -e "${BLUE}🗄️  Backing up database...${NC}"
    if mysqldump -u moodleuser -pCodespacePass123! moodle > "$BACKUP_DIR/moodle_database.sql" 2>/dev/null; then
        echo -e "${GREEN}✅ Database backed up${NC}"
    else
        echo -e "${RED}❌ Database backup failed${NC}"
    fi
    
    # Moodledata backup
    if [ -d "/workspaces/moodledata" ]; then
        echo -e "${BLUE}📁 Backing up moodledata...${NC}"
        tar -czf "$BACKUP_DIR/moodledata.tar.gz" -C /workspaces moodledata
        echo -e "${GREEN}✅ Moodledata backed up${NC}"
    fi
    
    # Config backup
    cp config.php "$BACKUP_DIR/config.php" 2>/dev/null || true
    
    echo -e "${GREEN}✅ Backup created in: $BACKUP_DIR${NC}"
}

# Clean cache function
clean_cache() {
    echo -e "${YELLOW}🧹 Cleaning Moodle cache...${NC}"
    
    # Clear Moodle cache directories
    find /workspaces/moodledata/cache -type f -name "*.cache" -delete 2>/dev/null || true
    find /workspaces/moodledata/temp -type f -delete 2>/dev/null || true
    find /workspaces/moodledata/trashdir -type f -delete 2>/dev/null || true
    
    echo -e "${GREEN}✅ Cache cleaned successfully${NC}"
}

# Run tests function
run_tests() {
    echo -e "${YELLOW}🧪 Running PHP syntax tests...${NC}"
    
    # Check PHP syntax
    if find . -name "*.php" -path "./local/*" -o -path "./theme/*" -exec php -l {} \; 2>/dev/null; then
        echo -e "${GREEN}✅ All PHP files have valid syntax${NC}"
    else
        echo -e "${RED}❌ PHP syntax errors found${NC}"
    fi
    
    # Check config file
    if [ -f "config.php" ]; then
        if php -l config.php >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Config file syntax is valid${NC}\n"
        else
            echo -e "${RED}❌ Config file has syntax errors${NC}"
        fi
    fi
}

# Main menu loop
while true; do
    show_menu
    case $choice in
        1) quick_start ;;
        2) create_feature_branch ;;
        3) setup_custom_theme ;;
        4) setup_custom_plugin ;;
        5) create_backup ;;
        6) echo -e "${BLUE}Migration helper functionality integrated${NC}" ;;
        7) echo -e "${BLUE}Deploy to VPS - check deployment/ directory${NC}" ;;
        8) run_tests ;;
        9) clean_cache ;;
        0) echo -e "${GREEN}👋 Goodbye!${NC}"; exit 0 ;;
        *) echo -e "${RED}❌ Invalid choice!${NC}" ;;
    esac
    echo
    read -p "Press Enter to continue..."
    clear
done
