# ROXOI Reimagined SDDM

A personalized reworking of the ROXOI SDDM login theme: a looping video background, a big red clock, and a rotating quote bar, with the standard SDDM login functionality kept intact.

## Changes from ROXOI

- Enlarged clock for better visibility.
- Removed the logo and greeting text.
- Removed the animated vertical crack effect.
- Qt6 support (the default), with the Qt5 version kept in `qt5/`.
- Static-image fallback under the video, so a video failure never leaves a blank screen.
- New `theme.conf` options: `UseVideo`, `ShowQuotes`, `CustomQuotes`.
- `install.sh` and `test.sh` helper scripts.

## Screenshots

_Coming soon: add `preview.png` to the repo root and embed it here with `![preview](preview.png)`._

## Requirements

SDDM 0.21 and newer use Qt6. SDDM 0.20 and older (for example Ubuntu 24.04) use Qt5. This repo supports both:

* **Qt6** (default): the QML files in the repo root.
* **Qt5**: the same theme in `qt5/`. `install.sh` and `test.sh` pick the right one for the installed greeter, or you can force it with `THEME_QT=5` or `THEME_QT=6`.

Qt6 SDDM needs these QML modules:

| Debian / Ubuntu / Kali | Arch |
| --- | --- |
| `qml6-module-qtquick-controls`, `qml6-module-qtquick-layouts`, `qml6-module-qt5compat-graphicaleffects`, `qml6-module-qtmultimedia`, `qml6-module-qtquick-virtualkeyboard` | `qt6-5compat`, `qt6-multimedia`, `qt6-svg`, `qt6-virtualkeyboard` |

Qt5 SDDM needs these instead:

| Debian / Ubuntu | Arch |
| --- | --- |
| `qml-module-qtquick-controls2`, `qml-module-qtquick-layouts`, `qml-module-qtgraphicaleffects`, `qml-module-qtmultimedia`, `qml-module-qtquick-virtualkeyboard` | `qt5-quickcontrols2`, `qt5-graphicaleffects`, `qt5-multimedia`, `qt5-svg` |

On Qt5 the video also needs a GStreamer H.264 decoder (`gstreamer1.0-libav` on Debian based systems, `gst-libav` on Arch). Qt6 bundles its own FFmpeg backend. If the video does not play, set `UseVideo="false"` (see below) and the theme shows the static background instead.

## Installation

### Quick way

```bash
git clone https://github.com/smaaqib/roxoi-reimagined-sddm.git
cd roxoi-reimagined-sddm
./install.sh
```

The script copies the theme to `/usr/share/sddm/themes/roxoi-reimagined-sddm`, writes `/etc/sddm.conf.d/10-roxoi-reimagined-sddm.conf` (backing up any earlier copy), and warns if another config file also sets a theme.

It also sets `InputMethod=` to empty. SDDM 0.21 enables Qt's on screen keyboard by default, and it draws over the login form on laptops and desktops. On a touchscreen, keep it with `sudo KEEP_OSK=1 ./install.sh`.

### Manual way

```bash
sudo mkdir -p /usr/share/sddm/themes/roxoi-reimagined-sddm
sudo cp -a . /usr/share/sddm/themes/roxoi-reimagined-sddm/
# Qt5 SDDM only: overlay the Qt5 files
sudo cp -a qt5/. /usr/share/sddm/themes/roxoi-reimagined-sddm/
```

Then set the theme in `/etc/sddm.conf` or a file under `/etc/sddm.conf.d/`:

```ini
[General]
InputMethod=

[Theme]
Current=roxoi-reimagined-sddm
```

`InputMethod=` (empty) turns off the on screen keyboard that SDDM 0.21 enables by default. Leave that part out if you want it.

SDDM selects themes by **folder name**, so `Current=` must match the directory you copied to. Make sure no other file sets a conflicting `Current=`.

### Preview without logging out

```bash
./test.sh
```

This runs the SDDM greeter in test mode in a window. If the on screen keyboard shows up in the preview, that is the SDDM default described above.

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
