# Vibe App Deployment Guide

## Overview
This guide covers the deployment of the Vibe social media application to production environments. The application consists of a Node.js backend API and a Flutter mobile application.

## Prerequisites

### System Requirements
- **Server**: Ubuntu 20.04+ or CentOS 7+ with 2GB RAM minimum
- **Database**: MongoDB 5.0+ (Atlas cloud or self-hosted)
- **Reverse Proxy**: Nginx
- **SSL Certificate**: Let's Encrypt or commercial SSL
- **Domain**: Registered domain name

### Development Tools
- Node.js 18+ installed
- Flutter 3.0+ installed
- Git
- PM2 process manager
- Docker (optional)

## Backend Deployment

### 1. Server Preparation
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2
sudo npm install -g pm2

# Install Nginx
sudo apt install nginx -y

# Install Git
sudo apt install git -y
```

### 2. Database Setup

#### Option A: MongoDB Atlas (Recommended)
1. Create account at [MongoDB Atlas](https://www.mongodb.com/atlas)
2. Create a cluster
3. Create database user with read/write permissions
4. Get connection string

#### Option B: Self-hosted MongoDB
```bash
# Install MongoDB
sudo apt-get install gnupg
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org

# Start MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod
```

### 3. Application Deployment
```bash
# Clone repository
git clone https://github.com/yourusername/vibe.git
cd vibe/backend

# Install dependencies
npm install

# Create environment file
cp .env.example .env
nano .env
```

### 4. Environment Configuration
```env
# Production Environment Variables
NODE_ENV=production
PORT=5000

# MongoDB Configuration
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/vibe_prod?retryWrites=true&w=majority

# JWT Configuration
JWT_SECRET=your_super_secure_jwt_secret_key_here
JWT_EXPIRE=7d

# Email Configuration (for future features)
EMAIL_SERVICE=gmail
EMAIL_USER=your_email@gmail.com
EMAIL_PASS=your_app_password

# File Upload Configuration
UPLOAD_PATH=/var/www/vibe/uploads
MAX_FILE_SIZE=5242880

# Redis Configuration (for future caching)
REDIS_URL=redis://localhost:6379

# Logging
LOG_LEVEL=info
LOG_FILE=/var/log/vibe/app.log
```

### 5. PM2 Configuration
Create `ecosystem.config.js`:
```javascript
module.exports = {
  apps: [{
    name: 'vibe-backend',
    script: 'server.js',
    instances: 'max',
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: 5000
    },
    error_file: '/var/log/vibe/error.log',
    out_file: '/var/log/vibe/out.log',
    log_file: '/var/log/vibe/combined.log',
    time: true
  }]
};
```

### 6. Start Application
```bash
# Start with PM2
pm2 start ecosystem.config.js

# Save PM2 configuration
pm2 save

# Set up PM2 to start on boot
pm2 startup
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u $USER --hp $HOME
```

## Frontend Deployment

### 1. Build Flutter App

#### Android APK
```bash
cd frontend

# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

#### iOS Build
```bash
# For iOS (requires macOS)
flutter build ios --release
```

### 2. App Store Deployment

#### Google Play Store
1. Create Google Play Console account
2. Create new app
3. Upload `app-release.aab` file
4. Fill store listing information
5. Set pricing and distribution
6. Publish app

#### Apple App Store
1. Create Apple Developer account
2. Create App ID and provisioning profiles
3. Build with Xcode or `flutter build ios --release`
4. Upload to App Store Connect
5. Fill app information and screenshots
6. Submit for review

## Nginx Configuration

### 1. SSL Certificate Setup
```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate
sudo certbot --nginx -d yourdomain.com -d api.yourdomain.com
```

### 2. Nginx Configuration
Create `/etc/nginx/sites-available/vibe`:
```nginx
# Upstream backend servers
upstream vibe_backend {
    server 127.0.0.1:5000;
    keepalive 32;
}

# API Server
server {
    listen 80;
    server_name api.yourdomain.com;

    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.yourdomain.com;

    # SSL configuration
    ssl_certificate /etc/letsencrypt/live/api.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.yourdomain.com/privkey.pem;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    # API endpoints
    location /api/ {
        proxy_pass http://vibe_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;

        # Timeout settings
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # Health check
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}

# Static Website (Optional - for landing page)
server {
    listen 80;
    server_name yourdomain.com;

    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    root /var/www/vibe/frontend/build/web;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

### 3. Enable Site
```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/vibe /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

## Database Configuration

### Production MongoDB Setup
```javascript
// MongoDB connection with production settings
const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    const conn = await mongoose.connect(process.env.MONGODB_URI, {
      // Production connection options
      maxPoolSize: 10, // Maintain up to 10 socket connections
      serverSelectionTimeoutMS: 5000, // Keep trying to send operations for 5 seconds
      socketTimeoutMS: 45000, // Close sockets after 45 seconds of inactivity
      bufferCommands: false, // Disable mongoose buffering
      bufferMaxEntries: 0, // Disable mongoose buffering
    });

    console.log(`MongoDB Connected: ${conn.connection.host}`);
  } catch (error) {
    console.error('MongoDB connection error:', error);
    process.exit(1);
  }
};

module.exports = connectDB;
```

