FROM uhopper/hadoop

RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
    A864F0C3E5262F9A229B85D07B165D2A15E06093 \
    3E1CBD0F0533D602E80C6E986B32946082667DC1 \
    9555DAB91FFA8A15D0925B87B1A91F0000799F7E \
    67B2C95165D2E87617433C3C5D951CFF87FD1A97 \
    5AA90E72812FF2467904277D548F5FEE9E4FE3AF \
    EEDABD1C71C548D6F00661D37C6C105FFC8ED089

ENV SPARK_VERSION 1.5.1
ENV SPARK_URL https://www.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-without-hadoop.tgz
RUN set -x \
    && curl -fSL "$SPARK_URL" -o /tmp/spark.tar.gz \
    && curl -fSL "$SPARK_URL.asc" -o /tmp/spark.tar.gz.asc \
    && gpg --verify /tmp/spark.tar.gz.asc \
    && tar -xvf /tmp/spark.tar.gz -C /opt/ \
    && rm /tmp/spark.tar.gz*

RUN mv /opt/spark-$SPARK_VERSION-* /opt/spark-$SPARK_VERSION

WORKDIR /opt/spark-$SPARK_VERSION
ENV PATH /opt/spark-$SPARK_VERSION/bin:$PATH

ADD spark-entrypoint.sh /
RUN chmod a+x /spark-entrypoint.sh

RUN echo "export SPARK_DIST_CLASSPATH=$(hadoop classpath)" >> /opt/spark-$SPARK_VERSION/conf/spark-env.sh
