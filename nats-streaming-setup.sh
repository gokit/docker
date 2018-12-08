#!/usr/bin/env bash

mkdir /nats-streaming
wget https://github.com/nats-io/nats-streaming-server/releases/download/v0.11.2/nats-streaming-server-v0.11.2-linux-amd64.zip -O nats-streaming.zip
unzip nats-streaming.zip
mv nats-streaming-server-v0.11.2-linux-amd64/* /nats-streaming
rm -rf nats-streaming-server-v0.11.2-linux-amd64

