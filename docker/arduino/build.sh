#!/bin/bash

cp ../../mlops/mlops.sh .
docker build -t qooba/tinyml-arduino:mlops .
rm mlops.sh
