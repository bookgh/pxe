#!/bin/bash

set -xe

if [ -f /init ];then
    chmod +x /init
    ./init && rm -f /init
fi

# start xinetd
/usr/sbin/xinetd -stayalive -pidfile /var/run/xinetd.pid

# start dhcp
/usr/sbin/dhcpd -s -f -cf /etc/dhcp/dhcpd.conf -user dhcpd -group dhcpd --no-pid

exec "$@"
