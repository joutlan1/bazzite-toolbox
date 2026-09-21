# Bazzite Toolbox

Practical Linux fixes for the weird little problems that show up after the install finishes.

This repo collects small, tested helpers for Bazzite and GNOME systems, especially the kind of issues that are easy to solve once somebody has already fought the dragon.

## Tools

### TRCC / Thermalright LCD fix for Bazzite

**TRCC not launching on Bazzite? Thermalright LCD blank? PySide6 or Qt version mismatch? TRCC works manually but refuses to autostart?**

The TRCC helper installs `trcc-linux` inside its own Python virtual environment, avoiding conflicts with Bazzite's host Python/Qt/PySide stack. It also creates a delayed GNOME autostart launcher so the USB LCD controller has time to initialize before TRCC connects.

Files:

- `trcc/install-trcc.sh`
- `trcc/uninstall-trcc.sh`

See [trcc/README.md](trcc/README.md).

### GNOME Dock Monitor Fix

Restores a GNOME Wayland multi-monitor layout by identifying physical monitors by serial number rather than assuming stable DisplayPort connector names.

Useful when a Thunderbolt or USB-C dock reconnects monitors as different DP connectors and GNOME scrambles the layout.

Files:

- `gnome-dock-monitor-fix/fix-dock-layout.sh`

See [gnome-dock-monitor-fix/README.md](gnome-dock-monitor-fix/README.md).

## License

MIT
