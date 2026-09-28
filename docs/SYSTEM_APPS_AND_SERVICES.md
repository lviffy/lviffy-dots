# Complete System Software, Services & Development Tools Guide

> **An exhaustive, single-source-of-truth inventory of every application, systemd service, CLI tool, developer runtime, and IDE extension installed on this machine.**  
> Use this document when setting up a fresh Arch Linux installation to restore your complete workflow.

---

## Table of Contents
1. [Systemd Services (System & User)](#1-systemd-services)
2. [Desktop GUI Applications](#2-desktop-gui-applications)
3. [Developer Runtimes & Compilers](#3-developer-runtimes--compilers)
4. [Global Package Manager Toolchains (NPM, UV, Pipx)](#4-global-package-manager-toolchains)
5. [Web3, Blockchain & Zero-Knowledge Toolchains](#5-web3-blockchain--zero-knowledge-toolchains)
6. [IDE Extensions (Antigravity & VS Code)](#6-ide-extensions)
7. [Hardware & OCR Language Packs](#7-hardware--ocr-language-packs)
8. [Automated One-Click Provisioning Script](#8-automated-one-click-provisioning-script)

---

## 1. Systemd Services

### System-Level Services
Enable with `sudo systemctl enable --now <service>`:

| Service | Purpose |
| :--- | :--- |
| **`NetworkManager.service`** | Primary network connection manager |
| **`bluetooth.service`** | Bluetooth daemon for peripherals & audio |
| **`sddm.service`** | Display manager / graphical login screen |
| **`systemd-timesyncd.service`** | Automatic NTP network time synchronization |
| **`fstrim.timer`** | Weekly NVMe/SSD TRIM optimization and wear leveling |
| **`docker.service`** | Docker container virtualization daemon |
| **`mariadb.service`** | Local MariaDB / MySQL relational database server |
| **`warp-svc.service`** | Cloudflare WARP 1.1.1.1 VPN client daemon |
| **`cups.service`** | Common Unix Printing System |
| **`nvidia-persistenced.service`** | Keeps NVIDIA GPU initialized across sleep/wake states |

### User-Level Services
Enable with `systemctl --user enable --now <service>`:

| Service | Purpose |
| :--- | :--- |
| **`pipewire.socket`** | High-performance Wayland audio routing |
| **`pipewire-pulse.socket`** | PulseAudio drop-in compatibility socket |
| **`wireplumber.service`** | Modular PipeWire session and device manager |
| **`ydotool.service`** | Virtual Wayland input automation (used by Quickshell actions) |
| **`gnome-keyring-daemon.socket`** | Secret storage and secure credential keyring |

---

## 2. Desktop GUI Applications

### Web Browsers
- **Google Chrome** (`google-chrome` - AUR) — Primary daily driver
- **Zen Browser** (`zen-browser-bin` - AUR) — Gecko-based aesthetic browser
- **Brave Browser** (`brave-bin` - AUR) — Chromium privacy browser
- **Microsoft Edge** (`microsoft-edge-stable-bin` - AUR)
- **Mozilla Firefox** (`firefox` - Official)

### IDEs, Code Editors & AI Suites
- **Antigravity IDE** (`antigravity-ide` - AUR) & **Antigravity CLI** (`antigravity`)
- **Visual Studio Code** (`visual-studio-code-bin` - AUR)
- **VSCodium** (`vscodium-bin` - AUR)
- **Android Studio** (`android-studio` - AUR)
- **Neovim** (`neovim`) & **Vim** (`vim`)
- **LM Studio** (`lmstudio-bin` - AUR) — Local offline LLM inference
- **Claude Desktop** (`claude` - AUR)
- **Ollama** (`ollama` - Official) — Terminal AI models
- **tgpt** (`tgpt` - AUR) — Terminal GPT assistant
- **Burp Suite** (`burpsuite` - Official) — Security & HTTP proxy testing
- **Unity Hub** (`unityhub` - AUR) — Unity game engine

### Media, Graphics & Audio
- **Spotify** (`spotify` - AUR)
- **VLC Media Player** (`vlc` - Official)
- **MPV** (`mpv` - Official) — Fast video player and engine for live wallpapers
- **OBS Studio** (`obs-studio` - Official) — Screen recording & streaming
- **GIMP** (`gimp` - Official) — Image manipulation
- **EasyEffects** (`easyeffects` - Official) + `5db5-equalizer-lv2-bin` (AUR) — Audio equalizer & DSP
- **Pwvucontrol** (`pwvucontrol` - AUR) — Modern PipeWire volume mixer

### Social & Productivity
- **Vesktop** (`vesktop` - AUR) — Enhanced Discord with Wayland screen-share audio
- **Telegram Desktop** (`telegram-desktop` - Official)
- **Zoom** (`zoom` - AUR)
- **Obsidian** (`obsidian` - Official) — Markdown knowledge base
- **Postman** (`postman-bin` - AUR) — API client
- **MongoDB Compass** (`mongodb-compass-bin` - AUR) & `mongosh-bin`
- **MySQL Workbench** (`mysql-workbench` - Official)
- **Dolphin** (`dolphin`) & **Thunar** (`thunar`) — Desktop file managers

---

## 3. Developer Runtimes & Compilers

- **Bun**: High-speed JavaScript/TypeScript runtime & package manager (`bun`)
- **Node.js**: Standard JS runtime with `npm`, `yarn`, and `pnpm`
- **Python**: Python 3.12 / 3.14 via `uv`, `python-pip`, `python-pipx`, `python-virtualenv`
  - Core libraries: `python-pandas`, `python-matplotlib`, `python-pycryptodome`
- **Rust Toolchain**: `cargo`, `rustup`, `rustc`, `rust-analyzer`, `rustfmt`, `clippy`
- **Go Toolchain**: `go` compiler & `gopls` language server
- **Java / Android**: `jdk17-openjdk`, `gradle`, Android SDK CLI tools
- **Flutter**: Flutter SDK (`flutter` - AUR)
- **Virtualization**: `docker`, `docker-compose`, `qemu-full`, `libvirt`, `wine`, `winetricks`

---

## 4. Global Package Manager Toolchains

### Global NPM Tools
Install with `npm install -g <package>`:
- **`vercel`** — Vercel cloud deployment CLI
- **`eas-cli`** — Expo Application Services (React Native / mobile app builds)
- **`openclaw` & `clawhub`** — OpenClaw autonomous AI agent framework
- **`snarkjs`** — zk-SNARK proof generator and verifier
- **`@okxweb3/a2a-node`** — OKX Web3 Agent-to-Agent protocol daemon
- **`pear`** — P2P decentralized app runtime by Holepunch

### Pipx & UV Standalone Python Tools
Install with `uv tool install <tool>` or `pipx install <tool>`:
- **`free-claude-code`** (`fcc-init`, `free-claude-code`) — Autonomous AI coding CLI
- **`litellm` & `litellm-proxy`** — Unified multi-LLM proxy server
- **`graphify` & `graphify-mcp`** — Code knowledge graph generator & Model Context Protocol server
- **`weasyprint`** — Visual HTML/CSS to PDF document converter
- **`nano-pdf`** — Command-line PDF manipulation tool
- **`uv` & `uvx`** — Fast Python package manager

---

## 5. Web3, Blockchain & Zero-Knowledge Toolchains

- **Foundry** (Ethereum smart contract development framework):
  - Provides: `forge`, `cast`, `anvil`, `chisel`, `foundryup` (in `~/.foundry/bin`)
  - Install: `curl -L https://foundry.paradigm.xyz | bash && foundryup`
- **Noir / Nargo** (Zero-Knowledge programming language):
  - Provides: `nargo`, `noir-inspector`, `noir-profiler`, `noirup` (in `~/.nargo/bin`)
  - Install: `curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash && noirup`
- **Circom** (zk-SNARK arithmetic circuit compiler):
  - Install: `cargo install --git https://github.com/iden3/circom.git circom`
- **Arbitrum Stylus**:
  - Install: `cargo install --force cargo-stylus`
- **Odra Smart Contracts**:
  - Install: `cargo install cargo-odra`
- **Stellar CLI**:
  - Provides: `stellar`

---

## 6. IDE Extensions

Compatible with **Antigravity IDE**, **VS Code**, and **VSCodium**:

| Category | Extensions |
| :--- | :--- |
| **Productivity & Tracking** | `wakatime.vscode-wakatime`, `usernamehw.errorlens`, `mhutchie.git-graph`, `ritwickdey.liveserver`, `fill-labs.dependi` |
| **Languages & Syntax** | `rust-lang.rust-analyzer`, `golang.go`, `ms-python.python`, `ms-python.vscode-pylance`, `vscjava.vscode-java-pack`, `redhat.java`, `llvm-vs-code-extensions.vscode-clangd`, `tamasfe.even-better-toml`, `esbenp.prettier-vscode` |
| **Diagrams & Docs** | `shd101wyy.markdown-preview-enhanced`, `mermaidchart.vscode-mermaid-chart`, `tomoki1207.pdf` |
| **AI & Cloud** | `anthropic.claude-code`, `openai.chatgpt`, `ms-azuretools.vscode-docker`, `ms-azuretools.vscode-containers`, `github.vscode-github-actions` |

---

## 7. Hardware & OCR Language Packs

- **NVIDIA GPU Stack**: `nvidia-open`, `nvidia-prime`, `nvidia-settings`, `envycontrol`
- **Screen Snip OCR (Tesseract)**:
  - `tesseract-data-chi_sim` (Simplified Chinese)
  - `tesseract-data-chi_tra` (Traditional Chinese)
  - `tesseract-data-jpn` (Japanese)
  - `tesseract-data-kor` (Korean)
  - `tesseract-data-lat` (Latin)
  - `tesseract-data-spa` (Spanish)

---

## 8. Automated One-Click Provisioning Script

To install every single application, runtime, and toolchain above on a fresh system, run:

```bash
cd ~/Projects/lviffy-dots
./setup/install-all-extras.sh
```
