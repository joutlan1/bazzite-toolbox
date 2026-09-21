# TRCC on Bazzite: Thermalright LCD Linux Installer & Autostart Fix

A simple installer and uninstaller for **TRCC / trcc-linux on Bazzite**, designed to fix one of the most annoying failure modes for Thermalright LCD coolers on Linux: Python, Qt, and PySide dependency conflicts.

If you searched for things like:

- **TRCC Bazzite fix**
- **Thermalright LCD Linux**
- **TRCC won't launch on Bazzite**
- **TRCC PySide6 Qt version mismatch**
- **TRCC Python version error**
- **TRCC autostart GNOME**
- **Thermalright Peerless Assassin Vision Linux**
- **TRCC AIO LCD Bazzite**

...this is the problem these scripts are intended to solve.

## The problem

TRCC can work perfectly on Linux and still fail on a distro such as Bazzite because the system Python environment may contain Qt or PySide versions that do not match what TRCC expects.

Typical symptoms include:

- TRCC refusing to launch
- PySide6 / Qt version mismatch errors
- TRCC working from one Python environment but not another
- A Thermalright LCD remaining blank even though the USB device is present
- TRCC starting manually but failing during login
- A systemd user service launching TRCC too early and losing the USB device during startup

Rather than changing Bazzite's system Python packages, this installer gives TRCC its own isolated environment.

## What this fix does

The installer creates:

```
~/.venvs/trcc
```

TRCC and its Python dependencies live inside that virtual environment, isolated from the host operating system.

It also creates a delayed GNOME/XDG autostart launcher. TRCC waits 8 seconds after login before connecting to the Thermalright LCD controller, giving GNOME and the USB stack time to finish initializing.

That means:

**Bazzite system Python stays untouched. TRCC gets the versions it needs. The LCD gets a cleaner startup path.**

## Install TRCC on Bazzite

From the `trcc` directory:

```bash
chmod +x install-trcc.sh
./install-trcc.sh
```

**Do not run the installer with `sudo`.**

The installer:

- Checks for Python 3
- Creates `~/.venvs/trcc`
- Installs or updates `trcc-linux`
- Creates `~/.local/bin/trcc-start.sh`
- Creates `~/.config/autostart/trcc.desktop`
- Waits 8 seconds after login before starting TRCC
- Runs TRCC with `gui --resume`
- Does not modify Bazzite's system Python packages

### Test it immediately

```bash
~/.venvs/trcc/bin/trcc gui --resume
```

If the LCD comes alive, log out/in or reboot and verify that TRCC starts automatically.

## Why not systemd?

A user-level systemd service can start TRCC very early in the login process. On some systems that creates a race with USB initialization and the Thermalright controller may not be ready yet.

The delayed GNOME autostart path proved more reliable in testing:

```
GNOME login
    ↓
~/.config/autostart/trcc.desktop
    ↓
~/.local/bin/trcc-start.sh
    ↓
8 second delay
    ↓
~/.venvs/trcc/bin/trcc gui --resume
    ↓
Thermalright LCD
```

## Uninstall TRCC cleanly

```bash
chmod +x uninstall-trcc.sh
./uninstall-trcc.sh
```

**Do not run the uninstaller with `sudo`.**

The uninstaller removes:

- The isolated TRCC virtual environment
- The delayed startup launcher
- The GNOME/XDG autostart entry
- An old user-level `trcc.service`, if one exists

It deliberately does **not** remove or alter system Python, Qt, PySide, or Bazzite packages.

## Tested

- **Bazzite GNOME:** isolated TRCC install and delayed autostart approach
- **CachyOS:** cleanup/uninstall path

Originally developed while getting a Thermalright LCD cooler working reliably on a real Bazzite gaming PC, then turned into reusable scripts so the next person does not have to rediscover the same Python/Qt rabbit hole.

## Compatibility

These are community helper scripts, not official Thermalright or TRCC tooling. Other GNOME-based Linux distributions may work as well, but hardware and desktop configurations vary.
