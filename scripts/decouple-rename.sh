#!/usr/bin/env bash
# ==============================================================================
# Script: scripts/decouple-rename.sh
# Purpose: Rename legacy shell to lviffy-shell across Quickshell & Hyprland
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

QS_DIR="$HOME/.config/quickshell"
OLD_NAME="${1:-legacy-shell}"
NEW_NAME="lviffy-shell"

OLD_PATH="$QS_DIR/$OLD_NAME"
NEW_PATH="$QS_DIR/$NEW_NAME"
HYPR_DIR="$HOME/.config/hypr"
FISH_CONFIG="$HOME/.config/fish/config.fish"

log_info "Step 1: Renaming Quickshell directory..."

if [[ -d "$OLD_PATH" ]]; then
    if [[ -d "$NEW_PATH" ]]; then
        log_warn "Target directory $NEW_PATH already exists. Skipping directory move."
    else
        mv "$OLD_PATH" "$NEW_PATH"
        log_success "Renamed $OLD_PATH -> $NEW_PATH"
    fi
elif [[ -d "$NEW_PATH" ]]; then
    log_info "Directory is already renamed to $NEW_PATH."
else
    log_err "Neither $OLD_PATH nor $NEW_PATH was found in $QS_DIR!"
    exit 1
fi

log_info "Step 2: Scanning and replacing string references ($OLD_NAME -> $NEW_NAME)..."

SEARCH_DIRS=("$NEW_PATH" "$HYPR_DIR")
TARGET_EXTENSIONS=(-name "*.qml" -o -name "*.js" -o -name "*.py" -o -name "*.conf" -o -name "*.lua" -o -name "*.sh" -o -name "*.json" -o -name "*.fish")

modified_count=0

for search_dir in "${SEARCH_DIRS[@]}"; do
    if [[ ! -d "$search_dir" ]]; then
        log_warn "Directory $search_dir not found, skipping."
        continue
    fi

    log_info "Searching in: $search_dir"

    while IFS= read -r file; do
        if grep -q "$OLD_NAME" "$file" 2>/dev/null; then
            sed -i "s|${OLD_NAME}|${NEW_NAME}|g" "$file"
            log_success "Updated: $file"
            modified_count=$((modified_count + 1))
        fi
    done < <(find "$search_dir" -type d -name ".git" -prune -o -type f \( "${TARGET_EXTENSIONS[@]}" \) -print)
done

log_info "Step 3: Updating Hyprland & Shell variables..."

# 3a. Update hyprland/variables.lua
if [[ -f "$HYPR_DIR/hyprland/variables.lua" ]]; then
    sed -i "s|qsConfig\", \".*\"|qsConfig\", \"${NEW_NAME}\"|g" "$HYPR_DIR/hyprland/variables.lua"
    log_success "Updated qsConfig in hyprland/variables.lua"
fi

# 3b. Update hyprland/variables.conf
if [[ -f "$HYPR_DIR/hyprland/variables.conf" ]]; then
    sed -i "s|\$qsConfig = .*|\$qsConfig = ${NEW_NAME}|g" "$HYPR_DIR/hyprland/variables.conf"
    log_success "Updated \$qsConfig in hyprland/variables.conf"
fi

# 3c. Update hyprland/execs.lua
if [[ -f "$HYPR_DIR/hyprland/execs.lua" ]]; then
    sed -i "s|qs -c [^\" ]*|qs -c ${NEW_NAME}|g" "$HYPR_DIR/hyprland/execs.lua"
    log_success "Updated qs command in hyprland/execs.lua"
fi

# 3d. Update switchwall.sh inside lviffy-shell
SWITCHWALL_SCRIPT="$NEW_PATH/scripts/colors/switchwall.sh"
if [[ -f "$SWITCHWALL_SCRIPT" ]]; then
    sed -i "s|QUICKSHELL_CONFIG_NAME=\".*\"|QUICKSHELL_CONFIG_NAME=\"${NEW_NAME}\"|g" "$SWITCHWALL_SCRIPT"
    log_success "Updated QUICKSHELL_CONFIG_NAME in switchwall.sh"
fi

# 3e. Update fish alias
if [[ -f "$FISH_CONFIG" ]]; then
    sed -i "s|alias q 'qs -c .*'|alias q 'qs -c ${NEW_NAME}'|g" "$FISH_CONFIG"
    log_success "Updated alias q in fish config"
fi

log_success "Decoupling complete! Modified $modified_count files."
echo -e "${GREEN}==>${NC} Quickshell config is now decoupled as ${BOLD}$NEW_NAME${NC}"
