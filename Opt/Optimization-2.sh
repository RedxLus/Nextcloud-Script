#!/bin/bash
memcache=$('memcache.local' => '\OC\Memcache\APCu',)

apt install php-apcu -y
sed -i "18i 'memcache.local' => '\\\\OC\\\\Memcache\\\\APCu'," /var/www/html/nextcloud/config/config.php

#/etc/php/7.0/apache2
#apc.enable_cli to 1 on your php.ini
