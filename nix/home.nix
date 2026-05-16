{ config, lib, pkgs, pkgs-neovim11, rustToolchain, ... }:
let
    dotfiles = "${config.home.homeDirectory}/software/dotfiles";
in
{
    home.username = "nixtest";
    home.homeDirectory = "/home/nixtest";

    # When replacing nixtest with your real user, update the two lines above.
    # This version string must match the home-manager release you bootstrap with.
    home.stateVersion = "24.11";

    programs.home-manager.enable = true;

    home.file = {
        ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink
            "${dotfiles}/configs/nvim/nvim-conf";
        ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink
            "${dotfiles}/configs/kitty";
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
    ]) ++ [
        rustToolchain
    ] ++ (with pkgs-neovim11; [ neovim ]);
}
