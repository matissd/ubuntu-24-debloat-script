# Ubuntu 24.04 Debloat Script

A bash script to remove Snap packages, bloatware, and set up a clean development environment on Ubuntu 24.04 LTS.

## What it does

1. **Remove Snap** - Completely removes Snap packages and snapd, prevents future installation
2. **Add Brave repository** - Sets up Brave browser repository
3. **Update and upgrade** - Updates package lists and upgrades system
4. **Remove bloat** - Removes unwanted default applications
5. **Install tools and Brave** - Installs development tools and Brave browser
6. **Final cleanup** - Cleans up package configs, logs, and caches

## Requirements

- Ubuntu 24.04 LTS
- sudo privileges
- Internet connection

## Usage

```bash
chmod +x ubuntu-24-debloat.sh
./ubuntu-24-debloat.sh
```

## Removed packages

- Snap packages (firefox, thunderbird, snap-store, etc.)
- Thunderbird
- LibreOffice suite
- Media players (Totem, Rhythmbox)
- Games (Aisleriot, Mahjongg, Mines, Sudoku)
- Other bloat (Simple Scan, Cheese, Transmission)

## Installed packages

- Development tools: build-essential, cmake, ninja-build, git, curl, wget
- Python: python3, python3-pip, python3-venv
- Build tools: flex, bison, gperf, libffi-dev, libssl-dev, pkg-config
- USB/Serial tools: dfu-util, libusb-1.0-0, minicom, picocom, screen, usbutils
- Other: ccache, unzip, xz-utils
- Brave browser

## Notes

- The script adds your user to the `dialout` group for serial port access
- Snap is permanently blocked from being reinstalled
- System logs older than 7 days are removed
- A reboot is recommended after completion
