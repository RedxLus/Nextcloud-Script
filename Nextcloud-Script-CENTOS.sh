#!/bin/bash

    echo ""
    echo "Please enter root user MySQL password!"
    read rootpasswd
    
yum update -y
yum install epel-release -y
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

yum install httpd unzip php70w php70w-dom php70w-mbstring php70w-gd php70w-pdo php70w-json php70w-xml php70w-zip php70w-curl php70w-mcrypt php70w-pear setroubleshoot-server bzip2 -y

yum install mariadb-server php70w-mysql -y

systemctl start mariadb
systemctl enable mariadb

yum -y install expect

// Not required in actual script
MYSQL_ROOT_PASSWORD=abcd1234

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"

yum remove expect -y
yum clean all

    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE nextcloud;"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin'@'localhost' IDENTIFIED BY '$rootpasswd';"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
    
curl -LO https://download.nextcloud.com/server/releases/nextcloud-13.0.1.zip

unzip nextcloud-13.0.1.zip -d /var/www/html/
mkdir /var/www/html/nextcloud/data && chown -R apache:apache nextcloud

cd /etc/httpd/conf.d && curl -LO https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/master/Archivos/nextcloud.conf

