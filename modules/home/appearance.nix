{ config, pkgs, ... }:
{
  gtk = {
    enable = true;
    gtk4.theme = config.gtk.theme;
    iconTheme = {
      name = "gruvbox-dark-icons-gtk";
      package = pkgs.gruvbox-dark-icons-gtk;
    };
    theme = {
      name = "colloid-gtk-theme";
      package = pkgs.colloid-gtk-theme;
    };
  };

  home.file.".config/rofi/themes".source = pkgs.fetchFromGitHub {
    hash = "sha256-96wSyOp++1nXomnl8rbX5vMzaqRhTi/N7FUq6y0ukS8=";
    owner = "newmanls";
    repo = "rofi-themes-collection";
    rev = "ec731cef79d39fc7ae12ef2a70a2a0dd384f9730";
  };

  xdg.mimeApps = {
    defaultApplications."inode/directory" = "org.kde.dolphin.desktop";
    enable = true;
  };

  xresources.properties."Xft.dpi" = 144;
}
