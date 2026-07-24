{ localPkgs, pkgs, ... }:
{
  home.packages = [
    pkgs.dolphin-emu
    pkgs.pcsx2
    pkgs.r2modman
    pkgs.unityhub
    localPkgs.view-file
  ];
}
