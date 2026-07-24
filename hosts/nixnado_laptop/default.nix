{
  imports = [ ./hardware.nix ];

  nixnado = {
    hasNvidia = false;
    isLaptop = true;
    name = "nixnado_laptop";
  };
}
