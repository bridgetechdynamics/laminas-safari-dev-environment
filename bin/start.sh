#!/usr/bin/env bash
set -Eeuo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(cd -- "$script_dir/.." && pwd)"
source "$script_dir/lib/compose.sh"
require_env
"$script_dir/prepare-runtime.sh"

if [[ ! -f "$project_dir/app/composer.json" ]]; then
    "$script_dir/extract-source.sh"
fi

compose_run up -d --build db app
wait_for_service db
wait_for_service app

echo 'Laminas Safari local stack is running.'
echo "Open http://localhost:${APP_HTTP_PORT:-8080}/"
compose_run ps

