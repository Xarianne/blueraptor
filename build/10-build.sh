#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# Main Build Script
###############################################################################
# This script follows the @ublue-os/bluefin pattern for build scripts.
# It uses set -eoux pipefail for strict error handling and debugging.
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

# Enable nullglob for all glob operations to prevent failures on empty matches
shopt -s nullglob

echo "::group:: Copy Bluefin Config from Common"

# Copy just files from @projectbluefin/common (includes 00-entry.just which imports 60-custom.just)
mkdir -p /usr/share/ublue-os/just/
shopt -s nullglob
cp -r /ctx/oci/common/bluefin/usr/share/ublue-os/just/* /usr/share/ublue-os/just/
shopt -u nullglob

echo "::endgroup::"

echo "::group:: Copy Custom Files"

# Copy Brewfiles to standard location
mkdir -p /usr/share/ublue-os/homebrew/
cp /ctx/custom/brew/*.Brewfile /usr/share/ublue-os/homebrew/

# Consolidate Just Files
find /ctx/custom/ujust -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >> /usr/share/ublue-os/just/60-custom.just

# Copy Flatpak preinstall files
mkdir -p /etc/flatpak/preinstall.d/
cp /ctx/custom/flatpaks/*.preinstall /etc/flatpak/preinstall.d/

echo "::endgroup::"

echo "::group:: Install Packages"
# Install packages using dnf5
dnf5 install -y \
  firefox \
  steam \
  goverlay \
  mangohud \
  vkBasalt \
  fish

echo "::endgroup::"

echo "::group:: CachyOS Optimizations"
# 1. Manually enable the repo
dnf5 -y copr enable bieszczaders/kernel-cachyos-addons

# 2. Perform the 'swap' manually with --allowerasing
# This removes zram-generator-defaults and adds cachyos-settings in one go
dnf5 -y install --allowerasing \
    cachyos-settings \
    scx-scheds \
    scx-tools \
    scx-manager \
    ananicy-cpp \
    cachyos-ananicy-rules

# 3. Disable the repo immediately to maintain the "isolated" pattern
dnf5 -y copr disable bieszczaders/kernel-cachyos-addons

echo "::endgroup::"

echo "::group:: Tools"
copr_install_isolated "xariann/tools" \
    boot-windows \
    nautilus-copy-path \

echo "::endgroup::"

echo "::group:: System Configuration"

# Enable/disable systemd services
systemctl enable podman.socket
systemctl enable ananicy-cpp.service
systemctl enable scx_loader.service

echo "::endgroup::"

# Restore default glob behavior
shopt -u nullglob

echo "Custom build complete!"
