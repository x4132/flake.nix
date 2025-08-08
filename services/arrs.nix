{
  config,
  lib,
  pkgs,
  ...
}:

{
  services = {
    # .*arr
    bazarr.enable = true;
    bazarr.openFirewall = false;
    bazarr.listenPort = 6767;
    prowlarr.enable = true;
    sonarr.enable = true;
    radarr.enable = true;
  };
}
