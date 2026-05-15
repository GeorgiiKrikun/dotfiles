{
    description = "My core system dependencies";


    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-neovim11.url = "github:nixos/nixpkgs/832efc09b4caf6b4569fbf9dc01bec3082a00611";
        rust-overlay.url = "github:oxalica/rust-overlay";
    };

    outputs = { self, nixpkgs, nixpkgs-neovim11, rust-overlay} :
        let
            system = "x86_64-linux"; # Use "aarch64-darwin" if you ever move to an Apple Silicon Mac
            overlays = [ (import rust-overlay) ];
            pkgs = import nixpkgs { inherit system overlays; };
            pkgs-neovim11 = import nixpkgs-neovim11 { inherit system; };
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
                    lazygit
                    nodejs
                    gnumake
                    just
                    kitty
                ]) ++ [
                    rustToolchain
                ] ++ (
                    with pkgs-neovim11; [neovim]
                );
            };
        };
}
