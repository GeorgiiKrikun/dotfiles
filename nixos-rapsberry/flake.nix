{
    description = "NixOS Raspberry Pi 5 TV Box";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
        nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs, nixos-raspberrypi, nixpkgs-unstable, ... }:
        {
            nixosConfigurations.rpi5 = nixos-raspberrypi.lib.nixosSystem {
                inherit nixpkgs;
                system = "aarch64-linux";
                specialArgs = {
                    pkgs-unstable = import nixpkgs-unstable {
                        system = "x86_64-linux";
                        config.allowUnfree = true;
                    };
                };
                modules = [
                    nixos-raspberrypi.nixosModules.trusted-nix-caches
                    nixos-raspberrypi.nixosModules.raspberry-pi-5.base
                    # NOTE: page-size-16k is an optional jemalloc memory optimization, not a
                    # correctness requirement. It forces a from-source rebuild of most of
                    # nixpkgs (Firefox, Hyprland, ...) because the results no longer match
                    # cache.nixos.org — so it's left OFF to keep everything substitutable.
                    nixos-raspberrypi.nixosModules.raspberry-pi-5.display-vc4
                    ./configuration.nix
                    ./hardware-configuration.nix
                ];

            };
        };
}
