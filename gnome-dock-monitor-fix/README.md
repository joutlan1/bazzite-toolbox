# GNOME Dock Monitor Fix

A small Bash utility for restoring a multi-monitor layout on GNOME Wayland using `gdctl`.

This was created to solve a problem where external monitors connected through a laptop dock could appear on different display connectors after disconnecting and reconnecting the dock.

A layout tied directly to connector names such as `DP-6` or `DP-9` can therefore become unreliable.

Instead of assuming a particular connector, this script identifies each physical monitor by its serial number, determines its current connector using `gdctl`, and then applies the desired layout.

## How It Works

The script:

1. Runs `gdctl show` to retrieve the monitors currently detected by GNOME.
2. Finds each physical monitor using its hardware serial number.
3. Determines the connector currently associated with that monitor.
4. Verifies that both configured monitors are present.
5. Applies the desired position, orientation, and primary-monitor configuration using `gdctl set --persistent`.

## Requirements

- GNOME
- Wayland
- `gdctl`
- Bash
- `awk`

Check whether `gdctl` is available by running:

```bash
gdctl show
```

## Installation

From the root of this repository:

```bash
mkdir -p ~/.local/bin
cp gnome-dock-monitor-fix/fix-dock-layout.sh ~/.local/bin/
chmod +x ~/.local/bin/fix-dock-layout.sh
```

## Configuration

Run:

```bash
gdctl show
```

Locate the serial numbers of the external monitors you want the script to manage.

Edit `fix-dock-layout.sh` and replace the configured serial numbers with your own:

```bash
LG_SERIAL="YOUR_FIRST_MONITOR_SERIAL"
SAMSUNG_SERIAL="YOUR_SECOND_MONITOR_SERIAL"
```

You will also need to modify the final `gdctl set` command to match your desired monitor arrangement.

## Usage

```bash
~/.local/bin/fix-dock-layout.sh
```

If both configured monitors are detected, the desired layout will be applied. If either monitor cannot be found, the script exits without changing the display configuration.

## Why Serial Numbers?

Display connector names are not always stable identifiers for physical monitors when using docks, USB-C, Thunderbolt, or changing display configurations. The serial number gives the script a stable way to discover the monitor's current connector dynamically.

## Tested On

Originally developed and tested on Bazzite with GNOME and Wayland using a Lenovo ThinkPad connected to two external monitors through a Thunderbolt dock.
