#!/bin/sh

yum update -y
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
wget https://rpms.remirepo.net/enterprise/remi-release-6.rpm
rpm -Uvh remi-release-6.rpm epel-release-latest-6.noarch.rpm

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

echo " install php 5.6"
yum --enablerepo=remi-php56 install php-cli php-pear php-intl php-pdo php-mysql php-pgsql php-fpm php-gd php-mbstring php-mcrypt php-xml -y

mkdir -p /etc/nginx/{sites-available,sites-enabled}

wget -P /etc/nginx -N https://raw.githubusercontent.com/cybernet/linux/centos/etc/nginx/nginx.conf
wget -P /etc/nginx -N https://raw.githubusercontent.com/cybernet/linux/centos/etc/nginx/mime.types
wget -P /etc/nginx -N https://raw.githubusercontent.com/cybernet/linux/centos/etc/nginx/caches.conf
wget -P /etc/nginx -N https://raw.githubusercontent.com/cybernet/linux/centos/etc/nginx/repel
mv /etc/nginx/conf.d/default.conf /etc/nginx/sites-available

# get swap.sh
echo "get swap utility"
wget -P /usr/bin -N https://raw.githubusercontent.com/cybernet/linux/centos/sh/swap.sh && chmod +x /usr/bin/swap.sh
echo "checking swap..."
swap.sh
# Don't expose php headers
echo "Dont expose php headers"
sed -i -e 's/expose_php = On/expose_php = Off/g' /etc/php.ini
echo "done"

# Configure php-fpm for { www } pool
# Up to now, we have used TCP connections for our PHP-FPM pool (127.0.0.1:9000, 127.0.0.1:9001, etc.). This causes some overhead. Fortunately we can use Unix sockets instead of TCP connections for our pools and get rid of this overhead. Therefore, Unix sockets are more performant than TCP connections.

# We want sockets to be created in the /var/run/php-fpm directory, therefore we have to create that directory first :

mkdir -p /var/run/php-fpm

# Better run with sockets

sed -i -e 's/127.0.0.1:9000/\/var\/run\/php-fpm\/www.socket/g' -e 's/pm.start_servers = 5/pm.start_servers = 1/g' -e 's/pm.min_spare_servers = 5/pm.min_spare_servers = 1/g' -e 's/pm.max_children = 50/pm.max_children = 10/g' -e 's/pm.max_spare_servers = 35/pm.max_spare_servers = 5/g' -e 's/user = apache/user = nginx/g' -e 's/group = apache/group = nginx/g' -e 's/;listen.owner = nobody/;listen.owner = nginx/g' -e 's/;listen.group = nobody/;listen.group = nginx/g' -e 's/;chdir = \/var\/www/chdir = \/var\/www/g' /etc/php-fpm.d/www.conf

sed -i -e 's/post_max_size = 8M/post_max_size = 50M/g' -e 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g' /etc/php.ini

# Disable MySQL persistent connections / they are slowing the server

sed -i -e 's/mysql.allow_persistent = On/mysql.allow_persistent = Off/g' /etc/php.ini

# Change TimeZone to London -> i chosed London because is GMT+0, easier to implement in code ...

sed -i -e 's/;date.timezone =/date.timezone = "Europe\/London"/g' /etc/php.ini
