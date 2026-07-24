{ localPkgs, pkgs, ... }:
{
  home.packages = [
    localPkgs.brightness-notify
    pkgs.brightnessctl
    localPkgs.i3-rofi-switchers
    pkgs.i3lock
    pkgs.i3status
    pkgs.lightlocker
    pkgs.maim
    pkgs.pavucontrol
    pkgs.xdotool
  ];
}
