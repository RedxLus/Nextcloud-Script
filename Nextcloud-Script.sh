#!/bin/bash

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

seleccion="inicializacion"

pedir_mysql_y_update () {

   # Pedir contraseña root para Mysql
       echo ""
       echo "Please enter root password (same as root user) to use in MySQL"
       read rootpasswd
       
   # Actualizar
   apt update && apt upgrade -y
}

debian () {

   pedir_mysql_y_update

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

   SECURE_MYSQL=$(expect -c "

   set timeout 10
   spawn mysql_secure_installation

   expect \"Enter current password for root (enter for none):\"
   send \"$rootpasswd\r\"

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

   apt -y purge expect
   apt autoremove -y

   #Creacion base datos, usuario, privilegios
       mysql -uroot -p${rootpasswd} -e "CREATE DATABASE nextcloud;"
       mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin'@'localhost' IDENTIFIED BY '$rootpasswd';"
       mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"

   #Descarga. Descomprimir Nextcloud. Privilegios. Elimina.
   curl -LO https://download.nextcloud.com/server/releases/nextcloud-13.0.1.zip
   unzip nextcloud-13.0.1.zip -d /var/www/html/
   chown -R www-data:www-data /var/www/html/nextcloud/
   rm -r nextcloud-13.0.1.zip
   

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
   ip_config
   
   #Menu 2 (ocdownloader)
   menu_oc
}

ubuntu_16 () {

    pedir_mysql_y_update

    apt-get install apache2 libapache2-mod-php7.0 bzip2 unzip curl -y
    apt-get install php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring -y
    apt-get install php7.0-intl php7.0-mcrypt php-imagick php7.0-xml php7.0-zip -y

    apt-get install mariadb-server php-mysql -y

    /etc/init.d/mysql stop && /etc/init.d/mysql start

    apt -y install expect


   SECURE_MYSQL=$(expect -c "
   set timeout 10
   spawn mysql_secure_installation
   expect \"Enter current password for root (enter for none):\"
   send \"$rootpasswd\r\"
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

   menu_oc
}

ubuntu_18 () {

   pedir_mysql_y_update

   sudo apt-get install -y software-properties-common
   sudo add-apt-repository ppa:ondrej/php -y

   apt update && apt upgrade -y

    apt-get install apache2 libapache2-mod-php7.0 bzip2 unzip curl -y
    apt-get install php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring -y
    apt-get install php7.0-intl php7.0-mcrypt php-imagick php7.0-xml php7.0-zip -y

    apt-get install mariadb-server php-mysql -y
    
    curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/dev2/mysql_secure_installation_MARIADB.sh -k
    chmod +x mysql_secure_installation_MARIADB.sh
    sh mysql_secure_installation_MARIADB.sh && rm -r mysql_secure_installation_MARIADB.sh

       mysql -uroot -p${rootpasswd} -e "CREATE DATABASE nextcloud;"
       mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin'@'localhost' IDENTIFIED BY '$rootpasswd';"
       mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"


   curl -LO https://download.nextcloud.com/server/releases/nextcloud-13.0.1.zip

   unzip nextcloud-13.0.1.zip -d /var/www/html/
   chown -R www-data:www-data /var/www/html/nextcloud/

   cd /etc/apache2/sites-available && curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos/nextcloud.conf
   a2ensite nextcloud
   a2enmod rewrite headers env dir mime
   a2enmod ssl && a2ensite default-ssl.conf
   systemctl restart apache2

   cd /var/www/html/nextcloud && sudo -u www-data php occ  maintenance:install --database "mysql" --database-name "nextcloud"  --database-user "admin" --database-pass "$rootpasswd" --admin-user "admin" --admin-pass "$rootpasswd" 

   cd /var/www/html/nextcloud && sed -i "1i <IfModule mod_rewrite.c>" .htaccess && sed -i "2i RewriteCond %{HTTPS} off" .htaccess && sed -i "3i RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]" .htaccess && sed -i "4i </IfModule>" .htaccess
   systemctl restart apache2

   ip_config

   menu_oc
}

centos () {
   
   echo ""
   echo "Please enter root password (same as root user) to use in MySQL"
   read rootpasswd

   yum update -y
   yum install epel-release -y
   rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

   yum install httpd unzip php70w php70w-dom php70w-mbstring php70w-gd php70w-pdo php70w-json php70w-xml php70w-zip php70w-curl php70w-mcrypt php70w-pear setroubleshoot-server bzip2 sudo -y

   yum install mariadb-server php70w-mysql -y

   systemctl start mariadb
   systemctl enable mariadb

   yum -y install expect

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

   yum remove expect -y
   yum clean all

       mysql -uroot -e "CREATE DATABASE nextcloud;"
       mysql -uroot -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY '$rootpasswd';"
       mysql -uroot -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin'@'localhost';"
       mysql -uroot -e "FLUSH PRIVILEGES;"

   curl -LO https://download.nextcloud.com/server/releases/nextcloud-13.0.1.zip

   unzip nextcloud-13.0.1.zip -d /var/www/html/
   mkdir /var/www/html/nextcloud/data && cd /var/www/html && chown -R apache:apache nextcloud

   cd /etc/httpd/conf.d && curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos/nextcloud.conf

   systemctl start httpd
   systemctl enable httpd

   cd /var/www/html/nextcloud && sudo -u apache php occ maintenance:install --database "mysql" --database-name "nextcloud"  --database-user "admin" --database-pass "$rootpasswd" --admin-user "admin" --admin-pass "$rootpasswd"

   #Menu 1 (ip)
   yum install net-tools -y
   curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos/ip-config.php.sh -k && sh ip-config.php.sh && rm -r ip-config.php.sh
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
     read seleccion_oc

     case $seleccion_oc in
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

until [ "$seleccion" = "5" ]; do
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
   echo "" 
   echo "5. Salir del script. Exit." 
   echo ""
   echo -n "Seleccione una opcion [1 - 5]: "
     read seleccion
     case $seleccion in
        1)
           echo "Descargando y ejecutando Script para UBUNTU 16"

           ubuntu_16
        ;;
        2)
           echo "Descargando y ejecutando Script para UBUNTU 18"

           ubuntu_18
        ;;
        3)
           echo "Descargando y ejecutando Script para DEBIAN"

           debian
        ;;
        4)
           echo "Descargando y ejecutando Script para CENTOS"
           curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos-so/Nextcloud-Script-CENTOS.sh -k
           chmod +x Nextcloud-Script-CENTOS.sh
           sh Nextcloud-Script-CENTOS.sh && rm -r Nextcloud-Script-CENTOS.sh
        ;;
        5)
           echo "Saliendo ..."
           exit
        ;;
        *)
           echo "Numero no reconocido."
           sleep 1
        ;;
     esac
done
