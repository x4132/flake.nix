{
  description = "sandbox-nuc0 (NixOS)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    {
      # $ sudo nixos-rebuild switch --flake .#sandbox-nuc0
      nixosConfigurations.sandbox-nuc0 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration.nix ];
      };
    };
}
