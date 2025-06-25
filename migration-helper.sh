#!/bin/bash

# 🔄 Moodle Migration Helper - From Codespaces to VPS
# Script này giúp backup và chuẩn bị migration từ Codespaces sang VPS

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "🔄 Moodle Migration Helper"
echo "========================="
echo "From GitHub Codespaces to VPS"
echo -e "${NC}"

# Function to create backup
create_backup() {
    echo -e "${YELLOW}📦 Creating backup package...${NC}"
    
    BACKUP_DIR="moodle-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # 1. Export database
    echo -e "${BLUE}🗄️  Exporting database...${NC}"
    if command -v mysqldump >/dev/null 2>&1; then
        mysqldump -u moodleuser -pCodespacePass123! moodle > "$BACKUP_DIR/moodle_database.sql"
        echo -e "${GREEN}✅ Database exported successfully${NC}"
    else
        echo -e "${RED}❌ mysqldump not found${NC}"
        return 1
    fi
    
    # 2. Backup moodledata directory
    echo -e "${BLUE}📁 Backing up moodledata...${NC}"
    if [ -d "/workspaces/moodledata" ]; then
        tar -czf "$BACKUP_DIR/moodledata.tar.gz" -C /workspaces moodledata
        echo -e "${GREEN}✅ Moodledata backed up${NC}"
    else
        echo -e "${YELLOW}⚠️  Moodledata directory not found${NC}"
    fi
    
    # 3. Copy custom configurations
    echo -e "${BLUE}⚙️  Backing up configurations...${NC}"
    cp config.php "$BACKUP_DIR/config-codespaces.php" 2>/dev/null || echo "Config not found"
    
    # 4. Backup custom themes and plugins
    echo -e "${BLUE}🎨 Backing up customizations...${NC}"
    if [ -d "theme/custom" ]; then
        tar -czf "$BACKUP_DIR/custom-themes.tar.gz" theme/custom
    fi
    
    if [ -d "local" ]; then
        tar -czf "$BACKUP_DIR/local-plugins.tar.gz" local
    fi
    
    # 5. Create migration guide
    cat > "$BACKUP_DIR/MIGRATION_GUIDE.md" << 'EOF'
# 🚀 Moodle Migration Guide

## Files in this backup:
- `moodle_database.sql`: Complete database dump
- `moodledata.tar.gz`: User data and files
- `config-codespaces.php`: Current configuration
- `custom-themes.tar.gz`: Custom themes (if any)
- `local-plugins.tar.gz`: Local plugins (if any)
- `vps-config-template.php`: VPS configuration template

## Migration Steps:

### 1. VPS Setup
```bash
# Run on your VPS
curl -O https://raw.githubusercontent.com/YOUR_USERNAME/moodlendk/main/deployment/vps-deploy.sh
chmod +x vps-deploy.sh
./vps-deploy.sh
```

### 2. Upload Files
```bash
# Upload this backup to your VPS
scp -r moodle-backup-* user@your-vps-ip:/tmp/
```

### 3. Restore Database
```bash
# On VPS
mysql -u moodleuser -p moodle < /tmp/moodle-backup-*/moodle_database.sql
```

### 4. Restore Data
```bash
# On VPS
cd /var/www/html
tar -xzf /tmp/moodle-backup-*/moodledata.tar.gz -C /var/
```

### 5. Update Configuration
- Copy `vps-config-template.php` to `config.php`
- Update database credentials and URLs
- Set correct file paths

### 6. Set Permissions
```bash
sudo chown -R www-data:www-data /var/www/html
sudo chown -R www-data:www-data /var/moodledata
sudo chmod -R 755 /var/www/html
sudo chmod -R 777 /var/moodledata
```

### 7. Test
- Access your VPS Moodle URL
- Login with existing credentials
- Verify all data and functionality
EOF
    
    # 6. Create VPS config template
    cat > "$BACKUP_DIR/vps-config-template.php" << 'EOF'
<?php  // Moodle configuration file for VPS deployment

unset($CFG);
global $CFG;
$CFG = new stdClass();

//=========================================================================
// 1. DATABASE SETUP FOR VPS
//=========================================================================
$CFG->dbtype    = 'mysqli';
$CFG->dblibrary = 'native';
$CFG->dbhost    = 'localhost';
$CFG->dbname    = 'moodle';
$CFG->dbuser    = 'moodleuser';
$CFG->dbpass    = 'YOUR_VPS_DB_PASSWORD';  // Change this!
$CFG->prefix    = 'mdl_';
$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => 3306,
  'dbsocket' => '',
  'dbcollation' => 'utf8mb4_unicode_ci',
);

