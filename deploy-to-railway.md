# 🚀 One-Click Moodle Deployment to Railway.app

## ⚡ Quick Deploy (5 Minutes!)

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/moodle-5.0.1)

### Step 1: Click Deploy Button
1. Click the "Deploy on Railway" button above
2. Login with your GitHub account
3. Railway will automatically fork this repository to your account

### Step 2: Wait for Deployment
- Railway automatically detects this is a PHP application
- PostgreSQL database is provisioned automatically
- Build process takes 2-3 minutes

### Step 3: Access Your Live Moodle
1. Once deployed, click on your project
2. Click the web service to get your URL
3. Your Moodle site is live at: `https://yourproject.up.railway.app`

## 🔧 Manual Setup (Alternative)

If you prefer manual setup:

### 1. Connect GitHub Repository
```bash
# Go to railway.app
# Click "New Project" → "Deploy from GitHub repo"
# Select: khanhnd2208/moodlendk (or your fork)
```

### 2. Add Database Service
```bash
# In your Railway project:
# Click "New Service" → "Database" → "PostgreSQL"
# Railway automatically sets environment variables
```

### 3. Configure Environment Variables
Railway automatically provides these environment variables:
- `PGHOST` - Database host
- `PGDATABASE` - Database name
- `PGUSER` - Database username
- `PGPASSWORD` - Database password
- `PGPORT` - Database port (5432)

### 4. Deploy!
```bash
# Push any changes to your GitHub repository
git push origin main
# Railway automatically rebuilds and deploys
```

## 🎯 What Happens During Deployment

### Build Phase
1. **Nixpacks Detection:** Railway detects PHP application
2. **Dependency Installation:** PHP 8.1 + PostgreSQL extensions
3. **Configuration:** Copies `config-railway.php` to `config.php`
4. **Database Setup:** Creates moodledata directory

### Runtime Phase
1. **Server Start:** PHP built-in server on port $PORT
2. **Database Connection:** Automatic PostgreSQL connection
3. **SSL Certificate:** Automatic HTTPS with Railway domain
4. **Public Access:** Your site is immediately available

## 🔄 GitHub Integration Features

### Automatic Deployments
- Push to GitHub → Automatic rebuild
- Pull requests → Preview deployments
- Branch deployments → Test different versions

### Environment Management
```bash
# Railway automatically handles:
# - Production vs development configs
# - Database environment variables
# - SSL certificates
# - Domain management
```

### Monitoring & Logs
- Real-time deployment logs
- Application logs
- Resource usage monitoring
- Custom domain support

## 🎨 Customization Options

### Custom Domain
1. Go to your Railway project
2. Click on your web service
3. Go to "Settings" → "Domains"
4. Add your custom domain

### Environment Variables
Add custom variables in Railway dashboard:
```bash
MOODLE_SITE_NAME=Your Moodle Site
MOODLE_ADMIN_EMAIL=admin@yoursite.com
MOODLE_LANG=en
```

### Database Scaling
- Upgrade PostgreSQL plan as needed
- Automatic backups included
- Point-in-time recovery available

## 📊 Deployment Verification

After deployment, verify these work:
- [ ] Site loads at Railway URL
- [ ] Database connection successful
- [ ] Moodle installation wizard appears
- [ ] Admin account creation works
- [ ] Course creation functions
- [ ] File uploads work
- [ ] SSL certificate is active

## 🚨 Troubleshooting

### Build Fails
```bash
# Check Railway build logs:
# 1. Go to your project dashboard
# 2. Click on deployment
# 3. Check "Build Logs" tab
```

### Database Connection Issues
```bash
# Verify PostgreSQL service is running:
# 1. Check "Services" in Railway dashboard
# 2. Ensure PostgreSQL status is "Active"
# 3. Verify environment variables are set
```

### Site Not Loading
```bash
# Check application logs:
# 1. Go to web service in Railway
# 2. Click "Logs" tab
# 3. Look for PHP errors or connection issues
```

## 💰 Pricing Information

### Free Tier
- $5/month in usage credits
- Perfect for development and small sites
- Includes PostgreSQL database
- SSL certificate included

### Paid Plans
- $20/month for production workloads
- Higher resource limits
- Priority support
- Custom domains included

## 🎉 Success! What's Next?

Once deployed:
1. **Complete Moodle Setup:** Follow the installation wizard
2. **Create Admin Account:** Set up your administrator user
3. **Configure Site Settings:** Customize your Moodle instance
4. **Add Content:** Create courses and upload materials
5. **Invite Users:** Share your Railway URL with students

## 🔗 Related Resources

- [Railway.app Documentation](https://docs.railway.app)
- [Moodle Installation Guide](https://docs.moodle.org/en/Installing_Moodle)
- [GitHub Integration Guide](GITHUB_HOSTING_GUIDE.md)
- [Development Workflow](DEVELOPMENT_WORKFLOW.md)

---

**🚀 Your Moodle LMS is now live and accessible to the world!**