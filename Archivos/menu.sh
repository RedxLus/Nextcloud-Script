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
        wget https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Nextcloud-Script-UBUNTU-16.sh --no-check-certificate
     ;;
     2)
       wget https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Nextcloud-Script-UBUNTU-18.sh --no-check-certificate
     ;;
     3)
       wget https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Nextcloud-Script-DEBIAN.sh --no-check-certificate
     ;;
     *)
        echo "no se qué numero es"
     ;;
  esac
