FROM uhopper/hadoop

ENV APACHE_SPARK_VERSION 1.5.1
ENV APACHE_HADOOP_VERSION 2.7.1

RUN set -x \
    && curl -fSL "https://dl.bintray.com/sbt/native-packages/sbt/0.13.9/sbt-0.13.9.tgz" -o /tmp/sbt.tgz \
    && tar -xvf /tmp/sbt.tgz -C /opt/ \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y unzip \
    && curl -fSL "https://github.com/ibm-et/spark-kernel/archive/master.zip" -o /tmp/spark-kernel-master.zip \
    && unzip /tmp/spark-kernel-master.zip -d /tmp/

RUN set -x \
    && cd /tmp/spark-kernel-master \
    && /opt/sbt/bin/sbt compile pack

RUN set -x \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y make \
    && cd /tmp/spark-kernel-master/kernel/target/pack \
    && make install

RUN set -x \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python python-dev \
    && curl -fSL "https://bootstrap.pypa.io/get-pip.py" -o /tmp/get-pip.py \
    && python /tmp/get-pip.py \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gcc g++ \    
    && pip install jupyter

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor \
    && mkdir /logs

#COPY supervisor-conf.d/ /etc/supervisor/conf.d/
#CMD ["supervisord" "-n"]

RUN mkdir -p /root/.local/share/jupyter/kernels/spark
COPY spark-kernel.json /root/.local/share/jupyter/kernels/spark/kernel.json

ENV SPARK_NOTEBOOK_MASTER yarn-client

COPY run.sh /run.sh
RUN chmod a+x /run.sh

RUN mkdir /notebooks
WORKDIR /notebooks

CMD ["/run.sh"]