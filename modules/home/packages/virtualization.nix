{ localPkgs, pkgs, ... }:
{
  home.packages = [
    pkgs.vagrant
    localPkgs.vboxmanage-wrapper
  ];
}
