FROM uhopper/hadoop

ENV APACHE_SPARK_VERSION 1.6.1
ENV APACHE_HADOOP_VERSION 2.7.1

ENV NOTEBOOK_VERSION 0.6.3
ENV NOTEBOOK_URL https://s3.eu-central-1.amazonaws.com/spark-notebook/tgz/spark-notebook-${NOTEBOOK_VERSION}-scala-2.11.7-spark-${APACHE_SPARK_VERSION}-hadoop-${APACHE_HADOOP_VERSION}-with-hive-with-parquet.tgz?max-keys=100000

RUN set -x \
    && curl -fSL "$NOTEBOOK_URL" -o /tmp/spark-notebook.tgz \
    && tar -xzvf /tmp/spark-notebook.tgz -C /opt/ \
    && mv /opt/spark-notebook-* /opt/spark-notebook \
    && rm /tmp/spark-notebook.tgz

COPY run.sh /run.sh
RUN chmod a+x /run.sh

WORKDIR /opt/spark-notebook/

CMD ["/run.sh"]