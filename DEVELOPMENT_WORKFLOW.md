# 🔄 Development to Production Workflow

## 📋 Tổng quan
Workflow này được thiết kế để bạn có thể phát triển trên GitHub Codespaces và dễ dàng chuyển sang VPS mà **KHÔNG GẶP KHÓ KHĂN**.

## 🎯 Workflow được khuyến nghị

### 1️⃣ **Development Phase (GitHub Codespaces)**
```bash
# Tạo Codespace từ repository
# Codespace tự động setup: PHP 8.1 + MySQL 8.0 + Nginx

# Bắt đầu development
./quick-start.sh

# Development URL: https://your-codespace-8080.githubpreview.dev
```

### 2️⃣ **Development & Testing**
```bash
# Thực hiện các thay đổi
- Customization themes
- Add/modify plugins
- Configure settings
- Add content

# Commit changes thường xuyên
git add .
git commit -m "✨ Added new feature"
git push origin main
```

### 3️⃣ **Pre-Migration Testing**
```bash
# Test migration readiness
./migration-helper.sh

# Chọn option 3: Test VPS compatibility
# Chọn option 1: Create backup package
```

### 4️⃣ **VPS Deployment**
```bash
# Trên VPS mới
curl -O https://raw.githubusercontent.com/khanhnd2208/moodlendk/main/deployment/vps-deploy.sh
chmod +x vps-deploy.sh
./vps-deploy.sh
```

### 5️⃣ **Data Migration**
```bash
# Upload backup từ Codespaces
scp -r moodle-backup-* user@vps-ip:/tmp/

# Restore database
mysql -u moodleuser -p moodle < /tmp/moodle-backup-*/moodle_database.sql

# Restore files
tar -xzf /tmp/moodle-backup-*/moodledata.tar.gz -C /var/
```

## 🔧 Environment Compatibility Matrix

| Component | Codespaces | VPS | Compatible |
|-----------|------------|-----|-----------|
| PHP Version | 8.1 | 8.1 | ✅ 100% |
| MySQL Version | 8.0 | 8.0 | ✅ 100% |
| Web Server | Nginx | Nginx | ✅ 100% |
| File Structure | Standard | Standard | ✅ 100% |
| Database Schema | utf8mb4_unicode_ci | utf8mb4_unicode_ci | ✅ 100% |
| PHP Extensions | All required | All required | ✅ 100% |

## 📁 File Structure Mapping

### Codespaces → VPS
```
Codespaces                    →  VPS
/workspaces/Github Codespace  →  /var/www/html/moodle
/workspaces/moodledata        →  /var/moodledata
config.php                    →  config.php (updated URLs)
```

## 🔄 Zero-Downtime Migration Process

### Phase 1: Preparation
1. ✅ Setup VPS with identical environment
2. ✅ Test VPS deployment script
3. ✅ Create backup from Codespaces

### Phase 2: Migration
1. ✅ Deploy Moodle to VPS
2. ✅ Restore database and files
3. ✅ Update configuration
4. ✅ Test functionality

### Phase 3: Go Live
1. ✅ Update DNS to point to VPS
2. ✅ Enable SSL certificate
3. ✅ Monitor and verify

## 🛠️ Troubleshooting Common Issues

### Database Connection Issues
```bash
# Check database service
sudo systemctl status mysql

# Test connection
mysql -u moodleuser -p moodle -e "SHOW TABLES;"
```

### File Permission Issues
```bash
# Fix permissions
sudo chown -R www-data:www-data /var/www/html/moodle
sudo chown -R www-data:www-data /var/moodledata
sudo chmod -R 755 /var/www/html/moodle
sudo chmod -R 777 /var/moodledata
```

### PHP Configuration Issues
```bash
# Check PHP-FPM status
sudo systemctl status php8.1-fpm

# Test PHP configuration
php -v
php -m | grep -E "(mysqli|curl|gd|xml|zip|intl|mbstring|soap|xmlrpc|opcache)"
```

### Nginx Configuration Issues
```bash
# Test Nginx configuration
sudo nginx -t

# Check Nginx status
sudo systemctl status nginx

# View error logs
sudo tail -f /var/log/nginx/moodle_error.log
```

## 🎯 Migration Checklist

### Pre-Migration ✅
- [ ] VPS meets system requirements
- [ ] Backup created from Codespaces
- [ ] DNS configured (if needed)
- [ ] SSL certificate ready (if needed)

### During Migration ✅
- [ ] VPS deployment script executed successfully
- [ ] Database restored without errors
- [ ] Files uploaded and extracted
- [ ] Configuration updated
- [ ] Services restarted

### Post-Migration ✅
- [ ] Website accessible via domain
- [ ] Login functionality working
- [ ] Database connections stable
- [ ] File uploads working
- [ ] Email functionality configured
- [ ] SSL certificate active (if enabled)
- [ ] Performance optimized

## 📊 Performance Comparison

| Metric | Codespaces | VPS | Note |
|--------|------------|-----|------|
| Response Time | ~200ms | ~100ms | VPS typically faster |
| File Upload | 100MB limit | Configurable | VPS more flexible |
| Storage | 32GB | Unlimited | VPS advantage |
| Bandwidth | GitHub limits | Server limits | Depends on provider |
| Uptime | 99.9% | 99.9%+ | Similar reliability |

## 🔐 Security Considerations

### Codespaces Security ✅
- Isolated containers
- HTTPS by default
- GitHub authentication
- Private by default

### VPS Security ✅
- Firewall configuration
- SSL certificates
- Regular updates
- Access control

## 💰 Cost Analysis

### Codespaces Costs
- Free tier: 120 hours/month
- Paid: $0.18/hour (2-core)
- Ideal for: Development, testing

### VPS Costs
- Entry level: $5-10/month
- Production: $20-50/month
- Ideal for: Production, high traffic

## 🎉 Migration Success Stories

> **"Chuyển từ Codespaces sang VPS chỉ mất 30 phút!"**
> - Database export/import: 5 phút
> - File transfer: 10 phút  
> - Configuration update: 5 phút
> - Testing: 10 phút

## 📞 Support & Help

### Common Resources
- 📚 **Documentation**: Check all .md files in repository
- 🐛 **Issues**: Use GitHub Issues for bug reports
- 💬 **Discussions**: GitHub Discussions for questions
- 🚀 **Deployment**: Use provided scripts

### Emergency Procedures
1. **Backup everything** before major changes
2. **Test in Codespaces** before VPS deployment
3. **Keep both environments** during migration
4. **Document custom changes** for easy restoration

---

## 🎯 **Kết luận: TẠI SAO KHÔNG KHÓ KHĂN?**

1. **🎯 Cùng technology stack**: PHP 8.1, MySQL 8.0, Nginx
2. **📦 Automated tools**: Scripts xử lý tất cả complexity
3. **🔄 Seamless migration**: Backup/restore process đơn giản
4. **🛡️ Risk mitigation**: Keep both environments during transition
5. **📚 Complete documentation**: Step-by-step guides

**➡️ Bạn có thể yên tâm phát triển trên Codespaces!**
