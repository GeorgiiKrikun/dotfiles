{
    description = "My core system dependencies";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        rust-overlay.url = "github:oxalica/rust-overlay";
        neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    };

    outputs = { self, nixpkgs, rust-overlay, nvim-nightly-overlay} :
        let
            system = "x86_64-linux"; # Use "aarch64-darwin" if you ever move to an Apple Silicon Mac
            overlays = [ (import rust-overlay) (import neovim-nightly-overlay) ];
            pkgs = import nixpkgs { inherit system overlays; };
            rustToolchain = pkgs.rust-bin.stable.latest.default;
        in {
            # This creates a custom "package" that bundles all your tools
            packages.${system}.default = pkgs.buildEnv {
                name = "my-core-packages";
                paths = (with pkgs; [
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
                    # sudo probably won't work
                    wget
                    curl
                    git
                    unzip
                    neovim
                    lazygit
                    nodejs
                    gnumake
                    just
                    kitty
                ]) ++ [
                    rustToolchain
                ];
            };
        };
}
