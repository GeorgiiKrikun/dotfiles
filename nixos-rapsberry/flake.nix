{
  description = "NixOS Raspberry Pi 5 TV Box";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi";
  };

  outputs = { self, nixpkgs, nixos-raspberrypi, ... }:
  {
    nixosConfigurations.rpi5 = nixos-raspberrypi.lib.nixosSystem {
      inherit nixpkgs;
      system = "aarch64-linux";
      modules = [
        nixos-raspberrypi.nixosModules.trusted-nix-caches
        nixos-raspberrypi.nixosModules.raspberry-pi-5.base
        nixos-raspberrypi.nixosModules.raspberry-pi-5.page-size-16k
        nixos-raspberrypi.nixosModules.raspberry-pi-5.display-rp1
        ./configuration.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
