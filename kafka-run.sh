#!/usr/bin/env bash

export ZOOKEEPER_PEERS='localhost:2181'
export KAFKA_PEERS='localhost:9092'

nohup bash -c "cd kafka && bin/zookeeper-server-start.sh config/zookeeper.properties &"
sleep 3
bash -c "cd kafka && bin/kafka-server-start.sh config/server.properties &"
