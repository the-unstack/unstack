#!/bin/bash
# installs cron_unstack to /etc/cron.d with the repo path substituted. Run as root.
# shellcheck source=scripts/_lib.sh
source "$(dirname "$(readlink -f "$0")")/_lib.sh"
[ "$EUID" -eq 0 ] || { echo "run as root" >&2; exit 1; }
sed "s|/srv/unstack|$ROOT_DIR|" "$ROOT_DIR/scripts/cron_unstack" > /etc/cron.d/unstack
chown root:root /etc/cron.d/unstack
chmod 644 /etc/cron.d/unstack
echo "installed /etc/cron.d/unstack ($ROOT_DIR)"
