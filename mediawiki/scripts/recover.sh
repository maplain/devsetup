#!/bin/bash

if [ ! -f /mysql/backup/wiki.tgz ]; then
	exit 0
fi
mysql="mysql --defaults-extra-file=/home/vagrant/creds"
mysqlimport="mysqlimport --defaults-extra-file=/home/vagrant/creds"

mkdir -p /var/lib/mysql-files
rm -rf /var/lib/mysql-files/*
tar xzvf /mysql/backup/wiki.tgz -C /var/lib/mysql-files

$mysql -e "create database wiki;"
pushd /var/lib/mysql-files
  cp LocalSettings.php /home/vagrant/LocalSettings.php
  for i in *.sql; do $mysql wiki < $i; done
  for i in *.txt; do $mysqlimport --local wiki /var/lib/mysql-files/$i; done
popd
