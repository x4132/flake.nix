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

    authentik-server = {
      image = "ghcr.io/goauthentik/server:2026.2.2";
      cmd = [ "server" ];
      environmentFiles = [ config.age.secrets.authentik.path ];
      ports = [ "127.0.0.1:36080:9000" ];
      volumes = [
        "/var/lib/authentik/data:/data"
        "/var/lib/authentik/certs:/certs"
        "/var/lib/authentik/custom-templates:/templates"
      ];
      extraOptions = [ "--shm-size=512m" ];
    };

    authentik-worker = {
      image = "ghcr.io/goauthentik/server:2026.2.2";
      cmd = [ "worker" ];
      environmentFiles = [ config.age.secrets.authentik.path ];
      volumes = [
        "/var/lib/authentik/data:/data"
        "/var/lib/authentik/certs:/certs"
        "/var/lib/authentik/custom-templates:/templates"
        "/var/run/docker.sock:/var/run/docker.sock"
      ];
      extraOptions = [ "--shm-size=512m" ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/authentik 0755 root root -"
    "d /var/lib/authentik/data 0755 root root -"
    "d /var/lib/authentik/certs 0755 root root -"
    "d /var/lib/authentik/custom-templates 0755 root root -"
  ];
}
