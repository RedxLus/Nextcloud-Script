#!/bin/bash
clear
echo "Elige" 
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
