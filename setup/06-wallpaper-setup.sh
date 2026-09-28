#!/usr/bin/env bash
# ==============================================================================
# Script: setup/06-wallpaper-setup.sh
# Purpose: Initialize wallpaper directories, starter media, and mpvpaper helpers
# ==============================================================================
set -euo pipefail

BOLD='\033[1m'
BLUE='\033[34m'
GREEN='\033[32m'
YELLOW='\033[33m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}::${NC} ${BOLD}$1${NC}"; }
log_success() { echo -e "${GREEN}==>${NC} ${BOLD}$1${NC}"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
THUMBNAIL_DIR="$HOME/.config/hypr/custom/scripts/mpvpaper_thumbnails"

log_info "Initializing wallpaper directories..."
mkdir -p "$WALLPAPER_DIR" "$THUMBNAIL_DIR"

# Copy starter wallpaper if none exists
if [[ ! -f "$WALLPAPER_DIR/default.png" && -f "$REPO_ROOT/assets/wallpapers/default.png" ]]; then
    cp "$REPO_ROOT/assets/wallpapers/default.png" "$WALLPAPER_DIR/default.png"
    log_success "Deployed starter wallpaper: $WALLPAPER_DIR/default.png"
fi

# Verify dependencies for live & static wallpapers
for cmd in mpvpaper ffmpeg matugen; do
    if command -v "$cmd" &>/dev/null; then
        log_success "Verified wallpaper dependency: $cmd"
    else
        log_warn "Missing dependency: $cmd. Video wallpapers and dynamic theming require this tool."
    fi
done

log_success "Wallpaper subsystem initialized."
