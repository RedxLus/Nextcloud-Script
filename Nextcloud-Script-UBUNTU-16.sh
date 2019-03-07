#!/bin/bash

apt update && apt upgrade -y
 
 apt-get install apache2 libapache2-mod-php7.0 bzip2 unzip curl -y
 apt-get install php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring -y
 apt-get install php7.0-intl php7.0-mcrypt php-imagick php7.0-xml php7.0-zip -y
 
 apt-get install mariadb-server php-mysql -y
 
 apt -y install expect

// Not required in actual script
MYSQL_ROOT_PASSWORD=abcd1234

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"

apt -y purge expect
apt autoremove -y


    echo ""
    echo "Please enter root user MySQL password!"
    read rootpasswd
    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE nextcloud;"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin'@'localhost' IDENTIFIED BY '$rootpasswd';"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"


curl -LO https://download.nextcloud.com/server/releases/nextcloud-13.0.1.zip

unzip nextcloud-13.0.1.zip -d /var/www/html/
chown -R www-data:www-data /var/www/html/nextcloud/

# cd /var/www/html
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
