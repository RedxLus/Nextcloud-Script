#!/bin/bash

apt-get install net-tools
laip=$(ifconfig|awk 'NR == 2'|awk '{print $2}'|cut -d ':' -f2)

clear

echo "Su IP es $laip. ¿Es correcta?. Puede modificarla despues en /var/www/html/nextcloud/config/config.php "
echo "1. Si. Puede añadirla automaticamente para que funcione NextCloud."
echo "2. No. No es mi ip o quiero hacerlo manual."
echo -n "Seleccione una opcion [1 - 2]"
read respuesta

if [ $respuesta = 1 ]
then
cd /var/www/html/nextcloud/config && sed -i "8i 1 => \'$laip\',"  config.php && echo "Todo correcto"
else
echo "Saliendo"
fi
