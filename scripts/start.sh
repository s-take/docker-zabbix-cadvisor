#!/bin/bash

set -e

passwd -d root

ZABBIX_SERVER=${ZABBIX_SERVER}
ACTIVE_CHECK_PORT=${ACTIVE_CHECK_PORT}
HOSTNAME=${HOSTNAME}

# configure zabbix server

sed -i "s/Server=127\.0\.0\.1,::1/Server=${ZABBIX_SERVER}/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/ListenIP=127\.0\.0\.1,::1/ListenIP=0\.0\.0\.0/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive=127\.0\.0\.1,::1/ServerActive=${ZABBIX_SERVER}:${ACTIVE_CHECK_PORT}/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/Hostname=${HOSTNAME}/" /etc/zabbix/zabbix_agentd.conf

/usr/bin/supervisord

