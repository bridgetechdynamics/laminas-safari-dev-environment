#!/usr/bin/env bash
set -Eeuo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(cd -- "$script_dir/.." && pwd)"
source "$script_dir/lib/compose.sh"
require_env

dump="$project_dir/input/horsesns_safari-dev.sql.gz"
[[ -f "$dump" ]] || { echo "Missing database payload: $dump" >&2; exit 1; }

compose_run up -d db
wait_for_service db

echo "Restoring private local database payload into Compose project '${COMPOSE_PROJECT_NAME:-laminas-safari-dev}'."
gzip -dc "$dump" | compose_run exec -e MYSQL_PWD="${DB_ROOT_PASSWORD:-}" -T db mariadb -uroot
touch "$project_dir/.db-restored"
echo 'Database restore completed.'

