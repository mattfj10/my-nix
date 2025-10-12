{pkgs, ...}:
{
    # I3 CONFIG
    xsession.windowManager.i3 = {
      enable = true;

      extraConfig = ''
        exec --no-startup-id ${pkgs.psmisc}/bin/killall -q .polybar-wrappe; polybar main &
        exec feh --bg-fill ~/nixos-config/media/wallpapers/snowy_peaks_blue.jpg
        exec --no-startup-id conky -c ~/nixos-config/configs/conky.conf
      '';
      config = {
        bars = [ ];
        gaps = {
          inner = 10;
          outer = 5;
          smartGaps = true;
          smartBorders = "on";
        };
        modifier = "Mod1";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        keybindings =
          let
            modifier = "Mod4";
            altmod = "Mod2";
          in
          {
            #Workspace management
            "${modifier}+1" = "workspace number 1";
            "${modifier}+2" = "workspace number 2";
            "${modifier}+3" = "workspace number 3";
            "${modifier}+4" = "workspace number 4";
            "${modifier}+5" = "workspace number 5";
            "${modifier}+6" = "workspace number 6";
            "${modifier}+7" = "workspace number 7";
            "${modifier}+8" = "workspace number 8";
            "${modifier}+9" = "workspace number 9";
            "${modifier}+Shift+w" = "exec i3-rofi-workspace-switcher";
            "${modifier}+j" = "focus down";
            "${modifier}+k" = "focus up";
            "${modifier}+h" = "focus left";
            "${modifier}+l" = "focus right";
            "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
            "${modifier}+Right" = "focus right";
            "${modifier}+Shift+0" = "move container to workspace number 10";
            "${modifier}+Shift+1" = "move container to workspace number 1";
            "${modifier}+Shift+2" = "move container to workspace number 2";
            "${modifier}+Shift+3" = "move container to workspace number 3";
            "${modifier}+Shift+4" = "move container to workspace number 4";
            "${modifier}+Shift+5" = "move container to workspace number 5";
            "${modifier}+Shift+6" = "move container to workspace number 6";
            "${modifier}+Shift+7" = "move container to workspace number 7";
            "${modifier}+Shift+8" = "move container to workspace number 8";
            "${modifier}+Shift+9" = "move container to workspace number 9";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+l" = "move right";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+c" = "reload";
            "${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
            "${modifier}+Shift+minus" = "move scratchpad";
            "${modifier}+Shift+q" = "kill";
            "${modifier}+Shift+r" = "restart";
            "${modifier}+Shift+space" = "floating toggle";
            "${modifier}+Shift+s" = "sticky toggle";
            "${modifier}+Up" = "focus up";
            "${modifier}+a" = "focus parent";
            "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun -icon-theme \"Papirus\" -show-icons";
            "Ctrl+${modifier}+f" =
              "exec ${pkgs.rofi}/bin/rofi -modi filebrowser -show filebrowser -icon-theme \"Papirus\" -show-icons";
            "${modifier}+e" = "layout toggle split";
            "${modifier}+f" = "fullscreen toggle";
            "${modifier}+y" = "split h";
            "${modifier}+minus" = "scratchpad show";
            "${modifier}+r" = "mode resize";
            "${modifier}+w" = "exec i3-rofi-window-switcher"; #"layout stacking";
            "${modifier}+space" = "focus mode_toggle";
            "${modifier}+v" = "split v";
            "${modifier}+t" = "layout tabbed";
            "${altmod}+l" = "exec dm-tool lock";

            #Media Keys
            "XF86AudioPlay" = "exec playerctl play-pause";
            "XF86AudioNext" = "exec playerctl next";
            "XF86AudioPrev" = "exec playerctl previous";
            "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" = "exec pactl set-sink-mute 0 toggle";

            # Screenshot keys
            "Print" = "exec --no-startup-id maim \"/home/$USER/Pictures/$(date)\"";
            "Shift+Print" = "exec --no-startup-id maim --select \"/home/$USER/Pictures/$(date)\"";
            "${modifier}+Print" = "exec --no-startup-id maim --window $(xdotool getactivewindow) \"/home/$USER/Pictures/$(date)\"";
            "Ctrl+Print" = "exec --no-startup-id maim | xclip -selection clipboard -t image/png";
            "Ctrl+Shift+Print" = "exec --no-startup-id maim --select | xclip -selection clipboard -t image/png";
            "Ctrl+${modifier}+Print" = "exec --no-startup-id maim --window $(xdotool getactivewindow) | xclip -selection clipboard -t image/png";
          };
      };
    };
}