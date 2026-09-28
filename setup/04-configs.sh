#!/usr/bin/env bash
# ==============================================================================
# Script: setup/04-configs.sh
# Purpose: Backup existing configurations and create atomic symlinks to repo
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
REPO_CONFIG_DIR="$REPO_ROOT/config"
TARGET_CONFIG_DIR="$HOME/.config"

BACKUP_TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$HOME/.config.backup.$BACKUP_TIMESTAMP"

CONFIG_ITEMS=(
    "hypr"
    "quickshell"
    "illogical-impulse"
    "kitty"
    "fish"
    "matugen"
    "cava"
    "fastfetch"
    "wlogout"
    "fuzzel"
    "fontconfig"
    "starship.toml"
)

log_info "Deploying configurations with atomic symlinks..."
log_info "Repository source: $REPO_CONFIG_DIR"
log_info "Target directory:  $TARGET_CONFIG_DIR"

mkdir -p "$TARGET_CONFIG_DIR"

backup_created=false

for item in "${CONFIG_ITEMS[@]}"; do
    src="$REPO_CONFIG_DIR/$item"
    dest="$TARGET_CONFIG_DIR/$item"

    if [[ ! -e "$src" ]]; then
        log_warn "Source $src does not exist in repo. Skipping."
        continue
    fi

    # Handle existing target
    if [[ -e "$dest" || -L "$dest" ]]; then
        # If already pointing to the exact repo file, skip
        if [[ -L "$dest" && "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
            log_info "Symlink already current for: $item"
            continue
        fi

        # If it's a real directory or file, back it up
        if [[ ! -L "$dest" ]]; then
            if [[ "$backup_created" == false ]]; then
                log_warn "Existing configurations found. Creating backup directory: $BACKUP_DIR"
                mkdir -p "$BACKUP_DIR"
                backup_created=true
            fi
            log_info "Backing up: $dest -> $BACKUP_DIR/$item"
            mv "$dest" "$BACKUP_DIR/$item"
        else
            rm "$dest"
        fi
    fi

    # Create atomic symlink
    ln -sfn "$src" "$dest"
    log_success "Linked: ~/.config/$item -> $src"
done

# Check if config.json exists in illogical-impulse, else instantiate from template
II_CONFIG="$TARGET_CONFIG_DIR/illogical-impulse/config.json"
II_EXAMPLE="$TARGET_CONFIG_DIR/illogical-impulse/config.example.json"
if [[ ! -f "$II_CONFIG" && -f "$II_EXAMPLE" ]]; then
    log_info "Creating initial config.json from template..."
    cp "$II_EXAMPLE" "$II_CONFIG"
    log_success "Created ~/.config/illogical-impulse/config.json"
fi

if [[ "$backup_created" == true ]]; then
    log_success "Backup of previous configurations preserved at: $BACKUP_DIR"
fi

log_success "Configuration deployment complete!"
