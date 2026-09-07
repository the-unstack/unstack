<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Apache-2.0][license-shield]][license-url]

<!-- PROJECT LOGO & Header -->
<br />
<div align="center">
  <a href="https://github.com/the-unstack/unstack">
    <img src="https://github.com/the-unstack/unstack-docs/blob/main/images/logo_3d.png" alt="Logo" width="180" height="180">
  </a>

  <h3 align="center">the UNStack</h3>

  <p align="center">
    modular, open-architecture, Unified Namespace focused, Industrial-IoT data stack
    <br />
    <br />
    <a href="#quickstart"><strong>Quickstart</strong></a>
    &middot;
    <a href="https://github.com/the-unstack/unstack-docs"><strong>Explore the docs</strong></a>
    <br />
    <a href="https://github.com/the-unstack/unstack/issues/new?labels=bug">Report Bug</a>
    &middot;
    <a href="https://github.com/the-unstack/unstack/issues/new?labels=enhancement">Request Feature</a>
  </p>
</div>

## About The Project
The UNStack is a modular, open-architecture, Unified Namespace focused, Industrial-IoT data stack.<br>
It delivers your data from your edge devices to your central dashboards and beyond.<br>
Even in small commercial applications, you quickly reach the limitations of the [MING][ming-url] stack.<br>
This is where the UNStack comes in!

## Architecture
The numbering follows the automation pyramid: sort the folders and you get the hierarchy.

```
                /\                  GLOBAL:
               /  \                  05_grafana
              /    \                 09_adminer
             /      \                10_connect_global-to-postgres
            /        \               11_timescaledb
           /          \              19_nodered_global
          /            \             20_connect_factory1-to-global
         /______________\            30_redpanda_broker-global
        __________________
       /                  \         EDGE:
      /                    \         55_connect_kafka-to-cloud
     /                      \        60_redpanda_broker-edge
    /                        \       65_connect_mqtt-to-kafka
   /                          \      80_nodered_edge
  /                            \     90_mosquitto_broker-edge
 /                              \    91_telegraf_opcua-to-mqtt
/________________________________\   99_opcplc_opcua-simulator
```

## Under the hood
- Grafana (Dashboards) ([Github][grafana-url-github], [Docker Hub][grafana-url-dockerhub])
- TimescaleDB ([PostgreSQL][postgres-url] extension) ([Github][timescale-url-github], [Docker Hub][timescale-url-dockerhub])
- Redpanda Connect (ETL-Tool) ([Github][connect-url-github], [Docker Hub][connect-url-dockerhub])
- Redpanda (Kafka Broker) ([Github][redpanda-url-github], [Docker Hub][redpanda-url-dockerhub])
- Node-RED (Low-code logic) ([Github][nodered-url-github], [Docker Hub][nodered-url-dockerhub])
- Mosquitto (MQTT-Broker) ([Github][mosquitto-url-github], [Docker Hub][mosquitto-url-dockerhub])
- Adminer (Database management) ([Github][adminer-url-github], [Docker Hub][adminer-url-dockerhub])
- Telegraf (ETL-Tool) ([Github][telegraf-url-github], [Docker Hub][telegraf-url-dockerhub])
- Redis (topic-id cache for Connect) ([Github][redis-url-github], [Docker Hub][redis-url-dockerhub])
- OPCUA-Simulator ([Github][opcplc-url-github], [Docker Hub][opcplc-url-dockerhub])

## Core guidelines
- Keep-It-Simple
- Containers Only, Linux Only
- Open Architecture / Open Standards Only
- S..t happens - design for troubleshooting
- Don’t reinvent the wheel – integrate best-in-class tools instead of forking or building them

## Motivation
Industrial-IoT platforms often cost an arm and a leg, while providing a hard vendor lock-in and ridiculously low amounts of innovation. Small and medium sized businesses should not be locked out of digitalization, due to software costs. 

