{
  pkgs,
  home-manager,
  services,
  lib,
  config,
  ...
}:
{

  environment = {
    variables = {
      EDITOR = "vim";
      NIXCONFIG = "nixos-config";
    };

    systemPackages = with pkgs; [
      feh
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      xclip
      wget
      pkgs.home-manager
      neofetch
      nix-direnv
      libnotify
      nixfmt-rfc-style
      playerctl
      pulseaudio
      rar
      config.boot.kernelPackages.kernel.dev
    ];
  };

  programs.dconf.enable = true;

  services = {
    pulseaudio.enable = false;
    picom = {
      enable = true;
      fade = true;
      fadeDelta = 10;
      settings = {
        corner-radius = 5;
        shadow = true;
        shadow-radius = 20;
        shadow-opacity = 0.4;
        shadow-offset-x = -7;
        shadow-offset-y = -7;
      };
    };

    clamav = {
    daemon.enable = true;
    updater.enable = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      windowManager.i3.enable = true;

      displayManager = {
        defaultSession = "none+i3";
        gdm.enable = false;
        gdm.wayland = false;
        lightdm = {
          greeters.gtk = {
            enable = true;
            theme = {
              package = pkgs.spacx-gtk-theme;
              name = "palenight";
            };
          };
        };
      };
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Enable CUPS to print documents.
    printing.enable = true;
  };

  hardware.steam-hardware.enable = true;

  home-manager.users.tornado711 = {
    home.packages = with pkgs; [
      i3status
      i3lock
      pavucontrol
      lightlocker
    ];

    imports = [./gui/i3_config.nix ./programs.nix];

    services = {
      dunst = import ./gui/dunst.nix;
      conky = {
        enable = true;
        extraConfig = builtins.readFile ../configs/conky.conf;
      };
      polybar = import ./gui/polybar.nix {inherit pkgs;};
    };

    gtk = {
      enable = true;
      theme = {
        package = pkgs.colloid-gtk-theme;
        name = "colloid-gtk-theme";
      };
      iconTheme = {
        package = pkgs.gruvbox-dark-icons-gtk;
        name = "gruvbox-dark-icons-gtk";
      };
    };

    home.file.".config/rofi/themes".source = pkgs.fetchFromGitHub {
      owner = "newmanls";
      repo = "rofi-themes-collection";
      rev = "master";
      sha256 = "sha256-96wSyOp++1nXomnl8rbX5vMzaqRhTi/N7FUq6y0ukS8=";
    };

  };
}
