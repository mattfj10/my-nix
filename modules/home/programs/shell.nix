{ lib, pkgs, ... }:
{
  programs = {
    alacritty = {
      enable = true;
      settings = {
        colors = {
          bright = {
            black = "#565575";
            blue = "#91ddff";
            cyan = "#aaffe4";
            green = "#95ffa4";
            magenta = "#c991e1";
            red = "#ff8080";
            white = "#cbe3e7";
            yellow = "#ffe9aa";
          };
          cursor = {
            cursor = "#fbfcfc";
            text = "#ff271d";
          };
          normal = {
            black = "#141228";
            blue = "#65b2ff";
            cyan = "#63f2f1";
            green = "#62d196";
            magenta = "#906cff";
            red = "#ff5458";
            white = "#a6b3cc";
            yellow = "#ffb378";
          };
          primary = {
            background = "#1e1c31";
            foreground = "#cbe1e7";
          };
        };
        window = {
          decorations = "Full";
          opacity = 0.8;
        };
      };
    };

    rofi = {
      enable = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      theme = "~/.config/rofi/themes/themes/spotlight-dark.rasi";
    };

    zsh = {
      autosuggestion = {
        enable = true;
        strategy = [ "history" ];
      };
      defaultKeymap = "viins";
      enable = true;
      enableCompletion = true;
      initContent = lib.mkBefore ''
        fastfetch
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "murilasso";
      };
      syntaxHighlighting.enable = true;
    };
  };
}
