FROM debian:7

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-7-jdk
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y net-tools

ADD http://www.us.apache.org/dist/hadoop/common/hadoop-2.7.1/hadoop-2.7.1.tar.gz /opt/
RUN ln -s /opt/hadoop-2.7.1/etc/hadoop /etc/hadoop
RUN cp /etc/hadoop/mapred-site.xml.template /etc/hadoop/mapred-site.xml
RUN mkdir /opt/hadoop-2.7.1/logs

RUN mkdir /hadoop-data

ENV HADOOP_PREFIX=/opt/hadoop-2.7.1
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1

ENV USER=root
ENV PATH /opt/hadoop-2.7.1/bin/:$PATH

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
