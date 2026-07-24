{ pkgs, ... }:
{
  home.packages = with pkgs; [
    calibre
    file
    kdePackages.dolphin
    kdePackages.kio-extras
    libreoffice
    obsidian
  ];
}
