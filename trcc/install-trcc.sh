#!/usr/bin/env bash

set -euo pipefail

echo "======================================"
echo " TRCC Bazzite Installer"
echo " Thermalright LCD Controller"
echo "======================================"
echo

VENV="$HOME/.venvs/trcc"
BIN_DIR="$HOME/.local/bin"
AUTOSTART_DIR="$HOME/.config/autostart"

LAUNCHER="$BIN_DIR/trcc-start.sh"
DESKTOP="$AUTOSTART_DIR/trcc.desktop"

if [[ "${EUID}" -eq 0 ]]; then
    echo "ERROR: Do not run this installer with sudo."
    echo "Run it as your normal desktop user:"
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

mkdir -p "$HOME/.venvs"

if [[ ! -d "$VENV" ]]; then
    python3 -m venv "$VENV"
else
    echo "TRCC virtual environment already exists."
fi

echo

echo "[3/5] Installing/updating TRCC..."

"$VENV/bin/python" -m pip install --upgrade pip setuptools wheel
"$VENV/bin/python" -m pip install --upgrade trcc-linux

echo

echo "[4/5] Creating delayed startup launcher..."

mkdir -p "$BIN_DIR"

cat > "$LAUNCHER" <<EOF
#!/usr/bin/env bash

# Give the desktop session and USB subsystem time to finish waking up.
sleep 8

exec "$VENV/bin/trcc" gui --resume
EOF

chmod +x "$LAUNCHER"

echo

echo "[5/5] Creating GNOME autostart entry..."

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
echo "======================================"
echo " INSTALL COMPLETE"
echo "======================================"
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
echo "You can test TRCC right now with:"
echo
echo "  $VENV/bin/trcc gui --resume"
echo
echo "Then reboot/login again to verify autostart."
