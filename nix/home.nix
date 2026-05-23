{ config, lib, pkgs, pkgs-neovim11, rustToolchain, ... }:
let
    dotfiles = "${config.home.homeDirectory}/software/dotfiles";
in
    {
    home.username = "georgii";
    home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/georgii" else "/home/georgii";
    home.stateVersion = "24.11";

    programs.home-manager.enable = true;

    home.file = {
        ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink
            "${dotfiles}/configs/nvim/nvim-conf";
        ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink
            "${dotfiles}/configs/kitty";
    } // lib.optionalAttrs (!pkgs.stdenv.isDarwin) {
            # cpptools ships Linux/Windows binaries only
            ".vscode/extensions/ms-vscode.cpptools/extension".source =
                "${pkgs.vscode-extensions.ms-vscode.cpptools}/share/vscode/extensions/ms-vscode.cpptools";
            ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink
                "${dotfiles}/configs/hypr";
            ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink
                "${dotfiles}/configs/waybar";
            ".config/mako".source = config.lib.file.mkOutOfStoreSymlink
                "${dotfiles}/configs/mako";
        };

    systemd.user.services.gnome-keyring-secrets = {
        Unit = {
            Description = "GNOME Keyring secrets component";
            WantedBy = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
        };
        Service = {
            Type = "simple";
            ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --foreground --components=secrets";
            Restart = "on-failure";
        };
    };

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
        Unit = {
            Description = "polkit-gnome-authentication-agent-1";
            WantedBy = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
        };
        Service = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
        };
    };

    programs.zsh = {
        enable = true;
        oh-my-zsh = {
            enable = true;
            theme = "robbyrussell";
            plugins = [ "git" "aws" "docker" "docker-compose" "extract" "pip" "rust" "kitty" "z" ];
        };
        initContent = lib.mkMerge [
            (lib.mkBefore ''
                ZSH_DISABLE_COMPFIX=true
            '')
            ''
                if (( $+commands[xhost] )); then
                    xhost +local:docker
                fi
                export USER_ID=$(id -u)
                export GROUP_ID=$(id -g)
            ''
        ];
        sessionVariables = {
            EDITOR = "nvim";
        };
    };

    services.ssh-agent.enable = true;

    programs.ssh = {
        enable = true;
        addKeysToAgent = "yes";
        matchBlocks."github.com" = {
            identityFile = "~/.ssh/gh";
        };
        matchBlocks."hetzner" = {
            hostname = "2a01:4f8:1c1f:afbf::1";
            user = "root";
            identityFile = "~/.ssh/hetzner";
        };
    };

    home.sessionPath = [ "$HOME/.npm-global/bin" ];

    home.activation.installClaudeCode = lib.hm.dag.entryAfter ["writeBoundary"] ''
        export PATH="${pkgs.nodejs}/bin:$PATH"
        ${pkgs.nodejs}/bin/npm install -g --prefix "$HOME/.npm-global" @anthropic-ai/claude-code
    '';

    home.packages = (with pkgs; [
        # --- The Unix Core ---
        coreutils
        findutils
        gnugrep
        gnused
        gawk
        bashInteractive
        # --- The Rust coreutils ---
        ripgrep
        bottom
        fd
        wget
        curl
        git
        unzip
        lazygit
        nodejs
        gnumake
        just
        nerd-fonts.commit-mono
        rbw
        nixd
        telegram-desktop
        python3
        python3Packages.pip
        uv
        zoom-us
        jq
    ]) ++ [
            rustToolchain
        ] ++ (with pkgs-neovim11; [ neovim ]);
}
