#!/bin/bash

docker run -it --network app_default --device=/dev/ttyACM0:/dev/ttyACM0 -e AWS_ACCESS_KEY_ID=minio -e AWS_SECRET_ACCESS_KEY=minio123 -e MLFLOW_S3_ENDPOINT_URL=http://minio:9000 -e MLFLOW_TRACKING_URI=http://mlflow:5000 qooba/tinyml-arduino:mlops ./mlops.sh -r 319c423a40544f13871a54b32dbce8f7
