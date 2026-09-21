#!/usr/bin/env bash
#
# TRCC BAZZITE / LINUX CLEAN UNINSTALLER
#
# Removes the isolated TRCC installation created by install-trcc.sh,
# including its GNOME autostart launcher and any old user-level systemd
# service. It deliberately leaves system Python, Qt, PySide, and OS
# packages untouched.
#
# Useful for:
#   uninstall TRCC Bazzite
#   remove trcc-linux
#   remove Thermalright LCD Linux controller
#   reset TRCC autostart GNOME
#
# Do NOT run this script with sudo.

set -u

echo "============================================================"
echo " TRCC for Bazzite - Clean Uninstaller"
echo " Removes TRCC without touching system Python / Qt / PySide"
echo "============================================================"
echo

VENV="$HOME/.venvs/trcc"
LAUNCHER="$HOME/.local/bin/trcc-start.sh"
AUTOSTART="$HOME/.config/autostart/trcc.desktop"
SERVICE="$HOME/.config/systemd/user/trcc.service"

if [[ "${EUID}" -eq 0 ]]; then
    echo "ERROR: Do not run this uninstaller with sudo."
    echo "Run it as the same desktop user that installed TRCC:"
    echo
    echo "  ./uninstall-trcc.sh"
    exit 1
fi

echo "[1/5] Stopping TRCC..."

pkill -f "$VENV/bin/trcc" 2>/dev/null || true
pkill -f "trcc gui" 2>/dev/null || true

echo "Done."
echo

echo "[2/5] Removing GNOME/XDG autostart entry..."

if [[ -f "$AUTOSTART" ]]; then
    rm -f "$AUTOSTART"
    echo "Removed:"
    echo "  $AUTOSTART"
else
    echo "No TRCC autostart entry found."
fi

echo

echo "[3/5] Removing delayed TRCC startup launcher..."

if [[ -f "$LAUNCHER" ]]; then
    rm -f "$LAUNCHER"
    echo "Removed:"
    echo "  $LAUNCHER"
else
    echo "No TRCC launcher found."
fi

echo

echo "[4/5] Checking for old user-level TRCC systemd service..."

systemctl --user stop trcc.service 2>/dev/null || true
systemctl --user disable trcc.service 2>/dev/null || true

if [[ -f "$SERVICE" ]]; then
    rm -f "$SERVICE"
    systemctl --user daemon-reload 2>/dev/null || true
    echo "Removed old TRCC systemd user service."
else
    echo "No TRCC systemd user service found."
fi

echo

echo "[5/5] Removing isolated TRCC virtual environment..."

if [[ -d "$VENV" ]]; then
    rm -rf "$VENV"
    echo "Removed:"
    echo "  $VENV"
else
    echo "TRCC virtual environment not found."
fi

echo
echo "============================================================"
echo " TRCC CLEANUP COMPLETE"
echo "============================================================"
echo
echo "TRCC, its isolated Python environment, delayed launcher,"
echo "GNOME autostart entry, and old user service are gone."
echo
echo "System Python, Qt, PySide, and OS packages were left alone."
