#!/usr/bin/env bash
set -Eeuo pipefail

project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
marker="$project_dir/app/.maintenance"

[[ -d "$project_dir/app" ]] || {
    echo "Missing application source directory: $project_dir/app" >&2
    echo 'Run bin/start.sh first.' >&2
    exit 1
}

touch "$marker"
echo "Local maintenance mode enabled: $marker"

