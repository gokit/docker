#!/usr/bin/env bash

mkdir /gnatsd
wget https://github.com/nats-io/gnatsd/releases/download/v1.3.0/gnatsd-v1.3.0-linux-amd64.zip -O gnatsd.zip
unzip gnatsd.zip
mv gnatsd-v1.3.0-linux-amd64/* /gnatsd
rm -rf gnatsd-v1.3.0-linux-amd64
