#!/usr/bin/env bash
set -euo pipefail

echo "--- ------------------------------------ ---"
echo "--- Starting Ubuntu 24.04 debloat script ---"
echo "--- ------------------------------------ ---"

# 1. Remove Snap
echo "--- [1/6] Removing Snaps and the Snap Daemon ---"
sudo systemctl stop snapd.service 2>/dev/null || true

SNAPS_TO_REMOVE=(
    firefox thunderbird snap-store firmware-updater 
    snapd-desktop-integration gtk-common-themes 
    gnome-42-2204 gnome-46-2404 bare core22 core24
)

for s in "${SNAPS_TO_REMOVE[@]}"; do
    if snap list 2>/dev/null | grep -q "^$s "; then
        echo "Removing snap: $s"
        sudo snap remove --purge "$s" || true
    fi
done

sudo apt purge -y snapd
sudo apt autoremove --purge -y
rm -rf ~/snap
sudo rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd

sudo bash -c 'cat <<EOF > /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF'

# 2. Add Brave repository
echo "--- [2/6] Adding Brave repository ---"
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
    https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
    sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# 3. Update and upgrade
echo "--- [3/6] Updating package lists and system ---"
sudo apt update
sudo apt upgrade -y

# 4. Remove bloat
echo "--- [4/6] Removing unwanted APT packages ---"
APT_REMOVE=(
    thunderbird libreoffice-common libreoffice-core libreoffice-gnome 
    totem rhythmbox simple-scan cheese transmission-gtk aisleriot 
    gnome-mahjongg gnome-mines gnome-sudoku
)
sudo apt remove -y "${APT_REMOVE[@]}"

# 5. Install tools and Brave
echo "--- [5/6] Installing dev tools & Brave ---"
sudo apt install -y \
    build-essential cmake ninja-build git curl wget python3 python3-pip \
    python3-venv flex bison gperf libffi-dev libssl-dev dfu-util \
    libusb-1.0-0 pkg-config unzip xz-utils ccache \
    minicom picocom screen usbutils \
    brave-browser \
    gnome-software --no-install-recommends

sudo usermod -aG dialout "$USER"
python3 -m pip install --user --upgrade pip setuptools wheel 2>/dev/null || true

# 6. Final cleanup
echo "--- [6/6] Final cleanup ---"
dpkg -l | awk '/^rc/ {print $2}' | xargs -r sudo dpkg --purge
sudo journalctl --vacuum-time=7d
rm -rf ~/.cache/thumbnails/* 2>/dev/null || true
sudo apt autoremove --purge -y
sudo apt clean

echo "--- ----------------- ---"
echo "--- Debloat complete! ---"
echo "--- ----------------- ---"