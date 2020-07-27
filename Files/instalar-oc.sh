#!/bin/bash

echo ""
echo "¿Desea Instalar OcDownloader (plugin para Nextcloud)?"
echo "1. Si. Me gustaria la instalacion automatica de OcDownloader." 
echo "2. No. Gracias. Salir" 
echo -n "Seleccione una opcion [1 - 2]"
  read seleccion
  
  case $seleccion in
     1)
        echo "Instalando y activando"
        curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos/ocDownloader.sh -k
        chmod +x ocDownloader.sh
        sh ocDownloader.sh && rm -r ocDownloader.sh
     ;;
     2)
        echo "Saliendo"
     ;;
     *)
        echo "Numero no reconocido."
     ;;
  esac
