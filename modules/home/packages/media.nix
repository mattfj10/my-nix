{ pkgs, ... }:
{
  home.packages = with pkgs; [
    audacity
    biglybt
    freetube
    spotify
  ];
}
