# INSECURITY

**This project is configured to be insecure by default.**
It is a development / lab stack. Do not expose it to an untrusted network without hardening.

The following points are the most obvious insecurities:

| # | Component | Insecurity | Minimum fix |
|---|-----------|------------|-------------|
| 1 | Node-RED (`19_`, `80_`) | Editor on `0.0.0.0:1880/1881`, **no login** → remote code execution; global instance reaches Postgres + Kafka | Bind `127.0.0.1`, add `adminAuth` in `settings.js`, set credential secret |
| 2 | Mosquitto (`90_`) | `allow_anonymous true` on `0.0.0.0:1883` | `password_file` + `acl_file`, bind loopback |
| 3 | Redpanda global (`30_`) | Kafka `0.0.0.0:29092`, no SASL/TLS, `--mode dev-container` on both brokers | Bind loopback, drop dev-container mode, SASL/SCRAM |
| 4 | Redpanda Console (`30_`, `60_`) | UI on `0.0.0.0:8090` (global) / `0.0.0.0:8080` (edge), no authentication | Bind loopback / reverse proxy, enable console login |
| 5 | Adminer (`09_`) | DB admin UI on `0.0.0.0:3010` | Bind `127.0.0.1` |
| 6 | OPC PLC simulator (`99_`) | Autostarts, `0.0.0.0:4840`, `--autoaccept` | Remove `.autostart`, private network |
| 7 | Telegraf OPC UA (`91_`) | `Sign` mode with empty cert/key, anonymous auth | Persist cert/key, user auth |
