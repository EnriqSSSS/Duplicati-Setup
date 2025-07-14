#!/bin/bash
exec /root/duplicati-scripts/before_backup_global.sh

cd /root/duplicati-scripts/NXTC-<cliente>-db_scripts || exit 1
for script in ./before/*.sh; do
    [ -x "$script" ] || continue
    exec "$script"
done