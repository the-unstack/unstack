#!/bin/bash

DIR=$(dirname "$0")

cp $DIR/cron_unstack /etc/cron.d/unstack
chown root:root /etc/cron.d/unstack