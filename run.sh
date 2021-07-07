#!/bin/bash

#docker network create -d bridge app_default

docker run -d --rm --name minio -p 9000:9000 -e MINIO_ROOT_USER=minio -e MINIO_ROOT_PASSWORD=minio123 --network app_default -v $(pwd)/minio:/data minio/minio:edge server /data

docker run -d --rm --name jupyter -p 8888:8888 --network app_default -e MLFLOW_TRACKING_URI=http://mlflow:5000 -e AWS_ACCESS_KEY_ID=minio -e AWS_SECRET_ACCESS_KEY=minio123 -e MLFLOW_S3_ENDPOINT_URL=http://minio:9000 -v $(pwd)/notebooks:/home/jovyan qooba/tinyml-arduino:jupyter 

docker run --name mlflow --rm -p 5000:5000 --network app_default -e MLFLOW_TRACKING_URI=http://mlflow:5000 -e AWS_ACCESS_KEY_ID=minio -e AWS_SECRET_ACCESS_KEY=minio123 -e MLFLOW_S3_ENDPOINT_URL=http://minio:9000 -v $(pwd)/mlflow_repository:/mlflow  -d qooba/mlflow:dev bash -c "mlflow server -h 0.0.0.0 --backend-store-uri sqlite:///mlflow/mlflow.db --default-artifact-root s3://mlflow/mlruns"


#docker run -it --rm -p 8888:8888 --network app_default --name arduino --device=/dev/ttyACM0:/dev/ttyACM0 -v $(pwd)/src/arduino:/arduino -v $(pwd)/src/server:/server qooba/tinyml-arduino:mlops /bin/bash

#docker run -it --network app_default -e AWS_ACCESS_KEY_ID=minio -e AWS_SECRET_ACCESS_KEY=minio123 -e MLFLOW_S3_ENDPOINT_URL=http://minio:9000 -e MLFLOW_TRACKING_URI=http://mlflow:5000   qooba/tinyml-arduino:mlops /bin/bash
