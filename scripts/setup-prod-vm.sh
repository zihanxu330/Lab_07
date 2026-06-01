#!/bin/bash
# ===================================================
# 生产环境 VM 初始化脚本
# 用法: ssh user@prod-vm 'bash -s' < setup-prod-vm.sh
# ===================================================

set -e

echo "🚀 开始配置生产环境 VM..."

# 1. 系统更新
sudo apt update && sudo apt upgrade -y

# 2. 安装 Nginx
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# 3. 安装 Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# 4. 安装 PM2 进程管理
sudo npm install -g pm2
pm2 startup systemd -u $USER --hp /home/$USER
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u $USER --hp /home/$USER

# 5. 创建应用目录
sudo mkdir -p /opt/lab07-prod
sudo chown -R $USER:$USER /opt/lab07-prod

# 6. 配置 Nginx
sudo cp /opt/lab07-prod/nginx-prod.conf /etc/nginx/sites-available/lab07-prod
sudo ln -sf /etc/nginx/sites-available/lab07-prod /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# 7. 测试 Nginx 配置并重启
sudo nginx -t && sudo systemctl reload nginx

# 8. 防火墙
sudo ufw allow 'Nginx Full'
sudo ufw allow OpenSSH
sudo ufw --force enable

echo "✅ 生产环境 VM 配置完成！"
echo "🌐 Nginx: http://$(curl -s ifconfig.me)"
echo "📁 应用目录: /opt/lab07-prod"
echo "🔧 PM2 进程: lab07-prod"
