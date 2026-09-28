#!/usr/bin/env bash
# ==============================================================================
# Script: setup/03-fonts.sh
# Purpose: Install custom fonts (SF-Pro, Inter, Google Sans) & update font cache
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
FONTS_SRC="$REPO_ROOT/fonts"
DEST_FONTS_DIR="$HOME/.local/share/fonts"

log_info "Installing custom typography to $DEST_FONTS_DIR..."
mkdir -p "$DEST_FONTS_DIR"

if [[ -d "$FONTS_SRC" ]]; then
    for font_dir in "$FONTS_SRC"/*; do
        if [[ -d "$font_dir" ]]; then
            font_name=$(basename "$font_dir")
            log_info "Deploying font family: $font_name"
            mkdir -p "$DEST_FONTS_DIR/$font_name"
            rsync -a --delete "$font_dir/" "$DEST_FONTS_DIR/$font_name/"
        fi
    done
    log_success "Font files deployed."
else
    log_warn "Fonts source directory not found at $FONTS_SRC"
fi

log_info "Updating system font cache (fc-cache)..."
fc-cache -f "$DEST_FONTS_DIR" >/dev/null 2>&1 || fc-cache -fv
log_success "Font cache refreshed."
