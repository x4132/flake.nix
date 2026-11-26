{ pkgs, self, ... }:
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../../common/darwin-packages.nix
    ../../common/darwin-settings.nix
  ];

  # host-specific packages (merged with common/darwin-packages.nix)
  environment.systemPackages = [
    # dev environment
    pkgs.starship

    # Python
    pkgs.pipx

    # C/C++ and embedded development
    pkgs.cmake
    pkgs.pkg-config
    pkgs.esptool
    pkgs.tio

    # Lua
    pkgs.lua
    pkgs.luarocks

    # General tools
    pkgs.gradle
    pkgs.google-cloud-sdk

    # CTF and reverse-engineering tools
    pkgs.sqlmap
    pkgs.radare2
    pkgs.binwalk
    pkgs.exiftool
    pkgs.netcat
    pkgs.pngcheck
    pkgs.nmap
    pkgs.sleuthkit
  ];

  # host-specific homebrew (merged with common/darwin-packages.nix)
  homebrew = {
    brews = [
      "python-setuptools"
      "opencode"
      "syncthing"
      "ffmpeg"
      "cyan"
      "ghidra"
    ];
    casks = [
      "bruno"
      "ghostty"
      "google-chrome"
      "legcord"
      "termius"
      "tunnelblick"
      "wireshark-app"
      "iina"
      "nikitabobko/tap/aerospace"
      "affinity"
      "prismlauncher"
      "audacity"
      "moonlight"
      "obs"
      "caido"
    ];
    taps = [
      "sst/tap"
    ];
  };

  nix.settings.experimental-features = "nix-command flakes";

  programs.fish.enable = true;

  system.configurationRevision = self.rev or self.dirtyRev or null;

  system.stateVersion = 6;

  system.primaryUser = "msvc";

  nixpkgs.hostPlatform = "aarch64-darwin";
}
