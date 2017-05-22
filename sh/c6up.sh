#!/bin/sh

yum update -y
yum install epel* -y

# Change TimeZone to London -> i chosed London because is GMT+0, easier to implement in code ...
echo " changing timezone to London, its easier"
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
# MySQL server, wGET && hTOP
echo "installing mysql server, wget, hTOP"
yum install mysql-server wget htop -y
# Get MySQL config from github repo
wget -O /etc/my.cnf -N https://raw.githubusercontent.com/cybernet/linux/centos/etc/my.cnf

# remove the old httpd
echo "removing httpd"
service httpd stop
chkconfig httpd off
yum remove httpd -y

# add nginx repo & yum priority plugin

yum install yum-plugin-priorities -y && wget -P /etc/yum.repos.d -N https://raw.githubusercontent.com/cybernet/linux/centos/repos/nginx.repo

# add nginx key
echo "get nginx key"
rpm --import http://nginx.org/keys/nginx_signing.key

yum install nginx -y

# start the service

service nginx start

# REMi Way
echo " get remi repo and install php 5.6"
wget -P /etc/yum.repos.d -N https://raw.githubusercontent.com/cybernet/linux/centos/repos/remi.repo
yum --enablerepo=remi install php-cli php-pear php-pdo php-mysql php-pgsql php-fpm php-gd php-mbstring php-mcrypt php-xml -y

mkdir -p /etc/nginx/{sites-available,sites-enabled}

wget -P /etc/nginx -N https://raw.githubusercontent.com/cybernet/linux/centos/etc/nginx/nginx.conf
wget -P /etc/nginx -N https://raw.githubusercontent.com/cybernet/linux/centos/etc/nginx/mime.types
wget -P /etc/nginx -N https://raw.githubusercontent.com/cybernet/linux/centos/etc/nginx/caches.conf
wget -P /etc/nginx -N https://raw.githubusercontent.com/cybernet/linux/centos/etc/nginx/repel
mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available

# get swap.sh
echo "get swap utility"
wget -P /usr/bin -N https://raw.githubusercontent.com/cybernet/linux/centos/sh/swap.sh && chmod +x /usr/bin/swap.sh

# Don't expose php headers
echo "Dont expose php headers"
sed -i -e 's/expose_php = On/expose_php = Off/g' /etc/php.ini
