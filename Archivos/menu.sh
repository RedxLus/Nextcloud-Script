#!/bin/bash
clear
while :
do
echo " Escoja una opcion "
echo "1. Ver configuración de red"
echo "2. Ver uso de disco"
echo "3. Ver uso de RAM"
echo "4. Salir"
echo -n "Seleccione una opcion [1 - 4]"
read opcion
case $opcion in
1) echo "La configuración de red:";
ip addr show;;
2) echo "El uso de disco:";
df;;
3) echo "El uso de RAM:";
free;;
4) echo "agur";
exit 1;;
*) echo "$opcion no es una opcion válida.";
echo "Presiona una tecla para continuar...";
read foo;;
esac
done
