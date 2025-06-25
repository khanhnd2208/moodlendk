# 🚀 Moodle 5.0.1 - GitHub Codespaces Edition

<p align="center"><a href="https://moodle.org" target="_blank" title="Moodle Website">
  <img src="https://raw.githubusercontent.com/moodle/moodle/main/.github/moodlelogo.svg" alt="The Moodle Logo">
</a></p>

A complete Moodle 5.0.1 Learning Management System optimized for GitHub Codespaces with automated setup and multi-platform deployment capabilities.

## ✨ Key Features

- 🚀 **GitHub Codespaces Ready**: Pre-configured devcontainer with MySQL, PHP 8.1
- 🐳 **Docker Compose**: Simplified container management
- 🔧 **Unified Management**: Single helper script for all tasks
- 📦 **Multi-Platform Deployment**: Oracle Cloud, DigitalOcean, Railway.app
- 🛡️  **Security Optimized**: Production-ready configurations
- ⚡ **Performance Tuned**: ARM processor compatibility

## 🚀 Quick Start

### 1. Open in GitHub Codespaces
1. Click the green "Code" button → "Codespaces" → "New codespace"
2. Wait for automatic setup (5-10 minutes)
3. Run: `./start.sh`

### 2. Access Moodle
- Codespaces: `https://[your-codespace]-8080.app.github.dev`
- Local: `http://localhost:8080`

### 3. Management Helper
Use the unified management script for all tasks:
```bash
./moodle-helper.sh
```

## 📁 Project Structure

```
├── .devcontainer/          # GitHub Codespaces configuration
├── .github/               # GitHub workflows and templates
├── deployment/            # Deployment scripts for different platforms
├── moodle-helper.sh       # Unified management script
├── start.sh              # Quick start script
└── [moodle-core-files]   # Standard Moodle 5.0.1 files
```

## 🛠️ Development Workflow

1. **Create Feature Branch**: `./moodle-helper.sh` → Option 2
2. **Develop**: Make changes, test in Codespace
3. **Commit**: Regular commits with meaningful messages
4. **Deploy**: Use deployment scripts for production

## 🚀 Deployment Options

### Oracle Cloud Free Tier (Recommended)
```bash
./deployment/deploy-oracle.sh
```
- 4 CPU cores, 24GB RAM
- Always free tier eligible
- ARM processor optimized

### DigitalOcean VPS
```bash
./deployment/deploy-digitalocean.sh
```
- Full control and customization
- Scalable resources

### Railway.app (Quick Deploy)
- Connect GitHub repository
- Automatic deployments
- PostgreSQL included

## ⚙️ Configuration

Key configuration files:
- `config-codespaces-sample.php`: Codespaces configuration template
- `.devcontainer/`: Development environment setup
- `deployment/`: Production deployment configurations

## 🔧 Management Tasks

The `moodle-helper.sh` script provides:
- 🚀 Quick start development server
- 🌿 Create feature branches
- 🎨 Setup custom themes
- 🔌 Create custom plugins
- 📦 Database and file backups
- 🧹 Cache cleaning
- 🧪 Syntax testing

## 📚 Documentation

- [GitHub Codespaces Guide](CODESPACES_GUIDE.md)
- [Development Workflow](DEVELOPMENT_WORKFLOW.md)
- [Moodle Development Guide](MOODLE_DEVELOPMENT_GUIDE.md)
- [Security Guidelines](SECURITY.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test in Codespaces
5. Submit a pull request

## 📄 License

This project follows Moodle's GPL v3 license. See [COPYING.txt](COPYING.txt) for details.

## 🆘 Support

- Check existing [Issues](../../issues)
- Review [Documentation](CODESPACES_GUIDE.md)
- Use the `moodle-helper.sh` script for common tasks

---

**🎉 Happy Learning with Moodle!**
