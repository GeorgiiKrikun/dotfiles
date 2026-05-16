{
    description = "My core system dependencies";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-neovim11.url = "github:nixos/nixpkgs/832efc09b4caf6b4569fbf9dc01bec3082a00611";
        rust-overlay.url = "github:oxalica/rust-overlay";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, nixpkgs-neovim11, rust-overlay, home-manager, flake-utils }:
        let
            supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

            mkPkgs = system:
                import nixpkgs {
                    inherit system;
                    overlays = [ (import rust-overlay) ];
                    config.allowUnfree = true;
                };

            mkHomeConfig = system:
                let
                    pkgs = mkPkgs system;
                    pkgs-neovim11 = import nixpkgs-neovim11 { inherit system; };
                    rustToolchain = pkgs.rust-bin.stable.latest.default;
                in home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    extraSpecialArgs = { inherit pkgs-neovim11 rustToolchain; };
                    modules = [ ./home.nix ];
                };
        in
        flake-utils.lib.eachSystem supportedSystems (system:
            let
                pkgs = mkPkgs system;
                pkgs-neovim11 = import nixpkgs-neovim11 { inherit system; };
                rustToolchain = pkgs.rust-bin.stable.latest.default;
            in {
                packages.default = pkgs.buildEnv {
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
                        bitwarden-cli
                    ]) ++ [
                        rustToolchain
                    ] ++ (with pkgs-neovim11; [neovim]);
                };
            }
        ) // {
            homeConfigurations = {
                "nixtest"     = mkHomeConfig "x86_64-linux";
                "nixtest-mac" = mkHomeConfig "aarch64-darwin";
            };
        };
}
