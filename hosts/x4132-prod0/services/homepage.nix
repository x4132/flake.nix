{ config, lib, pkgs, ... }:

{
  services.homepage-dashboard = {
    enable = true;
    listenPort = 30080;
    settings = {
      title = "msvc's homepage";
      description = "Home Launcher";
      startUrl = "https://cocogoat.club";
      background = {
        image = "https://4kwallpapers.com/images/wallpapers/macos-monterey-wwdc-21-stock-dark-mode-5k-3840x2160-5585.jpg";
        blur = "sm";
        brightness = "75";
      };
      theme = "dark";
    };
    allowedHosts = "cocogoat.club,localhost:30080";
    services = [
      {
        ".*arr" = [
          {
            "Bazarr" = {
              description = "Subtitle Manager";
              href = "https://bazarr.cocogoat.club";
            };
          }
          {
            "Prowlarr" = {
              description = "Index Manager";
              href = "https://prowlarr.cocogoat.club";
            };
          }
          {
            "Radarr" = {
              description = "Movie Collection Manager";
              href = "https://radarr.cocogoat.club";
            };
          }
          {
            "Sonarr" = {
              description = "TV Show Collection Manager";
              href = "https://sonarr.cocogoat.club";
            };
          }
        ];
      }
      {
        "Downloaders" = [
          {
            "Qbt" = {
              description = "Qbt";
              href = "https://qbt.cocogoat.club";
            };
          }
        ];
      }
      {
        "Media" = [
          {
            "Jellyfin" = {
              description = "The Free Software Media System";
              href = "https://jellyfin.cocogoat.club";
            };
          }
        ];
      }
      {
        "Misc" =[
          {
            "MicroBin" = {
              description = "pastes";
              href = "https://paste.cocogoat.club";
            };
          }
          {
            "MiniFlux" ={
              description = "News Reader";
              href = "https://news.cocogoat.club";
            };
          }
          {
            "NetData" ={
              description = "system monitoring";
              href = "https://app.netdata.cloud";
            };
          }
        ];
      }
    ];
  };
}
