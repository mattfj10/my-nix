{pkgs, host, lib}:
{
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
            modules-right = if host.name == "nixnado_laptop"
              then "filesystem pulseaudio xkeyboard memory cpu wlan eth battery date tray"
              else "filesystem pulseaudio xkeyboard memory cpu wlan eth date tray";
            cursor-click = "pointer";
            cursor-scroll = "ns-resize";
            enable-ipc = true;
            bottom = true;
          };

          "module/tray" = {
            type = "internal/tray";
            format-margin = "8px";
            tray-spacing = "8px";
            tray-size = "100%";
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
        }
        // lib.optionalAttrs (host.name == "nixnado_laptop") {
          "module/battery" = {
            type = "internal/battery";
            battery = "BAT0";
            # Run `ls /sys/class/power_supply/` to find your battery/adapter names. Common: AC, ADP1 (ThinkPad), ACAD
            adapter = "AC";
            full-at = 98;
            poll-interval = 5;
            format-charging = "<ramp-capacity> <label-charging>";
            format-charging-foreground = "\${colors.primary}";
            label-charging = "CHR %percentage%%";
            format-discharging = "<ramp-capacity> <label-discharging>";
            format-discharging-foreground = "\${colors.primary}";
            label-discharging = "BAT %percentage%%";
            format-full = "<ramp-capacity> <label-full>";
            format-full-foreground = "\${colors.primary}";
            label-full = "BAT %percentage%%";
            ramp-capacity-0 = "▁";
            ramp-capacity-1 = "▂";
            ramp-capacity-2 = "▃";
            ramp-capacity-3 = "▄";
            ramp-capacity-4 = "▅";
            ramp-capacity-foreground = "\${colors.primary}";
          };
        };
}
