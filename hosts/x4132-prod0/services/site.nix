{ pkgs, lib, ... }:

let
  siteSource = pkgs.fetchFromGitHub {
    owner = "x4132";
    repo = "x4132.dev";
    rev = "ad9ad135d7d8a310d251a355be17c16a48133708";
    hash = "sha256-q/j95rsmK2V3Fa5GXjGbSu9gXP4sbjYSCo4zDjEjW/c=";
  };

  runtimeDir = "/run/x4132-site";

  launchScript = pkgs.writeShellScript "launch-x4132-site" ''
    set -e
    cp -r ${siteSource}/* ${runtimeDir}/
    cd ${runtimeDir}
    ${pkgs.bun}/bin/bun install --production
    exec ${pkgs.bun}/bin/bun run start
  '';
in 
{
  systemd.services.x4132-site = {
    description = "Personal Website - x4132.dev";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = launchScript;
      Restart = "always";
      User = "msvc";
      Environment = "NODE_ENV=production PORT=20080";
      ProtectSystem = "full";
      RuntimeDirectory="x4132-site";
    };
  };
}
