#!/bin/bash

show_local_ip() {
	ip a | grep 192.168.3
}

setup_vip() {
  vip=${1}
  ip l add vip type dummy
  ip a add ${vip} dev vip
  ip l set vip up
}

healthcheck() {
   endpoint=${1}
   num=${2}
   action1=${3}
   action2=${4}
   executed=""
   for i in $(seq 1 $2); do
      if curl -s -m 2 ${endpoint} | grep 301 >/dev/null 2>&1 || ! curl -s -m 1 ${endpoint}  > /dev/null 2>&1; then
	 if [ "${executed}" != "removed" ]; then
		 eval "${action1}"
		 executed="removed"
		 sleep 5s
	 fi
      else
	 if [[ "${executed}" == "removed" ]]; then
		 eval "${action2}"
		 executed="added"
         fi
      fi
      sleep 1s
   done
}

h1() {
   healthcheck 192.168.36.2:12345 1000 'ipvsadm -d -t 192.168.100.231:12345 -r 192.168.36.2:12345' &
   healthcheck 192.168.35.2:12345 1000 './gobgp global rib -a ipv4 del 192.168.100.0/24' &
}

# for i in $(seq 7); do inject ~/.ssh/[xx.pub] u${i}; done

run_nginx_in_docker() {
  name=${1}
  mkdir /src/${name}
  echo "This is ${name}" > /src/${name}/index.html
  docker run --rm -d -v "/src/${name}:/usr/share/nginx/html" --name nginx-${name} nginx
  docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nginx-${name}
}

cleanup_nginx_in_docker() {
  name=${1}
  docker rm -f nginx-${name}
  rm -rf /src/${name}
}

install_quagga() {
	sudo apt-get update
	sudo apt-get install -y quagga
}

install_gobgp() {
	wget https://github.com/osrg/gobgp/releases/download/v2.5.0/gobgp_2.5.0_linux_amd64.tar.gz
	tar xzvf gobgp_2.5.0_linux_amd64.tar.gz
}

#ifname=${1}
#ip=$(ip a show dev ${ifname} | awk '/inet /{print $2}' | awk -F'/' '{print $1}')

add_service() {
	ip=${1}
        ipvsadm -A -t ${ip}
}

add_server_nat() {
	ep=${1}
        ipvsadm -a -t ${VEP} -r ${ep} -m
}

add_server_encap() {
	ep=${1}
        ipvsadm -a -t ${VEP} -r ${ep} -i
}

add_server_dr() {
	ep=${1}
        ipvsadm -a -t ${VEP} -r ${ep} -g
}

del_server() {
	ep=${1}
        ipvsadm -d -t ${VEP} -r ${ep}
}

delete_service() {
	ep=${1}
        ipvsadm -D -t ${ep}
}

#setup_nat_mode() {
  #ipvsadm -A -t ${ip}:12345
  #ipvsadm -a -t ${ip}:12345 -r 192.168.150.2:12345 -m
  #ipvsadm -a -t ${ip}:12345 -r 192.168.150.3:12345 -m
  #ipvsadm -a -t ${ip}:12345 -r 192.168.150.4:12345 -m
#}

#setup_dr_mode() {
  #ipvsadm -A -t ${ip}:12345
  #ipvsadm -a -t ${ip}:12345 -r 192.168.33.2:12345
  #ipvsadm -a -t ${ip}:12345 -r 192.168.33.3:12345
  #ipvsadm -a -t ${ip}:12345 -r 192.168.33.4:12345
#}

#cleanup_dr_mode_on_server() {
	#srcnet=${1}
	#ip r d ${srcnet}
	#ip l set vip down
	#ip l d vip
#}

#setup_dr_mode_on_server() {
	#vip=${1}
	#srcnet=${2}
	#ip l add vip type dummy
	#ip a add dev vip ${vip}/32
	#ip l set vip up
	#ip r a ${srcnet} via 192.168.33.1 dev enp0s8 src ${vip}
#}

setup_tunnel_mode_on_server() {
	vip=${1}
	gateway=${2}
	if ! ip a | grep ${vip} >/dev/null 2>&1; then
		ip a add dev tunl0 ${vip}/32
		ip l set tunl0 up
	fi
	sysctl -w net.ipv4.conf.tunl0.rp_filter=2
	sysctl -w net.ipv4.ip_forward=1
	ip r change default via ${gateway} src ${vip}
}

change_default_route() {
  ip r del default
  ip r add default via ${1}
}

change_default_as_vip() {
	vip=${1}
	gateway=${2}
	ip r del default
	ip r add default via ${gateway} src ${vip}
}

setup_vip_on_tunl0() {
  vip=${1}
  ip a add ${vip} dev tunl0
  ip l set tunl0 up
}

delete_vip() {
  ip l set vip down
  ip l del vip
}

# setup_vip 192.168.161.123
