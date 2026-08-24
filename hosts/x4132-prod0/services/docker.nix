{ config, lib, pkgs, virtualisation, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers = {
    qbt-wireguard = {
      image = "tenseiken/qbittorrent-wireguard:latest";
      ports = ["0.0.0.0:31080:8080"];
      environment = {
        QBT_LEGAL_NOTICE = "confirm";
        LAN_NETWORK = "LAN_NETWORK=192.168.0.0/24";
        PUID = "993";
        PGID = "990";
      };
      volumes = [
        "/home/qbt/config:/config"
        "/home/qbt/downloads:/downloads"
      ];
      extraOptions = ["--cap-add=NET_ADMIN"];
    };
  };
}
