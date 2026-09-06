# !scripts

Shared scripts. The root-level `container_*.sh` and each service's `container_{restart,down,logs,pull}.sh` are symlinks into this dir.
`container_all_*` and `initialize.sh` resolve the repo root via `readlink -f`, so they work from here or via the symlinks.

## Stack-wide

| Script | Does | Destructive |
|--------|------|-------------|
| `initialize.sh` | Creates `${STACK_DATA_DIR}` dirs with container uids + external docker networks. Idempotent, needs `sudo` (or `podman unshare`). Run automatically by the `*_restart.sh` scripts. | no |
| `_for_each_service.sh` | shared loop: `[-r] [-f RE\|-x RE] <compose args>` in every `NN_*` dir that has `.autostart` (`-r` descending, `-f`/`-x` include/skip by regex). Used by the `container_all_*` wrappers. | depends on args |
| `container_all_restart.sh` | `initialize.sh`, `down` descending (99→05), then `up -d` in two passes: infra first (`timescaledb`, `_broker-`, `mosquitto`), then the rest ascending | restarts |
| `container_all_pull+restart.sh` | same, with `compose pull` first. Cron target. | restarts |
| `container_all_pull.sh` | `compose pull` in every autostart dir | no |
| `container_all_down.sh` | `compose down` in every autostart dir, descending | stops stack |
| `container_ps.sh` | `docker ps` with wrapped port column | no |
| `container_stats.sh` | live `docker stats` table, `[-r] [1|2|3]` sort column | no |
| `container_list_external_networks.sh` / `_wide.sh` | which external networks each compose file uses (uses `yq` if installed) | no |
| `docker_system_prune.sh` | `docker system prune -a -f --volumes` — removes **all** unused images, networks and volumes without asking | **yes** |

## Per service (symlinked into each `NN_*` dir)

| Script | Does |
|--------|------|
| `container_restart.sh` | `compose down && up -d` |
| `container_down.sh` | `compose down` |
| `container_logs.sh` | `compose logs -f` |
| `container_pull.sh` | `compose pull` |

## Cron

| File | Does |
|------|------|
| `cron_unstack` | `01:30` daily, root: `/srv/unstack/container_all_pull+restart.sh` (edit path if repo is elsewhere) |
| `cron_install.sh` | copies `cron_unstack` to `/etc/cron.d/unstack`. Run as root. |
