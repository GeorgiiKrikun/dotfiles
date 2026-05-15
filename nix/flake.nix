{
    description = "My core system dependencies";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        rust-overlay.url = "github:oxalica/rust-overlay";
    };

    outputs = { self, nixpkgs, rust-overlay }:
        let
            system = "x86_64-linux"; # Use "aarch64-darwin" if you ever move to an Apple Silicon Mac
            overlays = [ (import rust-overlay) ];
            pkgs = nixpkgs.legacyPackages.${system};
            rustToolchain = pkgs.rust-bin.stable.latest.default;
        in {
            # This creates a custom "package" that bundles all your tools
            packages.${system}.default = pkgs.buildEnv {
                name = "my-core-packages";
                paths = (with pkgs; [
                    sudo
                    wget
                    curl
                    git
                    make
                    just
                ]) ++ [
                    rustToolchain
                ]
            };
        };
}
