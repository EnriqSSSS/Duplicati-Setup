#!/bin/bash
exec /root/duplicati-scripts/after_backup_global.sh

cd /root/duplicati-scripts/<example>_scripts || exit 1
for script in ./after/*.sh; do
    [ -x "$script" ] || continue
    exec "$script"
done