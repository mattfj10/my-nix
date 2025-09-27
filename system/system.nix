{
  pkgs,
  home-manager,
  services,
  lib,
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
      videoDrivers = [ "nvidia" ];
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

    imports = [./gui/i3_config.nix];

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

    programs = {

      alacritty = {
        enable = true;
        settings = {
          window = {
            opacity = 0.8;
            decorations = "Full";
          };

          colors = {
            primary = {
              background = "#1e1c31";
              foreground = "#cbe1e7";
            };
            cursor = {
              text = "#ff271d";
              cursor = "#fbfcfc";
            };
            normal = {
              black = "#141228";
              red = "#ff5458";
              green = "#62d196";
              yellow = "#ffb378";
              blue = "#65b2ff";
              magenta = "#906cff";
              cyan = "#63f2f1";
              white = "#a6b3cc";
            };
            bright = {
              black = "#565575";
              red = "#ff8080";
              green = "#95ffa4";
              yellow = "#ffe9aa";
              blue = "#91ddff";
              magenta = "#c991e1";
              cyan = "#aaffe4";
              white = "#cbe3e7";
            };
          };

        };
      };

      #ZSH config
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        autosuggestion.strategy = [ "history" ];
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        initContent = lib.mkBefore ''
          neofetch
        '';
        defaultKeymap = "viins";
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" ];
          theme = "murilasso";
        };
      };

      #ROFI CONFIG
      rofi = {
        enable = true;
        terminal = "${pkgs.alacritty}/bin/alacritty";
        theme = "~/.config/rofi/themes/themes/spotlight-dark.rasi";
      };

      #GIT CONFIG
      git = {
        enable = true;
        lfs.enable = true;
        userName = "mattfj10";
        userEmail = "mattfjones@protonmail.com";
        aliases = {
          ci = "commit";
          co = "checkout";
          s = "status";
        };
      };

    };

    home.file.".config/rofi/themes".source = pkgs.fetchFromGitHub {
      owner = "newmanls";
      repo = "rofi-themes-collection";
      rev = "master";
      sha256 = "sha256-pHPhqbRFNhs1Se2x/EhVe8Ggegt7/r9UZRocHlIUZKY=";
    };

  };
}
