#!/bin/sh

APP_NAME="gogs"
MYSQL_PASSWORD=NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
HOSTNAME="example.com"

# setup mysql
yum install mysql-server -y
service mysqld start
chkconfig mysqld --level235 on

mysqladmin -u root password "${MYSQL_PASSWORD}"
mysqladmin -u root --password="${MYSQL_PASSWORD}" password "${MYSQL_PASSWORD}"
mysql -u root -p${MYSQL_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS ${APP_NAME}; use ${APP_NAME}; set global storage_engine=INNODB;"

# add nginx repo & yum priority plugin

yum install yum-plugin-priorities -y && cd /etc/yum.repos.d && wget -N https://raw.githubusercontent.com/cybernet/linux/centos/repos/nginx.repo

yum install nginx -y

cat > /etc/nginx/conf.d/default.conf <<EOF
server {
  listen          80;
  server_name     ${HOSTNAME};
  location / {
    proxy_pass      http://localhost:3000;
  }
}
EOF

service nginx start
chkconfig nginx on
echo"MySQL root password is ${MYSQL_PASSWORD}"
