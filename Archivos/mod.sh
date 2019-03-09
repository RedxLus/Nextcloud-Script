#!/bin/bash

laip=$(sudo ifconfig|awk 'NR == 2'|awk '{print $2}'|cut -d ':' -f2)

echo "Su IP es $laip. Vamos a añadirla como Dominio de Confianza:"

sed -i '1i &laip' archivo.txt

