#!/bin/sh

# start nginx
/usr/sbin/nginx -c /etc/nginx/nginx.conf

exec "$@" "--dhcp-range=$IP,proxy"
