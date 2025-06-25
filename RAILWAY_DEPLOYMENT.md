# 🚀 Railway.app Deployment Guide for Moodle 5.0.1

## 🎯 Goal
Deploy Moodle to Railway.app for public access with automatic updates from GitHub.

## 📋 Prerequisites
- GitHub account with this repository
- Railway.app account (free tier available)

## 🚀 Deployment Steps

### Step 1: Sign up for Railway.app
1. Go to: https://railway.app
2. Click "Login" 
3. Choose "Login with GitHub"
4. Authorize Railway to access your GitHub account

### Step 2: Deploy from GitHub Repository
1. In Railway dashboard, click "New Project"
2. Select "Deploy from GitHub repo"
3. Choose your repository: `khanhnd2208/moodlendk`
4. Click "Deploy Now"

### Step 3: Add PostgreSQL Database
1. In your Railway project dashboard
2. Click "New Service" 
3. Select "Database"
4. Choose "PostgreSQL"
5. Wait for it to provision (1-2 minutes)

### Step 4: Configure Environment Variables
Railway will automatically set database environment variables:
- `PGHOST` - Database host
- `PGDATABASE` - Database name  
- `PGUSER` - Database username
- `PGPASSWORD` - Database password
- `PGPORT` - Database port

### Step 5: Access Your Live Moodle Site
1. Go to your project dashboard
2. Click on your web service
3. Copy the public URL (looks like: `https://yourproject.up.railway.app`)
4. Visit the URL to complete Moodle installation

### Step 6: Complete Moodle Installation
1. Follow the Moodle setup wizard
2. Database details are auto-configured
3. Create your admin account
4. Configure site settings

## 🔄 Automatic Updates
- Push changes to your GitHub repository
- Railway automatically rebuilds and deploys
- Your live site updates within 2-3 minutes

## 💡 Benefits
- ✅ Always online (24/7)
- ✅ Public URL for sharing
- ✅ Automatic deployments
- ✅ Managed database
- ✅ SSL certificate included
- ✅ No server management needed

## 🆘 Troubleshooting

### Build Fails
- Check the build logs in Railway dashboard
- Ensure all required files are committed to GitHub

### Database Connection Issues
- Verify PostgreSQL service is running
- Check environment variables are set correctly

### Site Not Loading
- Check deployment logs
- Verify the public URL is correct
- Ensure `config-railway.php` is being used

## 📊 Monitoring
- Railway dashboard shows:
  - Build status
  - Deployment logs  
  - Resource usage
  - Custom domains (if needed)

## 💰 Pricing
- **Free tier**: $5/month credit
- **Pro tier**: $20/month for more resources
- Perfect for development and small-scale production

---

**🎉 Once deployed, your Moodle site will be live and accessible to anyone with the URL!**
