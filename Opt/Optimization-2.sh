#!/bin/bash

apt install php-apcu
sed -i "18i 'memcache.local' => '/\/OC/\/Memcache/\/APCu',"  config.php
