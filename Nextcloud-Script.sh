#!/bin/bash

seleccion="x"
phpversion="7.4"
nextcloudversion="23.0.0"

# Esto es para obligar al script a usar SUDO
# This is to force the script to use SUDO
if ! [ $(id -u) = 0 ]; then
    clear
    echo "El script debe ejecutarse como root." >&2
    echo "The script need to be run as root." >&2
    exit 1
fi

inicio () {
    clear
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

case_versions (){
    if [[ "${idioma}" == "ES" ]]
    then
            case ${seleccion} in
            1)
            echo "Ejecutando Script para UBUNTU 20"
                ubuntu_18_and_20
            ;;
            2)
            echo "Ejecutando Script para UBUNTU 18"
                ubuntu_18_and_20
            ;;
            3)
            echo "Ejecutando Script para UBUNTU 16"
                phpversion="7.2"
                nextcloudversion="18.0.0"
                ubuntu_16
            ;;
            4)
            echo "Ejecutando Script para DEBIAN"
                debian
            ;;
            5)
            echo "Ejecutando Script para Raspberry Pi OS"
                phpversion="7.3"
                nextcloudversion="23.0.0"
                raspberry
            ;;
            6)
            echo "Ejecutando Script para CENTOS"
                centos
            ;;
            7)
            echo ""
                mensaje_final
            ;;
            *)
            echo "Número no reconocido."
            sleep 1
            ;;
            esac
    else
            case ${seleccion} in
            1)
            echo "Running Script for UBUNTU 20"
                ubuntu_18_and_20
            ;;
            2)
            echo "Running Script for UBUNTU 18"
                ubuntu_18_and_20
            ;;
            3)
            echo "Running Script for UBUNTU 16"
                phpversion="7.2"
                nextcloudversion="18.0.0"
                ubuntu_16
            ;;
            4)
            echo "Running Script for DEBIAN"
                debian
            ;;
            5)
            echo "Running Script for Raspberry Pi OS"
                phpversion="7.3"
                nextcloudversion="18.0.0"
                raspberry
            ;;
            6)
            echo "Running Script for CENTOS"
                centos
            ;;
            7)
            echo ""
                end_message
            ;;
            *)
            echo "Unrecognized number."
            sleep 1
            ;;
            esac
    fi
}

es () {
    idioma="ES"

    until [ "${seleccion}" = "7" ]; do
        clear
        echo ""
        echo "Comprobación previa. Este es tu sistema Operativo:"
        cat  /etc/issue
        echo "Ahora escribe el número correspondiente para comenzar la instalación automática de Nextcloud:" 
        echo ""
        echo ""
        echo "1. Ubuntu 20"
        echo "2. Ubuntu 18"
        echo "3. Ubuntu 16" 
        echo ""
        echo "4. Debian"
        echo "5. Raspberry Pi OS"
        echo ""
        echo "6. CentOS 8"
        echo ""
        echo ""
        echo "7. Salir del script. Exit." 
        echo ""
        echo -n "Seleccione una opción [1 - 7]: "
            read seleccion
            case_versions
    done
}

mensaje_final () {
    clear
    echo "Saliendo del instalador ..."
    echo "Recuerde si ha instalado correctamente Nextcloud puede acceder a la URL con su IP:"
    echo "https://SUIP/nextcloud"
    echo "Siendo el usuario: admin y la contraseña la introducida en el proceso de instalación."
    exit
}

en () {
    idioma="EN"

    until [ "${seleccion}" = "7" ]; do
        clear
        echo ""
        echo "Pre-check. This is your Operating system:"
        cat  /etc/issue
        echo "Now type the appropriate number to begin the automatic Nextcloud installation:" 
        echo ""
        echo ""
        echo "1. Ubuntu 20"
        echo "2. Ubuntu 18"
        echo "3. Ubuntu 16" 
        echo ""
        echo "4. Debian"
        echo "5. Raspberry Pi OS"
        echo ""
        echo "6. CentOS 8"
        echo ""
        echo ""
        echo "7. Exit the script. Exit." 
        echo ""
        echo -n "Select an option [1 - 7]: "
            read seleccion
            case_versions
    done
}

