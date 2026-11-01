{ lib, pkgs, ... }:
let
    use = app: types: lib.genAttrs types (_: app);

    # With no arguments, opens the current directory.
    open = pkgs.writeShellScriptBin "open" ''
        exec ${pkgs.handlr-regex}/bin/handlr open "''${@:-.}"
    '';

    # xdg-open ignores Terminal=true, so a plain nvim.desktop has nowhere to run
    # when launched from a GUI app. Stay in the current terminal if there is one.
    nvimOpen = pkgs.writeShellScriptBin "nvim-open" ''
        if [ -t 1 ]; then
            exec nvim "$@"
        fi
        exec kitty nvim "$@"
    '';
in
lib.mkIf pkgs.stdenv.isLinux {
    home.packages = [ open nvimOpen pkgs.handlr-regex ];

    programs.zsh.shellAliases.o = "open";

    xdg.desktopEntries.nvim-open = {
        name = "Neovim";
        exec = "${nvimOpen}/bin/nvim-open %F";
        terminal = true;
        noDisplay = true;
    };

    # Source of truth for what opens what: mimeapps.list is a read-only symlink,
    # so `handlr set` and app self-registration don't stick. Add handlers here.
    xdg.configFile."mimeapps.list".force = true;
    xdg.mimeApps = {
        enable = true;
        defaultApplications =
            use "nvim-open.desktop" [
                "inode/directory"
                "text/plain"
                "text/markdown"
                "text/rust"
                "text/x-c++src"
                "text/x-chdr"
                "text/x-csrc"
                "text/x-log"
                "text/x-lua"
                "text/x-python"
                "application/toml"
                "application/x-shellscript"
                "application/yaml"
            ]
            // use "imv.desktop" [ "image/png" "image/jpeg" "image/webp" "image/gif" ]
            // use "mpv.desktop" [ "video/mp4" "video/x-matroska" "video/webm" ]
            // use "org.pwmt.zathura.desktop" [ "application/pdf" ]
            // use "com.google.Chrome.desktop" [
                "text/html"
                "x-scheme-handler/http"
                "x-scheme-handler/https"
            ]
            // use "kitty.desktop" [ "x-scheme-handler/terminal" ]
            // use "org.telegram.desktop.desktop" [
                "x-scheme-handler/tg"
                "x-scheme-handler/tonsite"
            ]
            // use "claude-code-url-handler.desktop" [ "x-scheme-handler/claude-cli" ];
    };
}
