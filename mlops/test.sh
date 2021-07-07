#!/bin/bash

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -s|--serial) SERIAL="$2"; shift ;;
        -c|--core) CORE="$2"; shift ;;
        -m|--model) MODEL="$2"; shift ;;
        -h|--help) HELP=1 ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

echo "Where to deploy: $SERIAL $CORE $MODEL"
echo "Should uglify  : $HELP"
