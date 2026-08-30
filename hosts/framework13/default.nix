{ pkgs, self, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    # dev environment
    pkgs.neovim
    pkgs.fish
    pkgs.starship

    # Python
    pkgs.python312
    pkgs.python312Packages.httpx
    pkgs.python312Packages.httpx-ws
    pkgs.pipx
    pkgs.uv

    # C/C++ and embedded development
    pkgs.cmake
    pkgs.pkg-config
    pkgs.libsigrok
    pkgs.sigrok-cli
    pkgs.esptool
    pkgs.tio
    pkgs.openocd

    # Lua
    pkgs.lua
    pkgs.luarocks

    # Typst
    pkgs.typst

    # Nix
    pkgs.nil
    pkgs.nixd

    # Go and Rust
    pkgs.go
    pkgs.rustup

    # General tools
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
    pkgs.curl
    pkgs.imagemagick
    pkgs.fzf
    pkgs.yazi
    pkgs.chezmoi
    pkgs.gradle
    pkgs.awscli2
    pkgs.bitwarden-cli
    pkgs.git-lfs
    pkgs.google-cloud-sdk
    pkgs.azure-cli
    pkgs.terraform
    pkgs.terragrunt

    # CTF and reverse-engineering tools
    pkgs.sqlmap
    pkgs.radare2
    pkgs.binwalk
    pkgs.exiftool
    pkgs.netcat
    pkgs.pngcheck
    pkgs.nmap

    # Libraries
    pkgs.autoconf
  ];

  homebrew = {
    enable = true;
    brews = [
      "python-setuptools"
      "opencode"
      "syncthing"
      "ffmpeg"
      "gh"
      "node"
      "deno"
      "mole"
      "cyan"
      "rfidresearchgroup/proxmark3/proxmark3"
      "ghidra"
    ];
    casks = [
      "adium"
      "burp-suite"
      "bruno"
      "coconutbattery"
      "ghostty"
      "kitty"
      "github"
      "google-chrome"
      "jordanbaird-ice@beta"
      "linearmouse"
      "legcord"
      "mx-power-gadget"
      "orbstack"
      "spotify"
      "termius"
      "tunnelblick"
      "visual-studio-code"
      "wireshark-app"
      "zed"
      "iina"
      "aerospace"
      "affinity"
      "prismlauncher"
      "audacity"
      "slack"
      "bambu-studio"
      "yubico-authenticator"
      "redis-insight"
      "codex-app"
      "signal"
      "bitwarden"
      "moonlight"
      "preform"
      "t3-code"
      "sfm"
      "homerow"
      "zbar"
    ];
    taps = [
      "sst/tap"
      "nikitabobko/tap"
    ];
    onActivation.cleanup = "zap";
  };

  nix.settings.experimental-features = "nix-command flakes";

  programs.fish.enable = true;

  system.configurationRevision = self.rev or self.dirtyRev or null;

  system.stateVersion = 6;

  system.primaryUser = "msvc";

  nixpkgs.hostPlatform = "aarch64-darwin";
}
