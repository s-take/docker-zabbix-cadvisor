#!/bin/bash

pidfile="/var/run/zabbix/zabbix_agentd.pid"
command="zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf"

# Proxy signals
function kill_app(){
    kill $(cat $pidfile)
    exit 0 # exit okay
}
trap "kill_app" SIGINT SIGTERM

# Start Zabbix Agentd
$command
sleep 2

# Loop while the pidfile and the process exist
while [ -f $pidfile ] && kill -0 $(cat $pidfile) ; do
    sleep 1
done
exit 1000 # exit unexpected

