#!/bin/sh
sudo rpm --import https://rpm.packager.io/key
echo "[gogs]
name=Repository for pkgr/gogs application.
baseurl=https://rpm.packager.io/gh/pkgr/gogs/centos6/pkgr
enabled=1" | sudo tee /etc/yum.repos.d/gogs.repo
sudo yum install gogs wget -y
cd /tmp && wget -N https://raw.githubusercontent.com/cybernet/linux/centos/sh/gogsd.sh && chmod +x gogsd.sh && ./gogsd.sh
