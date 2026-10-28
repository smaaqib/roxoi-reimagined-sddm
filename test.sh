#!/usr/bin/env bash
# Preview the theme in a window without logging out.
set -euo pipefail
cd "$(dirname "$0")"
if ! command -v sddm-greeter >/dev/null 2>&1 && ! command -v sddm-greeter-qt6 >/dev/null 2>&1; then
    echo "sddm-greeter not found. Install SDDM first (e.g. sudo apt install sddm)." >&2
    exit 1
fi
greeter=$(command -v sddm-greeter || command -v sddm-greeter-qt6)
exec "$greeter" --test-mode --theme "$PWD"
