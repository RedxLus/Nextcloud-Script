#!/bin/bash

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

inicio () {

    echo ""
    echo "Antes que nada, seleccione su idioma para este script:" 
    echo "First of all, select your language for this script:" 
    echo "" 
    echo "1. ESPAÑOL"
    echo "2. ENGLISH" 
    echo ""
    echo -n "Seleccione una opción / Select an option [1 - 2]: "
        read idioma
        case ${idioma} in
        1)
            echo "Ejecutando el Script en Español ..."

            es
        ;;
        2)
            echo "Running the Script in English ..."

            en
        ;;
        *)
            echo "Número no reconocido."
            echo "Unrecognized number."
            sleep 1
        ;;
     esac
}

es () {

    idioma="ES"

    until [ "${seleccion}" = "6" ]; do
        clear
        echo ""
        echo "Comprobación previa. Este es tu sistema Operativo:"
        cat  /etc/issue
        echo "Ahora escribe el número correspondiente para comenzar la instalación automática de Nextcloud:" 
        echo ""
        echo "1. UBUNTU 16"
        echo "2. UBUNTU 18" 
        echo "3. DEBIAN" 
        echo "4. CentOS 8"
        echo "5. Raspberry Pi OS (Buster/Jessie/Stretch)" 
        echo "" 
        echo "6. Salir del script. Exit." 
        echo ""
        echo -n "Seleccione una opción [1 - 6]: "
            read seleccion
            case ${seleccion} in
            1)
            echo "Ejecutando Script para UBUNTU 16"

            ubuntu_16
            ;;
            2)
            echo "Ejecutando Script para UBUNTU 18"

            ubuntu_18
            ;;
            3)
            echo "Ejecutando Script para DEBIAN"

            general_debian_and_raspberry
            ;;
            4)
            echo "Ejecutando Script para CENTOS"
           
            centos
            ;;
            5)
            echo "Ejecutando Script para Raspberry Pi OS (Buster/Jessie/Stretch)"
           
            general_debian_and_raspberry
            ;;
            6)
            echo ""
            echo "Saliendo del instalador ..."
            echo "Recuerde si ha instalado correctamente Nextcloud puede acceder a la URL con su IP:"
            echo "https://SUIP/nextcloud"
            echo "Siendo el usuario: admin y la contraseña la introducida en el proceso de instalación."
            exit
            ;;
            *)
            echo "Número no reconocido."
            sleep 1
            ;;
        esac
    done
}

en () {

    idioma="EN"

    until [ "${seleccion}" = "6" ]; do
        clear
        echo ""
        echo "Pre-check. This is your Operating system:"
        cat  /etc/issue
        echo "Now type the appropriate number to begin the automatic Nextcloud installation:" 
        echo ""
        echo "1. UBUNTU 16"
        echo "2. UBUNTU 18" 
        echo "3. DEBIAN" 
        echo "4. CentOS 8"
        echo "5. Raspberry Pi OS (Buster/Jessie/Stretch)" 
        echo "" 
        echo "6. Exit the script. Exit." 
        echo ""
        echo -n "Select an option [1 - 6]: "
            read seleccion
            case ${seleccion} in
            1)
            echo "Running Script for UBUNTU 16"

            ubuntu_16
            ;;
            2)
            echo "Running Script for UBUNTU 18"

            ubuntu_18
            ;;
            3)
            echo "Running Script for DEBIAN"

            general_debian_and_raspberry
            ;;
            4)
            echo "Running Script for CENTOS"
           
            centos
            ;;
            5)
            echo "Running Script for Raspberry Pi OS (Buster/Jessie/Stretch)"
           
            general_debian_and_raspberry
            ;;
            6)
            echo ""
            echo "Exiting the installer ..."
            echo "Remember if you have successfully installed Nextcloud you can access the URL with your IP:"
            echo "https://YOURIP/nextcloud"
            echo "Being the user: admin and the password entered in the installation process."
            exit
            ;;
            *)
            echo "Unrecognized number."
            sleep 1
            ;;
        esac
    done
}

