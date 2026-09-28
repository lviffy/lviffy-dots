# 📋 Complete Inventory of Services & Applications

This document lists every active service, desktop application, and developer toolchain running on this machine. Use this reference when performing a clean Arch Linux reinstall.

---

## ⚙️ 1. Essential Systemd Services

### System Services (`sudo systemctl enable --now <service>`)
| Service | Purpose | Enable Command |
| :--- | :--- | :--- |
| **NetworkManager** | Network connection daemon | `sudo systemctl enable --now NetworkManager.service` |
| **bluetooth** | Bluetooth device manager | `sudo systemctl enable --now bluetooth.service` |
| **sddm** | Wayland/X11 Display Login Manager | `sudo systemctl enable --now sddm.service` |
| **systemd-timesyncd** | NTP automatic clock sync | `sudo systemctl enable --now systemd-timesyncd.service` |
| **fstrim.timer** | Weekly NVMe/SSD TRIM optimization | `sudo systemctl enable --now fstrim.timer` |
| **docker** | Container virtualization engine | `sudo systemctl enable --now docker.service` |
| **mariadb** | Local MySQL/MariaDB database server | `sudo systemctl enable --now mariadb.service` |
| **warp-svc** | Cloudflare WARP 1.1.1.1 VPN daemon | `sudo systemctl enable --now warp-svc.service` |
| **cups** | Printer management service | `sudo systemctl enable --now cups.service` |
| **nvidia-persistenced** | Keeps NVIDIA GPU initialized across sleeps | `sudo systemctl enable --now nvidia-persistenced.service` |

### User Services (`systemctl --user enable --now <service>`)
| Service | Purpose | Enable Command |
| :--- | :--- | :--- |
| **pipewire** | Core multimedia audio server | `systemctl --user enable --now pipewire.socket` |
| **pipewire-pulse** | PulseAudio compatibility layer | `systemctl --user enable --now pipewire-pulse.socket` |
| **wireplumber** | PipeWire session & hardware manager | `systemctl --user enable --now wireplumber.service` |
| **ydotool** | Virtual Wayland input automation for Quickshell | `systemctl --user enable --now ydotool.service` |
| **gnome-keyring-daemon** | Secret storage & keyring unlock | `systemctl --user enable --now gnome-keyring-daemon.socket` |

---

## 🖥️ 2. Desktop Applications & GUI Software

### 🌐 Web Browsers
- **Google Chrome**: `google-chrome` (AUR) — Primary daily browser
- **Zen Browser**: `zen-browser-bin` (AUR) — Gecko-based customizable browser
- **Brave Browser**: `brave-bin` (AUR) — Privacy & Chromium fallback
- **Microsoft Edge**: `microsoft-edge-stable-bin` (AUR)
- **Mozilla Firefox**: `firefox` (Official)

### 💻 IDEs, Editors & AI Workstations
- **Antigravity IDE**: `antigravity-ide` (AUR) & `antigravity`
- **Visual Studio Code / VSCodium**: `visual-studio-code-bin`, `vscodium-bin`
- **Android Studio**: `android-studio` (AUR)
- **Neovim / Vim**: `neovim`, `vim`
- **LM Studio**: `lmstudio-bin` (AUR) — Local LLM inference
- **Ollama**: `ollama` (Official) — Terminal AI models
- **Claude Desktop**: `claude` (AUR) & CLI URL handlers
- **Postman**: `postman-bin` (AUR) — API client
- **Burp Suite**: `burpsuite` (Official) — Security & proxy toolkit
- **Unity Hub**: `unityhub` (AUR) — Game development

### 🎨 Media, Graphics & Audio
- **Spotify**: `spotify` (AUR)
- **VLC Media Player**: `vlc` (Official)
- **MPV**: `mpv` (Official) — Video engine for `mpvpaper`
- **OBS Studio**: `obs-studio` (Official) — Screen & stream recording
- **GIMP**: `gimp` (Official) — Photo editing
- **EasyEffects**: `easyeffects` + `5db5-equalizer-lv2-bin` — Audio equalizer & DSP
- **Pwvucontrol**: `pwvucontrol` (AUR) — PipeWire volume mixer

### 💬 Social & Productivity
- **Vesktop**: `vesktop` (AUR) — Discord client with screen-share audio
- **Telegram Desktop**: `telegram-desktop` (Official)
- **Zoom**: `zoom` (AUR)
- **Obsidian**: `obsidian` (Official) — Markdown knowledge base
- **MongoDB Compass**: `mongodb-compass-bin` (AUR) & `mongosh-bin`
- **MySQL Workbench**: `mysql-workbench` (Official)
- **Dolphin & Thunar**: `dolphin`, `thunar` — GUI file managers

---

## 🛠️ 3. Developer Toolchains & Runtimes

### JavaScript / TypeScript & Web Runtimes
- **Bun**: `bun` (Fast JS/TS runtime & package manager)
- **Node.js & npm / yarn / pnpm**
- Modern dev aliases: `br` (`bun run dev`), `bi` (`bun install`), `dev` (`npm run dev`)

