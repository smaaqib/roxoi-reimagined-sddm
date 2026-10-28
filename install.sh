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
    exec sudo "$0" "$@"
fi

echo "Copying theme to $DEST"
mkdir -p "$DEST"
cp -a "$SRC"/. "$DEST"/
rm -rf "$DEST/.git"

mkdir -p "$CONF_DIR"
if [ -f "$CONF" ]; then
    cp -a "$CONF" "$CONF.bak.$(date +%s)"
fi
printf '[Theme]\nCurrent=%s\n' "$THEME" > "$CONF"
echo "Wrote $CONF"

# Warn about other files that set a theme and could override ours.
others=$(grep -ls '^Current=' /etc/sddm.conf "$CONF_DIR"/*.conf 2>/dev/null | grep -v "^$CONF$" || true)
if [ -n "$others" ]; then
    echo "WARNING: these files also set Current= and may conflict:"
    echo "$others"
fi

echo "Done. Preview with ./test.sh, or reboot to apply."
echo "To undo: sudo rm $CONF and select your old theme."
