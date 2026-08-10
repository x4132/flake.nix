{
  description = "x4132's nix configs (macOS + prod server)";

  inputs = {
    # server (NixOS)
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # macOS (nix-darwin master requires the nixpkgs-unstable branch)
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # server
    agenix.url = "github:ryantm/agenix";

    sandbox-nuc0.url = "path:./hosts/sandbox-nuc0";
    sandbox-nuc0.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-darwin,
      nix-darwin,
      nix-homebrew,
      agenix,
      ...
    }:
    {
      # $ sudo darwin-rebuild switch --flake .#framework16-pro
      darwinConfigurations."framework16-pro" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self; };
        modules = [
          ./hosts/framework16-pro
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;

              user = "johndoe";

              autoMigrate = true;
            };
          }
        ];
      };

      # $ sudo darwin-rebuild switch --flake .#framework13
      darwinConfigurations."framework13" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self; };
        modules = [
          ./hosts/framework13
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;

              user = "msvc";

              autoMigrate = true;
            };
          }
        ];
      };

      # $ sudo nixos-rebuild switch --flake .#x4132-prod0
      nixosConfigurations.x4132-prod0 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/x4132-prod0/configuration.nix
          ./hosts/x4132-prod0/hardware-configuration.nix
          ./hosts/x4132-prod0/services/nginx.nix
          ./hosts/x4132-prod0/services/arrs.nix
          ./hosts/x4132-prod0/services/homepage.nix
          ./hosts/x4132-prod0/services/docker.nix
          ./hosts/x4132-prod0/services/site.nix
          agenix.nixosModules.default
          {
            environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
          }
        ];
      };

      # $ sudo nixos-rebuild switch --flake .#sandbox-nuc0
      nixosConfigurations.sandbox-nuc0 = inputs.sandbox-nuc0.nixosConfigurations.sandbox-nuc0;
    };
}