## Quickstart
> **Insecure by default.** Lab/dev stack, no authentication on most services. Read [INSECURITY.md](INSECURITY.md) before exposing it to any network.

- Prerequisites: Linux, Docker Engine + Compose v2 (or rootless Podman with the `docker` alias)
- Install:
```
cd /srv
git clone https://github.com/the-unstack/unstack.git
cd unstack

cp .env.example .env                # edit: passwords, STACK_DATA_DIR
./container_all_restart.sh
```
- Access (replace `hostip`):
  - Grafana: http://hostip:3000
  - Node-RED: http://hostip:1881 (global), http://hostip:1880 (edge)
  - Redpanda Console: http://hostip:8090 (global), http://hostip:8080 (edge)
  - Adminer: http://hostip:3010
  - all ports: see the table in [AGENTS.md](AGENTS.md#service-access-points)

## Roadmap
- [ ] v1: One-way, reporting-only (edge ➜ global)
- [ ] v2: Two-way, full unified-namespace (edge ⇄ global)

## License
Distributed under the Apache-2.0 license. See `LICENSE` for more information.

## Contact
Marc Lüerssen - [Email](mailto:unstack@marcluerssen.de), [LinkedIn][linkedin-url]<br>
Project link: [https://github.com/the-unstack/unstack](https://github.com/the-unstack/unstack)


<!-- MARKDOWN LINKS & IMAGES -->
[contributors-shield]: https://img.shields.io/github/contributors/the-unstack/unstack.svg?style=for-the-badge
[contributors-url]: https://github.com/the-unstack/unstack/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/the-unstack/unstack.svg?style=for-the-badge
[forks-url]: https://github.com/the-unstack/unstack/network/members
[stars-shield]: https://img.shields.io/github/stars/the-unstack/unstack.svg?style=for-the-badge
[stars-url]: https://github.com/the-unstack/unstack/stargazers
[issues-shield]: https://img.shields.io/github/issues/the-unstack/unstack.svg?style=for-the-badge
[issues-url]: https://github.com/the-unstack/unstack/issues
[license-shield]: https://img.shields.io/github/license/the-unstack/unstack.svg?style=for-the-badge
[license-url]: https://github.com/the-unstack/unstack/blob/main/LICENSE

[ming-url]: https://flowfuse.com/blog/2023/02/ming-blog/

[grafana-url-github]: https://github.com/grafana/grafana
[grafana-url-dockerhub]: https://hub.docker.com/r/grafana/grafana
[timescale-url-github]: https://github.com/timescale/timescaledb
[timescale-url-dockerhub]: https://hub.docker.com/r/timescale/timescaledb
[postgres-url]: https://www.postgresql.org
[adminer-url-github]:  https://github.com/vrana/adminer
[adminer-url-dockerhub]: https://hub.docker.com/_/adminer
[connect-url-github]: https://github.com/redpanda-data/connect
[connect-url-dockerhub]: https://hub.docker.com/r/redpandadata/connect
[redpanda-url-github]: https://github.com/redpanda-data/redpanda
[redpanda-url-dockerhub]: https://hub.docker.com/r/redpandadata/redpanda
[nodered-url-github]: https://github.com/node-red/node-red
[nodered-url-dockerhub]: https://hub.docker.com/r/nodered/node-red
[mosquitto-url-github]: https://github.com/eclipse-mosquitto/mosquitto
[mosquitto-url-dockerhub]: https://hub.docker.com/_/eclipse-mosquitto
[telegraf-url-github]: https://github.com/influxdata/telegraf
[telegraf-url-dockerhub]: https://hub.docker.com/_/telegraf
[redis-url-github]: https://github.com/redis/redis
[redis-url-dockerhub]: https://hub.docker.com/_/redis
[opcplc-url-github]: https://github.com/Azure-Samples/iot-edge-opc-plc
[opcplc-url-dockerhub]: https://hub.docker.com/r/microsoft/iotedge-opc-plc

[linkedin-url]: https://linkedin.com/in/marcluer
