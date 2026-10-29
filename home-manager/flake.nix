{
    description = "My core system dependencies";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager }:
        let
            supportedSystems = [
                "x86_64-linux" 
                "aarch64-linux" 
                "aarch64-darwin"
            ];

            # Packages pulled from nixos-unstable while 26.05 lags behind.
            # claude-code needs >= 2.1.280 for Opus 5.5; cursor-cli for freshness.
            unstableOverlay = system: final: prev:
                let
                    unstable = import nixpkgs-unstable {
                        system = system;
                        config.allowUnfree = true;
                    };
                in {
                    inherit (unstable) claude-code cursor-cli;
                };

            mkPkgs = system:
                import nixpkgs {
                    system = system;
                    config.allowUnfree = true;
                    overlays = [ (unstableOverlay system) ];
                };

            mkHomeConfig = system:
                let
                    pkgs = mkPkgs system;
                in home-manager.lib.homeManagerConfiguration {
                    pkgs = pkgs;
                    modules = [ ./home.nix ];
                };

            mkHomeContainerConfig = system:
                let
                    pkgs = mkPkgs system;
                in home-manager.lib.homeManagerConfiguration {
                    pkgs = pkgs;
                    modules = [ ./home-container.nix ];
                };
        in
        {
            homeConfigurations = {
                "desktop"     = mkHomeConfig "x86_64-linux";
                "mac-desktop" = mkHomeConfig "aarch64-darwin";
                "container"   = mkHomeContainerConfig "x86_64-linux";
            };
        };
}
