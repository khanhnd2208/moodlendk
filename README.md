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

### 🌐 Want to Host on GitHub? 
**Yes, you can!** While GitHub doesn't directly host PHP apps, we provide the **perfect GitHub-integrated solution**:

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/moodle)

**✅ One-click deployment from GitHub**  
**✅ Auto-deploys when you push changes**  
**✅ Live public URL with SSL**  
**✅ Managed database included**

[📖 **Complete GitHub Hosting Guide**](GITHUB_HOSTING_GUIDE.md) | [🚀 **Railway Deployment Guide**](deploy-to-railway.md)

### 💻 Development Options

#### Option 1: GitHub Codespaces (Recommended for Development)
1. Click the green "Code" button → "Codespaces" → "New codespace"
2. Wait for automatic setup (5-10 minutes)
3. Run: `./start.sh`
4. Access: `https://[your-codespace]-8080.app.github.dev`

#### Option 2: Local Development
1. Clone this repository
2. Run: `./start.sh`
3. Access: `http://localhost:8080`

### 🔧 Management Helper
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

### 🌟 Railway.app (GitHub-Integrated Hosting)
**Best for**: GitHub users who want seamless deployment
```bash
# 1. Go to railway.app and login with GitHub
# 2. Click "Deploy from GitHub repo"
# 3. Select this repository
# 4. Your site is live in 3-5 minutes!
```
- ✅ **Auto-deploys from GitHub pushes**
- ✅ **Managed PostgreSQL database**
- ✅ **Free tier with $5/month credit**
- ✅ **Custom domains supported**

[🚀 **One-Click Railway Deployment**](deploy-to-railway.md)

### ☁️ Oracle Cloud Free Tier
**Best for**: Maximum resources and control
```bash
./deployment/deploy-oracle.sh
```
- 4 CPU cores, 24GB RAM
- Always free tier eligible
- ARM processor optimized

### 🌊 DigitalOcean VPS
**Best for**: Full control and customization
```bash
./deployment/deploy-digitalocean.sh
```
- Full control and customization
- Scalable resources

### 📄 GitHub Pages (Documentation)
**Best for**: Project documentation and landing pages
- Enable in repository settings
- Perfect for showcasing your Moodle project
- See `/docs/index.html` for the landing page

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

**NEW:** GitHub Hosting Setup
```bash
./setup-github-hosting.sh
```
- 🌐 Verify GitHub hosting configuration
- 📋 Show all available deployment options
- 📄 GitHub Pages setup instructions
- 🚀 Railway.app deployment guide

## 📚 Documentation

- [🌐 GitHub Hosting Guide](GITHUB_HOSTING_GUIDE.md) - **NEW!** Complete guide to hosting on GitHub
- [🚀 Railway Deployment Guide](deploy-to-railway.md) - **NEW!** One-click deployment
- [💻 GitHub Codespaces Guide](CODESPACES_GUIDE.md) - Development environment setup
- [🔄 Development Workflow](DEVELOPMENT_WORKFLOW.md) - From dev to production
- [📖 Moodle Development Guide](MOODLE_DEVELOPMENT_GUIDE.md) - Moodle customization
- [🔒 Security Guidelines](SECURITY.md) - Security best practices
- [📄 GitHub Pages](docs/index.html) - Project landing page

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
