#!/usr/bin/env bash
# ==============================================================================
# Script: scripts/sanitize-paths.sh
# Purpose: Find and replace hardcoded /home/lviffy paths with portable standards
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

HARDCODED_USER="/home/lviffy"
TARGET_DIRS=(
    "$HOME/.config/hypr"
    "$HOME/.config/quickshell/lviffy-shell"
    "$HOME/.config/illogical-impulse"
)

log_info "Scanning for occurrences of $HARDCODED_USER..."

total_matches=0

for dir in "${TARGET_DIRS[@]}"; do
    [[ ! -d "$dir" ]] && continue

    while IFS= read -r file; do
        if grep -Fq "$HARDCODED_USER" "$file"; then
            total_matches=$((total_matches + 1))
            ext="${file##*.}"

            case "$ext" in
                conf)
                    sed -i "s|${HARDCODED_USER}|~|g" "$file"
                    log_success "[Hyprland Conf] Replaced with '~' in: $file"
                    ;;
                sh)
                    sed -i 's|'"${HARDCODED_USER}"'|"$HOME"|g' "$file"
                    log_success "[Shell Script] Replaced with '\"\$HOME\"' in: $file"
                    ;;
                lua)
                    sed -i 's|"'${HARDCODED_USER}'/|HOME .. "/|g' "$file"
                    log_success "[Lua Config] Replaced with 'HOME .. \"/' in: $file"
                    ;;
                qml|js)
                    sed -i "s|${HARDCODED_USER}|Quickshell.env(\"HOME\")|g" "$file"
                    log_success "[QML/JS] Replaced with 'Quickshell.env(\"HOME\")' in: $file"
                    ;;
                json)
                    sed -i 's|'"${HARDCODED_USER}"'|~|g' "$file"
                    log_success "[JSON] Replaced with '~' in: $file"
                    ;;
                *)
                    sed -i 's|'"${HARDCODED_USER}"'|$HOME|g' "$file"
                    log_success "[Generic] Replaced with '\$HOME' in: $file"
                    ;;
            esac
        fi
    done < <(find "$dir" -type d -name ".git" -prune -o -type f -print)
done

if (( total_matches == 0 )); then
    log_info "No hardcoded instances of $HARDCODED_USER found."
else
    log_success "Path sanitization completed across $total_matches files."
fi
