# ROXOI Reimagined SDDM

A personalized reworking of the ROXOI SDDM login theme, focused on a cleaner, more minimal login experience.

## Changes

- Enlarged clock for better visibility.
- Removed the logo and greeting text.
- Removed the animated vertical crack effect.
- Retained the theme's core SDDM login functionality.
- Background presentation: Retains the theme's bundled background assets while refining the overall login-screen layout.

## Screenshots

Add screenshots of the customized login screen here.

## Installation

1. Install SDDM and its required Qt/QML dependencies.
2. Copy this theme directory into your SDDM themes directory.
3. Select `roxoi-sddm-dev` as the current SDDM theme in your SDDM configuration.
4. Restart SDDM or reboot to apply the theme.

**Warning:** Restarting SDDM ends the current graphical session. Save your work before applying changes.

## License and acknowledgments

This project modifies the existing ROXOI SDDM theme. Refer to the included `LICENSE` file for the original MIT license and applicable copyright notice.

Further changes and their licensing should be documented as the project evolves.

---## Installation

### 1. Download the theme

Open a terminal and run:

```bash
git clone https://github.com/smaaqib/roxoi-reimagined-sddm.git
```

### 2. Install the theme

```bash
cd roxoi-reimagined-sddm
sudo mkdir -p /usr/share/sddm/themes/roxoi-reimagined-sddm
sudo cp -a . /usr/share/sddm/themes/roxoi-reimagined-sddm/
```

### 3. Enable the theme

Back up your SDDM configuration before changing it. Then configure SDDM to use:

```ini
[Theme]
Current=roxoi-reimagined-sddm
```

The configuration file is commonly `/etc/sddm.conf` or a file under `/etc/sddm.conf.d/`. Make sure you don't create conflicting theme settings.

### 4. Restart

Save your work and reboot to apply the new login theme.

**Important:** SDDM themes can depend on specific Qt/QML modules. If the theme fails to load, switch back to your previous working theme using a recovery terminal or another administrative session.
