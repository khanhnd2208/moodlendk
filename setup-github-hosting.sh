#!/bin/bash

# 🌐 GitHub Hosting Setup and Verification Script

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🌐 GitHub Hosting Setup for Moodle 5.0.1${NC}"
echo -e "${BLUE}===========================================${NC}\n"

# Check current repository status
echo -e "${YELLOW}📋 Checking repository status...${NC}"
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ Not in a Git repository!${NC}"
    exit 1
fi

REPO_URL=$(git remote get-url origin 2>/dev/null || echo "No origin remote")
echo -e "Repository: ${REPO_URL}"

# Check for GitHub hosting files
echo -e "\n${YELLOW}🔍 Checking GitHub hosting configuration...${NC}"

files_to_check=(
    "GITHUB_HOSTING_GUIDE.md"
    "deploy-to-railway.md"
    "docs/index.html"
    "config-railway.php"
    "railway.json"
    "railway-start.sh"
    ".github/workflows/ci-cd.yml"
    ".github/workflows/pages.yml"
)

missing_files=()
for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo -e "✅ $file"
    else
        echo -e "❌ $file"
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -gt 0 ]; then
    echo -e "\n${RED}❌ Missing files for GitHub hosting setup${NC}"
    exit 1
fi

echo -e "\n${GREEN}✅ All GitHub hosting files present!${NC}"

# Check GitHub Pages setup
echo -e "\n${YELLOW}📄 GitHub Pages Setup${NC}"
echo -e "To enable GitHub Pages:"
echo -e "1. Go to your repository settings"
echo -e "2. Scroll to 'Pages' section"
echo -e "3. Source: 'GitHub Actions'"
echo -e "4. Your docs will be available at: https://$(echo $REPO_URL | sed 's|.*github.com/||' | sed 's|\.git||').github.io/$(basename $(pwd))"

# Railway.app deployment guide
echo -e "\n${YELLOW}🚀 Railway.app Deployment${NC}"
echo -e "For one-click deployment:"
echo -e "1. Go to: ${BLUE}https://railway.app${NC}"
echo -e "2. Login with GitHub"
echo -e "3. Click 'New Project' → 'Deploy from GitHub repo'"
echo -e "4. Select this repository"
echo -e "5. Add PostgreSQL database"
echo -e "6. Your site will be live in 3-5 minutes!"

# GitHub Codespaces
echo -e "\n${YELLOW}💻 GitHub Codespaces${NC}"
echo -e "For development:"
echo -e "1. Click 'Code' button → 'Codespaces' → 'Create codespace'"
echo -e "2. Wait for setup (5-10 minutes)"
echo -e "3. Run: ./start.sh"
echo -e "4. Access: https://[codespace-name]-8080.app.github.dev"

# Final summary
echo -e "\n${GREEN}🎉 GitHub Hosting Setup Complete!${NC}"
echo -e "\n${BLUE}Available Options:${NC}"
echo -e "🌐 Railway.app: Best for production hosting with GitHub integration"
echo -e "💻 Codespaces: Perfect for development and testing"
echo -e "📄 GitHub Pages: Documentation and project landing page"
echo -e "☁️  Oracle Cloud: Free tier with maximum resources"
echo -e "🌊 DigitalOcean: Full control VPS hosting"

echo -e "\n${YELLOW}📚 Read the documentation:${NC}"
echo -e "• GITHUB_HOSTING_GUIDE.md - Complete hosting guide"
echo -e "• deploy-to-railway.md - Railway.app deployment"
echo -e "• CODESPACES_GUIDE.md - Codespaces setup"

echo -e "\n${GREEN}Happy hosting! 🚀${NC}"