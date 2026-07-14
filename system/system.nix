{
  pkgs,
  home-manager,
  services,
  lib,
  config,
  host,
  ...
}:
{

  environment = {
    variables = {
      EDITOR = "vim";
      NIXCONFIG = "nixos-config";
    };

    systemPackages = with pkgs; [
      blueman
      feh
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      xclip
      wget
      pkgs.home-manager
      fastfetch
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

  # Make Qt apps follow system theme (and thus use dark mode)
  qt.platformTheme = "gnome";

  hardware.bluetooth.enable = true;

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
      extraLadspaPackages = [ pkgs.rnnoise-plugin.ladspa ];
      extraConfig.pipewire."99-input-denoising" = {
        "context.modules" = [
          {
            name = "libpipewire-module-filter-chain";
            args = {
              "node.description" = "Noise Canceling Source";
              "media.name" = "Noise Canceling Source";

              "filter.graph" = {
                nodes = [
                  {
                    type = "ladspa";
                    name = "rnnoise";
                    plugin = "librnnoise_ladspa";
                    label = "noise_suppressor_mono";
                    control = {
                      "VAD Threshold (%)" = 50;
                      "VAD Grace Period (ms)" = 200;
                      "Retroactive VAD Grace (ms)" = 0;
                    };
                  }
                ];
              };

              "capture.props" = {
                "node.name" = "capture.rnnoise_source";
                "node.passive" = true;
              };

              "playback.props" = {
                "node.name" = "rnnoise_source";
                "media.class" = "Audio/Source";
              };
            };
          }
        ];
      };
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
      brightnessctl
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
      polybar = import ./gui/polybar.nix { inherit pkgs host lib; };
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
