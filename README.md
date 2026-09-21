# Bazzite Toolbox

A small collection of Linux helper scripts built from real-world Bazzite/GNOME troubleshooting.

## Tools

### TRCC helper

Installs TRCC in an isolated Python virtual environment to avoid host Python/Qt/PySide conflicts, then launches it through a delayed GNOME autostart entry.

Files:

- `trcc/install-trcc.sh`
- `trcc/uninstall-trcc.sh`

See [trcc/README.md](trcc/README.md).

### GNOME Dock Monitor Fix

Restores a GNOME Wayland multi-monitor layout by identifying physical monitors by serial number rather than assuming stable DisplayPort connector names.

Files:

- `gnome-dock-monitor-fix/fix-dock-layout.sh`

See [gnome-dock-monitor-fix/README.md](gnome-dock-monitor-fix/README.md).

## License

MIT
