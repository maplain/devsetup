#!/bin/bash

mysqldump='mysqldump --defaults-extra-file=/home/vagrant/creds'
mkdir -p /var/lib/mysql-files
rm -rf /var/lib/mysql-files/*

# dump all *sql *txt files
$mysqldump --tab=/var/lib/mysql-files wiki
cp /home/vagrant/LocalSettings.php /var/lib/mysql-files
tar czvf /mysql/backup/wiki.tgz -C /var/lib/mysql-files .
