# !scripts

Shared scripts. The root-level `container_*.sh` and each service's `container_{restart,down,logs,pull}.sh` are symlinks into this dir.
Every script starts with `source _lib.sh`, so they work from here, via the symlinks, or from cron.

## Shared

| File | Does |
|------|------|
| `_lib.sh` | sourced preamble, never run: `set -euo pipefail`, `ROOT_DIR` (repo root), `SCRIPT_DIR` (dir of the invoked script, symlink not resolved = service dir), `load_env` (sources `.env` or exit 1) |
| `_for_each_service.sh` | shared loop: `[-r] [-f RE\|-x RE] <compose args>` in every `NN_*` dir that has `.autostart` (`-r` descending, `-f`/`-x` include/skip by regex). Keeps going on failure, exit 1 if any service failed. |

## Stack-wide

| Script | Does | Destructive |
|--------|------|-------------|
| `initialize.sh` | Creates `${STACK_DATA_DIR}` dirs with container uids + external docker networks. Idempotent, needs `sudo` (or `podman unshare`). Run automatically by the `*_restart.sh` scripts. | no |
| `container_all_restart.sh` | `initialize.sh`, `down` descending (99→05), then `up -d` in two passes: infra first (`timescaledb`, `_broker-`, `mosquitto`), then the rest ascending. Exit 1 if any service failed. | restarts |
| `container_all_pull+restart.sh` | same, with `compose pull` first. Cron target. Exit 1 if any service failed. | restarts |
| `container_all_pull.sh` | `compose pull` in every autostart dir. Exit 1 if any failed. | no |
| `container_all_down.sh` | `compose down` in every autostart dir, descending. Exit 1 if any failed. | stops stack |
| `container_ps.sh` | `docker ps` with wrapped port column | no |
| `container_list_external_networks.sh` / `_wide.sh` | which external networks each compose file uses (uses `yq` if installed) | no |
| `container_system_prune.sh` | `docker system prune -a -f --volumes` — removes **all** unused images, networks and volumes without asking | **yes** |

## Per service (symlinked into each `NN_*` dir)

| Script | Does |
|--------|------|
| `container_restart.sh` | `compose down && up -d` |
| `container_down.sh` | `compose down` |
| `container_logs.sh` | `compose logs -f` |
| `container_pull.sh` | `compose pull` |

Service-specific `container_exec_*.sh` scripts live in their service dir and source `../!scripts/_lib.sh`.

## Cron

| File | Does |
|------|------|
| `cron_unstack` | `01:30` daily, root: `container_all_pull+restart.sh 2>&1 \| logger -t unstack` → `journalctl -t unstack` |
| `cron_install.sh` | writes `cron_unstack` to `/etc/cron.d/unstack` with `/srv/unstack` replaced by the real repo path, `root:root`, `chmod 644`. Run as root. |

## Notes

**Container logs** are `json-file` (podman: `k8s-file`), 10 MB per container (Docker keeps 3 rotated files, podman truncates at the limit).
They are no longer in `journalctl`; use `./container_logs.sh` / `docker logs`.

**Memory limits** (`deploy.resources.limits.memory`) sum to ≈ 4.7 GB global, ≈ 3.7 GB edge. Sized for 8 GB boxes.

**TimescaleDB re-init** (PGDATA moved to `timescaledb/postgres/pgdata`, chunk interval 1 day; init scripts only run on an empty data dir):
```bash
cd 11_timescaledb && ./container_down.sh
podman unshare rm -rf "$STACK_DATA_DIR/timescaledb/postgres"   # whole dir (a /* glob can't expand: sub-uid 70 owns it); plain sudo rm on Docker
docker exec connect-global-to-postgres-redis redis-cli FLUSHALL   # cached topic ids now invalid
../container_all_restart.sh                                       # initialize.sh recreates the dir
```
