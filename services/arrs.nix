{ config, lib, pkgs, ... }:

{
  services = {
    # .*arr
    bazarr.enable = true;
    prowlarr.enable = true;
    sonarr.enable = true;
    radarr.enable = true;
  };
}
