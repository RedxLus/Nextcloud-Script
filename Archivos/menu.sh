#!/bin/bash
clear
echo "¿Cual es tu sistema operativo?" 
echo ""
echo "1. UBUNTU 16"
echo "2. UBUNTU 18" 
echo "3. DEBIAN" 
echo -n "Seleccione una opcion [1 - 3]"
  read x
  case $x in
     1)
        echo "Descargando y ejecutando Script para UBUNTU 16"
        wget https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Nextcloud-Script-UBUNTU-16.sh --no-check-certificate
        sh Nextcloud-Script-UBUNTU-16.sh
     ;;
     2)
        echo "Descargando y ejecutando Script para UBUNTU 18"
        wget https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Nextcloud-Script-UBUNTU-18.sh --no-check-certificate
        sh Nextcloud-Script-UBUNTU-18.sh
     ;;
     3)
        echo "Descargando y ejecutando Script para DEBIAN"
        wget https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Nextcloud-Script-DEBIAN.sh --no-check-certificate
        sh Nextcloud-Script-DEBIAN.sh
     ;;
     *)
        echo "no se qué numero es"
     ;;
  esac
