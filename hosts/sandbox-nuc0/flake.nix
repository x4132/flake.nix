{
  description = "sandbox-nuc0 (NixOS)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      nixpkgs,
      helium,
      ...
    }:
    {
      # $ sudo nixos-rebuild switch --flake .#sandbox-nuc0
      nixosConfigurations.sandbox-nuc0 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            nixpkgs.overlays = [
              helium.overlays.default
            ];
          }
          ./configuration.nix
        ];
      };
    };
}
