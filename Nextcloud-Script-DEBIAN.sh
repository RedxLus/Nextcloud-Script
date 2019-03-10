#!/bin/bash

    echo ""
    echo "Please enter root password (same as root user) to use in MySQL"
    read rootpasswd
    
apt update && apt upgrade -y
 
apt install apache2 -y && /etc/init.d/apache2 start && systemctl enable apache2 && a2enmod rewrite headers env dir mime && a2enmod ssl && a2ensite default-ssl.conf && /etc/init.d/apache2 restart
 
apt install php7.0 libapache2-mod-php7.0 php7.0-common php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring php7.0-intl php7.0-mcrypt php7.0-imagick php7.0-xml php7.0-zip -y
apt install unzip curl aria2 -y
 
apt -y install mariadb-server

/etc/init.d/mysql stop && /etc/init.d/mysql start

systemctl enable mariadb
systemctl start mariadb

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

    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE nextcloud;"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin'@'localhost' IDENTIFIED BY '$rootpasswd';"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
    
curl -LO https://download.nextcloud.com/server/releases/nextcloud-13.0.1.zip

unzip nextcloud-13.0.1.zip -d /var/www/html/
chown -R www-data:www-data /var/www/html/nextcloud/

apt install sudo -y

cd /var/www/html/nextcloud && sudo -u www-data php occ  maintenance:install --database "mysql" --database-name "nextcloud"  --database-user "admin" --database-pass "$rootpasswd" --admin-user "admin" --admin-pass "$rootpasswd"


curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos/mod.sh -k && sh mod.sh

curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos/pedir.sh -k && sh pedir.sh
