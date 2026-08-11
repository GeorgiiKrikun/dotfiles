# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Nix-based personal system configuration for a Linux (NixOS) workstation running
the Hyprland Wayland desktop, plus a home-manager layer that also works on macOS
and inside containers. It manages:

- the NixOS system (`nixos/`)
- the per-user environment via home-manager (`home-manager/`)
- application configs consumed as out-of-store symlinks (`configs/`)
- an encrypted secrets store built on sops/age (`secrets/`)
- a Raspberry Pi 5 NixOS image (`nixos-rapsberry/`)

There is **no** `install.sh` / imperative bootstrap. Everything is applied with
Nix flakes, driven by `just` recipes.

## Layout

| Path | What it is |
|---|---|
| `nixos/` | NixOS system flake — `nixosConfigurations."nixos"` |
| `home-manager/` | home-manager flake — `home.nix` (workstation) imports `home-container.nix` (portable base) |
| `configs/` | App configs symlinked into `~/.config` by home-manager (kitty, hypr, waybar, mako, nvim, zsh) |
| `secrets/` | Standalone sops/age secrets tooling; encrypted data in the `store/` submodule |
| `nixos-rapsberry/` | Raspberry Pi 5 NixOS config (`nixosConfigurations.rpi5`, aarch64) |
| `nixos/` `hardware-configuration.nix` | Machine-specific, generated — don't hand-edit blindly |
| `utils/`, `wallpapers/` | Helper scripts and assets |

Images are tracked via git-lfs (`.gitattributes`). `secrets/store` is a git
submodule pointing at a **private** repo.

## Applying configuration

Each area has a `justfile`; run `just --list` in it to see recipes.

**System (NixOS):**
```bash
cd nixos && just switch      # sudo nixos-rebuild switch --flake .#nixos
```

**User environment (home-manager):**
```bash
cd home-manager && just switch          # picks .#desktop on Linux, .#nixtest-mac on Darwin
cd home-manager && just install-dotfiles # removes conflicting ~/.zshrc & ~/.config/nvim first, then switches
```
home-manager flake outputs: `desktop` (x86_64-linux), `mac-desktop`
(aarch64-darwin), `container` (portable base only).

**Raspberry Pi:** build/deploy `nixosConfigurations.rpi5` from `nixos-rapsberry/`
(aarch64; the workstation enables `boot.binfmt.emulatedSystems = [ "aarch64-linux" ]`
so it can build Pi closures under QEMU).

## home-manager structure

- `home-container.nix` — the portable base, and the only layer safe for containers.
  Defines zsh + oh-my-zsh, git, rbw, the leaf CLI toolset (ripgrep, fd, bottom,
  lazygit, neovim, just, jq, uv, nodejs, claude-code, …), and symlinks the nvim
  config. Identity falls back to `HM_USERNAME`/`HM_HOME` env vars for container use.
- `home.nix` — workstation layer. Imports the container base, sets the real
  `georgii` identity, symlinks GUI configs (kitty/hypr/waybar/mako), and adds
  desktop packages + user systemd services (gnome-keyring, polkit agent, ssh-agent).

Configs are linked with `config.lib.file.mkOutOfStoreSymlink` so edits under
`configs/` take effect live without a rebuild. zsh and nvim are wired up through
home-manager — there is no per-config `setup.sh`/`justfile` to run.

## Neovim config

Based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) with
lazy.nvim. Entry point `configs/nvim/nvim-conf/init.lua`; symlinked to
`~/.config/nvim` by home-manager (`home-container.nix`).

Plugins split across `lua/config/plugins/`:
- `core.lua` — general editing plugins
- `lsp.lua` — LSP + completion
- `debug.lua` — DAP (nvim-dap + vscode-cpptools)
- `git.lua` — git integration
- `copilot.lua` — GitHub Copilot
- `ui.lua`, `themes.lua` — UI

Profile detection in `init.lua` switches on hostname (`georgii-laptop` = work
profile). Machine-local overrides go in `lua/config`/`local_config.lua`.

## Secrets (sops/age)

Portable, versioned secrets committed **encrypted-at-rest**. The public
machinery lives here; encrypted data lives in the private `secrets/store`
submodule. Root of trust is a personal age key (`~/.config/sops/age/keys.txt`,
backed up in Bitwarden — never committed). SSH private keys are themselves stored
inside sops. Not yet wired into NixOS/home-manager (sops-nix is documented as a
future step).

```bash
cd secrets
just edit          # edit & re-encrypt store/secrets.yaml
just view          # decrypt to stdout
just rekey         # re-encrypt to current .sops.yaml recipients
just deploy-ssh    # materialize a stored SSH key onto a new machine
```

See `secrets/README.md` for the full trust model and first-time setup. Only
**public** age keys belong in `.sops.yaml`.

## Conventions

- Nix files use 4-space indentation.
- Flakes pin `nixpkgs` to `nixos-26.05` (the Pi uses `nixos-25.11`).
- `nixpkgs.config.allowUnfree = true` is set in both system and home layers.
- Ongoing ideas / TODOs live in `todo.md` and `long-plan-todo.md`.