end_message () {
    clear
    echo "Exiting the installer ..."
    echo "Remember if you have successfully installed Nextcloud you can access the URL with your IP:"
    echo "https://YOURIP/nextcloud"
    echo "Being the user: admin and the password entered in the installation process."

    exit
}

ask_mysql_password () {
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

install_apache2 () {
    # Instalar apache, activar modulos y reiniciar
    # Install apache, activate modules and restart
        apt install apache2 apt-transport-https ca-certificates unzip curl aria2 wget systemd software-properties-common -y
        /etc/init.d/apache2 start && systemctl enable apache2 && a2enmod rewrite headers env dir mime && a2enmod ssl && a2ensite default-ssl.conf
        /etc/init.d/apache2 restart
}

install_php () {
    # Instalar PHP y otros
    # Install PHP and others
        apt install php${phpversion} \
                    php${phpversion}-gd \
                    php${phpversion}-mysql \
                    php${phpversion}-curl \
                    php${phpversion}-mbstring \
                    php${phpversion}-intl \
                    php${phpversion}-xml \
                    php${phpversion}-zip \
                    php${phpversion}-gmp \
                    php${phpversion}-bcmath \
                    libapache2-mod-php${phpversion} \
                    php${phpversion}-cli \
                    php${phpversion}-ldap \
                    php${phpversion}-xmlrpc \
                    php${phpversion}-json \
                    php${phpversion}-redis \
                    php${phpversion}-imagick \
                    ffmpeg -y
}

install_other_version_php_ubuntu () {
        apt install locales locales-all software-properties-common -y
        export LANGUAGE=en_US.UTF-8 && export LANG=en_US.UTF-8 && export LC_ALL=en_US.UTF-8
        locale-gen en_US.UTF-8
        add-apt-repository ppa:ondrej/php -y
        apt-get update
}

install_mariadb () {
    # Instalar mysql (mariadb), reiniciar, activar y ejecutar al inicio
    # Install mysql (mariadb), restart, activate and run at startup
        apt -y install mariadb-server
        /etc/init.d/mysql stop && /etc/init.d/mysql start
        /etc/init.d/mariadb stop && /etc/init.d/mariadb start
        systemctl enable mariadb
        systemctl start mariadb
    # Instalación segura mysql. Fuente (https://bit.ly/2T09N8A)
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
    # Creación base datos, usuario, privilegios
    # Database creation, user, privileges
        mysql -uroot -p${rootpasswd} -e "CREATE DATABASE nextcloud;"
        mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin'@'localhost' IDENTIFIED BY '${rootpasswd}';"
        mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
}

install_nextcloud () {
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
        cd /etc/apache2/sites-available && curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Files/nextcloud.conf
        a2ensite nextcloud
        systemctl restart apache2
    # Redireccion SSL
    # SSL redirect
        apt install sed -y
        cd /var/www/html/nextcloud && sed -i "1i <IfModule mod_rewrite.c>" .htaccess && sed -i "2i RewriteCond %{HTTPS} off" .htaccess && sed -i "3i RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]" .htaccess && sed -i "4i </IfModule>" .htaccess
        systemctl restart apache2
}

ip_config () {
    # Install Net Tools
        apt-get install net-tools

    clear

    if [ -z ${laip} ]
    then
        
        laip=$(ifconfig|awk 'NR == 2'|awk '{print $2}'|cut -d ':' -f2)

        if [[ "${idioma}" == "ES" ]]
        then
            echo "Su IP es ${laip}. ¿Es correcta?. Puede modificarla despues en /var/www/html/nextcloud/config/config.php "
            echo "1. Sí. Quiero añadirla automaticamente para que funcione NextCloud (la IP se añadira al archivo de configuracion)."
            echo "2. No. No es mi IP pero quiero escribirla ahora."
            echo "3. No. No es mi IP pero quiero hacerlo manualmente en otro momento. Exit."
            echo -n "Seleccione una opción [1 - 3]: "
            read respuesta
        else
            echo "Your IP is ${laip}. It's correct?. You can modify it later in /var/www/html/nextcloud/config/config.php "
            echo "1. Yes. I want to add it automatically for NextCloud to work (the IP will be added to the configuration file)."
            echo "2. No. It is not my IP but I want to write it now."
            echo "3. No. It is not my IP but I want to do it manually at another time. Exit."
            echo -n "Select an option [1 - 3]: "
            read respuesta
        fi


        if [ ${respuesta} = 1 ]
        then
            cd /var/www/html/nextcloud/config && sed -i "8i 1 => \'${laip}\',"  config.php 
            echo "Todo correcto / All right"

            elif [ ${respuesta} = 2 ]
            then
                if [[ "${idioma}" == "ES" ]]
                then
                    echo -n "Introduzca la IP de esta máquina: "
                    read laip
                    cd /var/www/html/nextcloud/config && sed -i "8i 1 => \'${laip}\',"  config.php
                else
                    echo -n "Enter the IP of this machine: "
                    read laip
                    cd /var/www/html/nextcloud/config && sed -i "8i 1 => \'${laip}\',"  config.php   
                fi
            elif [ ${respuesta} = 3 ]
            then
                echo "Saliendo / Exit"
        fi
    else
        cd /var/www/html/nextcloud/config && sed -i "8i 1 => \'${laip}\',"  config.php
    fi
}

debian () {
    if [[ -z ${rootpasswd} ]]
    then
        ask_mysql_password
    fi
        apt update
    # Install Apache2
        install_apache2
    # Instalar PHP y otros  
        install_php
    # Install mysql (mariadb)
        install_mariadb
    # Install Nextcloud
        install_nextcloud
    # Menu 1 (ip)
        ip_config
    # Menu 2 (out)
    if [[ "${idioma}" == "ES" ]]
    then
        mensaje_final
    else
        end_message
    fi
}

raspberry () {
    if [[ -z ${rootpasswd} ]]
    then
        ask_mysql_password
    fi
    # Install Apache2
        install_apache2
    # Instalar PHP y otros
    # Install PHP and others
        # wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
        # getRasperryVersion=$(cat /etc/os-release | grep VERSION_CODENAME | cut -d '=' -f 2)
        # echo "deb https://packages.sury.org/php/ ${getRasperryVersion} main" | tee /etc/apt/sources.list.d/php.list
        # apt update
        install_php
    # Install mysql (mariadb)
        install_mariadb
    # Install Nextcloud
        install_nextcloud
    # Menu 1 (ip)
        ip_config
    # Menu 2 (out)
    if [[ "${idioma}" == "ES" ]]
    then
        mensaje_final
    else
        end_message
    fi
}

ubuntu_16 () {
    if [[ -z ${rootpasswd} ]]
    then
        ask_mysql_password
    fi

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

   cd /etc/apache2/sites-available && curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Files/nextcloud.conf
   a2ensite nextcloud
   a2ensite default-ssl.conf
   a2enmod rewrite headers env dir mime
   a2enmod ssl && a2ensite default-ssl.conf
   systemctl restart apache2

   cd /var/www/html/nextcloud && sudo -u www-data php occ maintenance:install --database "mysql" --database-name "nextcloud"  --database-user "admin" --database-pass "$rootpasswd" --admin-user "admin" --admin-pass "$rootpasswd"

   cd /var/www/html/nextcloud && sed -i "1i <IfModule mod_rewrite.c>" .htaccess && sed -i "2i RewriteCond %{HTTPS} off" .htaccess && sed -i "3i RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]" .htaccess && sed -i "4i </IfModule>" .htaccess
   systemctl restart apache2

    ip_config

}

ubuntu_18_and_20 () {
    if [[ -z ${rootpasswd} ]]
    then
        ask_mysql_password
    fi
        apt update
    # Install Apache2
        install_apache2
    # Install other version not default PHP
        install_other_version_php_ubuntu
    # Install PHP
        install_php
    # Install mysql (mariadb)
        install_mariadb
    # Install Nextcloud
        install_nextcloud
    # Menu 1 (ip)
        ip_config
    # Menu 2 (out)
        if [[ "${idioma}" == "ES" ]]
        then
            mensaje_final
        else
            end_message
        fi
}

centos () {
    if [[ -z ${rootpasswd} ]]
    then
        ask_mysql_password
    fi

    yum update -y && yum -y install epel-release yum-utils unzip curl \
                                    wget bash-completion policycoreutils-python-utils mlocate bzip2 httpd

    sudo yum install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm

    yum update -y

    yum module disable -y php && yum module enable -y php:remi-7.4

    dnf install -y php php-gd php-mbstring php-intl php-pecl-apcu \
                    php-mysqlnd php-opcache php-json php-zip php-pear \
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

    cd /etc/httpd/conf.d && curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Files/nextcloud.conf

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

error_headless () {
    echo ""
    echo ""
    echo "Ha ejecutado el script en modo headless pero ha ocurrido algun fallo."
    echo "Recuerde la estructura:"
    echo ""
    echo "Primero el comando: sudo bash Nextcloud-Script/Nextcloud-Script.sh"
    echo "Un espacio en blanco seguido del idioma, entre los que puede ser ESPAÑOL indicando ES o INGLÉS indicando EN"
    echo "Por lo tanto quedaría así para por ejemplo ESPAÑOL :"
    echo " sudo bash Nextcloud-Script/Nextcloud-Script.sh ES"
    echo ""
    echo ""
    echo "Un espacio en blanco seguido del sistema operativo, entre los que puede ser ubuntu20, ubuntu18, ubuntu16, debian, centos o raspberry."
    echo "Por lo tanto quedaría así para por ejemplo ESPAÑOL y Ubuntu 20 (Cambie ubuntu20 por su sistema operativo) :"
    echo " sudo bash Nextcloud-Script/Nextcloud-Script.sh ES ubuntu20"
    echo ""
    echo ""
    echo "Un espacio en blanco seguido de la contraseña para el usuario admin de Nextcloud y el usuario root de MYSQL."
    echo "Por lo tanto quedaría así para por ejemplo ESPAÑOL, Ubuntu 20 y la contraseña P@ssw0rd:"
    echo " sudo bash Nextcloud-Script/Nextcloud-Script.sh ES ubuntu20 P@ssw0rd"
    echo ""
    echo ""
    echo "Por último, un espacio en blanco seguido de la IP de la máquina."
    echo "Por lo tanto quedaría así para por ejemplo ESPAÑOL, Ubuntu 18, la contraseña P@ssw0rd y la IP 192.168.1.14:"
    echo " sudo bash Nextcloud-Script/Nextcloud-Script.sh ES ubuntu20 P@ssw0rd 192.168.1.14"
    echo ""
    echo ""
}

# $@
while getopts "l:s:p:i:" option
do
    case "${option}"
    in
        l) 
            idioma=${OPTARG}
        ;;
        lenguaje) 
            idioma=${OPTARG}
        ;;
        language) 
            idioma=${OPTARG}
        ;;
        s) 
            system=${OPTARG}
        ;;
        p) 
            pass=${OPTARG}
        ;;
        i) 
            ip=${OPTARG}
        ;;
    esac
