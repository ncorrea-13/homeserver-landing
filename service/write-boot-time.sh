#!/bin/sh
set -e
: "${DOC_ROOT:?DOC_ROOT no definido (revisar EnvironmentFile en el .service o el .env sourceado)}"

BOOT_EPOCH=$(date -d "$(uptime -s)" +%s)
printf '{"boot_epoch": %s}\n' "$BOOT_EPOCH" > "$DOC_ROOT/boot.json"
