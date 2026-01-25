#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# Hyprland and Dank Material Shell
###############################################################################
# Needs separate dots post install
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

echo "::group:: Install Hyprland"

# Hyprland
copr_install_isolated "sdegler/hyprland" \
    hyprland \
    xdg-desktop-portal-hyprland \
    hyprland-contrib \
    hyprland-guiutils \
    hyprqt6engine

echo "::endgroup::"

echo "::group:: Dank Material Shell"

copr_install_isolated "avengemedia/danklinux" \
    quickshell \
    dgop \
    dsearch \
    matugen \
    khal \
    ghostty \
    dms-greeter

copr_install_isolated "avengemedia/dms" \
    dms 

echo "::endgroup::"

echo "::group:: System Configuration"

# Enable/disable systemd services
systemctl enable podman.socket
# Example: systemctl mask unwanted-service

echo "::endgroup::"

echo "Hyprland with Dank Material Shell install complete!"
