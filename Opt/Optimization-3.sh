#!/bin/bash

apt install redis-server php-redis -y
sed -i "19i 'memcache.distributed' => '\\\\OC\\\\Memcache\\\\Redis', " /var/www/html/nextcloud/config/config.php
sed -i "20i 'redis' => [ " /var/www/html/nextcloud/config/config.php
sed -i "21i      'host' => 'redis-host.example.com', " /var/www/html/nextcloud/config/config.php
sed -i "22i      'port' => 6379, " /var/www/html/nextcloud/config/config.php
sed -i "23i ], " /var/www/html/nextcloud/config/config.php

sed -i "24i 'memcache.locking' => '\\\\OC\\\\Memcache\\\\Redis'," /var/www/html/nextcloud/config/config.php
