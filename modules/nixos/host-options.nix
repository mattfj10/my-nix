{ lib, ... }:
{
  options.nixnado = {
    hasNvidia = lib.mkOption {
      type = lib.types.bool;
      description = "Whether this host uses the NVIDIA driver.";
    };

    isLaptop = lib.mkOption {
      type = lib.types.bool;
      description = "Whether this host needs laptop-specific configuration.";
    };

    name = lib.mkOption {
      type = lib.types.enum [
        "nixnado_desktop"
        "nixnado_laptop"
      ];
      description = "Stable flake host identifier.";
    };
  };
}
