ARG HADOOP_TAG
FROM infotechsoft/hadoop:${HADOOP_TAG}

ARG SPARK_VERSION=2.3.1
ENV SPARK_VERSION ${SPARK_VERSION}
ENV SPARK_HOME=/opt/spark-$SPARK_VERSION

RUN set -x \
    && . /functions.sh \
    && apache_install spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz spark/KEYS \
    && mv /opt/spark-$SPARK_VERSION-* $SPARK_HOME

WORKDIR $SPARK_HOME
ENV PATH $SPARK_HOME/bin:$PATH

ADD spark-entrypoint.sh /
ADD spark-historyserver.sh /
ADD spark-master.sh /
ADD spark-slave.sh /

RUN chmod a+x \
    /spark-entrypoint.sh \
    /spark-historyserver.sh \
    /spark-master.sh \
    /spark-slave.sh
    
RUN echo "export SPARK_DIST_CLASSPATH=$(hadoop classpath)" >> /opt/spark-$SPARK_VERSION/conf/spark-env.sh

ENTRYPOINT ["/spark-entrypoint.sh"]
