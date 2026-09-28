#!/usr/bin/env bash
# ==============================================================================
# Script: setup/install-all-extras.sh
# Purpose: One-click batch installation of all optional desktop apps & dev tools
# ==============================================================================
set -euo pipefail

BOLD='\033[1m'
CYAN='\033[36m'
BLUE='\033[34m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
NC='\033[0m'

log_step()    { echo -e "\n${CYAN}==>${NC} ${BOLD}$1${NC}"; }
log_success() { echo -e "${GREEN}==>${NC} ${BOLD}$1${NC}"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_err()     { echo -e "${RED}[ERROR]${NC} $1" >&2; }

# Determine AUR Helper
if command -v paru &>/dev/null; then
    AUR="paru"
elif command -v yay &>/dev/null; then
    AUR="yay"
else
    log_err "Neither yay nor paru found! Please run ./install.sh first."
    exit 1
fi

log_step "1. Installing Desktop GUI Applications & Media Tools..."
"$AUR" -S --needed --noconfirm \
    google-chrome zen-browser-bin brave-bin \
    antigravity-ide visual-studio-code-bin vscodium-bin android-studio neovim vim \
    lmstudio-bin ollama claude tgpt \
    spotify vlc mpv obs-studio gimp easyeffects 5db5-equalizer-lv2-bin pwvucontrol \
    vesktop telegram-desktop zoom obsidian \
    postman-bin mongodb-compass-bin mongosh-bin mysql-workbench burpsuite \
    dolphin thunar unityhub

log_step "2. Installing Development Runtimes & Virtualization..."
"$AUR" -S --needed --noconfirm \
    bun nodejs npm yarn pnpm \
    python python-pip python-pipx python-virtualenv uv \
    python-pandas python-matplotlib python-pycryptodome \
    rustup cargo \
    go \
    jdk17-openjdk gradle flutter \
    docker docker-compose qemu-full libvirt wine winetricks \
    tesseract tesseract-data-chi_sim tesseract-data-chi_tra tesseract-data-jpn tesseract-data-kor tesseract-data-lat tesseract-data-spa \
    cloudflare-warp-bin proton-vpn-cli

log_step "3. Installing Global NPM Development Tools..."
if command -v npm &>/dev/null; then
    sudo npm install -g vercel eas-cli snarkjs openclaw clawhub @okxweb3/a2a-node pear || true
fi

log_step "4. Installing UV & Pipx Standalone Python Tools..."
if command -v uv &>/dev/null; then
    uv tool install free-claude-code || true
    uv tool install graphifyy || true
    uv tool install nano-pdf || true
fi
if command -v pipx &>/dev/null; then
    pipx install litellm || true
    pipx install weasyprint || true
fi

log_step "5. Installing Web3 & ZK-SNARK Toolchains..."
# Foundry
if ! command -v forge &>/dev/null; then
    log_warn "Installing Foundry..."
    curl -L https://foundry.paradigm.xyz | bash || true
    export PATH="$HOME/.foundry/bin:$PATH"
    foundryup || true
fi

# Noir / Nargo
if ! command -v nargo &>/dev/null; then
    log_warn "Installing Noir/Nargo..."
    curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash || true
    export PATH="$HOME/.nargo/bin:$PATH"
    noirup || true
fi

# Circom & Stylus
if command -v cargo &>/dev/null; then
    cargo install --force cargo-stylus || true
    cargo install cargo-odra || true
    cargo install --git https://github.com/iden3/circom.git circom || true
fi

# Go Language Server
if command -v go &>/dev/null; then
    go install golang.org/x/tools/gopls@latest || true
fi

log_step "6. Installing IDE Extensions..."
IDE_EXTENSIONS=(
    anthropic.claude-code
    carmelopullara.material-dark-extra
    esbenp.prettier-vscode
    fill-labs.dependi
    github.vscode-github-actions
    golang.go
    llvm-vs-code-extensions.vscode-clangd
    mermaidchart.vscode-mermaid-chart
    mhutchie.git-graph
    miguelsolorio.min-theme
    ms-azuretools.vscode-containers
    ms-azuretools.vscode-docker
    ms-python.debugpy
    ms-python.python
    ms-python.vscode-pylance
    ms-python.vscode-python-envs
    ms-toolsai.jupyter
    ms-vscode.cmake-tools
    ms-vscode.cpptools
    ms-vscode.cpptools-extension-pack
    openai.chatgpt
    redhat.java
    ritwickdey.liveserver
    rust-lang.rust-analyzer
    shd101wyy.markdown-preview-enhanced
    tamasfe.even-better-toml
    tomoki1207.pdf
    usernamehw.errorlens
    vscjava.vscode-gradle
    vscjava.vscode-java-pack
    wakatime.vscode-wakatime
)

for ext in "${IDE_EXTENSIONS[@]}"; do
    if command -v antigravity-ide &>/dev/null; then
        antigravity-ide --install-extension "$ext" --force 2>/dev/null || true
    fi
    if command -v code &>/dev/null; then
        code --install-extension "$ext" --force 2>/dev/null || true
    fi
done

log_step "7. Enabling System & User Services..."
sudo systemctl enable --now \
    NetworkManager.service \
    bluetooth.service \
    sddm.service \
    docker.service \
    mariadb.service \
    warp-svc.service \
    fstrim.timer \
    systemd-timesyncd.service || true

systemctl --user enable --now \
    pipewire.socket \
    pipewire-pulse.socket \
    wireplumber.service \
    ydotool.service \
    gnome-keyring-daemon.socket || true

log_success "All applications, runtimes, toolchains, and services installed and initialized!"
