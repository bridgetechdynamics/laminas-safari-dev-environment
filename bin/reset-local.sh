#!/usr/bin/env bash
set -Eeuo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/lib/compose.sh"
require_env

project_name="${COMPOSE_PROJECT_NAME:-laminas-safari-dev}"
echo "This will delete only the local database and application volumes for Compose project '$project_name'."
echo 'It cannot be undone.'
if [[ "${1:-}" != --yes ]]; then
    read -r -p "Type RESET to continue: " confirmation
    [[ "$confirmation" == RESET ]] || { echo 'Reset cancelled.'; exit 1; }
fi

compose_run down -v --remove-orphans
rm -f "$project_dir/.db-restored" 2>/dev/null || true
echo 'Local environment reset. Run bin/start.sh, then bin/restore-database.sh when appropriate.'

