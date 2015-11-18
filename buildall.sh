#!/bin/sh

for i in hadoop namenode datanode resourcemanager nodemanager spark; do
    ( cd $i && ./build.sh)
done
