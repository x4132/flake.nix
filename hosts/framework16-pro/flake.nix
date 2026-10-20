{
  description = "framework16-pro (macOS)";

  inputs = {
    # nix-darwin master requires the nixpkgs-unstable branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    {
      self,
      nix-darwin,
      nix-homebrew,
      ...
    }:
    {
      # $ sudo darwin-rebuild switch --flake .#framework16-pro
      darwinConfigurations."framework16-pro" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self; };
        modules = [
          ./default.nix
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
    };
}
