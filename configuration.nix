# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  networking.hostName = "x4132-prod0"; # Define your hostname.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.msvc = {
    isNormalUser = true;
    group = "msvc";
    extraGroups = [
      "wheel"
      "docker"
      "config_editors"
    ];
    # packages = with pkgs; [
    # ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID8ah2yYFV/gxr7gcGdSlhd6K7PpXbknDU5yeIeBC7ik msvc@nyarch"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDj7h0Nv3q/WRzMGTqTOn/MkH2InkbNt+45A94IT6yz3DwBxpnFhek6ovBeuQfTG7OUprahc0/VuUCdmtIAidy/FmAsJzsCUDRbNhiGja2r0ad+ICw4Lpd2D8pprkDLJKGU2AvNi8pWPY8ba8MXYcplfribGg5GH/6HIzOv/0is/hbDz5OLczpTZERLItADO5ilzOeQc06FkxHBTbFrJ7BclHuy09dDiBXJOuQek9QXJncJWv3LOwOow+DWTILFMS+SV2r+1zkWOSv0sGbX31QS4hHvACldKoHvt4V74TiSv+9mHoDcNJzpcqTrvI52jub4sgQOxerS2Qdwp46UN1HFLmYmxX0kwrgI+AN8F5JKH8USjRCNmfQqBE/hXzZXJnYDpRZQy+IoO9a3eoTmwAxYgn7GbGYPpZmNSeZ/2lR2jVcVuJj/1OPp0B1hEjFCVnwYNRmz4tTcJMusDAiY6w44U4r4wwZ0wU1jVUl7RmlLAyWrnbpI0Xe2O8pArMhsOQU= msvc@framework13"
    ];
  };

  users.users.qbt = {
    isSystemUser = true;
    createHome = true;
    home = "/home/qbt";
    homeMode = "777";
    group = "qbt";
    extraGroups = [ ];
  };

  users.groups = {
    msvc = { };
    qbt = { };
    config_editors = { };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # editors
    vim
    neovim

    # utilities
    wget
    curl
    git
    tmux
    tree
    zip
    unzip
    bash
    fish
    zsh
    coreutils
    htop
    btop
    claude-code
    chezmoi

    # languages
    tree-sitter
    gcc
    nodejs_24
    go
    cargo
    bun
    nixd
    nil
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  # Nix Settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.download-buffer-size = 524288000;

  # Time
  time.timeZone = "Etc/UTC";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # age secrets
  age.secrets.microbin.file = "/etc/nixos/secrets/microbin.age";
  age.secrets.miniflux.file = "/etc/nixos/secrets/miniflux.age";

  # Enabled Services
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
      openFirewall = false;
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      openFirewall = true;
    };

    resolved = {
      enable = true;
      dnssec = "false";
      domains = [ "~." ];
      fallbackDns = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
      ];
    };

    jellyfin.enable = true;

    microbin = {
      enable = true;
      settings = {
        MICROBIN_HIDE_LOGO = true;
        MICROBIN_PORT = 32080;
        MICROBIN_GC_DAYS = 180;
        MICROBIN_ENABLE_READONLY = true;
        MICROBIN_READONLY = true;
        MICROBIN_DEFAULT_EXPIRY = "never";
        MICROBIN_ETERNAL_PASTA = true;
      };
      passwordFile = config.age.secrets.microbin.path; # set MICROBIN_ADMIN_USERNAME MICROBIN_ADMIN_PASSWORD MICROBIN_UPLOADER_PASSWORD
    };

    miniflux = {
      enable = true;
      config = {
        LISTEN_ADDR = "0.0.0.0:33080";
        # DATABASE_URL = "postgres://miniflux:miniflux@localhost/miniflux?sslmode=disable";
      };
      adminCredentialsFile = config.age.secrets.miniflux.path; # set ADMIN_USERNAME ADMIN_PASSSWORD
    };

    uptime-kuma = {
      enable = true;
      settings = {
        PORT = "30081";
      };
    };

    netdata = {
      enable = true;
      package = pkgs.netdata.override {
        withCloudUi = true;
      };
    };

    qemuGuest.enable = true;
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      80
      443
      8080
    ];
    allowedUDPPorts = [ ];
    checkReversePath = "loose";
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}
