{
    description = "My core system dependencies";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager }:
        let
            supportedSystems = [
                "x86_64-linux" 
                "aarch64-linux" 
                "aarch64-darwin"
            ];

            mkPkgs = system:
                import nixpkgs {
                    inherit system;
                    config.allowUnfree = true;
                };

            mkHomeConfig = system:
                let
                    pkgs = mkPkgs system;
                in home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    modules = [ ./home.nix ];
                };

            mkHomeContainerConfig = system:
                let
                    pkgs = mkPkgs system;
                in home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
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
