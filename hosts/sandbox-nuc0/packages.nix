{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    font-awesome
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Text Editors
    vim
    neovim
    nano
    emacs

    # General Utilities
    coreutils
    wget
    wget2
    curl
    ffmpeg
    chezmoi
    ripgrep
    tree
    rsync
    btop
    htop
    fastfetch
    imagemagick
    yazi
    fzf
    bitwarden-cli
    signal-cli

    # Software Development Utilities
    git
    git-lfs
    github-cli
    amp-cli
    tmux
    zellij
    awscli2
    ssm-session-manager-plugin
    temporal-cli
    postgresql
    valkey
    pi-coding-agent
    lazygit
    (google-cloud-sdk.withExtraComponents (
      with google-cloud-sdk.components;
      [
        gke-gcloud-auth-plugin
      ]
    ))
    duckdb
    buf
    terraform
    terragrunt
    argo-workflows
    argocd
    kubernetes
    kubernetes-helm
    helm-ls
    codex
    claude-code
    opencode

    # General Applications
    spotify
    tigervnc
    signal-desktop
    obsidian
    firefox
    helium

    # Software Development Applications
    kitty
    zed-editor
    package-version-server # for Zed!
    vscode
    ghidra
    github-desktop
    redisinsight
    headlamp
    mongodb-compass
    caido-desktop
    burpsuite
    dbeaver-bin
    starship

    # Language Servers, Daemons, Et cetera.
    ## Nix
    nil
    nixd

    ## Python
    # python312Minimal
    # python312Packages.httpx
    # python312Packages.httpx-ws
    uv

    ## C/C++ (+Build Tools)
    cmake
    pkg-config
    gcc
    autoconf

    ## Go
    go

    ## Rust
    rustup

    ## Node
    nodejs_26
    pnpm
  ];

  virtualisation.docker.enable = true;
}
