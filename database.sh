#!/bin/bash    
    
    echo "Please enter root user MySQL password!"
    read rootpasswd
    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE nextcloud;"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud_user'@'localhost' IDENTIFIED BY 'PASSWORD';"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
