#!/bin/bash

apt-get install net-tools
laip=$(ifconfig|awk 'NR == 2'|awk '{print $2}'|cut -d ':' -f2)

echo "Su IP es $laip. Vamos a añadirla como Dominio de Confianza:"

sed -i "8i 0 => \'&laip\',"  config.php

echo "Añadida"
