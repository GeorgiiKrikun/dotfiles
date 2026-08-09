{
    description = "Portable sops/age secrets tooling (devshell)";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    };

    outputs = { self, nixpkgs }:
        let
            supportedSystems = [
                "x86_64-linux"
                "aarch64-linux"
                "aarch64-darwin"
            ];

            forAllSystems = f:
                nixpkgs.lib.genAttrs supportedSystems
                    (system: f (import nixpkgs { inherit system; }));
        in
        {
            devShells = forAllSystems (pkgs: {
                default = pkgs.mkShell {
                    packages = with pkgs; [
                        sops
                        age
                        ssh-to-age
                        rbw
                        just
                    ];

                    # Every recipe looks for the personal age key here.
                    shellHook = ''
                        export SOPS_AGE_KEY_FILE="''${SOPS_AGE_KEY_FILE:-$HOME/.config/sops/age/keys.txt}"
                    '';
                };
            });
        };
}
