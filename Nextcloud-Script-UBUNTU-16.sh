#!/bin/bash

apt update && apt upgrade -y
 
 apt-get install apache2 libapache2-mod-php7.0 bzip2 -y
 apt-get install php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring -y
 apt-get install php7.0-intl php7.0-mcrypt php-imagick php7.0-xml php7.0-zip -y
 
 apt-get install mariadb-server php-mysql -y
 
 mysql -u root -p
 
 CREATE DATABASE nextcloud;
 CREATE USER 'admin'@'localhost' IDENTIFIED BY 'Contraseña';
 GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin'@'localhost';
 FLUSH PRIVILEGES;
 exit;

# cd /var/www
# wget https://download.nextcloud.com/server/releases/latest-13.tar.bz2 -O nextcloud-13-latest.tar.bz2
# tar -xvjf nextcloud-13-latest.tar.bz2
# chown -R www-data:www-data nextcloud
# rm nextcloud-13-latest.tar.bz2


Alias /nextcloud "/var/www/nextcloud/"
<Directory /var/www/nextcloud/>
  Options +FollowSymlinks
  AllowOverride All
 <IfModule mod_dav.c>
  Dav off
 </IfModule>
 SetEnv HOME /var/www/nextcloud
 SetEnv HTTP_HOME /var/www/nextcloud
</Directory>


# a2ensite nextcloud
# a2enmod rewrite headers env dir mime
# systemctl restart apache2
