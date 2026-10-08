#!/usr/bin/env bash
set -Eeuo pipefail

project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$project_dir/runtime"
if [[ ! -f "$project_dir/runtime/local.php" ]]; then
    cp "$project_dir/runtime/local.php.template" "$project_dir/runtime/local.php"
fi
chmod 600 "$project_dir/runtime/local.php"

