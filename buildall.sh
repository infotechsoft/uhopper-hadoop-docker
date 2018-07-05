#!/bin/sh
set -e

if [ $# -gt 0 ]; then
    HADOOP_VERSION=$1
    if [ $# -gt 1 ]; then
        HADOOP_TAG=$2
    else
        HADOOP_TAG=${HADOOP_TAG:-"latest"}
    fi
fi

if [ -z ${HADOOP_VERSION+x} ]; then
  echo "Must define HADOOP_VERSION enviroment variable, or pass as first argument"
  exit 1
fi

for i in hadoop namenode datanode resourcemanager nodemanager historyserver spark; do
    echo Building $i
    [ "$i" = "hadoop" ] && name="hadoop" || name="hadoop-$i"
    ( cd $i && docker build --build-arg HADOOP_VERSION=$HADOOP_VERSION --build-arg HADOOP_TAG=$HADOOP_TAG -t infotechsoft/$name:$HADOOP_TAG . )
done
