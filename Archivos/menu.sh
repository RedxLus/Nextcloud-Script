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
        echo "uno"
     ;;
     2)
        echo "dos"
     ;;
     *)
        echo "no se qué numero es"
     ;;
  esac
