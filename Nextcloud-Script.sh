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
        wget https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Nextcloud-Script-UBUNTU-16.sh --no-check-certificate
        chmod +x Nextcloud-Script-UBUNTU-16.sh
        sudo sh Nextcloud-Script-UBUNTU-16.sh && rm -r Nextcloud-Script-UBUNTU-16.sh
     ;;
     2)
        echo "Descargando y ejecutando Script para UBUNTU 18"
        wget https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Nextcloud-Script-UBUNTU-18.sh --no-check-certificate
        chmod +x Nextcloud-Script-UBUNTU-18.sh
        sudo sh Nextcloud-Script-UBUNTU-18.sh && rm -r Nextcloud-Script-UBUNTU-18.sh
     ;;
     3)
        echo "Descargando y ejecutando Script para DEBIAN"
        wget https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Nextcloud-Script-DEBIAN.sh --no-check-certificate
        chmod +x Nextcloud-Script-DEBIAN.sh
        sh Nextcloud-Script-DEBIAN.sh && rm -r Nextcloud-Script-DEBIAN.sh
     ;;
     4)
        echo "Descargando y ejecutando Script para DEBIAN"
        curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Nextcloud-Script-CENTOS.sh -k
        chmod +x Nextcloud-Script-CENTOS.sh
        sh Nextcloud-Script-CENTOS.sh && rm -r Nextcloud-Script-CENTOS.sh
     ;;
     *)
        echo "Numero no reconocido."
     ;;
  esac
