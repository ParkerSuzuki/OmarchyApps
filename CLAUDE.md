# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repo holds `setup.sh`, a post-install script for [Omarchy](https://omarchy.com) (an Arch Linux + Hyprland desktop environment). Run it once after a fresh Omarchy install to restore personal apps and tools that Omarchy does not install by default.

## Running the script

```bash
./setup.sh
```

The script is idempotent — safe to re-run. It skips anything already installed.

## What Omarchy already provides

Do **not** add these to `setup.sh` — they are installed by Omarchy itself:

- Desktop: hyprland, waybar, mako, swaybg, walker, alacritty
- Apps: obsidian, spotify, signal-desktop, libreoffice, obs-studio, chromium, 1password
- Dev tools: neovim (omarchy-nvim), lazygit, lazydocker, docker, mise, git, github-cli, ripgrep, fzf, tmux, starship, bat, eza, btop
- Web apps: Discord, YouTube, GitHub, Figma, WhatsApp, ChatGPT, Zoom (chromium PWAs)

The full Omarchy base package list lives at `~/.local/share/omarchy/install/omarchy-base.packages`.

## Adding new packages

- **Official Arch repo**: add to `PACMAN_PKGS` array
- **AUR or omarchy custom repo**: add to `YAY_PKGS` array
- **npm globals**: add to `NPM_GLOBALS` array (installed after mise activates node)
- **pipx**: add to `PIPX_PKGS` array

Before adding a package, check if it's already in Omarchy base:
```bash
grep <package-name> ~/.local/share/omarchy/install/omarchy-base.packages
```

## Package sources

| Package | Source |
|---------|--------|
| `anki`, `calibre`, `gpodder`, `intellij-idea-community-edition`, `python-*` | Arch `extra` repo |
| `teams-for-linux` | AUR (built via yay) |
| `visual-studio-code-bin` | Omarchy custom repo (available via yay) |
| Node.js | mise (`~/.config/mise/config.toml`) |
| `@angular/cli`, `typescript` | npm global |
| `spotdl` | pipx |

## Manual steps after running

These cannot be automated and must be done manually:
- Sign into 1Password
- Sign into Microsoft Teams
- Restore Anki decks from backup
- Restore Obsidian vault (git clone or sync)
