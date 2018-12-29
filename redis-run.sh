#!/usr/bin/env bash

# export REDIS_PORT=6379

bash -c "redis-server --port $REDIS_PORT &"
sleep 5
