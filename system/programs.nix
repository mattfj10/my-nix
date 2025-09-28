{pkgs, lib, ...}:
{
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
}