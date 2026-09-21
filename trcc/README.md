# TRCC Linux Helper

Helper scripts for running TRCC on Bazzite and similar Linux systems without relying on the host Python environment.

## Why

Some Linux distributions ship Python, Qt, and PySide versions that do not line up cleanly with TRCC. The installer creates a dedicated virtual environment at:

```
~/.venvs/trcc
```

TRCC and its Python dependencies stay isolated there.

## Install

```bash
chmod +x install-trcc.sh
./install-trcc.sh
```

**Do not run the installer with `sudo`.**

The installer:

- Creates `~/.venvs/trcc`
- Installs or updates `trcc-linux`
- Creates `~/.local/bin/trcc-start.sh`
- Creates `~/.config/autostart/trcc.desktop`
- Waits 8 seconds after login before starting TRCC so the desktop session and USB device have time to initialize
- Does not modify system Python packages

Manual test:

```bash
~/.venvs/trcc/bin/trcc gui --resume
```

Then log out/in or reboot to verify autostart.

## Uninstall

```bash
chmod +x uninstall-trcc.sh
./uninstall-trcc.sh
```

**Do not run the uninstaller with `sudo`.**

The uninstaller removes:

- The TRCC virtual environment
- The delayed launcher
- The GNOME/XDG autostart entry
- An old user-level `trcc.service`, if one exists

It does not remove or change system Python packages.

## Tested

- Bazzite GNOME: isolated TRCC install and autostart approach
- CachyOS: cleanup/uninstall path

These are community helper scripts, not official Thermalright or TRCC tooling.
