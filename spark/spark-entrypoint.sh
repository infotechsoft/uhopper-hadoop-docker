#!/bin/bash

export SPARK_DIST_CLASSPATH=$(hadoop classpath)

exec /entrypoint.sh $@
