# 💠 lviffy-shell

> **The modern, customized Quickshell desktop shell for lviffy-dots.**

[English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md)

---

## 🌟 Overview

`lviffy-shell` is a tailored, fluid desktop shell built using [Quickshell](https://quickshell.outfoxxed.me/). It features iOS/macOS styled control sliders, quick toggles, dock, right sidebar, workspace indicators, and dynamic palette extraction with Matugen.

## 🚀 Usage

`lviffy-shell` is automatically started by Hyprland on login:

```bash
qs -c lviffy-shell
```

To reload or restart the shell during runtime:
```bash
killall qs; qs -c lviffy-shell & disown
```

## 🎨 Theming & Wallpapers
- **Wallpaper Selector**: `Super + P` opens the wallpaper picker for both static images and live video wallpapers (`mpvpaper`).
- **Dynamic Theming**: Color palettes are dynamically extracted and synchronized across Qt, GTK, and terminal emulators via Matugen.
