#!/bin/bash
 
apt update && apt upgrade -y
 
apt install apache2 -y && systemctl start apache2 && systemctl enable apache2
 
apt install php7.0 libapache2-mod-php7.0 php7.0-common php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring php7.0-intl php7.0-mcrypt php7.0-imagick php7.0-xml php7.0-zip zip unzip -y
 
apt -y install mariadb-server
 
systemctl enable mariadb
systemctl start mariadb

mysql_secure_installation
