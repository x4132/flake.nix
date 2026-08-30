{ pkgs, ... }:
let
  niri-notify-focus = pkgs.stdenvNoCC.mkDerivation {
    pname = "niri-notify-focus";
    version = "unstable-2026-05-20";

    src = pkgs.fetchFromGitHub {
      owner = "Oaklight";
      repo = "niri-notify-focus";
      rev = "f0e3a7c12abf3b8c371e6f9dd8e55101a1476d37";
      hash = "sha256-h7pvvN/wZ5MQz/XfQn9N51mjmLiAIsfYc3ZFbCMd+Mw=";
    };

    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [
      (pkgs.python3.withPackages (ps: [
        ps.dbus-python
        ps.pygobject3
      ]))
    ];

    installPhase = ''
      install -Dm755 niri-notify-focus $out/bin/niri-notify-focus
      patchShebangs $out/bin/niri-notify-focus
    '';
  };
in
{
  # Focuses the exact source window (by sender PID -> process tree -> niri
  # window) when a notification action is invoked, since apps don't get an
  # xdg-activation token from makoctl/mako action invocation.
  systemd.user.services.niri-notify-focus = {
    description = "Focus source window on notification action (niri)";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    path = [ pkgs.niri ];
    serviceConfig = {
      ExecStart = "${niri-notify-focus}/bin/niri-notify-focus";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
}
