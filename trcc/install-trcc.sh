#!/usr/bin/env bash
#
# TRCC ON BAZZITE / THERMALRIGHT LCD LINUX FIX
#
# Search terms this script is intended to help with:
#   TRCC Bazzite fix
#   Thermalright LCD Linux
#   TRCC PySide6 Qt version mismatch
#   TRCC Python version error
#   TRCC won't launch on Bazzite
#   TRCC autostart GNOME
#
# This installer keeps TRCC out of the host Python environment by creating
# a dedicated virtual environment, then adds a delayed GNOME/XDG autostart
# entry so the Thermalright USB LCD controller has time to initialize.
#
# Do NOT run this script with sudo.

set -euo pipefail

echo "============================================================"
echo " TRCC for Bazzite - Thermalright LCD Linux Installer"
echo " Isolated Python environment + reliable GNOME autostart"
echo "============================================================"
echo

VENV="$HOME/.venvs/trcc"
BIN_DIR="$HOME/.local/bin"
AUTOSTART_DIR="$HOME/.config/autostart"

LAUNCHER="$BIN_DIR/trcc-start.sh"
DESKTOP="$AUTOSTART_DIR/trcc.desktop"

if [[ "${EUID}" -eq 0 ]]; then
    echo "ERROR: Do not run this installer with sudo."
    echo "TRCC should be installed for your normal desktop user."
    echo
    echo "Run:"
    echo "  ./install-trcc.sh"
    exit 1
fi

echo "[1/5] Checking Python..."

if ! command -v python3 >/dev/null 2>&1; then
    echo "ERROR: python3 was not found."
    exit 1
fi

echo "Using: $(python3 --version)"
echo

echo "[2/5] Creating isolated TRCC Python environment..."
echo "This avoids host Python / Qt / PySide dependency conflicts."

mkdir -p "$HOME/.venvs"

if [[ ! -d "$VENV" ]]; then
    python3 -m venv "$VENV"
else
    echo "TRCC virtual environment already exists."
fi

echo

echo "[3/5] Installing/updating trcc-linux inside the virtual environment..."

"$VENV/bin/python" -m pip install --upgrade pip setuptools wheel
"$VENV/bin/python" -m pip install --upgrade trcc-linux

echo

echo "[4/5] Creating delayed TRCC startup launcher..."

mkdir -p "$BIN_DIR"

cat > "$LAUNCHER" <<EOF
#!/usr/bin/env bash

# Give GNOME and the USB subsystem time to finish waking up before TRCC
# connects to the Thermalright LCD controller.
sleep 8

exec "$VENV/bin/trcc" gui --resume
EOF

chmod +x "$LAUNCHER"

echo

echo "[5/5] Creating GNOME/XDG autostart entry..."

mkdir -p "$AUTOSTART_DIR"

cat > "$DESKTOP" <<EOF
[Desktop Entry]
Type=Application
Name=TRCC
Comment=Thermalright LCD Controller
Exec=$LAUNCHER
Terminal=false
X-GNOME-Autostart-enabled=true
StartupNotify=false
EOF

echo
echo "============================================================"
echo " TRCC INSTALL COMPLETE"
echo "============================================================"
echo
echo "TRCC is isolated from the system Python environment."
echo "A delayed GNOME autostart entry has also been installed."
echo
echo "TRCC venv:"
echo "  $VENV"
echo
echo "Manual launch:"
echo "  $VENV/bin/trcc gui --resume"
echo
echo "Autostart launcher:"
echo "  $LAUNCHER"
echo
echo "GNOME autostart:"
echo "  $DESKTOP"
echo
echo "Test it now with:"
echo
echo "  $VENV/bin/trcc gui --resume"
echo
echo "If the Thermalright LCD comes alive, reboot or log out/in"
echo "to verify that delayed autostart works."
