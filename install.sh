#!/usr/bin/env bash
# ==============================================================================
#  _       _  __  __         _       _       
# | |_   _(_)/ _|/ _|_   _  __| | ___ | |_ ___ 
# | \ \ / / | |_| |_| | | |/ _` |/ _ \| __/ __|
# | |\ V /| |  _|  _| |_| | (_| | (_) | |_\__ \
# |_| \_/ |_|_| |_|  \__, |\__,_|\___/ \__|___/
#                    |___/                     
# ==============================================================================
# Master Installer for lviffy-dots on pure Arch Linux
# ==============================================================================
set -euo pipefail

BOLD='\033[1m'
CYAN='\033[36m'
BLUE='\033[34m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
NC='\033[0m'

banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    cat << "BANNER_ART"
 _       _  __  __         _       _       
| |_   _(_)/ _|/ _|_   _  __| | ___ | |_ ___ 
| \ \ / / | |_| |_| | | |/ _` |/ _ \| __/ __|
| |\ V /| |  _|  _| |_| | (_| | (_) | |_\__ \
|_| \_/ |_|_| |_|  \__, |\__,_|\___/ \__|___/
                   |___/                     
BANNER_ART
    echo -e "${NC}"
    echo -e "${BOLD}Pure Arch Linux Hyprland + Quickshell Desktop Suite${NC}"
    echo -e "${BLUE}================================================================${NC}"
    echo ""
}

log_step()    { echo -e "\n${CYAN}==>${NC} ${BOLD}$1${NC}"; }
log_success() { echo -e "${GREEN}==>${NC} ${BOLD}$1${NC}"; }
log_err()     { echo -e "${RED}[ERROR]${NC} $1" >&2; }

trap 'log_err "Installation failed at line $LINENO. Review above logs for details."; exit 1' ERR

banner

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Stage 0: System Detection & GPU
log_step "Stage 0: Pre-flight Verification"
bash "$SCRIPT_DIR/setup/00-detect-system.sh"

# Stage 1: AUR Helper
log_step "Stage 1: AUR Helper (yay / paru)"
bash "$SCRIPT_DIR/setup/01-aur-helper.sh"

# Stage 2: Packages Installation
log_step "Stage 2: Installing Dependencies"
bash "$SCRIPT_DIR/setup/02-packages.sh"

# Stage 3: Fonts & Typography
log_step "Stage 3: Deploying Custom Typography"
bash "$SCRIPT_DIR/setup/03-fonts.sh"

# Stage 4: Dotfile Deployment & Symlinking
log_step "Stage 4: Deploying Configurations"
bash "$SCRIPT_DIR/setup/04-configs.sh"

# Stage 5: Python Virtual Environment
log_step "Stage 5: Configuring Quickshell Python Virtualenv"
bash "$SCRIPT_DIR/setup/05-python-venv.sh"

# Stage 6: Wallpapers Subsystem
log_step "Stage 6: Initializing Wallpaper Subsystem"
bash "$SCRIPT_DIR/setup/06-wallpaper-setup.sh"

# Stage 7: Shell Defaults
log_step "Stage 7: Configuring Fish Shell"
bash "$SCRIPT_DIR/setup/07-shell-defaults.sh"

# Final summary
echo ""
echo -e "${GREEN}================================================================${NC}"
echo -e "${GREEN}${BOLD}       INSTALLATION COMPLETED SUCCESSFULLY!${NC}"
echo -e "${GREEN}================================================================${NC}"
echo ""
echo -e "${BOLD}Next Steps:${NC}"
echo -e " 1. ${CYAN}Reboot or log out${NC} to start your new environment."
echo -e " 2. If using a Display Manager (e.g. SDDM), select ${BOLD}Hyprland${NC}."
echo -e " 3. If launching from TTY, execute: ${BOLD}start-hyprland${NC} or ${BOLD}Hyprland${NC}."
echo -e " 4. Open the Wallpaper Selector anytime with: ${BOLD}SUPER + P${NC}."
echo -e " 5. Lock screen anytime with: ${BOLD}SUPER + L${NC}."
echo ""
