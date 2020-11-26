FROM centos:7

ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]

RUN yum install -y wget openssh-server openssh-clients sudo

RUN wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/cloudera-manager.repo -P /etc/yum.repos.d/ && \
    rpm --import https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/RPM-GPG-KEY-cloudera

RUN yum install -y oracle-j2sdk1.8

RUN yum install -y cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server postgresql-jdbc python3-pip mysql-connector-java

RUN pip3 install psycopg2==2.7.5 --ignore-installed

RUN sed -i "s/^session.*//g" /etc/pam.d/sudo

RUN sed -i "s/^UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config

RUN echo "cloudera-scm    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

RUN ssh-keygen -A

RUN echo "scmcloudera" | passwd cloudera-scm --stdin

RUN chsh cloudera-scm -s /bin/bash

RUN rm -rf /etc/yum.repos.d/*

RUN systemctl enable sshd

COPY cloudera-manager.repo /etc/yum.repos.d/

COPY init-script.sh /init-script.sh

COPY cloudera-scm-server.service /usr/lib/systemd/system/

RUN systemctl daemon-reload && systemctl enable cloudera-scm-server

ENTRYPOINT ["/usr/sbin/init"]
