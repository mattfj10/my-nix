{
  imports = [ ./hardware.nix ];

  nixnado = {
    hasNvidia = true;
    isLaptop = false;
    name = "nixnado_desktop";
  };
}
