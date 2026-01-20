#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# Dank Material Shell & Hyprland Installation
###############################################################################
# This script installs the Dank Material Shell (DMS) and Quickshell 
# via the Danklinux COPR repository.
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
    quickshell \
    dgop \
    dsearch
    
copr_install_isolated "avengemedia/dms" \
    dms 
    
echo "Dank Material Shell installed successfully"
echo "::endgroup::

echo "Hyprland and Dank Material Shell installation complete!"
echo "After booting, select 'Hyprland' session at the login screen"