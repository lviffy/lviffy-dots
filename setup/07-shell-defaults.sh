#!/usr/bin/env bash
# ==============================================================================
# Script: setup/07-shell-defaults.sh
# Purpose: Configure Fish shell as the default user login shell
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

FISH_BIN=$(command -v fish || true)

if [[ -z "$FISH_BIN" ]]; then
    log_warn "Fish shell is not installed. Skipping shell change."
    exit 0
fi

CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)

if [[ "$CURRENT_SHELL" == "$FISH_BIN" ]]; then
    log_success "Fish is already your default shell: $FISH_BIN"
else
    log_info "Setting default shell to Fish ($FISH_BIN)..."
    if ! grep -q "$FISH_BIN" /etc/shells; then
        echo "$FISH_BIN" | sudo tee -a /etc/shells
    fi
    chsh -s "$FISH_BIN" "$USER"
    log_success "Default shell set to $FISH_BIN (active on next login)."
fi
