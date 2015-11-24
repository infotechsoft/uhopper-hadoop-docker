#!/bin/sh

sed -i "s/<MASTER>/$SPARK_NOTEBOOK_MASTER/" /root/.local/share/jupyter/kernels/spark/kernel.json

jupyter notebook --no-browser --ip=*
