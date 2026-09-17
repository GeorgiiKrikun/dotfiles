{
    description = "NixOS system configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    };

    outputs = { self, nixpkgs }:
    {
        # Impure: configuration.nix imports /etc/nixos/hardware-configuration.nix
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./configuration.nix ];
        };
    };
}
