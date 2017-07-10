#!/bin/bash

$HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR namenode -checkpoint
