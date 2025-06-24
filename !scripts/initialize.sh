#!/bin/bash

## ***** edge *****
# MQTT Broker
docker network create mqtt

# Node-RED Edge
sudo mkdir -p /srv/unstack-data/nodered-edge
sudo chown 1000:1000 /srv/unstack-data/nodered-edge

# Kafka Broker Edge
docker network create kafka-edge
sudo mkdir -p /srv/unstack-data/redpanda-broker-edge
sudo chown 101:101 /srv/unstack-data/redpanda-broker-edge

# Kafka Broker Global
docker network create kafka-global
sudo mkdir -p /srv/unstack-data/redpanda-broker-global
sudo chown 101:101 /srv/unstack-data/redpanda-broker-global

