FROM centos:latest

MAINTAINER from ibash.cc by Nick

# install basic software and sshd service
RUN yum update -y
RUN yum install vim curl wget python-devel iproute util-linux sysstat iputils lsof tree epel-release libaio-devel make gcc -y
RUN yum update -y
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

# copy redis.tar.gz & install redis
ADD redis.tar.gz /tmp
RUN cd /tmp && cd redis-3.2.9 && make && make PREFIX=/usr/local/redis install && mkdir /usr/local/redis/{conf,db}
ADD redis.conf /usr/local/redis/conf
ADD sentinel.conf /usr/local/redis/conf
RUN chmod 644 /usr/local/redis/conf/redis.conf
RUN chmod 644 /usr/local/redis/conf/sentinel.conf
RUN echo "PATH=/usr/local/redis/bin:$PATH" >> /etc/profile
RUN source /etc/profile

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
EXPOSE 22 6379
CMD ["/run.sh"]
