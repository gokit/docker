#!/usr/bin/env bash

wget http://www.us.apache.org/dist/kafka/2.1.0/kafka_2.12-2.1.0.tgz  -O kafka.tgz
mkdir -p kafka && tar xzf kafka.tgz -C kafka --strip-components 1
rm -rf kafka.tgz
