#!/usr/bin/env bash
# Install ROXOI Reimagined as the active SDDM theme. Run from the repo: ./install.sh
set -euo pipefail

THEME=roxoi-reimagined-sddm
DEST=/usr/share/sddm/themes/$THEME
CONF_DIR=/etc/sddm.conf.d
CONF=$CONF_DIR/10-$THEME.conf
SRC=$(cd "$(dirname "$0")" && pwd)

if [ "$(id -u)" -ne 0 ]; then
    echo "Needs root, re-running with sudo..."
    exec sudo THEME_QT="${THEME_QT:-}" KEEP_OSK="${KEEP_OSK:-0}" "$0" "$@"
fi

# Qt6 files live in the repo root, Qt5 files in qt5/. Pick by installed greeter,
# or force one with THEME_QT=5 or THEME_QT=6.
qt="${THEME_QT:-}"
if [ -z "$qt" ]; then
    if command -v sddm-greeter-qt6 >/dev/null 2>&1; then qt=6
    elif command -v sddm-greeter >/dev/null 2>&1; then qt=5
    else
        echo "No SDDM greeter found. Install SDDM first." >&2
        exit 1
    fi
fi

echo "Copying theme to $DEST (Qt$qt files)"
mkdir -p "$DEST"
cp -a "$SRC"/. "$DEST"/
rm -rf "$DEST/.git"
if [ "$qt" = "5" ]; then
    cp -a "$SRC"/qt5/. "$DEST"/
fi

mkdir -p "$CONF_DIR"
if [ -f "$CONF" ]; then
    cp -a "$CONF" "$CONF.bak.$(date +%s)"
fi
# SDDM 0.21 and newer turns on Qt's on screen keyboard by default, and it draws
# over the login form. Switch it off unless KEEP_OSK=1 is set (touchscreens).
if [ "${KEEP_OSK:-0}" = "1" ]; then
    printf '[Theme]\nCurrent=%s\n' "$THEME" > "$CONF"
else
    printf '[General]\nInputMethod=\n\n[Theme]\nCurrent=%s\n' "$THEME" > "$CONF"
fi
echo "Wrote $CONF"

# Warn about other files that set a theme and could override ours.
others=$(grep -ls '^Current=' /etc/sddm.conf "$CONF_DIR"/*.conf 2>/dev/null | grep -v "^$CONF$" || true)
if [ -n "$others" ]; then
    echo "WARNING: these files also set Current= and may conflict:"
    echo "$others"
fi

echo "Done. Preview with ./test.sh, or reboot to apply."
echo "On screen keyboard is off by default. For a touchscreen run: sudo KEEP_OSK=1 ./install.sh"
echo "To undo: sudo rm $CONF and select your old theme."
