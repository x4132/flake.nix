{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    albert
    waybar
    mako
    awww
    pulseaudio
    xdg-desktop-portal
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xdg-utils
    xwayland-satellite
    pulsemixer
    swaylock
    adwaita-icon-theme
    adwaita-fonts
    adwaita-qt
    bibata-cursors
    playerctl
  ];

  programs.niri.enable = true;
}
