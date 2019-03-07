#!/bin/bash    
    
echo NOMBRE-USUARIO-NEXTCLOUD :
read to_print

echo CONTRASENA-USUARIO-NEXTCLOUD:
read t2o_print


    echo "Please enter root user MySQL password!"
    read rootpasswd
    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE nextcloud;"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON nextcloud.* TO '$to_print'@'localhost' IDENTIFIED BY '$t2o_print';"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
