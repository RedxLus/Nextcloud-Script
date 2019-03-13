#!/bin/bash
memcache=$('memcache.local' => '\OC\Memcache\APCu',)

apt install php-apcu
sed -i "18i \'$memcache\'"  config.php
