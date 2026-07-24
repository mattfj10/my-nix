{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    blueman
    feh
    libnotify
    playerctl
    pulseaudio
    xclip
  ];
}
