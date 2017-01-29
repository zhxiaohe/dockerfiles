FROM centos:latest

MAINTAINER from ibash.cc by Nick

# add user and group
RUN groupadd -r mysql && useradd -r -g mysql mysql

# copy mysql.tar.gz & my.cnf
ADD mysql-5.7.tar.gz /usr/local/
RUN ln -s /usr/local/mysql* /usr/local/mysql
ADD my.cnf /etc/my.cnf
RUN chmod 644 /etc/my.cnf

# config mysql
RUN rm -rf /var/lib/mysql \
    && mkdir -p /var/lib/mysql/log /var/lib/mysql/data /var/lib/mysql/redolog /var/lib/mysql/undolog /var/lib/mysql/binlog /var/run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld
ENV MYSQL_USER root
ENV MYSQL_PASS **Random**
VOLUME  ["/var/lib/mysql/log", "/var/lib/mysql/data", "/var/lib/mysql/redolog", "/var/lib/mysql/undolog", "/var/lib/mysql/binlog"]

# install basic software and sshd service
RUN yum update -y
RUN yum install vim curl wget python-devel iproute util-linux sysstat iputils lsof tree epel-release libaio-devel -y
RUN yum update
RUN yum install supervisor pwgen openssh-server openssh openssh-clients -y
RUN mkdir -p /var/run/sshd
RUN mkdir -p /root/.ssh
ADD authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
RUN sed -ri 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd
RUN sed -ri 's@#HostKey /etc/ssh/ssh_host_dsa_key@HostKey /etc/ssh/ssh_host_dsa_key@g' /etc/ssh/sshd_config
RUN sed -ri 's@#UseDNS yes@UseDNS no@g' /etc/ssh/sshd_config
RUN /usr/bin/ssh-keygen -q -t rsa1 -f /etc/ssh/ssh_host_key -C '' -N '' >& /dev/null
RUN chmod 600 /etc/ssh/ssh_host_key && chmod 644 /etc/ssh/ssh_host_key.pub
RUN /usr/bin/ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N '' >& /dev/null
RUN chmod 600 /etc/ssh/ssh_host_rsa_key && chmod 644 /etc/ssh/ssh_host_rsa_key.pub
RUN /usr/bin/ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_dsa_key -C '' -N '' >& /dev/null
RUN chmod 600 /etc/ssh/ssh_host_dsa_key && chmod 644 /etc/ssh/ssh_host_dsa_key.pub
RUN /usr/bin/ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -C '' -N '' >& /dev/null
RUN chmod 600 /etc/ssh/ssh_host_ecdsa_key && chmod 644 /etc/ssh/ssh_host_ecdsa_key.pub
RUN /usr/bin/ssh-keygen -q -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -C '' -N '' >& /dev/null
RUN chmod 600 /etc/ssh/ssh_host_ed25519_key && chmod 644 /etc/ssh/ssh_host_ed25519_key.pub

# clean yum
RUN yum clean all

# set timezone
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

# config supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisord.conf
VOLUME  /var/log/supervisor

# start
ADD run.sh /run.sh
RUN chmod 755 /*.sh
EXPOSE 22 3306
CMD ["/run.sh"]