#!/usr/bin/env bash

wget http://www.us.apache.org/dist/kafka/0.10.2.2/kafka_2.10-0.10.2.2.tgz  -O kafka.tgz
mkdir -p kafka && tar xzf kafka.tgz -C kafka --strip-components 1
rm -rf kafka.tgz
