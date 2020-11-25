FROM centos:7

RUN yum install -y wget openssh-server openssh-clients

RUN ssh-keygen -A

RUN wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/cloudera-manager.repo -P /etc/yum.repos.d/ && \
    rpm --import https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/RPM-GPG-KEY-cloudera

RUN yum install -y oracle-j2sdk1.8

RUN yum install -y cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server postgresql-jdbc python3-pip mysql-connector-java

RUN pip3 install psycopg2==2.7.5 --ignore-installed

RUN service sshd enable

USER cloudera-scm

ENV CLOUDERA_ROOT=/opt/cloudera

ENV CMF_DEFAULTS=/etc/default/cloudera-scm-server

CMD /opt/cloudera/cm/schema/scm_prepare_database.sh postgresql -h postgres --scm-host cloudera-manager scm scm; /opt/cloudera/cm/bin/cm-server 

