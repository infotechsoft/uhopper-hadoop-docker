FROM debian:stretch-backports

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -t stretch-backports --no-install-recommends openjdk-8-jre-headless ca-certificates-java
    
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends net-tools curl gnupg \
    && rm -rf /var/lib/apt/lists/*

ADD functions.sh /functions.sh

ARG HADOOP_VERSION
ENV HADOOP_VERSION ${HADOOP_VERSION}
ENV HADOOP_PATH hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
RUN . /functions.sh \
    && curl -fSL "$(apache_mirror $HADOOP_PATH)" -o /tmp/hadoop.tar.gz \
    && curl -fSL "https://archive.apache.org/dist/$HADOOP_PATH.asc" -o /tmp/hadoop.tar.gz.asc \
    && curl -fSL https://dist.apache.org/repos/dist/release/hadoop/common/KEYS -o /tmp/KEYS \
    && gpg --no-default-keyring --keyring /tmp/keys.gpg --import /tmp/KEYS \
    && gpgv --keyring /tmp/keys.gpg /tmp/hadoop.tar.gz.asc /tmp/hadoop.tar.gz \
    && tar -xf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz* /tmp/KEYS /tmp/keys.gpg \
    && ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop \
    && cp /etc/hadoop/mapred-site.xml.template /etc/hadoop/mapred-site.xml \
    && mkdir /opt/hadoop-$HADOOP_VERSION/logs \
    && mkdir /hadoop-data \
    && rm -Rf /opt/hadoop-$HADOOP_VERSION/share/doc/hadoop

ENV HADOOP_PREFIX=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1

ENV USER=root
ENV PATH $HADOOP_PREFIX/bin/:$PATH

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
