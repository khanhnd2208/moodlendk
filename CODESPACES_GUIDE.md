# 🚀 Moodle 5.0.1 GitHub Codespaces Guide

This guide will help you set up and deploy Moodle 5.0.1 using GitHub Codespaces for development and production deployment.

## 📋 Quick Start with GitHub Codespaces

### 1. Push to GitHub Repository

```bash
# Add your GitHub repository as remote
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# Push the code
git branch -M main
git push -u origin main
```

### 2. Create Codespace

1. Go to your GitHub repository
2. Click the green "Code" button
3. Switch to "Codespaces" tab
4. Click "Create codespace on main"
5. Wait for the environment to build (5-10 minutes)

### 3. Automatic Setup

The Codespace will automatically:
- ✅ Install PHP 8.1 with required extensions
- ✅ Configure MySQL 8.0 database
- ✅ Set up Nginx web server
- ✅ Create Moodle database and user
- ✅ Configure proper file permissions

## 🔧 Manual Configuration Steps

After Codespace is ready:

### 1. Update config.php

```php
<?php
$CFG = new stdClass();

// Database configuration for Codespaces
$CFG->dbtype    = 'mysqli';
$CFG->dblibrary = 'native';
$CFG->dbhost    = 'localhost';
$CFG->dbname    = 'moodle';
$CFG->dbuser    = 'moodleuser';
$CFG->dbpass    = 'CodespacePass123!';
$CFG->prefix    = 'mdl_';
$CFG->dboptions = array(
    'dbpersist' => 0,
    'dbport' => 3306,
    'dbsocket' => '',
    'dbcollation' => 'utf8mb4_unicode_ci',
);

// Codespace-specific URLs (will be updated automatically)
$CFG->wwwroot   = 'https://YOUR-CODESPACE-URL.githubpreview.dev';
$CFG->dataroot  = '/workspaces/moodledata';

// Performance settings
$CFG->directorypermissions = 0777;
$CFG->admin = 'admin';

require_once(__DIR__ . '/lib/setup.php');
?>
```

### 2. Start Development Server

```bash
# Option 1: PHP built-in server (recommended for development)
php -S 0.0.0.0:8080

# Option 2: Use Nginx (for production-like testing)
sudo service nginx start
sudo service php8.1-fpm start
```

### 3. Access Your Moodle

- **Development Server**: Use the forwarded port 8080
- **Nginx Server**: Use the forwarded port 80
- **phpMyAdmin**: Use the forwarded port 8081

## 🎯 Deployment Options

### A. Oracle Cloud (Free Tier)
- 4 ARM CPUs, 24GB RAM
- Use the scripts in `/deployment/oracle-cloud/`

### B. Railway.app
- Quick deployment with PostgreSQL
- Use the scripts in `/deployment/railway/`

### C. DigitalOcean
- VPS with full control
- Use the scripts in `/deployment/digitalocean/`

## 🗄️ Database Information

```
Host: localhost
Database: moodle
Username: moodleuser
Password: CodespacePass123!
Port: 3306
Charset: utf8mb4_unicode_ci
```

## 📁 Directory Structure

```
/workspaces/
├── Github Codespace/          # Your Moodle root directory
│   ├── .devcontainer/         # Codespaces configuration
│   ├── admin/                 # Moodle admin files
│   ├── course/                # Course management
│   ├── mod/                   # Activity modules
│   ├── theme/                 # Themes
│   ├── custom-themes/         # Custom themes
│   ├── custom-plugins/        # Custom plugins
│   ├── deployment/            # Deployment scripts
│   └── config.php             # Main configuration
└── moodledata/                # Moodle data directory
```

## 🔍 Troubleshooting

### Common Issues:

1. **Port not accessible**
   - Check if ports are forwarded in Codespaces
   - Try accessing via the Ports tab in VS Code

2. **Database connection error**
   - Ensure MySQL service is running: `sudo service mysql status`
   - Check database credentials in config.php

3. **File permission issues**
   ```bash
   sudo chown -R vscode:vscode /workspaces/moodledata
   chmod -R 777 /workspaces/moodledata
   ```

4. **PHP extensions missing**
   ```bash
   # Install additional extensions
   sudo apt-get update
   sudo apt-get install php8.1-[extension-name]
   ```

### Useful Commands:

```bash
# Check services status
sudo systemctl status mysql nginx php8.1-fpm

# Restart services
sudo systemctl restart mysql nginx php8.1-fpm

# View logs
sudo tail -f /var/log/nginx/error.log
sudo journalctl -u mysql -f

# Database operations
mysql -u moodleuser -p moodle
```

## 🚀 Next Steps

1. **Complete Moodle Installation**
   - Access your Codespace URL
   - Follow Moodle installation wizard
   - Create admin account

2. **Customize Your Instance**
   - Install additional plugins
   - Configure themes
   - Set up courses and users

3. **Prepare for Production**
   - Choose deployment target
   - Update configuration for production
   - Set up domain and SSL certificates

4. **Backup and Maintenance**
   - Set up automated backups
   - Configure monitoring
   - Plan for updates and maintenance

## 📚 Additional Resources

- [Moodle 5.0.1 Documentation](https://docs.moodle.org/)
- [GitHub Codespaces Documentation](https://docs.github.com/en/codespaces)
- [Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/)
- [Railway.app Documentation](https://docs.railway.app/)

---

**Happy coding with Moodle 5.0.1! 🎓**
