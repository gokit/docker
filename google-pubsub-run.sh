#!/usr/bin/env bash

# export PUBSUB_EMULATOR_HOST=0.0.0.0:8538

bash -c "gcloud beta emulators pubsub start --host=$PUBSUB_EMULATOR_HOST --data-dir=/data --log-http --verbosity=debug --user-output-enabled &"
sleep 5
