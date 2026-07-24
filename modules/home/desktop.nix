{
  host,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ../../config/i3 ];

  services = {
    conky = {
      enable = true;
      extraConfig = builtins.readFile ../../config/conky/conky.conf;
    };
    dunst = import ../../config/dunst;
    polybar = import ../../config/polybar { inherit host lib pkgs; };
  };
}
