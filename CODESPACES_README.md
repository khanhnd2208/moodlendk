# 🚀 Moodle 5.0.1 - GitHub Codespaces Setup

A complete Moodle 5.0.1 Learning Management System configured for GitHub Codespaces deployment with automated setup and multi-platform deployment capabilities.

## 🎯 Features

- ✅ **GitHub Codespaces Ready**: Pre-configured devcontainer with MySQL, PHP 8.1, Nginx
- ✅ **Auto-setup**: Automated environment configuration
- ✅ **Multi-platform Deploy**: Oracle Cloud, Railway.app, DigitalOcean
- ✅ **Development Optimized**: Debug mode, error reporting, fast reload
- ✅ **Production Ready**: Deployment scripts for various cloud platforms

## 🚀 Quick Start

### 1. Open in GitHub Codespaces
1. Click **Code** > **Codespaces** > **Create codespace**
2. Wait for automatic setup (2-3 minutes)
3. Environment will be ready with MySQL, PHP, and all dependencies

### 2. Start Moodle
```bash
# Start PHP development server
php -S 0.0.0.0:8080
```

### 3. Access Your Site
- Click on the **Ports** tab in VS Code
- Open port 8080 in browser
- Complete Moodle installation with pre-configured database

## 🗄️ Database Configuration

Pre-configured database settings:
- **Host**: localhost
- **Database**: moodle
- **Username**: moodleuser
- **Password**: CodespacePass123!
- **Port**: 3306

## 📁 Project Structure

```
├── .devcontainer/          # GitHub Codespaces configuration
├── .github/               # GitHub workflows and instructions
├── deployment/            # Deployment scripts
├── [moodle-files]         # Moodle 5.0.1 source files
└── config.php             # Auto-configuring Moodle config
```

## 🔧 Development Commands

```bash
# Start Moodle development server
php -S 0.0.0.0:8080

# Check services status
sudo systemctl status mysql

# MySQL commands
mysql -u moodleuser -p moodle
```

## 🌐 Deployment Options

- **Oracle Cloud Free Tier**: 4 ARM CPUs, 24GB RAM (Always Free)
- **Railway.app**: $5/month with auto-scaling
- **DigitalOcean**: $4/month VPS

## 🆘 Troubleshooting

**Database Connection Error**
```bash
sudo service mysql start
```

**Permission Issues**
```bash
sudo chown -R vscode:vscode /workspaces/moodledata
chmod -R 777 /workspaces/moodledata
```

---

**🎉 Happy Learning with Moodle in GitHub Codespaces!**