done

if [ ${#} -eq 0 ]
then
    # Inicio normal sin argumentos. Basado en menús
    # Normal start without arguments. Menu-based
    inicio
elif [ ${#} -eq 8 ]
then
    if [ ${idioma} == "ES" ]
    then
        echo ""
        echo "Instalando en modo headless con los siguientes parámetros:"
        echo "IDIOMA: ${idioma}"
        echo "SISTEMA OPERATIVO: ${system}"
        echo "CONTRASEÑA NEXTCLOUD Y MYSQL: ${pass}"
            rootpasswd="${pass}"
        echo "IP PRIVADA DE ESTA MÁQUINA: ${ip}"
            laip="${ip}"
        echo ""
        sleep 3

        case ${system} in
        ubuntu20)
            ubuntu_18_and_20
        ;;
        ubuntu18)
            ubuntu_18_and_20
        ;;
        ubuntu16)
            ubuntu_16
        ;;
        debian)
            debian
        ;;
        raspberry)
            raspberry
        ;;
        centos)
            centos
        ;;
        *)
            error_headless
            sleep 2
        ;;
        esac
    else
        idioma="EN"
        echo ""
        echo "Installing in headless mode with the following parameters:"
        echo "LANGUAGE: ${idioma}"
        echo "OPERATING SYSTEM: ${system}"
        echo "PASSWORD NEXTCLOUD Y MYSQL: ${pass}"
            rootpasswd="${pass}"
        echo "PRIVATE IP OF THIS MACHINE: ${ip}"
            laip="${ip}"
        echo ""
        sleep 3
    fi
else
    echo ""
    echo "Ha introducido $# en vez de los argumentos."
    echo "Revise la documentación para utilizar el modo headless."
    echo ""
        error_headless
fi
