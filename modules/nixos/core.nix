{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  environment.variables = {
    EDITOR = "vim";
    NIXCONFIG = "nixos-config";
  };

  hardware = {
    graphics.enable = true;
    nvidia = lib.mkIf config.nixnado.hasNvidia {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
    };
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  networking = {
    firewall.allowedTCPPorts = [ 8083 ];
    hostName = "nixnado";
    networkmanager.enable = true;
  };

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  programs = {
    firefox.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        curl
        expat
        fuse3
        icu
        nss
        openssl
        stdenv.cc.cc.lib
        zlib
        zstd
      ];
    };
    zsh.enable = true;
  };

  services.xserver.videoDrivers =
    if config.nixnado.hasNvidia then [ "nvidia" ] else [ "modesetting" ];

  system.stateVersion = "24.11";
  time.timeZone = "America/New_York";

  users.users.tornado711 = {
    description = "Matt Jones";
    extraGroups = [
      "adbusers"
      "input"
      "kvm"
      "libvirtd"
      "networkmanager"
      "wheel"
    ];
    isNormalUser = true;
    shell = pkgs.zsh;
  };
}
