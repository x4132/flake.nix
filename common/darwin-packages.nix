{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # shell
    neovim
    fish

    # languages
    python312
    python312Packages.httpx
    python312Packages.httpx-ws
    uv
    cmake
    pkg-config
    typst
    nil
    nixd
    go
    rustup

    # utils
    ripgrep
    pcre2
    tree
    wget
    wget2
    btop
    htop
    fastfetch
    tmux
    zellij
    curl
    imagemagick
    fzf
    yazi
    chezmoi
    awscli2
    bitwarden-cli
    git-lfs
    terraform
    terragrunt

    autoconf
  ];

  homebrew = {
    enable = true;
    brews = [
      # apparently the nix one is super outdated
      "gh"

      "node"
      "corepack"
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
      "nikitabobko/tap/aerospace"
      "redis-insight"
      "codex-app"
      "bitwarden"
      "signal"
      "orbstack"
      "burp-suite"
      "mx-power-gadget"
      "t3-code"
    ];
    onActivation.cleanup = "zap";
  };
}
