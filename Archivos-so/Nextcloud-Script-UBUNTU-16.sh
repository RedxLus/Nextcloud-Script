#!/bin/bash

    echo ""
    echo "Please enter root user MySQL password!"
    read rootpasswd

apt update && apt upgrade -y
 
 apt-get install apache2 libapache2-mod-php7.0 bzip2 unzip curl -y
 apt-get install php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring -y
 apt-get install php7.0-intl php7.0-mcrypt php-imagick php7.0-xml php7.0-zip -y
 
 apt-get install mariadb-server php-mysql -y
 
 /etc/init.d/mysql stop && /etc/init.d/mysql start
 
 apt -y install expect


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

    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE nextcloud;"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin'@'localhost' IDENTIFIED BY '$rootpasswd';"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"


curl -LO https://download.nextcloud.com/server/releases/nextcloud-13.0.1.zip

unzip nextcloud-13.0.1.zip -d /var/www/html/
chown -R www-data:www-data /var/www/html/nextcloud/

cd /etc/apache2/sites-available && curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos/nextcloud.conf
a2ensite nextcloud
a2ensite default-ssl.conf
a2enmod rewrite headers env dir mime
a2enmod ssl && a2ensite default-ssl.conf
systemctl restart apache2

cd /var/www/html/nextcloud && sudo -u www-data php occ maintenance:install --database "mysql" --database-name "nextcloud"  --database-user "admin" --database-pass "$rootpasswd" --admin-user "admin" --admin-pass "$rootpasswd"

curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos/ip-config.php.sh -k && sh ip-config.php.sh && rm ip-config.php.sh

curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos/instalar-oc.sh -k && sh instalar-oc.sh && rm instalar-oc.sh
