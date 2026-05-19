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
            ''
        ];
        sessionVariables = {
            USER_ID = "1000";
            GROUP_ID = "1000";
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
    ]) ++ [
            rustToolchain
        ] ++ (with pkgs-neovim11; [ neovim ]);
}
