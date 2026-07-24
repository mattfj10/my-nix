{ pkgs, ... }:
{
  hardware = {
    bluetooth.enable = true;
    steam-hardware.enable = true;
  };

  programs.dconf.enable = true;
  qt.platformTheme = "gnome";

  services = {
    displayManager = {
      defaultSession = "none+i3";
      gdm.enable = false;
    };
    picom = {
      enable = true;
      fade = true;
      fadeDelta = 10;
      settings = {
        corner-radius = 5;
        shadow = true;
        shadow-offset-x = -7;
        shadow-offset-y = -7;
        shadow-opacity = 0.4;
        shadow-radius = 20;
      };
    };
    printing.enable = true;
    xserver = {
      displayManager.lightdm.greeters.gtk = {
        enable = true;
        theme = {
          name = "palenight";
          package = pkgs.spacx-gtk-theme;
        };
      };
      enable = true;
      windowManager.i3.enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };
}
