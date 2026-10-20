{ pkgs, self, ... }:
{

  nix.enable = false;
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../../common/darwin-packages.nix
    ../../common/darwin-settings.nix
  ];

  # host-specific packages (merged with common/darwin-packages.nix)
  environment.systemPackages = [
    pkgs.lazygit
    pkgs.ssm-session-manager-plugin
    pkgs.temporal-cli
    pkgs.temporal
    pkgs.ffmpeg
    pkgs.postgresql
    pkgs.valkey
    pkgs.redis
    pkgs.pi-coding-agent
    pkgs.claude-code
    (pkgs.google-cloud-sdk.withExtraComponents (
      with pkgs.google-cloud-sdk.components;
      [
        gke-gcloud-auth-plugin
      ]
    ))
    pkgs.rsync
    pkgs.duckdb
    pkgs.buf
    pkgs.github-cli
    pkgs._1password-cli

    # kubernetes
    pkgs.argo-workflows # `argo` CLI for Argo Workflows
    pkgs.argocd
    pkgs.kubectl
    pkgs.kubernetes-helm # `helm`
    pkgs.helm-ls
  ];

  # host-specific casks (merged with common/darwin-packages.nix)
  homebrew.casks = [
    "lm-studio"
    "obsidian"
    "tigervnc"
    "caido"
    "mongodb-compass"
    "kameleo"
    "headlamp"
    "dbeaver-community"
    "helium-browser"
    "linear"
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  programs.fish.enable = true;

  # use the 1Password SSH agent (enable it in 1Password > Settings > Developer)
  programs.ssh.extraConfig = ''
    Host *
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  '';

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  system.primaryUser = "johndoe";

  # Let johndoe run sudo without a password
  security.sudo.extraConfig = ''
    johndoe ALL=(ALL) NOPASSWD: ALL
  '';

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
