#!/usr/bin/env bash

# export PUBSUB_EMULATOR_HOST=0.0.0.0:8538

nohup bash -c "gcloud beta emulators pubsub start --host=$PUBSUB_EMULATOR_HOST --data-dir=/data &"
sleep 5
