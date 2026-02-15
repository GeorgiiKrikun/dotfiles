# Tmux Configuration for Dotfiles

A tmux configuration has been added with integration for Neovim session persistence.

## Keybinds

### Prefix
The default prefix has been changed from `Ctrl-b` to `Ctrl-a` to avoid conflicts with Neovim's default `Ctrl-b` (Scroll Backwards) and common terminal shortcuts.

- `Ctrl-a` is now the prefix.
- To send a literal `Ctrl-a` to the application, press `Ctrl-a` then `a`.

### Pane Management
- `Prefix + |`: Split pane horizontally (side-by-side).
- `Prefix + -`: Split pane vertically (top-and-bottom).
- `Prefix + r`: Reload tmux configuration.
- Mouse support is enabled for switching panes, resizing, and scrolling.

## Conflicts and Resolutions

### Neovim
- **Ctrl-b**: By changing the tmux prefix to `Ctrl-a`, we avoid overriding Neovim's default `Ctrl-b` (page up/scroll back).
- **Ctrl-e**: Neovim uses `Ctrl-e` for Snacks explorer. We avoided using `Ctrl-e` in tmux.
- **Session Persistence**: `tmux-resurrect` is configured to save and restore Neovim sessions. This requires the `tpope/vim-obsession` plugin which has been added to the Neovim configuration.

### Kitty
- **Ctrl-Shift**: Kitty's default shortcuts use `Ctrl-Shift`. These do not conflict with tmux's `Ctrl-a` prefix.
- **Clipboard**: Tmux is configured to work with the system clipboard via `tmux-sensible`.

### Shell (Zsh)
- **Ctrl-a**: In many shells, `Ctrl-a` moves the cursor to the beginning of the line. With tmux using it as a prefix, you may need to press `Ctrl-a` twice or use the tmux escape sequence to send it to the shell.

## Automatic Startup
New interactive Zsh and Bash sessions will automatically attempt to attach to a tmux session named `default` or create it if it doesn't exist.

To allow exiting the terminal with a single `Ctrl-D`, the startup script is configured to exit the outer shell if tmux exits normally. If tmux fails to start, the script will not exit, providing a fallback shell for debugging.

## Persistence
- `Prefix + Ctrl-s`: Save tmux session (including Neovim sessions).
- `Prefix + Ctrl-r`: Restore tmux session.
- `tmux-continuum` is enabled to automatically save sessions every 15 minutes.

### Neovim Session Restoration
To ensure Neovim sessions are fully restored (windows, tabs, etc.) after a reboot:
1. The `tpope/vim-obsession` plugin is installed.
2. An autocommand has been added to automatically start `Obsession` when opening Neovim inside tmux without arguments.
3. This creates a `Session.vim` file in your working directory, which `tmux-resurrect` uses to restore your exact Neovim state.
