FROM local/c7-systemd

RUN yum install -y wget openssh-server openssh-clients sudo

RUN wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/cloudera-manager.repo -P /etc/yum.repos.d/ && \
    rpm --import https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/RPM-GPG-KEY-cloudera

RUN yum install -y oracle-j2sdk1.8

RUN yum install -y cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server postgresql-jdbc python3-pip mysql-connector-java

RUN pip3 install psycopg2==2.7.5 --ignore-installed

RUN systemctl enable sshd.service

USER cloudera-scm

COPY start-script.sh /start-script.sh

CMD /start-script.sh 
