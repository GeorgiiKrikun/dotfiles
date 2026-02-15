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

### Single Exit and Detaching
The startup script is designed to let you close the terminal window with a single `Ctrl-D` when you are done, while still allowing you to access the underlying shell if needed.

- **To close the terminal window**: Exit all shells within the tmux session (e.g., press `Ctrl-D` in all windows/panes). When the tmux session ends, the terminal will automatically close.
- **To access the underlying shell**: Detach from tmux by pressing `Prefix + d`. This will return you to the plain shell without closing the terminal. From here, you can run tmux manually to create a new session (e.g., `tmux new -s my-other-session`).

### Customization
- **Change default session**: Set `TMUX_SESSION` environment variable (e.g., `TMUX_SESSION=work kitty`).
- **Bypass tmux**: Set `SKIP_TMUX=1` environment variable (e.g., `SKIP_TMUX=1 kitty`).

## Managing Multiple Sessions
The recommended way to manage multiple sessions is from within tmux:
- `Prefix + :new -s <name>`: Create a new session.
- `Prefix + s`: Interactively switch between sessions.
- This approach avoids nesting sessions and keeps your workflow clean.

## Persistence
- `Prefix + Ctrl-s`: Save tmux session (including Neovim sessions).
- `Prefix + Ctrl-r`: Restore tmux session.
- `tmux-continuum` is enabled to automatically save sessions every 15 minutes.

### Neovim Session Restoration
To ensure Neovim sessions are fully restored (windows, tabs, etc.) after a reboot:
1. The `tpope/vim-obsession` plugin is installed.
2. An autocommand has been added to automatically start `Obsession` when opening Neovim inside tmux without arguments.
3. This creates a `Session.vim` file in your working directory, which `tmux-resurrect` uses to restore your exact Neovim state.
