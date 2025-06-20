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
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">the UNStack</h3>

  <p align="center">
    modular, open-architecture, Industrial-IoT data stack
    <br />
    <br />
    <a href="#quickstart"><strong>Quickstart</strong></a>
    &middot;
    <a href="https://github.com/the-unstack/unstack-docs"><strong>Explore the docs</strong></a>
    <br />
    <a href="https://github.com/the-unstack/unstack/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    &middot;
    <a href="https://github.com/the-unstack/unstack/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>

## About The Project
The UNStack is a modular, open-architecture, Industrial-IoT data stack.<br>
It delivers your data from your edge devices to your central dashboards and beyond.<br>
Even in small commercial applications, you quickly reach the limitations of the [MING][ming-url] stack.<br>
This is where the UNStack comes in!

## Under the hood
- Grafana (Dashboards) ([Github][grafana-url-github], [Docker Hub][grafana-url-dockerhub])
- TimescaleDB ([PostgreSQL][postgres-url] extension) ([Github][timescale-url-github], [Docker Hub][timescale-url-dockerhub])
- Redpanda Connect (ETL-Tool) ([Github][connect-url-github], [Docker Hub][connect-url-dockerhub])
- Redpanda (Kafka Broker) ([Github][redpanda-url-github], [Docker Hub][redpanda-url-dockerhub])
- Node-RED (Low-code logic) ([Github][nodered-url-github], [Docker Hub][nodered-url-dockerhub])
- Mosquitto (MQTT-Broker) ([Github][mosquitto-url-github], [Docker Hub][mosquitto-url-dockerhub])
- Adminer (Database management) ([Github][adminer-url-github], [Docker Hub][adminer-url-dockerhub])
- Telegraf (ETL-Tool) ([Github][telegraf-url-github], [Docker Hub][telegraf-url-dockerhub])
- OPCUA-Simulator ([Github][opcsim-url-github], [Docker Hub][opcsim-url-dockerhub])

## Core guidelines
- Keep-It-Simple
- Containers Only, Linux Only
- Open Architecture / Open Standards Only
- S..t happens - design for troubleshooting
- Don’t reinvent the wheel – integrate best-in-class tools instead of forking or building them

## Motivation
Industrial-IoT platforms often cost an arm and a leg, while providing a hard vendor lock-in and ridiculously low amounts of innovation. Small and medium sized businesses should not be locked out of digitalization, due to software costs. 

## Quickstart

## Roadmap
- [ ] v1: One-way, reporting-only (edge ➜ data-center)
- [ ] v2: Two-way, full unified-namespace (edge ⇄ data-center)

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
[license-url]: https://github.com/the-unstack/unstack/blob/master/LICENSE

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
[opcsim-url-github]: https://github.com/amine-amaach/simulators
[opcsim-url-dockerhub]: https://hub.docker.com/r/amineamaach/sensors-opcua

[linkedin-url]: https://linkedin.com/in/marcluer
