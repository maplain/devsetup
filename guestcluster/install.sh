#!/bin/bash

install() {
	user=$1
	ip=$2
	password=$3
	sshpass -p "$password" ssh $user@$ip "apt-get install -y squid"
	sshpass -p "$password" scp squid.conf $user@$ip:/etc/squid/squid.conf
	sshpass -p "$password" ssh $user@$ip "ufw allow 3128"
	sshpass -p "$password" ssh $user@$ip "systemctl restart squid"
}
