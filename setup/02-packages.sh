#!/usr/bin/env bash
# ==============================================================================
# Script: setup/02-packages.sh
# Purpose: Install official Arch packages and AUR dependencies
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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Identify AUR Helper
if [[ -f /tmp/lviffy_dots_aur_helper.tmp ]]; then
    AUR_HELPER=$(cat /tmp/lviffy_dots_aur_helper.tmp)
elif command -v paru &>/dev/null; then
    AUR_HELPER="paru"
elif command -v yay &>/dev/null; then
    AUR_HELPER="yay"
else
    log_err "No AUR helper found! Run 01-aur-helper.sh first."
    exit 1
fi

log_info "Synchronizing package databases..."
sudo pacman -Sy

# 1. Install official repository packages
PACMAN_FILE="$REPO_ROOT/pkglist/pacman.txt"
if [[ -f "$PACMAN_FILE" ]]; then
    log_info "Installing official repository packages..."
    mapfile -t pacman_pkgs < <(grep -v '^#' "$PACMAN_FILE" | grep -v '^$' || true)
    sudo pacman -S --needed --noconfirm "${pacman_pkgs[@]}"
    log_success "Official repository packages installed."
fi

# 2. Install AUR packages
AUR_FILE="$REPO_ROOT/pkglist/aur.txt"
if [[ -f "$AUR_FILE" ]]; then
    log_info "Installing AUR packages via $AUR_HELPER..."
    mapfile -t aur_pkgs < <(grep -v '^#' "$AUR_FILE" | grep -v '^$' || true)
    "$AUR_HELPER" -S --needed --noconfirm "${aur_pkgs[@]}"
    log_success "AUR packages installed."
fi

log_success "All packages installed successfully!"
