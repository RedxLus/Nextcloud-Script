#!/bin/bash

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi

ubuntu_16 () {
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

   cd /var/www/html/nextcloud && sed -i "1i <IfModule mod_rewrite.c>" .htaccess && sed -i "2i RewriteCond %{HTTPS} off" .htaccess && sed -i "3i RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]" .htaccess && sed -i "4i </IfModule>" .htaccess
   systemctl restart apache2

   ip_config

   curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos/instalar-oc.sh -k && sh instalar-oc.sh && rm instalar-oc.sh
}

ip_config () {
   apt-get install net-tools
   laip=$(ifconfig|awk 'NR == 2'|awk '{print $2}'|cut -d ':' -f2)

   clear

   echo "Su IP es $laip. ¿Es correcta?. Puede modificarla despues en /var/www/html/nextcloud/config/config.php "
   echo "1. Si. Quiero añadirla automaticamente para que funcione NextCloud (la IP se añadira al archivo de configuracion)."
   echo "2. No. No es mi ip o quiero hacerlo manualmente."
   echo -n "Seleccione una opcion [1 - 2]"
   read respuesta

   if [ $respuesta = 1 ]
   then
   cd /var/www/html/nextcloud/config && sed -i "8i 1 => \'$laip\',"  config.php && echo "Todo correcto"
   else
   echo "Saliendo"
   fi
}

menu_oc () {
   echo ""
   echo "¿Desea Instalar OcDownloader (plugin para Nextcloud)?"
   echo "1. Si. Me gustaria la instalacion automatica de OcDownloader." 
   echo "2. No. Gracias. Salir" 
   echo -n "Seleccione una opcion [1 - 2]"
     read seleccion

     case $seleccion in
        1)
           echo "Instalando y activando"
           instalar_oc
        ;;
        2)
           echo "Saliendo"
        ;;
        *)
           echo "Numero no reconocido."
        ;;
     esac
}

instalar_oc () {
   apt-get install aria2 curl -y
   mkdir /var/log/aria2c /var/local/aria2c
   touch /var/log/aria2c/aria2c.log
   touch /var/local/aria2c/aria2c.sess
   chmod 770 -R /var/log/aria2c /var/local/aria2c
   aria2c --enable-rpc --rpc-allow-origin-all -c -D --log=/var/log/aria2c/aria2c.log --check-certificate=false --save-session=/var/local/aria2c/aria2c.sess --save-session-interval=2 --continue=true --input-file=/var/local/aria2c/aria2c.sess --rpc-save-upload-metadata=true --force-save=true --log-level=warn

   cd /var/www/html/nextcloud/apps && curl -LO https://github.com/e-alfred/ocdownloader/releases/download/1.5.5/ocdownloader.tar.gz
   tar -xvzf ocdownloader.tar.gz
   rm -r ocdownloader.tar.gz

   cd /var/www/html/nextcloud  && sudo -u www-data php occ app:enable ocdownloader
}

clear
echo ""
echo "Comprobacion previa. Este es tu sistema Operativo:"
cat  /etc/issue
echo "Ahora escribe el numero correspondiente para comenzar la instalacion automatica de Nextcloud:" 
echo ""
echo "1. UBUNTU 16"
echo "2. UBUNTU 18" 
echo "3. DEBIAN" 
echo "4. CentOS" 
echo -n "Seleccione una opcion [1 - 4]"
  read seleccion
  case $seleccion in
     1)
        echo "Descargando y ejecutando Script para UBUNTU 16"
        wget https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos-so/Nextcloud-Script-UBUNTU-16.sh --no-check-certificate
        chmod +x Nextcloud-Script-UBUNTU-16.sh
        sudo sh Nextcloud-Script-UBUNTU-16.sh && rm -r Nextcloud-Script-UBUNTU-16.sh
     ;;
     2)
        echo "Descargando y ejecutando Script para UBUNTU 18"
        wget https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos-so/Nextcloud-Script-UBUNTU-18.sh --no-check-certificate
        chmod +x Nextcloud-Script-UBUNTU-18.sh
        sudo sh Nextcloud-Script-UBUNTU-18.sh && rm -r Nextcloud-Script-UBUNTU-18.sh
     ;;
     3)
        echo "Descargando y ejecutando Script para DEBIAN"
        wget https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos-so/Nextcloud-Script-DEBIAN.sh --no-check-certificate
        chmod +x Nextcloud-Script-DEBIAN.sh
        sh Nextcloud-Script-DEBIAN.sh && rm -r Nextcloud-Script-DEBIAN.sh
     ;;
     4)
        echo "Descargando y ejecutando Script para DEBIAN"
        curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos-so/Nextcloud-Script-CENTOS.sh -k
        chmod +x Nextcloud-Script-CENTOS.sh
        sh Nextcloud-Script-CENTOS.sh && rm -r Nextcloud-Script-CENTOS.sh
     ;;
     *)
        echo "Numero no reconocido."
     ;;
  esac
