#!/usr/bin/env bash

nohup bash -c "/nats-streaming/nats-streaming-server -m 8222 &"
sleep 5
