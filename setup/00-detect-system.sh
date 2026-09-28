#!/usr/bin/env bash
# ==============================================================================
# Script: setup/00-detect-system.sh
# Purpose: Pre-flight environment check (Arch Linux + GPU detection)
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

log_info "Running pre-flight system checks..."

# Check non-root
if [[ "$EUID" -eq 0 ]]; then
    log_err "Please do NOT run this script as root! Run as regular user with sudo privileges."
    exit 1
fi

# Check Arch Linux
if [[ ! -f /etc/arch-release ]]; then
    log_err "This dotfile suite is specifically tailored for Arch Linux (/etc/arch-release not found)."
    exit 1
fi
log_success "Verified Arch Linux environment."

# GPU Detection
log_info "Detecting display hardware..."
gpu_info=$(lspci -k | grep -A 2 -E "(VGA|3D)" || true)

if echo "$gpu_info" | grep -qi "nvidia"; then
    log_warn "NVIDIA GPU detected!"
    log_info "Ensuring Wayland NVIDIA environment variables are enabled..."
    # Check ~/.config/hypr/custom/env.lua
    mkdir -p "$HOME/.config/hypr/custom"
    cat << 'NV_EOF' > "$HOME/.config/hypr/custom/env.lua"
-- NVIDIA Wayland optimizations
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
NV_EOF
    log_success "Configured NVIDIA Wayland variables in ~/.config/hypr/custom/env.lua"
else
    log_success "Standard / Non-NVIDIA GPU detected. Standard Wayland pipelines will be used."
fi
