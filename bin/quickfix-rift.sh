#!/usr/bin/env bash
set -euo pipefail

current_dir_name="$(basename "$PWD")"
if [[ "$current_dir_name" != "backend" ]]; then
  echo "Not in backend folder, quiting"
  exit 1
fi

rm -rf dist 
yarn nx reset
yarn nx clear-cache

echo "Done!"
