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
        extraConfig = builtins.readFile ./configs/conky.conf;
      };
      polybar = {
        enable = true;
        script = "polybar main &";
        package = pkgs.polybar.override {
          i3Support = true;
          pulseSupport = true;  # commonly needed, included for convenience
        };
        settings = {
          "colors" = {
            background = "#80373b41";
            background-alt = "#373be1";
            foreground = "#C5C8C6";
            primary = "#2e92d1";
            secondary = "#8ABEB7";
            alert = "#A54242";
            disabled = "#707880";
          };

          "bar/main" = {
            width = "100%";
            height = "12pt";
            radius = 6;
            background = "\${colors.background}";
            foreground = "\${colors.foreground}";
            line-size = "3pt";
            border-size = "4pt";
            border-color = "\${colors.background}";
            padding-left = 0;
            padding-right = 1;
            module-margin = 1;
            separator = "|";
            separator-foreground = "\${colors.disabled}";
            font-0 = "monospace:size=10;2";
            modules-left = "xworkspaces i3 xwindow";
            modules-right = "filesystem pulseaudio xkeyboard memory cpu wlan eth date";
            cursor-click = "pointer";
            cursor-scroll = "ns-resize";
            enable-ipc = true;
            bottom = true;
          };

          "module/xworkspaces" = {
            type = "internal/xworkspaces";
            label-active = "%name%";
            label-active-background = "\${colors.primary}";
            label-active-underline = "#00000000";
            label-active-padding = 1;
            label-occupied = "%name%";
            label-occupied-padding = 1;
            label-urgent = "%name%";
            label-urgent-background = "\${colors.alert}";
            label-urgent-padding = 1;
            label-empty = "%name%";
            label-empty-foreground = "\${colors.disabled}";
            label-empty-padding = 1;
          };

          "module/xwindow" = {
            type = "internal/xwindow";
            label = "%title:0:60:...%";
          };

          "module/filesystem" = {
            type = "internal/fs";
            interval = 30;

            mount-0 = "/";

            # Show free space, total space, and percentage
            label-mounted = "%free% (%percentage_used%%)";
            label-mounted-foreground = "\${colors.primary}";

            # Format when filesystem is unmounted
            label-unmounted = "not mounted";
            label-unmounted-foreground = "\${colors.alert}";

            fixed-values = true; # Use exact values instead of rounding
            spacing = 2; # Space between entries if you add more mount points

            warn-percentage = 90;
          };

          "module/pulseaudio" = {
            type = "internal/pulseaudio";
            format-volume-prefix = "VOL ";
            format-volume-prefix-foreground = "\${colors.primary}";
            format-volume = "<bar-volume> <label-volume>";
            bar-volume-width = 10;
            bar-volume-empty = "─";               # The character to show for empty volume
            bar-volume-empty-foreground = "#666"; # Color of empty volume bars
            bar-volume-empty-font = 2;            # Font index to use
            
            # Related settings you might want:
            bar-volume-filled = "─";
            bar-volume-indicator = "|";
            bar-volume-fill = "─";
            label-volume = "%percentage%%";
            label-muted = "muted";
            label-muted-foreground = "\${colors.disabled}";
          };

          "module/memory" = {
            type = "internal/memory";
            interval = 2;
            format-prefix = "RAM ";
            format-prefix-foreground = "\${colors.primary}";
            label = "%used% (%percentage_used:2%%)";
          };

          "module/cpu" = {
            type = "internal/cpu";
            interval = 2;
            format-prefix = "CPU ";
            format-prefix-foreground = "\${colors.primary}";
            label = "%percentage:2%%";
          };

          "module/wlan" = {
            type = "internal/network";
            interface = "wlan0";
            interval = "3.0";
            format-connected = "<ramp-signal> <label-connected>";
            format-connected-underline = "#9f78e1";
            label-connected = "%essid%";
            format-disconnected = "";
            ramp-signal-0 = "";
            ramp-signal-1 = "";
            ramp-signal-2 = "";
            ramp-signal-3 = "";
            ramp-signal-4 = "";
            ramp-signal-foreground = "\${colors.primary}";
          };

          "module/i3" = {
            type = "internal/i3";
            format = "<label-mode>";
            label-mode = "%mode%";
            label-mode-padding = 2;
            label-mode-background = "\${colors.alert}";
          };

          "module/date" = {
            type = "internal/date";
            interval = 1;
            date = "%Y-%m-%d %H:%M:%S";
            date-alt = "%Y-%m-%d %H:%M:%S";
            label = "%date%";
            label-foreground = "\${colors.primary}";
          };

          "settings" = {
            screenchange-reload = true;
            pseudo-transparency = true;
          };
        };
      };
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
