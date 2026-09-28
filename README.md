# 🌌 lviffy-dots

> **A standalone, reproducible, and beautifully crafted Hyprland + Quickshell (lviffy-shell) desktop suite for pure Arch Linux.**

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?logo=arch-linux&logoColor=white)
![Wayland](https://img.shields.io/badge/Wayland-Hyprland_0.56+-FF6F00)
![Quickshell](https://img.shields.io/badge/Quickshell-lviffy--shell-blueviolet)
![License](https://img.shields.io/badge/License-MIT-green)

---

## ✨ Features

- **Window Compositor**: Hyprland v0.56+ with custom `cleanDecel` / `cleanExit` non-cartoonish snappy animations, smooth window tile scaling, and subtle workspace fades.
- **Desktop Shell**: **`lviffy-shell`** (customized Quickshell environment with 31+ refined QML components, iOS/macOS frosted glass sliders, quick toggles, dock, and sidebar).
- **Theming & Color Synchronization**: Dynamic color palette extraction powered by **Matugen**, harmonizing GTK 3/4 (`adw-gtk3`), Qt (`kde-material-you-colors`), Kitty terminal, and Quickshell bars.
- **Wallpaper Engine**:
  - **Static Wallpapers**: Quickshell GUI selector (`Super + P`) with real-time palette regeneration.
  - **Live Video Wallpapers**: Seamless multi-monitor video playback powered by `mpvpaper`, automatic `ffmpeg` thumbnail color extraction, and persistent boot restoration (`__restore_video_wallpaper.sh`).
- **Lock Screen with Redundancy**:
  - Native Wayland session-lock protocol UI (`LockSurface.qml`, custom `PasswordChars.qml`, and PAM auth).
  - Wake focus recovery via `hypridle`.
  - Transparent fallback to `hyprlock` if the shell is ever stopped or updated.
- **Terminal & Shell**: Kitty (JetBrains Mono Nerd Font, beam cursor with trail) + Fish shell (starship prompt, fastfetch, eza, custom aliases `pamcan`, `wifi`, `q`).
- **Typography**: Bundled SF Pro Display / Text, Inter, and Google Sans Flex.

---

## 🚀 One-Command Installation on Pure Arch

On a fresh / minimal Arch Linux installation, simply execute:

```bash
git clone https://github.com/lviffy/lviffy-dots.git ~/Projects/lviffy-dots
cd ~/Projects/lviffy-dots
chmod +x install.sh
./install.sh
```

### What the installer handles automatically:
1. **System & GPU Verification**: Detects hardware; automatically activates NVIDIA Wayland environment flags if an NVIDIA GPU is present.
2. **AUR Helper**: Detects `paru` or `yay`, or bootstraps `yay-bin` automatically if neither is installed.
3. **Dependencies**: Installs all required official and AUR packages.
4. **Typography**: Deploys SF Pro, Inter, and Google Sans to `~/.local/share/fonts/` and refreshes `fc-cache`.
5. **Safe Config Deployment**: Automatically backs up any conflicting non-symlinked folders to `~/.config.backup.<timestamp>/` and creates atomic symlinks (`ln -sfn`) pointing to your repository.
6. **Python Virtualenv**: Builds a PEP 668 compliant venv at `~/.local/state/quickshell/.venv` with `pillow`, `requests`, and `dbus-python`.
7. **Wallpaper & Shell Setup**: Prepares `~/Pictures/Wallpapers/` and configures Fish as your default shell.

---

## ⌨️ Essential Keybindings

| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `Super + Return` | Terminal | Opens Kitty with Fish shell |
| `Super + F` | Web Browser | Launches Google Chrome |
| `Super + C` | Code Editor | Launches Antigravity IDE |
| `Super + X` | Music | Launches Spotify |
| `Super + P` | Wallpaper Selector | Toggles Quickshell Wallpaper Selector (Static + Video) |
| `Super + L` | Lock Screen | Locks session via Quickshell (or fallback `hyprlock`) |
| `Super + Escape` | System Settings | Toggles Quickshell control settings |
| `Super + Q` | Close Window | Closes focused window |
| `Super + Shift + S` | Screenshot | Interactive snip / region capture |
| `Super + Shift + R` | Screen Record | Starts screen recording |
| `Super + Space` | App Launcher | Fuzzel / Quickshell overview |

---

## 🛠️ Repository Structure

```text
lviffy-dots/
├── install.sh                  # Master orchestrator script
├── setup/                      # Modular installation stages
│   ├── 00-detect-system.sh     # System pre-flight & NVIDIA detection
│   ├── 01-aur-helper.sh       # yay / paru detection & auto-bootstrap
│   ├── 02-packages.sh         # Package installations
│   ├── 03-fonts.sh            # Typography deployment
│   ├── 04-configs.sh          # Atomic symlink deployment with backups
│   ├── 05-python-venv.sh      # PEP 668 Quickshell Python virtualenv
│   ├── 06-wallpaper-setup.sh  # Wallpaper directories & mpvpaper check
│   └── 07-shell-defaults.sh   # Sets Fish as default login shell
├── scripts/                    # Maintenance & migration utilities
│   ├── decouple-rename.sh     # Renames legacy shell -> lviffy-shell
│   ├── sanitize-paths.sh      # Normalizes /home/lviffy to $HOME
│   └── export-clean-config.sh # Sanitizes illogical-impulse config.example.json
├── pkglist/
│   ├── pacman.txt              # Official Arch Linux packages
│   └── aur.txt                 # AUR packages
├── config/                     # Source dotfiles symlinked to ~/.config/
│   ├── hypr/
│   ├── quickshell/lviffy-shell/
│   ├── illogical-impulse/
│   ├── kitty/
│   ├── fish/
│   ├── starship.toml
│   ├── matugen/
│   ├── cava/
│   ├── fastfetch/
│   ├── wlogout/
│   ├── fuzzel/
│   └── fontconfig/
├── fonts/                      # SF-Pro, Inter, Google Sans Flex
└── assets/                     # Starter wallpapers & media assets
```

---

## 🔒 Secret Management

Personal API keys (e.g. OpenRouter keys) should never be committed to Git.
- `config/illogical-impulse/config.example.json` provides the clean template.
- Your personal active `config.json` is automatically ignored via `.gitignore`.
- To re-generate the sanitized template after making changes to your local setup, run:
  ```bash
  ./scripts/export-clean-config.sh
  ```

---

## 📦 Full Software Suite & Development Toolchains

Looking to restore your full development suite, databases, AI tools, browsers, and systemd services on a clean installation?

- 📄 Read the complete inventory: [docs/SYSTEM_APPS_AND_SERVICES.md](docs/SYSTEM_APPS_AND_SERVICES.md)
- 🚀 Or run the automated all-in-one extra software provisioner:
  ```bash
  ./setup/install-all-extras.sh
  ```
