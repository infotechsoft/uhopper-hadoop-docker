FROM uhopper/hadoop:2.7.2

ENV SPARK_VERSION 1.6.2
ENV SPARK_HADOOP_PROFILE 2.6

ENV SPARK_SRC_URL https://www.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION.tgz
ENV MAVEN_URL https://www.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz

RUN set -x \
    # Force maven binary due to bug in Spark 1.6.2
    && curl -fSL "$MAVEN_URL" -o /tmp/maven.tar.gz \
    && tar -xvf /tmp/maven.tar.gz -C /tmp \
    && curl -fSL "$SPARK_SRC_URL" -o /tmp/spark.tar.gz \
    && tar -xvf /tmp/spark.tar.gz -C /tmp \
    && cd /tmp/spark-$SPARK_VERSION \
    && ./dev/change-scala-version.sh 2.11 \
    && PATH=$PATH:/tmp/apache-maven-3.3.9/bin ./make-distribution.sh --tgz --name $SPARK_HADOOP_PROFILE -Phadoop-provided -Phadoop-$SPARK_HADOOP_PROFILE -Pyarn -Dscala-2.11 -DskipTests \
    && tar xzf spark-$SPARK_VERSION-bin-$SPARK_HADOOP_PROFILE.tgz -C /opt/ \
    && mv /opt/spark-$SPARK_VERSION-bin-$SPARK_HADOOP_PROFILE /opt/spark-$SPARK_VERSION \
    && rm -rf /tmp/spark-$SPARK_VERSION \
    && rm -rf /tmp/apache-maven-3.3.9 \    
    && rm -f /tmp/spark-$SPARK_VERSION.tar.gz \
    && rm -rf /root/.m2

ENV SPARK_HOME=/opt/spark-$SPARK_VERSION

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
