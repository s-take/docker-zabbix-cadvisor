FROM centos:centos6

RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN localedef -f UTF-8 -i ja_JP ja_JP

# Update base images.
RUN yum distribution-synchronization -y

# setup zabbix
RUN yum install -y http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum install -y http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm

RUN yum install -y zabbix-agent zabbix-sender

# setup supervisor
RUN yum install -y python-setuptools
RUN easy_install supervisor

# Cleaining up.
RUN yum clean all

# configuration Zabbix
ADD ./zabbix/zabbix_agentd.conf       /etc/zabbix/zabbix_agentd.conf
ADD ./scripts/zabbix-agentd.sh        /usr/local/sbin/zabbix-agentd.sh

RUN chmod 755 /usr/local/sbin/zabbix-agentd.sh

# https://github.com/dotcloud/docker/issues/1240#issuecomment-21807183
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# Add the script that will start the repo.
ADD ./supervisord/supervisord.conf /etc/supervisord.conf
ADD ./scripts/start.sh /usr/local/sbin/start.sh
RUN chmod 755 /usr/local/sbin/start.sh

# Expose the Ports used by
# * Zabbix services
# * Apache with Zabbix UI
EXPOSE 10050

CMD ["/bin/bash", "/usr/local/sbin/start.sh"]
