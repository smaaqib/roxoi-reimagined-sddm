#!/usr/bin/env bash
# Preview the theme in a window without logging out.
# Picks the Qt6 files (repo root) or the Qt5 files (qt5/) to match the greeter
# that is installed. Force one with: THEME_QT=5 ./test.sh   or   THEME_QT=6 ./test.sh
set -euo pipefail
cd "$(dirname "$0")"

qt="${THEME_QT:-}"
if [ -z "$qt" ]; then
    if command -v sddm-greeter-qt6 >/dev/null 2>&1; then qt=6
    elif command -v sddm-greeter >/dev/null 2>&1; then qt=5
    else
        echo "No SDDM greeter found. Install SDDM first (for example: sudo apt install sddm)." >&2
        exit 1
    fi
fi

if [ "$qt" = "6" ]; then
    greeter=$(command -v sddm-greeter-qt6) || { echo "sddm-greeter-qt6 not found." >&2; exit 1; }
    theme=$PWD
else
    greeter=$(command -v sddm-greeter) || { echo "sddm-greeter (Qt5) not found." >&2; exit 1; }
    theme=$(mktemp -d)
    trap 'rm -rf "$theme"' EXIT
    cp -a . "$theme"/
    cp -a qt5/. "$theme"/
fi

echo "Using $greeter with the Qt$qt files"
echo "Note: SDDM 0.21 and newer can show its own on screen keyboard in this preview."
echo "install.sh turns that off; see the README."
"$greeter" --test-mode --theme "$theme"
