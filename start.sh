#!/bin/bash

# Apply munin-node allowed hosts
if [ ! -z ${ALLOWED_HOSTS+x} ]; then
	sed -i -e 's@^cidr_allow.*@cidr_allow '"$ALLOWED_HOSTS"'@' /etc/munin/munin-node.conf
fi

# Apply user defined server name from ENV
if [ ! -z ${HOSTNAME+x} ]; then
	sed -ie 's@localhost.localdomain@'"$HOSTNAME"'@g' /etc/munin/munin.conf
fi

# Set timezone if supplied ENV{TZ} is valid
if [ -f "/usr/share/zoneinfo/$TZ" ]; then
	rm /etc/localtime
	ln -s "/usr/share/zoneinfo/$TZ" /etc/localtime
fi

munin-node-configure --remove --shell | sh
service cron start
exec /usr/sbin/munin-node --config /etc/munin/munin-node.conf