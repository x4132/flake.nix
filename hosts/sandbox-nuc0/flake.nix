{
  description = "sandbox-nuc0 (NixOS)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      nixpkgs,
      helium,
      codex-desktop-linux,
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
          codex-desktop-linux.nixosModules.default
          {
            programs.codexDesktopLinux.enable = true;
          }
          ./configuration.nix
        ];
      };
    };
}
