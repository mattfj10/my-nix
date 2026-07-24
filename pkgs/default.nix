{ pkgs }:
{
  brightness-notify = pkgs.callPackage ./brightness-notify { };
  i3-rofi-switchers = pkgs.callPackage ./i3-rofi-switchers { };
  vboxmanage-wrapper = pkgs.callPackage ./vboxmanage-wrapper { };
  view-file = pkgs.callPackage ./view-file { };
}
