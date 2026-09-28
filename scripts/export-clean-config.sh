#!/usr/bin/env bash
# ==============================================================================
# Script: scripts/export-clean-config.sh
# Purpose: Sanitize illogical-impulse config.json into config.example.json
# ==============================================================================
set -euo pipefail

BOLD='\033[1m'
BLUE='\033[34m'
GREEN='\033[32m'
RED='\033[31m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}::${NC} ${BOLD}$1${NC}"; }
log_success() { echo -e "${GREEN}==>${NC} ${BOLD}$1${NC}"; }
log_err()     { echo -e "${RED}[ERROR]${NC} $1" >&2; }

SRC_CONFIG="$HOME/.config/illogical-impulse/config.json"
TARGET_DIR="$HOME/Projects/lviffy-dots/config/illogical-impulse"
DEST_CONFIG="$TARGET_DIR/config.example.json"

if ! command -v jq &>/dev/null; then
    log_err "jq is required but not installed. Install it with: sudo pacman -S jq"
    exit 1
fi

if [[ ! -f "$SRC_CONFIG" ]]; then
    log_err "Source configuration not found at $SRC_CONFIG"
    exit 1
fi

mkdir -p "$TARGET_DIR"

log_info "Sanitizing $SRC_CONFIG -> $DEST_CONFIG..."

# jq transformation:
# 1. Traverses all keys matching apiKey, api_key, token, secret and sets them to placeholder
# 2. Resets personal avatar/wallpaper paths to clean templates
jq '
  walk(
    if type == "object" then
      with_entries(
        if (.key | test("apiKey|api_key|token|secret"; "i")) and (.value | type == "string") and (.value != "") then
          .value = "YOUR_API_KEY_HERE"
        else
          .
        end
      )
    else
      .
    end
  )
  | .wallpaperPath = "~/Pictures/Wallpapers/default.png"
  | .thumbnailPath = ""
  | .avatarPicture = ""
  | .avatarPath = "~/Pictures/"
' "$SRC_CONFIG" > "$DEST_CONFIG"

# Also copy presets and actions if they exist
if [[ -d "$HOME/.config/illogical-impulse/presets" ]]; then
    cp -r "$HOME/.config/illogical-impulse/presets" "$TARGET_DIR/"
    log_success "Copied presets to $TARGET_DIR/presets"
fi

if [[ -d "$HOME/.config/illogical-impulse/actions" ]]; then
    cp -r "$HOME/.config/illogical-impulse/actions" "$TARGET_DIR/"
    log_success "Copied actions to $TARGET_DIR/actions"
fi

log_success "Sanitized configuration written to: $DEST_CONFIG"
