#!/usr/bin/env bash
set -Eeuo pipefail

project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
marker="$project_dir/app/.maintenance"

if [[ -f "$marker" ]]; then
    rm "$marker"
    echo 'Local maintenance mode disabled.'
else
    echo 'Local maintenance mode was already disabled.'
fi

