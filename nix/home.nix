{ pkgs, pkgs-neovim11, rustToolchain, ... }:
{
    home.username = "nixtest";
    home.homeDirectory = "/home/nixtest";

    # When replacing nixtest with your real user, update the two lines above.
    # This version string must match the home-manager release you bootstrap with.
    home.stateVersion = "24.11";

    programs.home-manager.enable = true;

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
