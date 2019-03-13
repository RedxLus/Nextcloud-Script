#!/bin/bash

apt install redis-server php-redis -y
sed -i "19i -- " /var/www/html/nextcloud/config/config.php
sed -i "20i 'memcache.locking' => '\\\\OC\\\\Memcache\\\\Redis'," /var/www/html/nextcloud/config/config.php
