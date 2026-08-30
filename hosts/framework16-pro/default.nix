{ pkgs, self, ... }:
{

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    # dev env
    pkgs.neovim
    pkgs.fish

    # languages

    ## python
    pkgs.python312
    pkgs.python312Packages.httpx
    pkgs.python312Packages.httpx-ws
    pkgs.uv

    ## C/C++ (+ Embedded)
    pkgs.cmake
    pkgs.pkg-config

    # typst
    pkgs.typst

    ## nix
    pkgs.nil
    pkgs.nixd

    ## go
    pkgs.go

    # rust
    pkgs.rustup

    # tools
    pkgs.ripgrep
    pkgs.pcre2
    pkgs.tree
    pkgs.wget
    pkgs.wget2
    pkgs.btop
    pkgs.htop
    pkgs.fastfetch
    pkgs.tmux
    pkgs.zellij
    # pkgs.coreutils
    pkgs.curl
    pkgs.imagemagick
    pkgs.fzf
    pkgs.yazi
    pkgs.chezmoi
    pkgs.awscli2
    pkgs.ssm-session-manager-plugin
    pkgs.bitwarden-cli
    pkgs.git-lfs
    pkgs.temporal-cli
    pkgs.temporal
    pkgs.ffmpeg
    pkgs.postgresql
    pkgs.valkey
    pkgs.redis
    pkgs.pi-coding-agent
    pkgs.lazygit
    (pkgs.google-cloud-sdk.withExtraComponents (
      with pkgs.google-cloud-sdk.components;
      [
        gke-gcloud-auth-plugin
      ]
    ))
    pkgs.rsync
    pkgs.duckdb
    pkgs.buf

    pkgs.terraform
    pkgs.terragrunt

    # kubernetes
    pkgs.argo-workflows # `argo` CLI for Argo Workflows
    pkgs.argocd
    pkgs.kubernetes-helm # `helm`
    pkgs.helm-ls

    # lib
    pkgs.autoconf
  ];

  homebrew = {
    enable = true;
    brews = [
      # apparently the nix one is super outdated
      "gh"

      "node"
      "ghidra"
      "mole"
    ];
    casks = [
      "coconutbattery"
      "kitty"
      "github"
      "jordanbaird-ice@beta"
      "linearmouse"
      "spotify"
      "visual-studio-code"
      "zed"
      "aerospace"
      "redis-insight"
      "codex-app"
      "bitwarden"
      "signal"
      "lm-studio"
      "obsidian"
      "tigervnc"
      "orbstack"
      "burp-suite"
      "caido"
      "mx-power-gadget"
      "mongodb-compass"
      "kameleo"
      "headlamp"
      "redis-insight"
      "dbeaver-community"
    ];
    taps = [
      "nikitabobko/tap"
    ];
    onActivation.cleanup = "zap";
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  system.primaryUser = "johndoe";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
