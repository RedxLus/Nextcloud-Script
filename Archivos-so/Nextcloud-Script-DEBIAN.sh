#!/bin/bash

# Pedir contraseña root para Mysql
    echo ""
    echo "Please enter root password (same as root user) to use in MySQL"
    read rootpasswd

# Actualizar
apt update && apt upgrade -y

# Instalar apache, activar modulos y reiniciar
apt install apache2 -y && /etc/init.d/apache2 start && systemctl enable apache2 && a2enmod rewrite headers env dir mime && a2enmod ssl && a2ensite default-ssl.conf && /etc/init.d/apache2 restart

# Instalar php y otros
apt install php7.0 libapache2-mod-php7.0 php7.0-common php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring php7.0-intl php7.0-mcrypt php7.0-imagick php7.0-xml php7.0-zip -y
apt install unzip curl aria2 -y

# Instalar mysql (mariadb), reiniciar, activar y ejecutar al inicio
apt -y install mariadb-server
/etc/init.d/mysql stop && /etc/init.d/mysql start
systemctl enable mariadb
systemctl start mariadb

#Instalacion segura mysql. Fuente (https://bit.ly/2T09N8A)
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

#Creacion base datos, usuario, privilegios
    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE nextcloud;"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin'@'localhost' IDENTIFIED BY '$rootpasswd';"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"

#Descarga. Descomprimir Nextcloud. Privilegios
curl -LO https://download.nextcloud.com/server/releases/nextcloud-13.0.1.zip
unzip nextcloud-13.0.1.zip -d /var/www/html/
chown -R www-data:www-data /var/www/html/nextcloud/

#Insta sudo (necesario si no esta instalado, aunque suele estarlo)
apt install sudo -y

# Instala Nextcloud
cd /var/www/html/nextcloud && sudo -u www-data php occ  maintenance:install --database "mysql" --database-name "nextcloud"  --database-user "admin" --database-pass "$rootpasswd" --admin-user "admin" --admin-pass "$rootpasswd"

# Archivo configuracion
cd /etc/apache2/sites-available && curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos/nextcloud.conf
a2ensite nextcloud
systemctl restart apache2

# Redireccion SSL
cd /var/www/html/nextcloud && sed -i "1i <IfModule mod_rewrite.c>" .htaccess && sed -i "2i RewriteCond %{HTTPS} off" .htaccess && sed -i "3i RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]" .htaccess && sed -i "4i </IfModule>" .htaccess
systemctl restart apache2

#Menu 1 (ip)
curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos/ip-config.php.sh -k && sh ip-config.php.sh && rm ip-config.php.sh

#Menu 2 (ocdownloader)
curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos/instalar-oc.sh -k && sh instalar-oc.sh && rm instalar-oc.sh
