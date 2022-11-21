#!/bin/sh -e

trap "trap exit TERM && kill -- -$$" INT TERM EXIT

. https-dns-proxy.conf
[ "$ipv4" != "1" ] && ipv4=

https_dns_proxy -a 127.0.0.53 -p 53 -u nobody -g nobody -l /var/log/https-dns-proxy.log ${dns_servers:+-b "$dns_servers"} ${resolver_url:+-r "$resolver_url"} ${ipv4:+-4} ${proxy_server:+-t "$proxy_server"} &

proxychains4 sniproxy -c sniproxy.conf -f 2>/var/log/proxychains.log &

wait -n
