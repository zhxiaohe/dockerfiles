FROM centos:latest

MAINTAINER from ibash.cc by Nick

# install basic software
RUN yum update -y
RUN yum install vim dmidecode curl wget python-devel iproute util-linux pciutils sysstat git iputils telnet strace ltrace lsof openssl openssl-devel pcre pcre-devel zlib-devel tree -y
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python

# install ssh daemon
RUN yum install openssh-server openssh openssh-clients -y
RUN mkdir -p /var/run/sshd
RUN mkdir -p /root/.ssh
RUN sed -ri 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd
RUN sed -ri 's@#HostKey /etc/ssh/ssh_host_dsa_key@HostKey /etc/ssh/ssh_host_dsa_key@g' /etc/ssh/sshd_config
RUN sed -ri 's@#UseDNS yes@UseDNS no@g' /etc/ssh/sshd_config

# ssh key gen
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

# copy publish key & chmod execute permission
ADD authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
RUN echo "#!/usr/bin/env bash" > /run.sh
RUN echo "/usr/sbin/sshd -D" >> /run.sh
RUN chmod 755 /run.sh

# clean yum
RUN yum clean all

# set timezone
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

# set port
EXPOSE 22

# start service command
CMD ["/run.sh"]
