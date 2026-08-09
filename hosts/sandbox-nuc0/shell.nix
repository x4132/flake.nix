{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    albert
    waybar
    mako
    swww
    pulseaudio
    xdg-desktop-portal
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xdg-utils
    xwayland-satellite
  ];

  programs.niri.enable = true;
}
