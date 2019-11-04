#!/bin/sh

sysctl -w net.ipv4.ip_forward=1

if [ ! -e /dev/net/tun ]; then
	mkdir -p /dev/net
	mknod /dev/net/tun c 10 200
	chmod 600 /dev/net/tun
fi

iptables -t nat -A POSTROUTING -j MASQUERADE
iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu 

ocserv -c /etc/ocserv/ocserv.conf -f "$@"