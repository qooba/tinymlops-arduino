#!/bin/bash

RUN_ID=-1

while [[ "$#" -gt 0 ]]; do
    case $1 in
	-r|--run) RUN_ID="$2"; shift ;;
        -s|--serial) SERIAL="$2"; shift ;;
        -c|--core) CORE="$2"; shift ;;
        -m|--model) MODEL="$2"; shift ;;
        -h|--help) HELP=1 ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done


Help()
{
   echo "ARDUINO MLOPS"
   echo
   echo "Syntax: docker run -it qooba/tinyml-arduino:mlops -h [-r MLFLOW_RUN_ID] [-s ARDUINO_SERIAL] [-c ARDUINO_CORE] [-m ARDUINO_MODEL]"
   echo "options:"
   echo "-h|--help     Print help"
   echo "-r|--run      MLflow run id"
   echo "-s|--serial   Arduino device serial (default: /dev/ttyACM0)"
   echo "-c|--core     Arduino core (default: arduino:mbed_nano)"
   echo "-m|--model    Arduino model (default: arduino:mbed_nano:nano33ble)"
   echo
}

if [[ $HELP -ne 1 && $RUN_ID -ne -1 ]]; then

  DEFAULT_ARDUINO_SERIAL="/dev/ttyACM0"
  DEFAULT_ARDUINO_CORE="arduino:mbed_nano"
  DEFAULT_ARDUINO_MODEL="arduino:mbed_nano:nano33ble"

  ARDUINO_SERIAL=${SERIAL:-$DEFAULT_ARDUINO_SERIAL}
  ARDUINO_CORE=${CORE:-$DEFAULT_ARDUINO_CORE}
  ARDUINO_MODEL=${MODEL:-$DEFAULT_ARDUINO_MODEL}

  echo $SERIAL $ARDUINO_CORE $ARDUINO_MODEL

  ARTIFACTS_PATH=$(mlflow artifacts download --run-id=$RUN_ID)
  echo $ARTIFACTS_PATH
  cd $ARTIFACTS_PATH/model/artifacts

  arduino-cli core update-index
  arduino-cli core install $ARDUINO_CORE

  cat requirements.ino.txt | xargs  arduino-cli lib install
  arduino-cli compile --fqbn $ARDUINO_MODEL
  arduino-cli upload -p $ARDUINO_SERIAL --fqbn $ARDUINO_MODEL
else
  Help
fi

