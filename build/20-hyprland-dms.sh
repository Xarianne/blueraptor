#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# Example: Swap GNOME Desktop with COSMIC Desktop
###############################################################################
# This example demonstrates replacing the GNOME desktop environment with
# System76's COSMIC desktop from their COPR repository.
#
# COSMIC is a new desktop environment built in Rust by System76.
# https://github.com/pop-os/cosmic-epoch
#
# To use this script:
# 1. Rename to remove .example extension: mv 30-cosmic-desktop.sh.example 30-cosmic-desktop.sh
# 2. Build - scripts run in numerical order automatically
#
# WARNING: This removes GNOME and replaces it with COSMIC. Only use this if
# you want COSMIC as your desktop environment instead of GNOME.
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

echo "::group:: Install Hyprland"
copr_install_isolated "solopasha/hyprland" \
    hyprland \
    xdg-desktop-portal-hyprland

echo "Hyprland installed successfully"
echo "::endgroup::

echo "::group:: Install Dank Material Shell"

copr_install_isolated "avengemedia/danklinux" \
    quickshell 
    
copr_install_isolated "avengemedia/dms" \
    dms 
    
echo "Dank Material Shell installed successfully"
echo "::endgroup::

echo "Hyprland and Dank Material Shell installation complete!"
echo "After booting, select 'Hyprland' session at the login screen"
