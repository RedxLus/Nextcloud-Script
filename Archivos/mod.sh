#!/bin/bash

laip=$(sudo ifconfig|awk 'NR == 2'|awk '{print $2}'|cut -d ':' -f2)

echo "$laip es"

