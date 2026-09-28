#!/usr/bin/env bash
# ==============================================================================
# Script: setup/01-aur-helper.sh
# Purpose: Detect or bootstrap an AUR helper (yay / paru)
# ==============================================================================
set -euo pipefail

BOLD='\033[1m'
BLUE='\033[34m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}::${NC} ${BOLD}$1${NC}"; }
log_success() { echo -e "${GREEN}==>${NC} ${BOLD}$1${NC}"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_err()     { echo -e "${RED}[ERROR]${NC} $1" >&2; }

log_info "Checking for AUR helper..."

if command -v paru &>/dev/null; then
    AUR_HELPER="paru"
    log_success "Found AUR helper: paru"
elif command -v yay &>/dev/null; then
    AUR_HELPER="yay"
    log_success "Found AUR helper: yay"
else
    log_warn "No AUR helper found. Installing yay-bin..."
    sudo pacman -S --needed --noconfirm base-devel git
    TMP_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$TMP_DIR/yay-bin"
    (
        cd "$TMP_DIR/yay-bin"
        makepkg -si --noconfirm
    )
    rm -rf "$TMP_DIR"
    AUR_HELPER="yay"
    log_success "Successfully bootstrapped yay-bin!"
fi

echo "$AUR_HELPER" > /tmp/lviffy_dots_aur_helper.tmp
