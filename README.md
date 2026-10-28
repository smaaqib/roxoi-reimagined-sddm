# ROXOI Reimagined SDDM

A personalized reworking of the ROXOI SDDM login theme: a looping video background, a big red clock, and a rotating quote bar, with the standard SDDM login functionality kept intact.

## Changes from ROXOI

- Enlarged clock for better visibility.
- Removed the logo and greeting text.
- Removed the animated vertical crack effect.
- Static-image fallback under the video, so a video failure never leaves a blank screen.
- New `theme.conf` options: `UseVideo`, `ShowQuotes`, `CustomQuotes`.
- `install.sh` and `test.sh` helper scripts.

## Screenshots

_Coming soon: add `preview.png` to the repo root and embed it here with `![preview](preview.png)`._

## Requirements

**Qt5 only for now.** This theme uses Qt5 QML modules, so it needs a Qt5 build of SDDM (0.20 or older). On SDDM 0.21 and newer, which ships a Qt6 greeter, the theme fails to load with `module "QtGraphicalEffects" is not installed` and SDDM falls back to its default theme. Qt6 support is not available yet.

You need SDDM (Qt5 greeter) plus these Qt5 modules:

| Debian / Ubuntu / Kali | Arch |
| --- | --- |
| `qml-module-qtquick-controls2`, `qml-module-qtquick-layouts`, `qml-module-qtgraphicaleffects`, `qml-module-qtmultimedia`, `qml-module-qtquick-virtualkeyboard` | `qt5-quickcontrols2`, `qt5-graphicaleffects`, `qt5-multimedia`, `qt5-svg` |

The video also needs a working GStreamer H.264 decoder (`gstreamer1.0-libav` on Debian-based systems, `gst-libav` on Arch). Without it, set `UseVideo="false"` (see below) and the theme shows the static background instead.

## Installation

### Quick way

```bash
git clone https://github.com/smaaqib/roxoi-reimagined-sddm.git
cd roxoi-reimagined-sddm
./install.sh
```

The script copies the theme to `/usr/share/sddm/themes/roxoi-reimagined-sddm`, writes `/etc/sddm.conf.d/10-roxoi-reimagined-sddm.conf` (backing up any earlier copy), and warns if another config file also sets a theme.

### Manual way

```bash
sudo mkdir -p /usr/share/sddm/themes/roxoi-reimagined-sddm
sudo cp -a . /usr/share/sddm/themes/roxoi-reimagined-sddm/
```

Then set the theme in `/etc/sddm.conf` or a file under `/etc/sddm.conf.d/`:

```ini
[Theme]
Current=roxoi-reimagined-sddm
```

SDDM selects themes by **folder name**, so `Current=` must match the directory you copied to. Make sure no other file sets a conflicting `Current=`.

### Preview without logging out

```bash
./test.sh
```

This runs `sddm-greeter --test-mode` in a window.

### Apply

Save your work, then reboot. Restarting SDDM ends the current graphical session.

**If the theme fails to load**, switch to a TTY (`Ctrl+Alt+F3`), delete `/etc/sddm.conf.d/10-roxoi-reimagined-sddm.conf`, and restart SDDM to return to your previous theme.

## Configuration

Edit `theme.conf` (or put overrides in `theme.conf.user`):

| Option | Default | What it does |
| --- | --- | --- |
| `UseVideo` | `"true"` | `"false"` shows only the static `Background` image. Lighter, and the fix if the video does not play. |
| `ShowQuotes` | `"true"` | `"false"` hides the bottom quote bar. |
| `CustomQuotes` | `""` | Your own quotes separated by `\|`, e.g. `"Stay curious\|Ship it"`. Empty uses the built-in list. |
| `Font` | `"Noto Sans"` | Must be installed on the system (`fc-list \| grep -i <name>`), otherwise Qt silently falls back. |
| `DimBackgroundImage` | `"0.0"` | Darkening overlay (0 to 1) above the background and video. |
| `Locale`, `HourFormat`, `DateFormat` | | Clock and date format. |

The screen size is detected automatically; `ScreenWidth`/`ScreenHeight` are no longer used.

## License and acknowledgments

This project modifies the ROXOI SDDM theme by Rajendra Pancholi (see `AUTHORS`), released under the MIT license. See `LICENSE` for the original copyright notice, which must be kept in copies and derivatives.
