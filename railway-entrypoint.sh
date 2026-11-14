#!/bin/sh
# Railway wrapper entrypoint for pgAdmin. Starts as root; the upstream entrypoint chowns
# /var/lib/pgadmin and runs everything else as uid 5050 through su-exec.
set -eu

if [ -z "${PGADMIN_DEFAULT_PASSWORD:-}" ]; then
  echo "railway-entrypoint: PGADMIN_DEFAULT_PASSWORD is empty; refusing to start with no administrator password" >&2
  exit 1
fi

# A public service must honour the PORT Railway injects: its healthcheck dials it.
export PGADMIN_LISTEN_PORT="${PORT:-8080}"

echo "railway-entrypoint: volume owner=$(stat -c %u:%g /var/lib/pgadmin) listen=${PGADMIN_LISTEN_PORT}"

exec /entrypoint.sh "$@"