//=========================================================================
// 2. WEB SITE LOCATION FOR VPS
//=========================================================================
$CFG->wwwroot   = 'https://your-domain.com';  // Change this!

//=========================================================================
// 3. SERVER FILE SYSTEM LOCATION FOR VPS
//=========================================================================
$CFG->dataroot  = '/var/moodledata';  // Standard VPS path
$CFG->admin     = 'admin';

//=========================================================================
// 4. PRODUCTION SETTINGS
//=========================================================================
$CFG->directorypermissions = 0777;

// Disable debugging in production
$CFG->debug = 0;
$CFG->debugdisplay = 0;

// Enable caching for better performance
$CFG->cachejs = true;
$CFG->cachetemplates = true;
$CFG->yuicomboloading = true;

// Security settings for production
$CFG->sslproxy = true;  // If using SSL
$CFG->cookiesecure = true;
$CFG->cookiehttponly = true;

// Email settings (configure for your SMTP)
$CFG->smtphosts = 'your-smtp-server.com';
$CFG->smtpuser = 'your-email@domain.com';
$CFG->smtppass = 'your-email-password';
$CFG->smtpsecure = 'tls';

//=========================================================================
// ALL DONE!
//=========================================================================

require_once(__DIR__ . '/lib/setup.php');

// END OF CONFIG FILE
EOF
    
    echo -e "\n${GREEN}🎉 Backup package created: $BACKUP_DIR${NC}"
    echo -e "${BLUE}📋 Contents:${NC}"
    ls -la "$BACKUP_DIR/"
    
    echo -e "\n${YELLOW}📝 Next steps:${NC}"
    echo "1. 📦 Download the backup: $BACKUP_DIR"
    echo "2. 🚀 Follow the MIGRATION_GUIDE.md"
    echo "3. 🔧 Deploy to your VPS using the provided scripts"
    
    return 0
}

# Function to export development changes
export_changes() {
    echo -e "${YELLOW}📤 Exporting recent changes...${NC}"
    
    CHANGES_DIR="moodle-changes-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$CHANGES_DIR"
    
    # Get recent commits
    echo -e "${BLUE}📋 Exporting recent commits...${NC}"
    git log --oneline -10 > "$CHANGES_DIR/recent-commits.txt"
    
    # Export modified files
    echo -e "${BLUE}📁 Exporting modified files...${NC}"
    git diff --name-only HEAD~5 HEAD > "$CHANGES_DIR/modified-files.txt"
    
    # Create patch file
    git format-patch -5 --stdout > "$CHANGES_DIR/recent-changes.patch"
    
    echo -e "${GREEN}✅ Changes exported to: $CHANGES_DIR${NC}"
}

# Function to test VPS compatibility
test_compatibility() {
    echo -e "${YELLOW}🧪 Testing VPS compatibility...${NC}"
    
    # Check PHP version
    php_version=$(php -v | head -n1 | cut -d' ' -f2 | cut -d'.' -f1,2)
    echo -e "${BLUE}PHP Version: $php_version${NC}"
    
    # Check required extensions
    echo -e "${BLUE}🔍 Checking PHP extensions...${NC}"
    required_extensions=("mysqli" "curl" "gd" "xml" "zip" "intl" "mbstring" "soap" "xmlrpc" "opcache")
    
    for ext in "${required_extensions[@]}"; do
        if php -m | grep -q "$ext"; then
            echo -e "${GREEN}✅ $ext${NC}"
        else
            echo -e "${RED}❌ $ext (missing)${NC}"
        fi
    done
    
    echo -e "\n${GREEN}🎯 Compatibility check completed${NC}"
}

# Main menu
echo -e "${BLUE}📋 What would you like to do?${NC}"
echo "1. 📦 Create complete backup for VPS migration"
echo "2. 📤 Export recent development changes"
echo "3. 🧪 Test VPS compatibility"
echo "4. 📚 Show migration guide"
echo "5. 🚪 Exit"

read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        create_backup
        ;;
    2)
        export_changes
        ;;
    3)
        test_compatibility
        ;;
    4)
        echo -e "${BLUE}📚 Migration Guide:${NC}"
        echo "1. 📦 Use option 1 to create backup"
        echo "2. 🚀 Setup VPS with deployment scripts"
        echo "3. 📤 Upload backup to VPS"
        echo "4. 🔄 Restore database and files"
        echo "5. ⚙️  Update configuration"
        echo "6. 🧪 Test functionality"
        ;;
    5)
        echo -e "${GREEN}👋 Goodbye!${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

echo -e "\n${GREEN}🎉 Operation completed!${NC}"
