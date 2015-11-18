FROM uhopper/hadoop

ADD http://www.apache.org/dyn/closer.lua/spark/spark-1.5.1/spark-1.5.1-bin-without-hadoop.tgz /opt/
RUN mv /opt/spark-1.5.1-* /opt/spark-1.5.1

WORKDIR /opt/spark-1.5.1
ENV PATH /opt/spark-1.5.1/bin:$PATH

ADD spark-entrypoint.sh /
RUN chmod a+x /spark-entrypoint.sh

RUN echo "export SPARK_DIST_CLASSPATH=$(hadoop classpath)" >> /opt/spark-1.5.1/conf/spark-env.sh

RUN touch /tmp/keepalive
CMD ["tail", "-f", "/tmp/keepalive"]
