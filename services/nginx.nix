{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfProxyExtraConfig = ''
    set_real_ip_from 173.245.48.0/20;
    set_real_ip_from 103.21.244.0/22;
    set_real_ip_from 103.22.200.0/22;
    set_real_ip_from 103.31.4.0/22;
    set_real_ip_from 141.101.64.0/18;
    set_real_ip_from 108.162.192.0/18;
    set_real_ip_from 190.93.240.0/20;
    set_real_ip_from 188.114.96.0/20;
    set_real_ip_from 197.234.240.0/22;
    set_real_ip_from 198.41.128.0/17;
    set_real_ip_from 162.158.0.0/15;
    set_real_ip_from 104.16.0.0/13;
    set_real_ip_from 104.24.0.0/14;
    set_real_ip_from 172.64.0.0/13;
    set_real_ip_from 131.0.72.0/22;
    real_ip_header CF-Connecting-IP;
  '';

  cfHostFw = ''
    proxy_http_version 1.1;
    proxy_buffering off;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  '';

  mkVirtualHost =
    {
      domain,
      port,
      extraLocations ? { },
    }:
    {
      enableACME = false;
      forceSSL = true;

      sslCertificate =
        if (builtins.match ".*cocogoat.club" domain) != null then
          "/etc/ssl/cocogoat.club.pem"
        else
          "/etc/ssl/${domain}.pem";

      sslCertificateKey =
        if (builtins.match ".*cocogoat.club" domain) != null then
          "/etc/ssl/cocogoat.club.key"
        else
          "/etc/ssl/${domain}.key";

      locations =
        if port != null then
          {
            "/" = {
              proxyPass = "http://localhost:${toString port}";
              extraConfig = cfHostFw;
            };
          }
        else
          { } // extraLocations;
    };
in
{
  services.nginx = {
    enable = true;

    virtualHosts = {
      "default" = {
        default = true;
        forceSSL = true;
        enableACME = false;

        sslCertificate = "/etc/ssl/cocogoat.club.pem";

        sslCertificateKey = "/etc/ssl/cocogoat.club.key";

        locations = {
          "/" = {
            extraConfig = ''
              return 444;
            '';
          };
        };
      };

      "x4132.dev" =
        mkVirtualHost {
          domain = "x4132.dev";
          port = 20080;
        }
        // {
          extraConfig = cfProxyExtraConfig;
        };

      "cocogoat.club" = mkVirtualHost {
        domain = "cocogoat.club";
        port = 30080;
      };

      "status.cocogoat.club" = mkVirtualHost {
        domain = "status.cocogoat.club";
        port = 30081;
      };

      "jellyfin.cocogoat.club" = mkVirtualHost {
        domain = "jellyfin.cocogoat.club";
        port = 8096;
      };

      "bazarr.cocogoat.club" = mkVirtualHost {
        domain = "bazarr.cocogoat.club";
        port = 6767;
      };

      "prowlarr.cocogoat.club" = mkVirtualHost {
        domain = "prowlarr.cocogoat.club";
        port = 9696;
      };

      "sonarr.cocogoat.club" = mkVirtualHost {
        domain = "sonarr.cocogoat.club";
        port = 8989;
      };

      "radarr.cocogoat.club" = mkVirtualHost {
        domain = "radarr.cocogoat.club";
        port = 7878;
      };

      "qbt.cocogoat.club" = mkVirtualHost {
        domain = "qbt.cocogoat.club";
        port = 31080;
      };

      "paste.cocogoat.club" = mkVirtualHost {
        domain = "paste.cocogoat.club";
        port = 32080;
      };

      "news.cocogoat.club" = mkVirtualHost {
        domain = "news.cocogoat.club";
        port = 33080;
      };

      "chat.x4132.dev" = mkVirtualHost {
        domain = "x4132.dev";
        port = 34080;
      };

      "chat.cocogoat.club" = mkVirtualHost {
        domain = "chat.cocogoat.club";
        port = 34080;
      };
    };
  };
}
