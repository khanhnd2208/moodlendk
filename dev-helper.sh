#!/bin/bash

# 🔧 Moodle Development Helper Script
# Script này giúp bạn bắt đầu development nhanh chóng

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${BLUE}"
echo "🔧 Moodle Development Helper"
echo "=========================="
echo -e "${NC}"

# Function to create feature branch
create_feature_branch() {
    echo -e "${YELLOW}🌿 Creating feature branch...${NC}"
    read -p "Enter feature name (e.g., custom-theme, new-plugin): " feature_name
    
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
    echo -e "${BLUE}You can now start developing your feature.${NC}"
}

# Function to setup custom theme
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
    
    # Copy from boost theme as template
    cp -r theme/boost/* "$theme_dir/"
    
    # Update theme config
    sed -i "s/boost/$theme_name/g" "$theme_dir/config.php"
    
    echo -e "${GREEN}✅ Custom theme '$theme_name' created successfully!${NC}"
    echo -e "${BLUE}Theme location: $theme_dir${NC}"
    echo -e "${YELLOW}Don't forget to update version.php and other theme files!${NC}"
}

# Function to setup custom plugin
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
        1)
            plugin_dir="local/$plugin_name"
            ;;
        2)
            plugin_dir="blocks/$plugin_name"
            ;;
        3)
            plugin_dir="mod/$plugin_name"
            ;;
        4)
            plugin_dir="admin/tool/$plugin_name"
            ;;
        *)
            echo -e "${RED}❌ Invalid choice!${NC}"
            return 1
            ;;
    esac
    
    if [ -d "$plugin_dir" ]; then
        echo -e "${RED}❌ Plugin directory already exists!${NC}"
        return 1
    fi
    
    echo -e "${BLUE}Creating plugin directory: $plugin_dir${NC}"
    mkdir -p "$plugin_dir"
    
    # Create basic plugin structure
    cat > "$plugin_dir/version.php" << EOF
<?php
defined('MOODLE_INTERNAL') || die();

\$plugin->version   = $(date +%Y%m%d)00;
\$plugin->requires  = 2023100900; // Moodle 5.0.1
\$plugin->component = '${plugin_type}_${plugin_name}';
\$plugin->maturity  = MATURITY_STABLE;
\$plugin->release   = '1.0';
EOF
    
    echo -e "${GREEN}✅ Custom plugin '$plugin_name' created successfully!${NC}"
    echo -e "${BLUE}Plugin location: $plugin_dir${NC}"
    echo -e "${YELLOW}Don't forget to add additional plugin files as needed!${NC}"
}

# Function to run development tests
run_dev_tests() {
    echo -e "${YELLOW}🧪 Running development tests...${NC}"
    
    echo -e "${BLUE}1. PHP Syntax Check...${NC}"
    if find . -name "*.php" -not -path "./vendor/*" -exec php -l {} \; > /dev/null 2>&1; then
        echo -e "${GREEN}✅ PHP syntax check passed${NC}"
    else
        echo -e "${RED}❌ PHP syntax errors found${NC}"
        find . -name "*.php" -not -path "./vendor/*" -exec php -l {} \;
        return 1
    fi
    
    echo -e "${BLUE}2. Checking Moodle database schema...${NC}"
    if php admin/cli/check_database_schema.php > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Database schema check passed${NC}"
    else
        echo -e "${YELLOW}⚠️  Database schema check had warnings${NC}"
    fi
    
    echo -e "${BLUE}3. Clearing Moodle caches...${NC}"
    php admin/cli/purge_caches.php
    echo -e "${GREEN}✅ Caches cleared${NC}"
    
    echo -e "${GREEN}🎉 Development tests completed!${NC}"
}

# Function to commit and push changes
commit_and_push() {
    echo -e "${YELLOW}📤 Committing and pushing changes...${NC}"
    
    # Check if there are changes
    if git diff --quiet && git diff --cached --quiet; then
        echo -e "${YELLOW}⚠️  No changes to commit${NC}"
        return 0
    fi
    
    echo -e "${BLUE}Current changes:${NC}"
    git status --short
    
    read -p "Enter commit message: " commit_message
    
    if [ -z "$commit_message" ]; then
        echo -e "${RED}❌ Commit message cannot be empty!${NC}"
        return 1
    fi
    
    git add .
    git commit -m "🔧 $commit_message"
    
    current_branch=$(git branch --show-current)
    git push origin "$current_branch"
    
    echo -e "${GREEN}✅ Changes committed and pushed successfully!${NC}"
    echo -e "${BLUE}Branch: $current_branch${NC}"
}

# Function to optimize Moodle for development
optimize_for_dev() {
    echo -e "${YELLOW}⚡ Optimizing Moodle for development...${NC}"
    
    if [ ! -f "config.php" ]; then
        echo -e "${RED}❌ config.php not found!${NC}"
        return 1
    fi
    
    # Backup original config
    cp config.php config.php.backup
    
    # Add development settings
    cat >> config.php << 'EOF'

// Development optimizations
@error_reporting(E_ALL | E_STRICT);
@ini_set('display_errors', '1');
$CFG->debug = (E_ALL | E_STRICT);
$CFG->debugdisplay = 1;
$CFG->cachejs = false;
$CFG->cachetemplates = false;
$CFG->langstringcache = false;
$CFG->themedesignermode = true;
EOF
    
    echo -e "${GREEN}✅ Moodle optimized for development!${NC}"
    echo -e "${YELLOW}Note: config.php.backup created as backup${NC}"
}

# Main menu
while true; do
    echo -e "\n${PURPLE}🛠️  What would you like to do?${NC}"
    echo "1. 🌿 Create feature branch"
    echo "2. 🎨 Setup custom theme"
    echo "3. 🔌 Setup custom plugin"
    echo "4. 🧪 Run development tests"
    echo "5. 📤 Commit and push changes"
    echo "6. ⚡ Optimize for development"
    echo "7. 📊 Show project status"
    echo "8. 🚪 Exit"
    
    read -p "Enter your choice (1-8): " choice
    
    case $choice in
        1)
            create_feature_branch
            ;;
        2)
            setup_custom_theme
            ;;
        3)
            setup_custom_plugin
            ;;
        4)
            run_dev_tests
            ;;
        5)
            commit_and_push
            ;;
        6)
            optimize_for_dev
            ;;
        7)
            echo -e "${BLUE}📊 Project Status:${NC}"
            echo -e "Current branch: $(git branch --show-current)"
            echo -e "Repository: $(git remote get-url origin 2>/dev/null || echo 'No remote configured')"
            echo -e "Uncommitted changes: $(git status --porcelain | wc -l) files"
            echo -e "Last commit: $(git log -1 --pretty=format:'%h - %s (%cr)')"
            ;;
        8)
            echo -e "${GREEN}👋 Happy coding with Moodle!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid choice. Please try again.${NC}"
            ;;
    esac
done
