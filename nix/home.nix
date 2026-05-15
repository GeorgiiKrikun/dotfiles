{ config, pkgs, pkgs-neovim11, rustToolchain, ... }:
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
        ".zshrc".source = config.lib.file.mkOutOfStoreSymlink
            "${dotfiles}/configs/zsh/.zshrc";
        ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink
            "${dotfiles}/configs/nvim/nvim-conf";
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
        kitty
    ]) ++ [
        rustToolchain
    ] ++ (with pkgs-neovim11; [ neovim ]);
}
