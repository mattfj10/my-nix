{
  services = {
    clamav = {
      daemon.enable = true;
      updater.enable = true;
    };
    gnome.gnome-keyring.enable = true;
  };
}
