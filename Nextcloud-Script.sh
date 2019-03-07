#!/bin/bash
 
apt update && apt upgrade -y
 
apt install apache2 -y && systemctl start apache2 && systemctl enable apache2
 
apt install php7.0 libapache2-mod-php7.0 php7.0-common php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring php7.0-intl php7.0-mcrypt php7.0-imagick php7.0-xml php7.0-zip zip unzip -y
 
apt -y install mariadb-server
 
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

echo NOMBRE-USUARIO-NEXTCLOUD :
read to_print

echo CONTRASENA-USUARIO-NEXTCLOUD:
read t2o_print


    echo "Please enter root user MySQL password!"
    read rootpasswd
    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE nextcloud;"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON nextcloud.* TO '$to_print'@'localhost' IDENTIFIED BY '$t2o_print';"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
    
wget https://download.nextcloud.com/server/releases/nextcloud-13.0.1.zip

unzip nextcloud-13.0.1.zip -d /var/www/html/
chown -R www-data:www-data /var/www/html/nextcloud/

cd /var/www/html/nextcloud

sudo -u www-data php occ  maintenance:install --database "mysql" --database-name "nextcloud"  --database-user "nextcloud_user" --database-pass "PASSWORD" --admin-user "admin" --admin-pass "PASSWORD"

nano config/config.php
    
