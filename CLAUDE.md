# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A dotfiles repo for bootstrapping a Linux (Ubuntu 22.04) development environment. It installs and symlinks configs for Zsh + Oh My Zsh, Neovim, and CLI utilities (ripgrep, bottom, fd, yazi, lazygit, Node.js).

## Running the full install

```bash
./install.sh
```

This calls `deps/bootstrap.sh` first (installs sudo, wget, curl, git, make, Rust/cargo, cargo-binstall, just), then uses `just` recipes in `deps/justfile` and `configs/*/justfile` to install and wire up each component.

## Task runner

All component-level operations use `just`. Run `just --list` in any directory containing a `justfile` to see available recipes.

Key justfiles:
- `deps/justfile` — installs individual tools (neovim, zsh, lazygit, node, ripgrep, fd, etc.)
- `configs/zsh/justfile` — runs `setup.sh` to symlink `.zshrc`
- `configs/nvim/justfile` — runs `setup.sh` to symlink the nvim config dir
- `nix/justfile` — runs a Nix shell with all tools (`just run`)

## Config linking

`setup.sh` in each config subdirectory backs up any existing config and creates a symlink:
- `~/.zshrc` → `configs/zsh/.zshrc`
- `~/.config/nvim` → `configs/nvim/nvim-conf/`

## Neovim config

Based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), using lazy.nvim as the plugin manager. Entry point is `configs/nvim/nvim-conf/init.lua`.

Plugins are split across `lua/config/plugins/`:
- `core.lua` — general editing plugins
- `lsp.lua` — LSP + completion
- `debug.lua` — DAP (nvim-dap + vscode-cpptools debugger)
- `git.lua` — git integration
- `copilot.lua` — GitHub Copilot
- `ui.lua`, `themes.lua` — UI

Profile detection in `init.lua` switches behavior based on hostname (`georgii-laptop` = work profile). Machine-local overrides go in `lua/local_config.lua`.

## Testing installs with Docker

`docker-compose.yaml` (at repo root) includes all test environments. Each lives in `test_dockers/<name>/`:

| Container | Purpose |
|---|---|
| `basic` | Root-user Ubuntu install test |
| `sudo_user` | Creates a non-root user with sudo |
| `user` | Full install on top of `sudo_user` |
| `bare-bones` | Minimal Ubuntu image |

Build and run a specific test container:
```bash
docker compose build dep_test    # or whichever service name
docker compose run dep_test bash
```

All containers mount the repo at `/root/dotfiles` (or the user home equivalent).

## Nix alternative

`nix/flake.nix` packages all the same tools via Nix. Uses a pinned nixpkgs commit for Neovim 11 (`nixpkgs-neovim11`) because the main unstable channel has a newer version. Run an isolated shell with everything available:

```bash
cd nix && just run
```
