# 🔧 Moodle Development Workflow - GitHub Codespaces

## 🎯 Recommended Development Workflow

### Phase 1: Setup Development Environment
```bash
# 1. Create new Codespace từ main branch
# 2. Wait for auto-setup (5-10 minutes)
# 3. Run quick start
./quick-start.sh
```

### Phase 2: Feature Development Cycle
```bash
# 1. Create feature branch
git checkout -b feature/your-feature-name

# 2. Make changes to Moodle code
# 3. Test immediately in Codespace
# 4. Commit changes
git add .
git commit -m "✨ Add new feature: description"

# 5. Push to GitHub
git push origin feature/your-feature-name

# 6. Create Pull Request on GitHub
```

### Phase 3: Testing & Deployment
```bash
# 1. Test in Codespace environment
# 2. Run automated tests (CI/CD pipeline)
# 3. Merge to main branch
# 4. Deploy to production
```

## 🛠️ Development Best Practices

### For Moodle Customization:
1. **Custom themes** → `/theme/custom-theme/`
2. **Custom plugins** → `/local/custom-plugin/`
3. **Custom blocks** → `/blocks/custom-block/`
4. **Custom activities** → `/mod/custom-activity/`

### Version Control Strategy:
- `main` branch: Production-ready code
- `develop` branch: Integration branch
- `feature/*` branches: Individual features
- `hotfix/*` branches: Quick fixes

### Testing Workflow:
1. **Local testing** in Codespace
2. **Automated testing** via GitHub Actions
3. **Manual testing** in staging environment
4. **Production deployment**

## 📊 Cost Comparison

### GitHub Codespaces (Recommended):
- ✅ **Free tier**: 120 hours/month
- ✅ **Cost**: $0-18/month (depending on usage)
- ✅ **Setup time**: 5-10 minutes
- ✅ **Maintenance**: Zero

### Local Development:
- ❌ **Hardware cost**: $500-2000+
- ❌ **Electricity**: $20-50/month
- ❌ **Setup time**: 2-4 hours
- ❌ **Maintenance**: High

### Cloud Server:
- ❌ **VPS cost**: $20-100/month
- ❌ **Setup complexity**: High
- ❌ **Maintenance**: Medium-High

## 🎯 Quick Start Guide

### 1. Access Your Repository
Go to: https://github.com/khanhnd2208/moodlendk

### 2. Create Codespace
- Click "Code" → "Codespaces"
- Click "Create codespace on main"
- Wait for automatic setup

### 3. Start Development
```bash
# Quick start development environment
./quick-start.sh

# Access Moodle at forwarded port 8080
# Access phpMyAdmin at port 8081
```

### 4. Common Development Tasks

#### Adding a Custom Theme:
```bash
# Create custom theme directory
mkdir -p theme/mytheme
cd theme/mytheme

# Copy from existing theme
cp -r ../boost/* .

# Customize theme files
# Edit config.php, version.php, etc.
```

#### Adding a Custom Plugin:
```bash
# Create local plugin
mkdir -p local/myplugin
cd local/myplugin

# Create plugin structure
# Edit version.php, db/install.xml, etc.
```

#### Database Changes:
```bash
# Access database via phpMyAdmin (port 8081)
# Or use CLI
mysql -u moodleuser -pCodespacePass123! moodle
```

### 5. Testing Your Changes
```bash
# Clear Moodle caches
php admin/cli/purge_caches.php

# Run Moodle upgrade
php admin/cli/upgrade.php --non-interactive

# Test functionality in browser
```

## 💡 Pro Tips for Efficient Development

### 1. Use Moodle CLI Tools:
```bash
# Install plugins
php admin/cli/install_plugins.php

# Upgrade database
php admin/cli/upgrade.php

# Clear caches
php admin/cli/purge_caches.php

# Create users
php admin/cli/create_user.php
```

### 2. Quick Testing:
```bash
# PHP syntax check
find . -name "*.php" -exec php -l {} \;

# Moodle code checker
php admin/cli/check_database_schema.php
```

### 3. Efficient Git Workflow:
```bash
# Quick commit
git add . && git commit -m "🔧 Update: description" && git push

# Create and switch to feature branch
git checkout -b feature/new-feature

# Sync with main
git fetch origin && git rebase origin/main
```

### 4. Performance Optimization:
```bash
# Enable debugging (development)
# In config.php:
$CFG->debug = (E_ALL | E_STRICT);
$CFG->debugdisplay = 1;

# Disable caching (development)
$CFG->cachejs = false;
$CFG->cachetemplates = false;
```

## 🔄 Continuous Integration

### Automated Testing:
- Code quality checks
- PHP syntax validation
- Moodle installation tests
- Security scanning

### Deployment Pipeline:
- Development → Codespace
- Testing → GitHub Actions
- Staging → Cloud environment
- Production → Final deployment

## 📚 Resources for Moodle Development

### Official Documentation:
- [Moodle Developer Documentation](https://docs.moodle.org/dev/)
- [Moodle Coding Style](https://docs.moodle.org/dev/Coding_style)
- [Plugin Development](https://docs.moodle.org/dev/Plugin_development)

### Tools Available in Codespace:
- VS Code with PHP extensions
- Moodle-specific debugging tools
- Database management (phpMyAdmin)
- Git integration
- Terminal access

---

**Happy Moodle Development! 🎓**