pedir_mysql_y_update () {

    if [[ "${idioma}" == "ES" ]]
    then
        # Pedir contraseña para el usuario root para Mysql y la misma para el usuario admin para Nextcloud
        echo ""
        echo "Por favor introduzca una contraseña para configurar el usuario admin para Nextcloud y el usuario root para MySQL:"
        read rootpasswd
    else
        # Ask for password for the root user for Mysql and the same for the admin user for Nextcloud
        echo ""
        echo "Please enter a password to configure the admin user for Nextcloud and the root user for MySQL:"
        read rootpasswd
    fi

    # Actualizar
    # Update
        apt update && apt upgrade -y
}

general_debian_and_raspberry () {

    pedir_mysql_y_update

    # Instalar apache, activar modulos y reiniciar
    # Install apache, activate modules and restart
        apt install apache2 apt-transport-https ca-certificates unzip curl aria2 wget systemd -y 
        /etc/init.d/apache2 start && systemctl enable apache2 && a2enmod rewrite headers env dir mime && a2enmod ssl && a2ensite default-ssl.conf
        /etc/init.d/apache2 restart

    # Instalar PHP y otros
    # Install PHP and others
        wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
        getRasperryVersion=$(cat /etc/os-release | grep VERSION_CODENAME | cut -d '=' -f 2)
        echo "deb https://packages.sury.org/php/ ${getRasperryVersion} main" | tee /etc/apt/sources.list.d/php.list
        apt update
    
        apt install php7.2 php-redis php7.2-cli php7.2-curl php7.2-gd php7.2-ldap php7.2-mbstring php7.2-mysql \
                  php7.2-xml php7.2-xmlrpc php7.2-zip libapache2-mod-php7.2 php7.2-json php7.2-intl php-imagick ffmpeg -y


    # Instalar mysql (mariadb), reiniciar, activar y ejecutar al inicio
    # Install mysql (mariadb), restart, activate and run at startup
        apt -y install mariadb-server
        /etc/init.d/mysql stop && /etc/init.d/mysql start
        systemctl enable mariadb
        systemctl start mariadb

    # Instalacion segura mysql. Fuente (https://bit.ly/2T09N8A)
    # Secure mysql installation. Source (https://bit.ly/2T09N8A)
        apt -y install expect

        SECURE_MYSQL=$(expect -c "
        set timeout 10
        spawn mysql_secure_installation
        expect \"Enter current password for root (enter for none):\"
        send \"${rootpasswd}\r\"
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

    # Creacion base datos, usuario, privilegios
    # Database creation, user, privileges
        mysql -uroot -p${rootpasswd} -e "CREATE DATABASE nextcloud;"
        mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin'@'localhost' IDENTIFIED BY '${rootpasswd}';"
        mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"

    # Descarga. Descomprimir Nextcloud. Privilegios. Elimina.
    # Download. Unzip Nextcloud. Privileges. Eliminate.
        curl -LO https://download.nextcloud.com/server/releases/nextcloud-${nextcloudversion}.zip
        unzip nextcloud-${nextcloudversion}.zip -d /var/www/html/
        chown -R www-data:www-data /var/www/html/nextcloud/
        rm -r nextcloud-${nextcloudversion}.zip

    # Instala sudo (necesario si no esta instalado, aunque suele estarlo)
    # Install sudo (necessary if it is not installed, although it usually is)
        apt install sudo -y

    # Instala Nextcloud
    # Install Nextcloud
        cd /var/www/html/nextcloud && sudo -u www-data php occ  maintenance:install --database "mysql" --database-name "nextcloud"  --database-user "admin" --database-pass "${rootpasswd}" --admin-user "admin" --admin-pass "${rootpasswd}"

    # Archivo configuracion
    # Configuration file
        cd /etc/apache2/sites-available && curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos/nextcloud.conf
        a2ensite nextcloud
        systemctl restart apache2

    # Redireccion SSL
    # SSL redirect
        cd /var/www/html/nextcloud && sed -i "1i <IfModule mod_rewrite.c>" .htaccess && sed -i "2i RewriteCond %{HTTPS} off" .htaccess && sed -i "3i RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]" .htaccess && sed -i "4i </IfModule>" .htaccess
        systemctl restart apache2

    # Menu 1 (ip)
        ip_config
   
    # Menu 2 (ocdownloader)
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
   send \"${rootpasswd}\r\"
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
       mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin'@'localhost' IDENTIFIED BY '${rootpasswd}';"
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

    # Instalar apache, activar modulos y reiniciar
    apt install apache2 apt-transport-https ca-certificates unzip curl aria2 wget systemd -y 
    /etc/init.d/apache2 start && systemctl enable apache2 && a2enmod rewrite headers env dir mime && a2enmod ssl && a2ensite default-ssl.conf
    /etc/init.d/apache2 restart

    # Instalar php y otros
    apt install php7.2 php-redis php7.2-cli php7.2-curl php7.2-gd php7.2-ldap php7.2-mbstring php7.2-mysql \
                  php7.2-xml php7.2-xmlrpc php7.2-zip libapache2-mod-php7.2 php7.2-json php7.2-intl php-imagick ffmpeg -y


    # Instalar mysql (mariadb), reiniciar, activar y ejecutar al inicio
    apt -y install mariadb-server
    /etc/init.d/mysql stop && /etc/init.d/mysql start
    systemctl enable mariadb
    systemctl start mariadb

    # Instalacion segura mysql. Fuente (https://bit.ly/2T09N8A)
    apt -y install expect

    SECURE_MYSQL=$(expect -c "
    set timeout 10
    spawn mysql_secure_installation
    expect \"Enter current password for root (enter for none):\"
    send \"${rootpasswd}\r\"
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
        mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin'@'localhost' IDENTIFIED BY '${rootpasswd}';"
        mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"

    #Descarga. Descomprimir Nextcloud. Privilegios. Elimina.
    curl -LO https://download.nextcloud.com/server/releases/nextcloud-${nextcloudversion}.zip
    unzip nextcloud-${nextcloudversion}.zip -d /var/www/html/
    chown -R www-data:www-data /var/www/html/nextcloud/
    rm -r nextcloud-${nextcloudversion}.zip

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

centos () {

    if [[ "${idioma}" == "ES" ]]
    then
        # Pedir contraseña para el usuario root para Mysql y la misma para el usuario admin para Nextcloud
        echo ""
        echo "Por favor introduzca una contraseña para configurar el usuario admin para Nextcloud y el usuario root para MySQL:"
        read rootpasswd
    else
        # Ask for password for the root user for Mysql and the same for the admin user for Nextcloud
        echo ""
        echo "Please enter a password to configure the admin user for Nextcloud and the root user for MySQL:"
        read rootpasswd
    fi

    yum update -y && yum -y install epel-release yum-utils unzip curl \
                                    wget bash-completion policycoreutils-python-utils mlocate bzip2 httpd

    sudo yum install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm

    yum update -y

    yum module disable -y php && yum module enable -y php:remi-7.4

    dnf install -y php php-gd php-mbstring php-intl php-pecl-apcu\
                    php-mysqlnd php-opcache php-json php-zip php-pear\
                     gcc curl-devel php-devel zlib-devel pcre-devel make

    dnf install -y mariadb mariadb-server
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
       mysql -uroot -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY '${rootpasswd}';"
       mysql -uroot -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin'@'localhost';"
       mysql -uroot -e "FLUSH PRIVILEGES;"

    curl -LO https://download.nextcloud.com/server/releases/nextcloud-${nextcloudversion}.zip
    unzip nextcloud-${nextcloudversion}.zip -d /var/www/html/
    mkdir /var/www/html/nextcloud/data && cd /var/www/html && chown -R apache:apache nextcloud

    cd /etc/httpd/conf.d && curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos/nextcloud.conf

    systemctl start httpd
    systemctl enable httpd

    cd /var/www/html/nextcloud && sudo -u apache php occ maintenance:install --database "mysql" --database-name "nextcloud"  --database-user "admin" --database-pass "${rootpasswd}" --admin-user "admin" --admin-pass "${rootpasswd}"

    firewall-cmd --zone=public --add-service=http --permanent
    firewall-cmd --reload

    semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/data(/.*)?'
    semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/config(/.*)?'
    semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/apps(/.*)?'
    semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/.htaccess'
    semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/.user.ini'
    semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/nextcloud/3rdparty/aws/aws-sdk-php/src/data/logs(/.*)?'

    restorecon -R '/var/www/html/nextcloud/'

    setsebool -P httpd_can_network_connect on

    # Menu 1 (ip)
    yum install net-tools -y
    ip_config
}

ip_config () {

    apt-get install net-tools
    laip=$(ifconfig|awk 'NR == 2'|awk '{print $2}'|cut -d ':' -f2)

    clear

    if [[ "${idioma}" == "ES" ]]
    then
        echo "Su IP es ${laip}. ¿Es correcta?. Puede modificarla despues en /var/www/html/nextcloud/config/config.php "
        echo "1. Sí. Quiero añadirla automaticamente para que funcione NextCloud (la IP se añadira al archivo de configuracion)."
        echo "2. No. No es mi ip o quiero hacerlo manualmente."
        echo -n "Seleccione una opción [1 - 2]: "
        read respuesta
    else
        echo "Your IP is ${laip}. It's correct?. You can modify it later in /var/www/html/nextcloud/config/config.php "
        echo "1. Yes. I want to add it automatically for NextCloud to work (the IP will be added to the configuration file)."
        echo "2. No. It is not my ip or I want to do it manually."
        echo -n "Select an option [1 - 2]: "
        read respuesta
    fi


    if [ ${respuesta} = 1 ]
    then
        cd /var/www/html/nextcloud/config && sed -i "8i 1 => \'${laip}\',"  config.php && echo "Todo correcto / All right"
    else
        echo "Saliendo / Exit"
    fi
}

menu_oc () {


    if [[ "${idioma}" == "ES" ]]
    then
        echo ""
        echo "¿Desea Instalar OcDownloader (plugin para Nextcloud)?"
        echo "1. Sí. Me gustaria la instalacion automatica de OcDownloader." 
        echo "2. No. Gracias. Salir" 
        echo -n "Seleccione una opción [1 - 2]: "
        read seleccion_oc
    else
        echo ""
        echo "Do you want to Install OcDownloader (plugin for Nextcloud)?"
        echo "1. Yes. I would like the automatic installation of OcDownloader." 
        echo "2. No thanks. Exit" 
        echo -n "Select an option [1 - 2]: "
        read seleccion_oc
    fi

    if [ ${seleccion_oc} = 1 ]
    then
        echo "Instalando y activando / Installing and activating"
        instalar_oc
    else
        echo "Saliendo / Exit"
    fi
}

instalar_oc () {

    apt-get install aria2 curl -y
    mkdir /var/log/aria2c /var/local/aria2c
    touch /var/log/aria2c/aria2c.log
    touch /var/local/aria2c/aria2c.sess
    chmod 770 -R /var/log/aria2c /var/local/aria2c
    aria2c --enable-rpc --rpc-allow-origin-all -c -D --log=/var/log/aria2c/aria2c.log --check-certificate=false --save-session=/var/local/aria2c/aria2c.sess --save-session-interval=2 --continue=true --input-file=/var/local/aria2c/aria2c.sess --rpc-save-upload-metadata=true --force-save=true --log-level=warn

    cd /var/www/html/nextcloud/apps && curl -LO https://github.com/e-alfred/ocdownloader/releases/download/${ocversion}/ocdownloader-${ocversion}.tar.gz
    tar -xvzf ocdownloader-${ocversion}.tar.gz
    rm -r ocdownloader-${ocversion}.tar.gz

    cd /var/www/html/nextcloud  && sudo -u www-data php occ app:enable ocdownloader
}


phpversion="7.2"
nextcloudversion="18.0.6"
ocversion="1.7.8"
seleccion="inicializada"


inicio
