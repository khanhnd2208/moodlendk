# 🚀 GitHub Codespaces Setup Guide

## Bước 1: Tạo GitHub Codespace

1. **Truy cập GitHub repository**: [https://github.com/khanhnd2208/moodlendk](https://github.com/khanhnd2208/moodlendk)

2. **Tạo Codespace**:
   - Click nút **"Code"** (màu xanh)
   - Chọn tab **"Codespaces"**
   - Click **"Create codespace on main"**
   - Đợi 5-10 phút để setup tự động

## Bước 2: Tự động setup trong Codespace

Khi Codespace mở, nó sẽ tự động:
- ✅ Cài đặt PHP 8.1 + extensions
- ✅ Setup MySQL 8.0 database
- ✅ Cấu hình Nginx (tùy chọn)
- ✅ Tạo moodledata directory
- ✅ Cấu hình quyền files

## Bước 3: Khởi động Moodle

```bash
# Cách 1: Sử dụng script nhanh
./start.sh

# Cách 2: Sử dụng helper script (khuyến nghị)
./moodle-helper.sh
# Chọn option 1: Quick Start

# Cách 3: Manual
sudo service mysql start
php -S 0.0.0.0:8080
```

## Bước 4: Truy cập Moodle

- **URL**: `https://[your-codespace-name]-8080.app.github.dev`
- **Database**: 
  - Host: `localhost`
  - User: `moodleuser`
  - Password: `CodespacePass123!`
  - Database: `moodle`

## Bước 5: Development Workflow

### 5.1 Tạo feature branch
```bash
./moodle-helper.sh
# Chọn option 2: Create Feature Branch
```

### 5.2 Develop tính năng
```bash
# Tạo custom theme
./moodle-helper.sh
# Chọn option 3: Setup Custom Theme

# Tạo custom plugin
./moodle-helper.sh
# Chọn option 4: Setup Custom Plugin
```

### 5.3 Test và commit
```bash
# Test syntax
./moodle-helper.sh
# Chọn option 8: Run Tests

# Commit changes
git add .
git commit -m "✨ Add new feature"
git push origin feature/your-feature-name
```

## Bước 6: Deployment Options

### 6.1 Oracle Cloud Free Tier (Khuyến nghị)
```bash
./deployment/deploy-oracle.sh
```
- **Specs**: 4 CPU, 24GB RAM, Always Free
- **Requirements**: Oracle Cloud account + SSH key

### 6.2 DigitalOcean VPS
```bash
./deployment/deploy-digitalocean.sh
```
- **Specs**: Tùy chọn droplet size
- **Requirements**: DigitalOcean account + API token

### 6.3 Railway.app (Nhanh nhất)
1. Connect GitHub repo to Railway
2. Set environment variables
3. Auto-deploy on push

## 🎯 Mục tiêu phát triển

### Phase 1: Setup & Customization
- [ ] Tạo custom theme
- [ ] Tạo custom plugins
- [ ] Cấu hình tính năng cần thiết
- [ ] Test trong Codespace

### Phase 2: Content & Configuration
- [ ] Tạo courses
- [ ] Setup users & roles
- [ ] Cấu hình học tập
- [ ] Backup & restore testing

### Phase 3: Deployment & Production
- [ ] Deploy to staging (Oracle Cloud)
- [ ] Performance testing
- [ ] Security hardening
- [ ] Production deployment

## 🔧 Useful Commands

```bash
# Xem logs
tail -f /workspaces/moodledata/temp/logs/apache_error.log

# Restart services
sudo service mysql restart
sudo service nginx restart

# Database operations
mysql -u moodleuser -pCodespacePass123! moodle

# Clean cache
./moodle-helper.sh
# Chọn option 9: Clean Cache

# Create backup
./moodle-helper.sh
# Chọn option 5: Create Backup
```

## 🆘 Troubleshooting

### Database connection issues
```bash
sudo service mysql start
mysql -u root -p
```

### Permission issues
```bash
sudo chown -R www-data:www-data /workspaces/moodledata
sudo chmod -R 755 /workspaces/moodledata
```

### Port conflicts
```bash
lsof -i :8080
kill -9 [PID]
```

---

**🎉 Ready to develop your Moodle LMS!**
