{ config, pkgs, ... }:
{
  # fish as login shell; uid must match the existing account (first macOS user = 501)
  users.knownUsers = [ config.system.primaryUser ];
  users.users.${config.system.primaryUser} = {
    uid = 501;
    shell = pkgs.fish;
  };

  # key repeat (units of 15 ms; lower = faster)
  system.defaults.NSGlobalDomain = {
    KeyRepeat = 2;
    InitialKeyRepeat = 25;
    ApplePressAndHoldEnabled = false; # hold key to repeat instead of accent picker
    "com.apple.keyboard.fnState" = true; # F1–F12 are function keys; hold fn for media keys
  };

  system.defaults.dock = {
    persistent-apps = [ ];
    persistent-others = [ "/Users/${config.system.primaryUser}/Downloads" ];
    show-recents = false;
    autohide = true;
  };
}
