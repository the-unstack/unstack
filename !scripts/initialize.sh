#!/bin/bash

## ***** global *****
# Postgres
docker network create postgres

# Node-RED Global
sudo mkdir -p /srv/unstack-data/nodered-global
sudo chown 1000:1000 /srv/unstack-data/nodered-global

# Kafka Broker Global
docker network create kafka-global
sudo mkdir -p /srv/unstack-data/redpanda-broker-global
sudo chown 101:101 /srv/unstack-data/redpanda-broker-global


## ***** edge *****
# Node-RED Edge
sudo mkdir -p /srv/unstack-data/nodered-edge
sudo chown 1000:1000 /srv/unstack-data/nodered-edge

# Kafka Broker Edge
docker network create kafka-edge
sudo mkdir -p /srv/unstack-data/redpanda-broker-edge
sudo chown 101:101 /srv/unstack-data/redpanda-broker-edge

# MQTT Broker
docker network create mqtt