### Database Indexes
Ensure these indexes are created for optimal performance:
```javascript
// User collection indexes
db.users.createIndex({ "email": 1 }, { unique: true });

// Profile collection indexes
db.profiles.createIndex({ "userId": 1 }, { unique: true });
db.profiles.createIndex({ "interests": 1 });
db.profiles.createIndex({ "location": 1 });

// Posts collection indexes
db.posts.createIndex({ "userId": 1 });
db.posts.createIndex({ "createdAt": -1 });
db.posts.createIndex({ "likes": 1 });

// Messages collection indexes
db.messages.createIndex({ "senderId": 1, "receiverId": 1, "createdAt": -1 });
db.messages.createIndex({ "receiverId": 1, "senderId": 1, "createdAt": -1 });
db.messages.createIndex({ "receiverId": 1, "isRead": 1 });

// Notifications collection indexes
db.notifications.createIndex({ "userId": 1, "isRead": 1 });
db.notifications.createIndex({ "userId": 1, "createdAt": -1 });
```

## Monitoring & Logging

### Application Monitoring
```bash
# PM2 monitoring
pm2 monit

# View logs
pm2 logs vibe-backend

# Restart application
pm2 restart vibe-backend

# Check application status
pm2 status
```

### Log Rotation
Create `/etc/logrotate.d/vibe`:
```
/var/log/vibe/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 644 www-data www-data
    postrotate
        pm2 reloadLogs
    endscript
}
```

### Health Checks
```bash
# Application health check
curl https://api.yourdomain.com/health

# Database connectivity check
curl https://api.yourdomain.com/api/health
```

## Security Hardening

### Firewall Configuration
```bash
# UFW firewall
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw --force reload
```

### SSL/TLS Configuration
```nginx
# Strong SSL configuration
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384;
ssl_prefer_server_ciphers off;
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 10m;
```

### Environment Security
```bash
# Secure environment file permissions
chmod 600 .env

# Use strong JWT secret
# Rotate secrets regularly
# Use environment-specific secrets
```

## Backup Strategy

### Database Backup
```bash
# MongoDB backup script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
mongodump --db vibe_prod --out /backup/vibe_$DATE
```

### File Backup
```bash
# Application backup
tar -czf /backup/vibe_app_$DATE.tar.gz /var/www/vibe
```

### Automated Backups
```bash
# Add to crontab
0 2 * * * /path/to/backup-script.sh
```

## Scaling Considerations

### Horizontal Scaling
- Use load balancer for multiple backend instances
- Implement Redis for session storage
- Use CDN for static assets

### Database Scaling
- Implement read replicas
- Use sharding for large datasets
- Optimize queries and indexes

### Monitoring
- Set up application performance monitoring
- Implement error tracking
- Monitor resource usage

## Troubleshooting

### Common Issues

#### Application Not Starting
```bash
# Check PM2 status
pm2 status

# Check logs
pm2 logs vibe-backend --lines 100

# Check environment variables
cat .env
```

#### Database Connection Issues
```bash
# Test MongoDB connection
mongosh mongodb://localhost:27017/vibe

# Check MongoDB status
sudo systemctl status mongod
```

#### Nginx Issues
```bash
# Test configuration
sudo nginx -t

# Check error logs
sudo tail -f /var/log/nginx/error.log
```

## Performance Optimization

### Backend Optimization
- Implement caching (Redis)
- Use compression middleware
- Optimize database queries
- Implement rate limiting

### Frontend Optimization
- Code splitting
- Image optimization
- Lazy loading
- Minimize bundle size

### Database Optimization
- Proper indexing
- Query optimization
- Connection pooling
- Regular maintenance

## Maintenance Tasks

### Regular Updates
```bash
# Update dependencies
npm audit fix
npm update

# Update system packages
sudo apt update && sudo apt upgrade
```

### Monitoring Checks
- Daily log review
- Weekly performance checks
- Monthly security updates
- Quarterly backup verification

## Support & Documentation

- **API Documentation**: `/docs/API_DOCUMENTATION.md`
- **Testing Guide**: `/docs/TESTING_VERIFICATION.md`
- **Troubleshooting**: Check logs and monitoring dashboards
- **Updates**: Monitor GitHub repository for updates

---

## Deployment Checklist

### Pre-Deployment
- [ ] Domain purchased and configured
- [ ] SSL certificates obtained
- [ ] Server provisioned and secured
- [ ] Database created and configured
- [ ] Environment variables set
- [ ] Application code deployed

### Deployment Steps
- [ ] Backend deployed and tested
- [ ] Frontend built and uploaded to stores
- [ ] Nginx configured and tested
- [ ] SSL configured
- [ ] Monitoring set up
- [ ] Backup strategy implemented

### Post-Deployment
- [ ] Application tested end-to-end
- [ ] Performance benchmarks run
- [ ] Monitoring alerts configured
- [ ] Documentation updated
- [ ] Team notified of deployment

For additional support or questions, please refer to the project documentation or create an issue in the repository.