### Python Environment
- **Python**: `python` (3.12/3.14 via `uv`), `python-pip`, `python-pipx`, `python-virtualenv`
- Data libraries: `python-pandas`, `python-matplotlib`, `python-pycryptodome`

### Mobile & Multiplatform
- **Flutter**: `flutter` (AUR)
- **Java**: `jdk17-openjdk`
- **Gradle**: `gradle`

### Systems & Game Dev
- **Rust**: `cargo`, `rustup`
- **Go**: `go` compiler & tooling
- **C/C++**: `base-devel`, `cmake`, `ninja`

### Virtualization & Containers
- **Docker & Docker Compose**: `docker`, `docker-compose`
- **QEMU / KVM**: `qemu-full`, `libvirt`
- **Wine**: `wine`, `winetricks`

### Web3 & Crypto Toolchains
- **Foundry**: `forge`, `cast`, `anvil` (installed in `~/.foundry/bin`)
- **Nargo**: Noir ZK language toolchain (`~/.nargo/bin`)

---

## 🧰 4. CLI Utilities & Hardware Helpers

- **Terminal & Multiplexing**: `kitty`, `tmux`
- **Search & Navigation**: `eza`, `ripgrep`, `jq`, `fastfetch`, `bpytop`, `dua-cli`
- **NVIDIA GPU Management**: `nvidia-open`, `nvidia-prime`, `nvidia-settings`, `envycontrol`
- **Multi-language OCR**: `tesseract-data-chi_sim`, `tesseract-data-jpn`, `tesseract-data-kor`, `tesseract-data-spa` (for Quickshell region snip & search)
- **VPN Clients**: `cloudflare-warp-bin` (`warp-cli`), `proton-vpn-cli`
- **Media CLI**: `ani-cli`, `timg`, `catimg`

---

## 🚀 Quick Batch Reinstall Commands

### 1. Install Full Software Suite (via yay/paru)
```bash
yay -S --needed \
    google-chrome zen-browser-bin brave-bin \
    antigravity-ide visual-studio-code-bin neovim android-studio \
    lmstudio-bin ollama claude \
    spotify vlc mpv obs-studio gimp easyeffects pwvucontrol \
    vesktop telegram-desktop zoom obsidian \
    postman-bin mongodb-compass-bin mysql-workbench \
    docker docker-compose bun jdk17-openjdk flutter \
    cloudflare-warp-bin proton-vpn-cli \
    bpytop dua-cli eza ripgrep jq tmux fastfetch
```

### 2. Enable All Core Services in One Command
```bash
# Enable system services
sudo systemctl enable --now \
    NetworkManager.service \
    bluetooth.service \
    sddm.service \
    docker.service \
    mariadb.service \
    warp-svc.service \
    fstrim.timer \
    systemd-timesyncd.service

# Enable user services
systemctl --user enable --now \
    pipewire.socket \
    pipewire-pulse.socket \
    wireplumber.service \
    ydotool.service \
    gnome-keyring-daemon.socket
```

---

## ⚡ 5. Deep Ecosystem Packages & Specialized Dev Toolchains

Beyond Pacman and AUR, these tools are installed in your language runtimes and local paths:

### 📦 Global NPM Tools (`npm install -g <package>`)
```bash
npm install -g \
    vercel \
    eas-cli \
    snarkjs \
    openclaw \
    clawhub \
    @okxweb3/a2a-node
```

### 🐍 Pipx & UV Standalone Python CLI Tools
```bash
# Via UV tools:
uv tool install free-claude-code
uv tool install graphifyy
uv tool install nano-pdf

# Via pipx:
pipx install litellm
pipx install weasyprint
```

### 🦀 Rust, ZK-Proofs & Smart Contract Tools
- **Circom** (zk-SNARK circuit compiler):
  ```bash
  cargo install --git https://github.com/iden3/circom.git circom
  ```
- **Arbitrum Stylus**:
  ```bash
  cargo install --force cargo-stylus
  ```
- **Odra Smart Contracts**:
  ```bash
  cargo install cargo-odra
  ```
- **Foundry** (Ethereum smart contract development):
  ```bash
  curl -L https://foundry.paradigm.xyz | bash
  foundryup
  ```
- **Noir / Nargo** (Zero-Knowledge programming language):
  ```bash
  curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
  noirup
  ```

### 🍐 Pear (P2P App Runtime)
- Installed at `~/.config/pear/bin` via Holepunch:
  ```bash
  npm install -g pear
  ```

### 🐹 Go Development
- **gopls** (Language Server):
  ```bash
  go install golang.org/x/tools/gopls@latest
  ```

---

## 🧩 6. IDE Extensions (VS Code / Antigravity / VSCodium)

To automatically restore all your active IDE extensions on a fresh machine:

```bash
extensions=(
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
    usernamehw.errorlens
    vscjava.vscode-gradle
    vscjava.vscode-java-pack
    wakatime.vscode-wakatime
)

for ext in "${extensions[@]}"; do
    code --install-extension "$ext" --force 2>/dev/null || true
    antigravity-ide --install-extension "$ext" --force 2>/dev/null || true
done
```
