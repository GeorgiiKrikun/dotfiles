{
    description = "My core system dependencies";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
        nixpkgs-neovim11.url = "github:nixos/nixpkgs/832efc09b4caf6b4569fbf9dc01bec3082a00611";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, nixpkgs-neovim11, home-manager, flake-utils }:
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
                    pkgs-neovim11 = import nixpkgs-neovim11 { inherit system; };
                in home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    extraSpecialArgs = { inherit pkgs-neovim11; };
                    modules = [ ./home.nix ];
                };

            mkHomeContainerConfig = system:
                let
                    pkgs = mkPkgs system;
                    pkgs-neovim11 = import nixpkgs-neovim11 { inherit system; };
                in home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    extraSpecialArgs = { inherit pkgs-neovim11; };
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
