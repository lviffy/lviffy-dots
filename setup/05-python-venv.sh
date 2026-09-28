#!/usr/bin/env bash
# ==============================================================================
# Script: setup/05-python-venv.sh (Python Virtual Environment Manager)
# Complies with: PEP 668 (EXTERNALLY-MANAGED Python Environments on Arch Linux)
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

VENV_DIR="$HOME/.local/state/quickshell/.venv"

log_info "Initializing Quickshell Python virtual environment (PEP 668 compliant)..."

if ! command -v python3 &>/dev/null; then
    log_err "python3 is not installed! Aborting."
    exit 1
fi

mkdir -p "$(dirname "$VENV_DIR")"

if [[ -d "$VENV_DIR" && -f "$VENV_DIR/bin/activate" ]]; then
    log_info "Existing virtual environment detected at $VENV_DIR."
else
    log_info "Creating clean virtual environment at $VENV_DIR..."
    python3 -m venv --system-site-packages "$VENV_DIR"
    log_success "Virtual environment initialized."
fi

VENV_PY="$VENV_DIR/bin/python"

# Ensure pip is present
if ! "$VENV_PY" -m pip --version &>/dev/null; then
    log_info "Bootstrapping pip via ensurepip..."
    "$VENV_PY" -m ensurepip --default-pip
fi

log_info "Upgrading pip, setuptools, and wheel..."
"$VENV_PY" -m pip install --upgrade --quiet pip setuptools wheel

log_info "Installing Quickshell dependencies: pillow, requests, dbus-python..."
REQUIRED_PKGS=("pillow" "requests" "dbus-python")

for pkg in "${REQUIRED_PKGS[@]}"; do
    log_info "Verifying $pkg..."
    if ! "$VENV_PY" -m pip install --upgrade --quiet "$pkg" 2>/dev/null; then
        mod="${pkg//-/_}"
        if "$VENV_PY" -c "import $mod" &>/dev/null; then
            log_success "Package $pkg is provided via system packages."
        else
            log_warn "Installing $pkg directly..."
            "$VENV_PY" -m pip install "$pkg"
        fi
    else
        log_success "Installed $pkg in venv."
    fi
done

# Verification test
log_info "Verifying virtual environment module imports..."
"$VENV_PY" -c "import PIL; import requests; import dbus; print('All Quickshell Python modules loaded successfully!')"

log_success "Quickshell Python virtual environment is active at: $VENV_DIR"
