#!/bin/sh

for i in hadoop namenode datanode resourcemanager nodemanager historyserver spark; do
    ( cd $i && ./build.sh)
done
