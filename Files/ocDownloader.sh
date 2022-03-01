#!/bin/bash    
    
apt-get install aria2 curl jq -y
mkdir /var/log/aria2c /var/local/aria2c
touch /var/log/aria2c/aria2c.log
touch /var/local/aria2c/aria2c.sess
chmod 770 -R /var/log/aria2c /var/local/aria2c
aria2c --enable-rpc --rpc-allow-origin-all -c -D --log=/var/log/aria2c/aria2c.log --check-certificate=false --save-session=/var/local/aria2c/aria2c.sess --save-session-interval=2 --continue=true --input-file=/var/local/aria2c/aria2c.sess --rpc-save-upload-metadata=true --force-save=true --log-level=warn

latest=$(curl -s https://api.github.com/repos/e-alfred/ocdownloader/releases/latest | jq --raw-output '.assets[0] | .browser_download_url')

cd /var/www/html/nextcloud/apps && curl -LO $latest
tar -xvzf ocdownloader*.tar.gz
rm -r ocdownloader*.tar.gz

cd /var/www/html/nextcloud  && sudo -u www-data php occ app:enable ocdownloader
