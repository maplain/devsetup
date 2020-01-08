#!/bin/bash

ip=$(ip a | grep 192.168 | awk '{print $2}' | awk -F'/' '{print $1}')
sed -i "s/\$wgServer =.*$/\$wgServer = \"http:\/\/$ip\";/g" /home/vagrant/LocalSettings.php
