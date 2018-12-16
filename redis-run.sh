#!/usr/bin/env bash

# export REDIS_PORT=6379

nohup bash -c "redis-server --port $REDIS_PORT &"
sleep 5
