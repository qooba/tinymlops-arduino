#!/bin/bash

docker run -it --network app_default --device=/dev/ttyACM0:/dev/ttyACM0 -e AWS_ACCESS_KEY_ID=minio -e AWS_SECRET_ACCESS_KEY=minio123 -e MLFLOW_S3_ENDPOINT_URL=http://minio:9000 -e MLFLOW_TRACKING_URI=http://mlflow:5000 qooba/tinyml-arduino:mlops ./mlops.sh -r b017ded03b3f4dd780d0437293b7f344
